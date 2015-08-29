require 'coinbase/wallet'
require 'coinbase/exchange'
require 'byebug'
require 'recursive-open-struct'
require 'active_record'
require 'sqlite3'
require 'mandrill'

$app_path =
  if !ARGV[1].nil? && ARGV[1] == 'local'
    "#{ENV['HOME']}/src/coinbase-bitcoin-trader"
  else
    "#{ENV['HOME']}/coinbase-bitcoin-trader"
  end

[:services, :migrations].each do |folder|
  Dir["#{$app_path}/#{folder}/*.rb"].each do |file|
    require file
  end
end