class CitiesController < ApplicationController 
    
    #Read
    get '/cities' do 
        if logged_in? 
            @cities = current_user.cities
            erb :"/cities/index"
        else 
            redirect "/login"
        end 
    end 
    
    
    
    
    #Create
    get "/countries/:id/cities/new" do  
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id])
            erb :"cities/new"
        else 
            redirect "/login"
        end
    end 

    post "/countries/:id/cities" do 
        if logged_in? 
            
            country = current_user.countries.find_by(id: params[:id])
            city = params[:cities]

            if params[:cities][:name].empty?
                redirect "/countries/#{params[:id]}/cities/new"
            else
                new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                country.cities << new_city 
            end 
            redirect "/countries/#{country.id}"
        else 
            redirect "/login"
        end
    end 
end 