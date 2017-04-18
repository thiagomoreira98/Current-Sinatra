require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require './song'
require 'data_mapper'

configure do 
	enable :sessions
	set :username, 'frank'
	set :password, 'sinatra'
end

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/styles.css' do
	scss :styles
end

get '/' do
	slim :home
end

get '/about' do
	@title =  "All About This Website"
	slim :about
end

get '/contact' do
	slim :contact
end

not_found do
	slim :not_found
end

get '/login' do
	slim :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] == true
		redirect to ('/songs')
	else
		slim :login
	end
end

get '/logout' do
	session.clear
	redirect to ('/login')
end

get '/set/:name' do
	session[:name] = params[:name]
end

get '/get/hello' do
	"Hello #{session[:name]}"
end

get'/songs/new' do
	halt(401, 'Not Authorized') unless session[:admin]
	@song = Song.new
	slim :new_song
end

