require 'bundler/setup'

Bundler.require

set :bind, '0.0.0.0'
set :port, 8081

get '/' do
  message = 'Hello debugging'
  message
end
