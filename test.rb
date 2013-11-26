require 'rubygems'
require 'sinatra'

get '/' do
  haml :test
end

get '/howmany' do
  "42"
end