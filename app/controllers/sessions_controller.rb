class SessionsController < ApplicationController 

    get "/login" do 
        if logged_in? 
            redirect "/countries"
        else 
            erb :'sessions/login'
        end
    end 

    post "/login" do 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])   
            session[:user_id] = @user.id    
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
    #<%= @user.errors.full_messages if !@user.errors.full_messages.empty?%> goes in new.erb line 3 