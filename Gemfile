source 'https://rubygems.org'

gem 'rails', '~> 4.2'

### 1. Database and modelling related gems
gem 'pg'

gem 'annotate', group: :development

gem 'jbuilder'
# gem 'paper_trail'
# end of 1.

### 2. Assets related gems
gem 'therubyracer', require: false
gem 'uglifier', require: false

# Lock sprockets-rails to 2.x.x since 3.0.0 breaks all other gems
gem 'sprockets-rails', '< 3.0.0'

gem 'sprockets', '~> 3.0'
gem 'sprockets-es6', '>= 0.6.0'
gem 'sass-rails', require: false
gem 'autoprefixer-rails', require: false
gem 'ractive_assets', github: 'unity/ractive_assets'
gem 'i18n-js' # , '>= 3.0.0.rc8'
# end of 2.

### 3. Cosmetics
group :development do
  gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.3.2'
  gem 'binding_of_caller', '>= 0.6.8'
end

gem 'kaminari', github: 'amatsuda/kaminari'
gem 'figaro'
gem 'simple_form', github: 'plataformatec/simple_form'
# end of 3.

### 4. Middleware and server related gems
gem 'puma', platforms: [:mri, :jruby, :rbx]
gem 'thin', platforms: [:mswin, :mingw]
# end of 4.

### 5. Job queueing related gems
gem 'sidekiq'
gem 'sidekiq-failures', github: 'mhfs/sidekiq-failures'
gem 'sidekiq-cron', github: 'ondrejbartas/sidekiq-cron'
gem 'sinatra', require: false
gem 'slim', require: false
# end of 5.

# 6. User authentication related gems
gem 'omniauth'
gem 'omniauth-twitter'
# end of 6.

# caching
gem 'dalli', require: false

# Feed fetching
gem 'feedjira', require: false
gem 'feedbag', require: false, github: 'fudanchii/feedbag', branch: 'dev'

# Test-related gems
group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-spec-rails'
  gem 'minitest-stub_any_instance'
end

group :development, :test do
  gem 'guard'
  gem 'teaspoon'
  gem 'guard-teaspoon'
  gem 'teaspoon-mocha'
end

# To use ActiveModel has_secure_password
gem 'bcrypt', require: false

gem 'oj'
gem 'redis'
gem 'hiredis'
gem 'connection_pool'

# Profiling
gem 'stathat'

gem 'foreman', require: false

group :development do
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-lodash'
  gem 'rails-assets-history.js'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-file-upload'
  gem 'rails-assets-scrollup'
  gem 'rails-assets-nprogress'
  gem 'rails-assets-ractive'
  gem 'rails-assets-ractive-transitions-fade'
  gem 'rails-assets-moment'
  gem 'rails-assets-zloirock--core-js'
  gem 'rails-assets-semantic-ui'
end
