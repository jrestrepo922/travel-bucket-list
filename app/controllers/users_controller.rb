class UsersController < ApplicationController 
    get '/signup' do 
        if logged_in?
            redirect "/countries"
        else 
            erb :"users/new"
        end 
    end 

    post '/signup' do 
        # we will need to add validation. Whatever that means. 
        @user = User.new(params)
        if @user.save 
            session[:user_id] = @user.id
            redirect '/countries'
        else binding.pry
            erb :"users/new"
            #redirect '/signup'
        end 
    end 
end 

#<%= @user.errors.full_messages if !@user.errors.full_messages.empty?%> goes in new.erb line 3 
