require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    #your code here
    if params[:username]
      @user = User.create(:username => params[:username], :password => params[:password])
      @user.save
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/withdraw' do 
    @user = User.find(session[:user_id])
    erb :withdraw
  end

  get '/deposit' do 
    @user = User.find(session[:user_id])
    erb :deposit
  end

  post '/w_receipt' do
    @user = User.find(session[:user_id])
    if params[:withdrawl]
      @withdrawl = params[:withdrawl]
      erb :w_receipt
    else
      redirect 'failure'
    end
  end

  post '/d_receipt' do
    @user = User.find(session[:user_id])
    if params[:deposit]
      @deposit = params[:deposit]
      erb :d_receipt
    else
      redirect 'failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
