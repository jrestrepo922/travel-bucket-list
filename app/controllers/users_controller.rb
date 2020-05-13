class UsersController < ApplicationController 
    get '/signup' do 
        if logged_in?
            redirect "/countries/cities"
        else 
            erb :"users/new"
        end 
    end 

    post '/signup' do 
        # we will need to add validation. Whatever that means. 
        @user = User.new(params)
        if @user.save 
            session[:user_id] = @user.id
            redirect 'countries/cities'
        else binding.pry
            erb :"users/new"
            #redirect '/signup'
        end 
    end 
end 