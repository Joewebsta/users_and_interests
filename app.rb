# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users = YAML.load_file('data/users.yml')
  # Should this be here or /users?
end

get '/' do
  redirect 'users'
end

get '/users' do
  @title = 'Users'
  @user_basic_info = user_names

  erb :users
end

get '/users/:id' do
  'Hello world'
  erb :user
end

not_found do
  redirect '/'
end

helpers do
end

# Create two iterator methods. 1 for /users and 1 for users/id?

def each_user
  user_names = @users.keys

  user_names.each_with_index do |name, index|
    id = index
    email = @users[name][:email]
    interests = @users[name][:interests]

    yield id, name, email, interests
  end
end

def user_names
  names = []

  each_user do |id, name, _email, _interests|
    names << { id: id, name: name.capitalize }
    # Add key value pair for list of other names?
  end

  names
end
