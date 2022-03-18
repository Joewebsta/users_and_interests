# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users = YAML.load_file('data/users.yml')
end

get '/' do
  redirect 'users'
end

get '/users' do
  @title = 'Users'
  @user_info = user_ids_and_names

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
  def other_users(id)
    user_ids_and_names.filter do |user|
      user[:id] != id
    end
  end

  def count_interests(users)
    users.values.reduce(0) do |count, user|
      count + user[:interests].size
    end
  end

  def count_users(_users)
    @users.keys.size
  end
end

def each_user
  user_names = @users.keys

  user_names.each_with_index do |name, index|
    id = index
    email = @users[name][:email]
    interests = @users[name][:interests]

    yield id, name, email, interests
  end
end

def user_ids_and_names
  users = []

  each_user do |id, name|
    users << { id: id, name: name.capitalize }
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
