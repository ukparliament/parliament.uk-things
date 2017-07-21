
# Parliament.uk-things
[Parliament.uk-things][parliament.uk-things] is a [Rails][rails] application designed to hold the individual 'thing' elements of the new [parliament.uk][parliament.uk] website made by the [Parliamentary Digital Service][parliamentary-digital-service].

### Contents
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Things Rails Application](#parliament-rails-application)
  - [Running the application](#running-the-application)
  - [Running the tests](#running-the-tests)
- [Contributing](#contributing)
- [License](#license)

## Requirements
[Parliament.uk-things][parliament.uk-things] requires the following:
* [Ruby][ruby]
* [Bundler][bundler]


## Getting Started
Clone the repository:
```bash
git clone https://github.com/ukparliament/Parliament.uk-things.git
cd Parliament.uk-things
```

#### Things Rails Application
The [Parliament.uk-things][parliament.uk-things] application holds the routes, controllers and views that make up all the 'thing' elements of the new [parliament.uk][parliament.uk] website. 'Things' are singular, individual items with ids.

### Running the application
To run the application locally, run:
```bash
bundle install

bundle exec rails s
```

### Running the tests
We use [RSpec][rspec] as our testing framework and tests can be run using:
```bash
bundle exec rspec
```

## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Ensure your changes are tested using [Rspec][rspec]
6. Create a new Pull Request

## License
[Parliament.uk-things][parliament.uk-things] is available as open source under the terms of the [Open Parliament Licence][info-license].

[parliament.uk-things]:          https://github.com/ukparliament/parliament.uk-things
[parliamentary-digital-service]: https://github.com/ukparliament
[ruby]:                          https://www.ruby-lang.org/en/
[bundler]:                       http://bundler.io/
[rspec]:                         http://rspec.info
[rails]:                         http://rubyonrails.org
[parliament.uk]:                 http://www.parliament.uk/

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
