source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'

# Use Puma as the app server
gem 'puma', '~> 3.10.0'
gem 'rack-timeout'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use HAML for our view rendering
gem 'haml'

# Use Parliament-Ruby for web requests
gem 'parliament-ruby', '1.0.0.pre6'

# Parliament Grom Decorators decorates Grom nodes
gem 'parliament-grom-decorators', '~> 0.2'

# Converts GeoSparql to GeoJSON
gem 'geosparql_to_geojson', '~> 0.2'

# Parliament routing
gem 'parliament-routes', '~> 0.6'

# Parliament-Utils gem for generic set up and configuration
gem 'parliament-utils', '~> 0.8', '>= 0.8.5', require: false

# Parliament NTriple processes N-triple data
gem 'parliament-ntriple', '~> 0.2', require: false

# Use bandiera-client for feature flagging
gem 'bandiera-client'

# Use Pugin for front-end components and templates
gem 'pugin', '~> 1.7', require: false

# Use dotenv to override environment variables
gem 'dotenv'

# Use Airbrake for error monitoring
gem 'airbrake'

# Gem to remove trailing slashes
gem 'rack-rewrite'

# Include time zone information
gem 'tzinfo-data'

# Support markdown to HTML transformation
gem 'redcarpet', '~> 3.0'

gem 'vcard', '~> 0.2'

# Include ApplicationInsights for application telemetry
gem 'application_insights'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'rack-test', '0.7.0'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Use FactoryBot for building models in tests
  gem 'factory_bot_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rake'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'simplecov', '~> 0.14', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'rubocop'
  gem 'rails-controller-testing'
  gem 'timecop'
end
