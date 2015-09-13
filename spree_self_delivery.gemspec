# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_self_delivery'
  s.version     = '2.2.2'
  s.summary     = ''
  s.description = ''
  s.required_ruby_version = '>= 1.9.3'

  s.author            = 'Babur Usenakunov'
  s.email             = 'bob.usenakunov@gmail.com'
  s.homepage          = 'https://github.com/secoint/spree_self_delivery'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '~> 3.0.4'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_frontend', spree_version

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 2.6'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end

