class UsersController < ApplicationController 
    get '/signup' do 
        if logged_in?
            redirect "/cities"
        else 
            erb :"users/new"
        end 
    end 

    post '/signup' do 
        # we will need to add validation. Whatever that means. 
        user = User.new(params)
        if user.save 
            session[:user_id] = user.id
            redirect '/cities'
        else 
            redirect '/signup'
        end 
    end 
end 