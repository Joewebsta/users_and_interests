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

  erb :users
end

get '/:username' do
  @name = params[:username].to_sym
  @title = @name
  @email = @users[@name][:email]
  @interests = @users[@name][:interests]

  erb :user
end

not_found do
  redirect '/'
end

helpers do
  def count_interests(users)
    users.reduce(0) do |count, (name, user)|
      count + user[:interests].size
    end
  end
end
