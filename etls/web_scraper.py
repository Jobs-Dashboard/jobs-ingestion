from typing import List, Tuple, Dict, Set, Union
import argparse
import re
import time
import logging
import sys

import pandas as pd
import bs4
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import requests
from utils.url import CountryURL
from utils import data_saver


def get_page_job_urls(base_url: str, search_url: str) -> Tuple[List[str], int]:
    '''Get the job urls for a given page url.

    param base_url: a url like 'https://www.indeed.com/'
    param search_url: a url like
        'https://www.indeed.com/jobs?l=California&q=data+scientist&fromage=1&start=0'
    '''
    chrome_options = Options()
    chrome_options.add_argument('--headless')
    try:
        driver = webdriver.Chrome(options=chrome_options)
        driver.get(search_url)
        html = driver.page_source.encode('utf-8')
    except Exception as e:
        raise e
    finally:
        driver.quit()
    soup = BeautifulSoup(html, 'html.parser')
    jobs_table = soup.find_all('table', id='pageContent')[0]
    job_cards = jobs_table.find_all('div', class_='jobsearch-SerpJobCard')
    job_urls = [
        base_url
        +
        card.find('a', class_='jobtitle turnstileLink').get('href')
        for card in job_cards
    ]
    page_number = jobs_table.find('div', id='searchCountPages').text.split()[1]

    return job_urls, page_number


def get_job_urls(**kwargs) -> Dict[str, Set[str]]:
    '''Gets the job urls from indeed for a specific country / US state.

    param country_code: the country code like PT or US_CA
    param last_n_days: the number of days to include in the search.
        Ex: 7 will mean 'include the last 7 days'.
    param keywords: the list of search keywords, like ['Data', 'Scientist']
    '''
    search_url = CountryURL(**kwargs)

    page_job_urls, page_number = get_page_job_urls(
        base_url=search_url.base_url, search_url=str(search_url)
    )
    job_urls: Set[str] = set()
    page_numbers: Set[int] = set(page_number)

    while True:
        '''loop through job search pages, getting every listed job's link'''
        time.sleep(1)  # sleep so that i dont get my ip blocked

        # add the job urls in the current page to the list
        job_urls.update(page_job_urls)

        # go to the next page
        search_url = search_url.next_page()
        page_job_urls, page_number = get_page_job_urls(
            base_url=search_url.base_url, search_url=str(search_url)
        )

        # Check if we've already visited this page, if we did, it essentially
        # means that we're done.
        # Longer answer is we're asking for request_page values that dont have
        # a corresponding
        # page_number and indeed handles that by giving us the last page.
        # Therefore we have all the urls, return them.
        if page_number in page_numbers:
            return {search_url.get_country_code(): job_urls}
        page_numbers.add(page_number)


def get_organization(soup: bs4.element.ResultSet) -> str:
    '''Gets the organization name.'''
    organization_section = soup.find(
        'div',
        class_="jobsearch-InlineCompanyRating"
    )

    # There are 2 ways indeed includes organization names in
    # the job page: with or without a link, and we extract the
    # organization name in a diferent way for those.
    try:
        # Try to get the organization name from a section WITHOUT a link.
        organization_name = list(organization_section.children)[0].string
    except:
        # Try to get the organization name from a section WITH a link.
        organization_name = list(organization_section.children)[0].a.string

    return organization_name


def get_days_since_posted(soup: bs4.element.ResultSet) -> str:
    '''Gets the days since posted.'''
    days_since_posted_raw: str = soup.find(
        'div',
        class_="jobsearch-JobMetadataFooter"
    ).get_text().split('-')[1]

    days_since_posted: Union[re.Match, None] = re.search(
        r'30\+|[\d]+', days_since_posted_raw
    )

    # if no match was found, its because it says 'today' in a given language
    if days_since_posted is None:
        return '0'
    # a match was found, get the number
    else:
        return days_since_posted.group()


def collect_job_urls(**kwargs) -> Dict[str, List[str]]:
    '''Get the job urls for all the countries or for a subset of them.
    '''
    job_urls: Dict[str, List[str]] = {}

    # get the job_urls for all the countries, and all the states in the US
    if kwargs['country_code'] == 'ALL':
        for country_code in CountryURL.get_country_codes():
            if country_code == 'US':
                for state_code in CountryURL.get_state_codes():
                    kwargs.update({'state_code': state_code})
                    job_urls.update(get_job_urls(**kwargs))
            else:
                job_urls.update(get_job_urls(**kwargs))

        return job_urls

    # in this case we just want the job urls for a single country or state
    return get_job_urls(**kwargs)


def get_job_data(url: str, country_code: str) -> Dict[str, str]:
    '''Get the data for the job corresponding url.
    '''
    time.sleep(1)  # sleep so that i dont get my ip blocked

    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    job: Dict[str, str] = {
        'description': str(soup.find('div', id="jobDescriptionText")),
        'url': str(soup.find('meta', id="indeed-share-url")['content']),
        'title': str(soup.find('meta', id="indeed-share-message")['content']),
        'organization': get_organization(soup),
        # search for a number from 1 to 30 or the string '30+'
        'days_since_posted': get_days_since_posted(soup),
        'country_code': country_code,
    }

    return job


def collect_job_data(job_urls: Dict[str, List[str]]) -> List[Dict[str, str]]:
    '''Get the job urls for all the countries or for a subset of them.
    '''
    job_data: List[Dict[str, str]] = []
    for country_code in job_urls:
        for url in job_urls[country_code]:
            job_data.append(get_job_data(url=url, country_code=country_code))

    return job_data


def _configure_argparser():
    '''Configures the argument parser.
    '''
    parser = argparse.ArgumentParser(description='Scrape job listings.')

    parser.add_argument(
        '--country-code',
        required=True,
        choices=['ALL'] + CountryURL.get_country_codes(),
        help='Two letter country_code code like PT, or ALL for all countries.',
    )
    parser.add_argument(
        '--state-code',
        required=False,
        choices=CountryURL.get_state_codes(),
        help='Two letter state_code code like CA.',
    )
    parser.add_argument(
        '--last-n-days',
        help=(
            'The number of days to include in the search.'
            'Ex: 7 will mean - include the last 7 days.')
    )
    parser.add_argument(
        '--keywords',
        help='The list of search keywords, like \"Data Scientist\"'
    )

    return parser


def main(**kwargs) -> None:

    job_urls: Dict[str, List[str]] = collect_job_urls(**kwargs)
    logger.info("Collected job urls.")

    job_data: List[Dict[str, str]] = collect_job_data(job_urls)
    logger.info("Collected job data.")

    data_saver.save(job_data)
    logger.info("Saved job data.")

    return


if __name__ == '__main__':

    # configure logger
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    logger = logging.getLogger(__name__)
    logger.info("Configured the logger.")

    # configure parser
    parser = _configure_argparser()
    kwargs = vars(parser.parse_args())
    logger.info("Configured the parser.")

    # scrape and store the jobs data
    main(**kwargs)
