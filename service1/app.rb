require 'bundler/setup'

Bundler.require

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
  response = Faraday.get('https://jsonplaceholder.typicode.com/posts/1')
  response.body
end
