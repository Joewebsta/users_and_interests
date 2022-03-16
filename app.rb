# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
end

get '/' do
  redirect 'names'
end

get '/names' do
  @title = 'User Names'
  users = YAML.load_file('data/users.yml')
  @names = users.keys.map { |name| name.to_s.capitalize }

  erb :names
end

not_found do
  redirect '/'
end

helpers do
end
