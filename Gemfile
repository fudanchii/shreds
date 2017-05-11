# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', git: 'https://github.com/rails/rails', branch: '5-0-stable'

### 1. Database and modelling related gems
gem 'pg'

gem 'annotate', group: :development

gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers'
# gem 'paper_trail'
# end of 1.

### 2. Assets related gems
gem 'therubyracer', require: false
gem 'uglifier', require: false

# Lock sprockets-rails to 2.x.x since 3.0.0 breaks all other gems
gem 'sprockets-rails', '< 3.0.0'

gem 'autoprefixer-rails', require: false
gem 'i18n-js' # , '>= 3.0.0.rc8'
gem 'multi_json'
gem 'ractive_assets', git: 'https://github.com/fudanchii/ractive_assets'
gem 'sass-rails', require: false
gem 'sprockets', '~> 3.0'
gem 'sprockets-es6', '>= 0.6.0'
# end of 2.

### 3. Cosmetics
group :development do
  # gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.3.2'
  gem 'binding_of_caller', '>= 0.6.8'
end

gem 'figaro'
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form'
# end of 3.

### 4. Middleware and server related gems
gem 'puma', platforms: %i(mri jruby rbx)
gem 'thin', platforms: %i(mswin mingw)

gem 'message_bus'
# end of 4.

### 5. Job queueing related gems
gem 'sidekiq'
gem 'sidekiq-cron', git: 'https://github.com/ondrejbartas/sidekiq-cron'
# gem 'sidekiq-failures', git: 'https://github.com/mhfs/sidekiq-failures'
gem 'slim', require: false
# end of 5.

# 6. User authentication related gems
gem 'omniauth'
gem 'omniauth-twitter'
# end of 6.

# caching
gem 'dalli', require: false

# Feed fetching
gem 'feedbag', require: false, git: 'https://github.com/fudanchii/feedbag', branch: 'dev'
gem 'feedjira', require: false

# Test-related gems
group :test do
  gem 'm'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-spec-rails'
  gem 'minitest-stub_any_instance'
  gem 'rails-controller-testing'
end

group :development, :test do
  #  gem 'guard'
  #  gem 'guard-teaspoon'
  gem 'teaspoon'
  gem 'teaspoon-mocha'
end

# To use ActiveModel has_secure_password
gem 'bcrypt', require: false

gem 'connection_pool'
gem 'hiredis'
gem 'oj'
gem 'redis'
gem 'redis-namespace'

# Profiling
gem 'stathat'

gem 'foreman', require: false

group :development do
  gem 'flamegraph'
  gem 'rack-mini-profiler', require: false
  gem 'stackprof'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-history.js'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-file-upload'
  gem 'rails-assets-lodash'
  gem 'rails-assets-moment'
  gem 'rails-assets-nprogress'
  gem 'rails-assets-ractive', '~> 0.7.3'
  gem 'rails-assets-ractive-transitions-fade'
  gem 'rails-assets-scrollup'
  gem 'rails-assets-semantic-ui'
  gem 'rails-assets-zloirock--core-js'
end
