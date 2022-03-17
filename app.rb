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
  @user_info = user_id_and_name

  erb :users
end

get '/users/:id' do
  id = params[:id].to_i
  @user = all_user_info[id]

  erb :user
end

not_found do
  redirect '/'
end

helpers do
  def format(interests)
    interests.join(', ')
  end
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

def user_id_and_name
  users = []

  each_user do |id, name|
    users << { id: id, name: name.capitalize }
    # Add key value pair for list of other names?
  end

  users
end

def all_user_info
  users = []

  each_user do |id, name, email, interests|
    users << { id: id, name: name.capitalize, email: email, interests: interests }
  end

  users
end
