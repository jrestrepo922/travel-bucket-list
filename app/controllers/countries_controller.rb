class CountriesController < ApplicationController 
   
    #CREATE
    get "/countries/new" do 
        if logged_in?
            @countries = Country.all
            erb :"/countries/new"
        else 
            redirect "/login"
        end 
    end 
    
    post "/countries" do 
        if logged_in?
            # if the existing country is not empty, No need to create a country
            if !params[:country][:name_exist].empty?
                cities_array = params[:country][:cities]
                country = Country.find_by(name: params[:country][:name_exist])
                #cities empty with no trip deatils or trip details
                if cities_array[0][:name].empty? && cities_array[1][:name].empty? && cities_array[2][:name].empty?
                    if !current_user.countries.find_by(name: country.name)
                        #create the association from user to country
                         current_user.countries << country
                         "/countries/#{country.id}"
                    else 
                        redirect '/countries/new'
                    end 
                end 
                
                #cities provided with trip details or no trip details
                cities_array.each { |city|
                if !city[:name].empty? 
                    new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                    country.cities << new_city 
                end 
                }

            # if the existing country is empty and if the country you are creating does not already exist, Create a new one
            elsif !params[:country][:name_new].empty? && !Country.find_by(name: params[:country][:name_new])
                cities_array = params[:country][:cities]

                # all cities are empty still create the Country
                if cities_array[0][:name].empty? && cities_array[1][:name].empty? && cities_array[2][:name].empty?
                    #Trip details are filled 
                    if !cities_array[0][:trip_details].empty? || !cities_array[1][:trip_details].empty? || !cities_array[2][:trip_details].empty?
                        redirect '/countries/new'
                    else 
                        # Creates a Country that belongs to an User but does not have any cities  
                        country = current_user.countries.create(name: params[:country][:name_new].titleize)          
                        redirect "/countries/#{country.id}"
                    end 
                else # cities are provided with or without trip_details
                    country = current_user.countries.create(name: params[:country][:name_new].titleize)
                        cities_array.each { |city|
                            if !city[:name].empty? 
                                new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                                country.cities << new_city 
                            end 
                        }
                end              
            
            else
                
                redirect '/countries/new'
            end
            redirect "/countries/#{country.id}"

        else 
            redirect "/login"
        end 
            
        
    end 

    #READ
    get "/countries" do 
        if logged_in? 
            @countries = current_user.countries.uniq
            erb :"/countries/index"
        else 
            redirect "/login"
        end 
    end 


    get "/countries/explore" do 
        if logged_in? 
            @countries = Country.all
            erb :"/countries/explore"
        else 
            redirect "/login"
        end 
    end 

    get "/countries/:id" do 
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id])
            erb :"/countries/show"
        else 
            redirect "/login"
        end 
    end 



    #EDIT
    get "/countries/:id/edit" do 
        if logged_in?
            @country = current_user.countries.find_by(id: params[:id])
            erb :"/countries/edit"
        else 
            redirect "/login"
        end 
    end

    patch "/countries/:id" do 
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id]) 
            if @country
                cities = @country.cities.where.not(name: nil).where(user_id: current_user.id)
                    cities.each_with_index do |city, index|

                    if city.name != params[:cities][index][:name] && city.trip_details == params[:cities][index][:trip_details]
                        city.name = params[:cities][index][:name]
                        city.save
                        
                    elsif city.name == params[:cities][index][:name] && city.trip_details != params[:cities][index][:trip_details]
                        city.trip_details = params[:cities][index][:trip_details]
                        city.save
                        
                    else
                        city.name = params[:cities][index][:name]
                        city.trip_details = params[:cities][index][:trip_details]
                        city.save
                    end 
                    
                end 
                redirect "/countries/#{@country.id}"
            else 
                redirect "/countries"
            end 
        else 
            redirect "/login"
        end 
    end 

    #DELETE
    delete "/countries/:id" do 
        if logged_in?
            @country = current_user.countries.find_by(id: params[:id])
            if @country
                @country.cities.where(user_id: current_user.id).delete_all
                current_user.countries.delete(@country)
            end 
            redirect '/countries'
        else 
            redirect 'login'
        end
    end 

end 