class CountriesController < ApplicationController 
   
    #CREATE
    get "/countries/new" do 
        if logged_in?
            # This allow us to pick from any country Created
            @countries = Country.all
            erb :"/countries/new"
        else 
            redirect "/login"
        end 
    end 
    
    post "/countries" do 
        if logged_in?
            # if the existing country is not empty. No need to create a country
            # this is the find 
            if !params[:country][:name_exist].empty?
                cities_array = params[:country][:cities]
                country = Country.find_by(name: params[:country][:name_exist])
                #this does not work anymore since that country does not belong to a user.
                #country = current_user.countries.find_by(name: params[:country][:name_exist])
                # if stament here when no cities are provided and associated them to the user
                #cities empty with no trip deatils or trip details
                if cities_array[0][:name].empty? && cities_array[1][:name].empty? && cities_array[2][:name].empty?
                    redirect '/countries/new'
                end 
                
                #cities provided with trip details or no trip details
                cities_array.each { |city|
                if !city[:name].empty? 
                    new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                    country.cities << new_city 
                end 
                }

            # if the existing country is empty and if the country you are creating does not already exist. Create a new one
            elsif !params[:country][:name_new].empty? && !Country.find_by(name: params[:country][:name_new])
                cities_array = params[:country][:cities]

                # all cities are empty still create the Country
                if cities_array[0][:name].empty? && cities_array[1][:name].empty? && cities_array[2][:name].empty?
                    #Trip details are filled 
                    if !cities_array[0][:trip_details].empty? || !cities_array[1][:trip_details].empty? || !cities_array[2][:trip_details].empty?

                        redirect '/countries/cities/new'
                    else 
                        country = current_user.countries.create(name: params[:country][:name_new].titleize)                  
                        redirect "/countries/#{country.id}/cities"
                    end 
                else # cities are provided with or without trip_details
                    country = current_user.countries.create(name: params[:country][:name_new].titleize)
                    #if country.save
                        cities_array.each { |city|
                            if !city[:name].empty? 
                                new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                                country.cities << new_city 
                            end 
                        }
                    
                    #end 
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
            #.first.cities.select {|c| c.user_id == current_user.id  }
            erb :"/countries/index"
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
                # country is change 
                if @country.name != params[:country][:name_new]
                    # will need to check if is submitted empty
                    if params[:country][:name_new].empty?
                        redirect "/countries/#{@country.id}/edit"
                    end 
                    # will need to delete the cities that belong to the country
                    @country.cities.delete_all
                    # update the country 
                    @country.update(name: params[:country][:name_new])
                    # check to see if information about the cities were enter and if is create new ones
                    params[:country][:cities].each do |city|
                        if !city[:name].empty? && !city[:trip_details].empty?
                            new_city = current_user.cities.create(name: city[:name], trip_details: city[:trip_details])
                            @country.cities << new_city 
                        end 
                    end 
                    redirect "/countries/#{@country.id}"
                # country is the same 
                elsif @country.name == params[:country][:name_new]

                    @country.cities.each_with_index do |city, index|
                        # city and trip details is the same 
                        if city.name == params[:country][:cities][index][:name] && city.trip_details == params[:country][:cities][index][:trip_details]
                            redirect "/countries/#{@country.id}"
                        elsif city.name != params[:country][:cities][index][:name] && city.trip_details == params[:country][:cities][index][:trip_details]
                            city.name = params[:country][:cities][index][:name]
                            city.save
                            redirect "/countries/#{@country.id}"
                        elsif city.name == params[:country][:cities][index][:name] && city.trip_details != params[:country][:cities][index][:trip_details]
                            city.trip_details = params[:country][:cities][index][:trip_details]
                            city.save
                            redirect "/countries/#{@country.id}"
                        else
                            city.name = params[:country][:cities][index][:name]
                            city.trip_details = params[:country][:cities][index][:trip_details]
                            city.save
                            redirect "/countries/#{@country.id}"
                        end 
                    end 
        
                end 
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
                #@country.cities.clear consider activating this line also. 
                current_user.countries.delete(@country)
                #@country.cities.delete_all
                #@country.delete
            end 
            redirect '/countries'
        else 
            redirect 'login'
        end
    end 

end 