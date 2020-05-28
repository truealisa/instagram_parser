## Instagram Brooklyn Bridge location scraper

Simple scraper to get last 100 instagram users who posted from [Brooklyn Bridge](https://www.instagram.com/explore/locations/49695104/).

### Requirements
- ruby 2.6.5
- rails 6
- geckodriver

### Instalation
```
bundle install
rails db:create
rails db:migrate
rails db:seed
```

### Usage
1. Rename `config/instagram_credentials.yml.example` to `config/instagram_credentials.yml`.
2. Fill `email` and `password` fields in it with actual instagram account credentials.
3. From `rails console` run
```
LocationScraper.new.fetch_usernames
```
4. Wait for result to be saved to `storage/csv` as .csv file.
