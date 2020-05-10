class UsersController < ApplicationController 
    get '/signup' do 
        erb :"users/new"
    end 

    post '/signup' do 
        # we will need to add validation. Whatever that means. 
        user = User.new(params)
        if user.save 
            redirect '/countries'
        else 
            redirect '/signup'
        end 
    end 
end 