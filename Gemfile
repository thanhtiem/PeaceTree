source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 7.0.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.x'
gem 'turbo-rails'
gem 'seedbank'
gem 'jbuilder'
gem 'redis'

gem 'devise'
gem 'pundit'
gem 'rolify'
gem 'pagy'
gem 'slim'
gem 'simple_form'
gem 'cocoon'
# gem 'image_processing'
gem 'active_storage_validations'
# gem 'ruby-vips'
gem 'enumerize'
gem 'validate_url'

gem 'bootsnap', require: false
gem 'tzinfo-data'

group :development, :test do
  gem 'debug'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 5.1', '>= 5.1.2'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  gem 'rubocop', '~> 1.31', '>= 1.31.2', require: false
  gem 'brakeman', require: false
  gem 'letter_opener'
  gem 'annotate'
  gem 'bullet'
end

group :test do
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'shoulda-matchers'
end
