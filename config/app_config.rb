require 'coinbase/wallet'
require 'coinbase/exchange'
require 'byebug'
require 'recursive-open-struct'
require 'active_record'
require "sqlite3"

[:services, :migrations].each do |folder|
  Dir["./#{folder}/*.rb"].each { |file| require file }
end