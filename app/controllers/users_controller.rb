class UsersController < ApplicationController 
    get '/signup' do 
        if logged_in?
            redirect "/countries"
        else 
            erb :"users/new"
        end 
    end 

    post '/signup' do 
        @user = User.new(params)
        if @user.save 
            
            session[:user_id] = @user.id
            redirect '/countries'
        else 
            erb :"users/new"
        end 
    end 
end 


