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
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    else
      user = User.new(params)
      if user.save
        redirect "/login"
      else
        redirect "failure"
      end
    end


  end

  get '/account' do
    @amount = params[:amount]
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    else
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/account'
      else
        redirect '/failure'
      end
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/deposit" do
    if logged_in?
      amount = current_user.deposit(params[:deposit])
      redirect "/account?amount=#{amount}"
    else
      redirect 'failure'
    end
  end

  post "/withdraw" do
     if logged_in?
      amount = current_user.withdraw(params[:withdraw])
      redirect "/account?amount=#{amount}"
    else
      redirect 'failure'
    end 

  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def amount(amount)
      amount
    end
  end

end
