# Jobs Scraper

Scrapes the jobs data and stores it.

## Testing

Manual testing with:

```bash
python web_scraper.py --country-code CH --last-n-days 1 --keywords "Data Scientist"
```

Manual testing and specifying a bucket:

```bash
STAGE=production \
LAKE_BUCKET=jobs-dashboard-lake-test \
python web_scraper.py --country-code CH --last-n-days 1 --keywords "Data Scientist"
```
