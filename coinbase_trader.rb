require 'daemons'
Daemons.run('main.rb')
require_relative './config/app_config'
Initializer.call