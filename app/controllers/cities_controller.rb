class CitiesController < ApplicationController 
    #CREATE
    get "/cities/new" do 
        if logged_in? 
            erb :"/cities/new"
        else 
            redirect "/login"
        end 
    end 
    
    post "/cities" do 
        
        if logged_in? 
            cities_array = params[:country][:cities]
            country = Country.new(name: params[:country][:name])
            cities_array.each { |city|
                if !city[:name].empty? && !city[:trip_details].empty? && !params[:country][:name].empty?
                    country.save
                    new_city = current_user.cities.build(name: city[:name], trip_details: city[:trip_details])
                    new_city.save
                    country.cities << new_city 
                end 
            }
            if  !cities_array[0][:name].empty? || !params[:country][:name].empty?
                redirect '/cities' #kind of confuse what displays what 
            else 
                redirect '/cities/new'
            end 
            
        else 
            redirect "/login"
        end 
            
        
    end 

    #READ
    get "/cities" do 
        if logged_in? 
            #Provides an Array of Countries
            @countries = current_user.countries.uniq
            erb :"/cities/index"
        else 
            redirect "/login"
        end 
    end 

    get "/cities/:id" do 
        if logged_in? 
            
            erb :"/cities/show"
        else 
            redirect "/login"
        end 
    end 

    #EDIT
    get "/cities/:id/edit" do 
        erb :"/cities/edit"
    end

    patch "/cities/:id" do 
        
    end 

    #DELETE
    delete "/cities/:id" do 

    end 

end 