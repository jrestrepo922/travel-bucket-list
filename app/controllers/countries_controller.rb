class CountriesController < ApplicationController 
   
    class CitiesController < ApplicationController 
        #CREATE
        get "/countries/cities/new" do 
            if logged_in?
                @countries = Country.all
                erb :"/countries/new"
            else 
                redirect "/login"
            end 
        end 
        
        
        post "/cities" do 
            if logged_in?
                # if the existing country is not empty. No need to create a country
                # this is the find 
                if !params[:country][:name_exist].empty?
                    cities_array = params[:country][:cities]
                    country = current_user.countries.find_by(name: params[:country][:name_exist])
                    # if stament here when no cities are provided and associated them to the user
                    if cities_array[0][:name].empty? || cities_array[0][:name].empty?
                        redirect '/cities/new'
                    end
                    cities_array.each { |city|
                    if !city[:name].empty? && !city[:trip_details].empty?
                        new_city = current_user.cities.create(name: city[:name], trip_details: city[:trip_details])
                        country.cities << new_city 
                    end 
                    }
                # if the existing country is empty. Create a new one
                elsif !params[:country][:name_new].empty?
                    cities_array = params[:country][:cities]
                    if cities_array[0][:name].empty? || cities_array[0][:name].empty?
                        redirect '/cities/new'
                    end
                    country = current_user.countries.build(name: params[:country][:name_new])
                    if country.save
                        cities_array.each { |city|
                            if !city[:name].empty? && !city[:trip_details].empty?
                                new_city = current_user.cities.create(name: city[:name], trip_details: city[:trip_details])
                                country.cities << new_city 
                            end 
                        }
                    end               
                
                else
                    
                    redirect '/cities/new'
                end 
                redirect '/cities'
    
            else 
                redirect "/login"
            end 
                
            
        end 

end 