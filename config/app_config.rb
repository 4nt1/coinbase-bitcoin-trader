require 'coinbase/wallet'
require 'coinbase/exchange'
require 'byebug'
require 'recursive-open-struct'
require 'active_record'
require 'sqlite3'
require 'mandrill'

[:services, :migrations].each do |folder|
  Dir["#{ENV['HOME']}/coinbase-bitcoin-trader/#{folder}/*.rb"].each do |file|
    require file
  end
end