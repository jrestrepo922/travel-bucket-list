class CountriesController < ApplicationController 
    
    #CREATE
    get "/countries/new" do 
        if logged_in?
            erb :"/countries/new"
        else 
            redirect "/login"
        end 
    end 


    post "/countries" do 
        if logged_in? 
            binding.pry
        else

        end 
    end 




    
    #READ, Considering adding being able to see other peoples vacation destinations
    get "/countries" do 
        if logged_in? 
            @countries = current_user.countries
            erb :"countries/index"
        else 
            redirect "/login"
        end 
    end 

    
    get "/countries/:id" do 

    end 


end 