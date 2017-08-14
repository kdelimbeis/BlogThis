require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'

require 'pry'
require './models'



set :database, { adapter: "sqlite3", database: "development.sqlite3" }

enable :sessions

def current_user
  @current_user ||= User.find_by_id(session[:user_id])
end

get '/' do
	@blogs = Blog.all
  erb :index
end

get '/signup' do
  erb :signup
end

get '/login' do
	erb :login
end

post '/login' do
	user = User.find_by(username: params[:username])
	if user && user.password == params[:password]
		session[:user_id] = user.id
		redirect '/show'
	else
		redirect '/signup'
	end
end

get '/logout' do
	session[:user_id] = nil
	redirect '/signup'
end

post '/new_user' do
	user = User.create(username: params[:username], password: params[:password], city: params[:city], school: params[:school])
	session[:user_id] = user.id
	redirect "/show"
end

post '/blog' do
	user = User.find(session[:user_id])
	Blog.create(title: params[:title], category: params[:category], content: params[:content], user_id: user.id)
	redirect "/"
end

post '/destroy_user' do
	user = User.find(session[:user_id])
	user.destroy
	redirect '/signup'
end

post '/edit_user' do
	user = User.find(session[:user_id])
	user.update(password: params[:password], city: params[:city], school: params[:school])
	redirect '/show'
end

get '/show' do
  erb :show
end
