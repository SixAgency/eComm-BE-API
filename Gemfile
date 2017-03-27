source 'https://rubygems.org'


gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'spree', github: 'spree/spree'                  # An open source e-commerce framework
gem 'spree_auth_devise', github: 'spree/spree_auth_devise'
gem 'spree_gateway', github: 'spree/spree_gateway'
gem 'spree_related_products', github: 'spree-contrib/spree_related_products'
gem 'spree_active_shipping', github: 'spree-contrib/spree_active_shipping'
gem 'spree_reviews', github:'CleverSoftwareSolutions/spree_reviews', ref: '6d1ccd6'

gem 'mysql2'                                        # Mysql library for Ruby

gem 'awesome_print'
gem 'figaro'
gem 'puma', '~> 3.0'                                # Use Puma as the app server
gem 'sass-rails', '~> 5.0'                          # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0'                          # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.2'                        # Use CoffeeScript for .coffee assets and views
gem 'therubyracer', platforms: :ruby                # Call JavaScript code and manipulate JavaScript objects from Ruby
gem 'rack-cors', :require => 'rack/cors'            # Middleware that will make Rack-based apps CORS compatible
gem 'jquery-rails'                                  # Use jquery as the JavaScript library
gem 'turbolinks', '~> 5'                            # Turbolinks makes navigating your web application faster.
gem 'jbuilder', '~> 2.5'                            # Build JSON APIs with ease.
gem 'delayed_job_active_record'                     # Running background jobs
gem 'daemons'                                       # Dependency of Delayed jobs managment script.

group :development, :test do
  gem 'byebug', platform: :mri                      # Stop execution and get a debugger console
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'           # Is a testing framework
  gem 'factory_girl_rails', '~> 4.7'                # Is a fixtures replacement support for multiple build strategies
end

group :development do
  gem 'web-console'                                 # Access an IRB console <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'                          # Listens to file modifications and notifies about the changes
  gem 'spring'                                      # Keeping your application running in the background.
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano',         require: false          # Executing commands in parallel on multiple remote machines
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-upload-config'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.1'      # Rspec-compatible one-liners that test common Rails functionality
  gem 'webmock', '~> 2.3', '>= 2.3.1'               # stubbing HTTP requests and setting expectations on HTTP requests
  gem 'database_cleaner', '~> 1.5', '>= 1.5.3'      # set of strategies for cleaning database
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # For use with TZInfo
gem 'spree_braintree_vzero', github: 'spree-contrib/spree_braintree_vzero'
gem 'swagger-docs', '~> 0.2.9'                      # Generates swagger-ui json files for rails apps with APIs
gem 'square_connect', '~>2.0.2'