from typing import List


class CountryURL:
    '''Represents an indeed.com url and gives get and set access to different
    attributes of this url.
    '''
    base_url: str  # like https://pt.indeed.com/
    jobs_portion: str  # like jobs?
    query: str  # like q={keywords}&fromage={last_n_days}&start={request_page}
    last_n_days: int  # get results from the last last_n_days days
    request_page: int  # the page of the request
    base_urls = {
        'PT': 'https://pt.indeed.com',
        'CH': 'https://ch.indeed.com',
        'DE': 'https://de.indeed.com',
        'NL': 'https://nl.indeed.com',
        'US': 'https://www.indeed.com',  # same for all states
    }
    state_names = {
        'NY': 'New-York',
        'CA': 'California',
    }

    def __init__(
        self,
        country_code: str,
        keywords: str,
        last_n_days: int,
        **kwargs,
    ):
        '''
        param country_code: two letter country_code code like PT
        param keywords: like 'data scientist'
        '''
        self.country_code = country_code.upper()
        self.base_url = self.base_urls[self.country_code]
        self.jobs_portion = '/jobs?'
        # for US change the country_code and jobs_portion
        if self.country_code == 'US':
            if kwargs.get('state_code') is None:
                self.state_code = 'CA'
            self.jobs_portion = (
                f'{self.jobs_portion}l={self.state_names[self.state_code]}&'
            )
            self.country_code = 'US_' + self.state_code
        self.last_n_days = last_n_days
        self.request_page = 0
        joined_keywords = '+'.join(keywords.split())
        self.query = (
            f'q={joined_keywords}'
            f'&fromage={last_n_days}'
            '&filter=0'
            # this portion will need to fe formated when __str__ is called
            '&start={request_page}'
        )

    def next_page(self, ):
        '''Sets the url to point to the next page.'''
        self.request_page += 10

        return self

    def get_country_code(self, ):
        '''Returns this urls country code.'''
        return self.country_code

    def __repr__(self, ):
        return self.base_url + self.jobs_portion + self.query.format(
            request_page=self.request_page
        )

    @staticmethod
    def get_country_codes() -> List[str]:
        '''Returns the list of available country codes like ['PT', 'CH'].'''

        return list(CountryURL.base_urls.keys())

    @staticmethod
    def get_state_codes() -> List[str]:
        '''Returns the list of available state codes like ['CA', 'NY'].'''

        return list(CountryURL.state_names.keys())
