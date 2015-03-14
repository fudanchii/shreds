source 'https://rubygems.org'

gem 'rails', '~> 4.2'

### 1. Database and modelling related gems
gem 'pg'

gem 'annotate', group: :development

gem 'jbuilder'
# gem 'paper_trail'
# end of 1.

### 2. Assets related gems
gem 'therubyracer'
gem 'uglifier'
gem 'sprockets', '>= 3.0.0.beta'
gem 'sprockets-es6', '>= 0.6.0'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'sass-rails', '~> 5.0.0'
gem 'autoprefixer-rails'
gem 'ractive-rails'
gem 'handlebars_assets'
# end of 2.

### 3. Cosmetics
group :development do
  gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.3.2'
  gem 'binding_of_caller', '>= 0.6.8'
end

gem 'kaminari', github: 'amatsuda/kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
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
gem 'sidetiq', github: 'tobiassvn/sidetiq'
gem 'sinatra', require: false
gem 'slim', require: false
# end of 5.

# 6. User authentication related gems
gem 'omniauth'
gem 'omniauth-twitter'
# end of 6.

# caching
gem 'dalli'
gem 'cache_digests'

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
gem 'teaspoon', group: [:development, :test]

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

gem 'skylight'

source 'https://rails-assets.org' do
  gem 'rails-assets-history.js'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-file-upload'
  gem 'rails-assets-ladda'
  gem 'rails-assets-scrollup'
  gem 'rails-assets-nprogress'
  gem 'rails-assets-ractive'
  gem 'rails-assets-moment'
end
