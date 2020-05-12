require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "crazyfun"
  end

  get "/" do
    if logged_in?
      redirect "/cities"
    else
      erb :welcome
    end 
  end

  helpers do #gives access to the controller and the views 
    
    def logged_in?
       !!session[:user_id]    # True , !true = false, !!true = true
    end

    def current_user
      @user ||= User.find_by_id(session[:user_id]) if logged_in?
    end 

  end 

  #Read
  get "/everyone" do 
    if logged_in? 
        #Provides an Array of Countries
        @countries = Country.all
        erb :"/everyone"
    else 
        redirect "/login"
    end 
  end 

  get "/everyone/:id" do 
    if logged_in? 
        @country = Country.find_by(id: params[:id])
        binding.pry
        # uses @country.cities.first.users
        erb :"/show"
    else 
        redirect "/login"
    end 
end 
end
