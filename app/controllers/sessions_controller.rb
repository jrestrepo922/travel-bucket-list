class SessionsController < ApplicationController 

    get "/login" do 
        erb :'sessions/login'
    end 

    post "/login" do 
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password]) #where is this coming from bcrypt and has_secure_passwrod
            session[:user_id] = user.id #once this line is executed the user is log in. 
            redirect "/countries"
        else  
            redirect "/login"
        end 
    
    end 

    get '/logout' do
        session.clear
        redirect "/login"
    end 
end 