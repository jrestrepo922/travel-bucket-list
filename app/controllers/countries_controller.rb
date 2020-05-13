class CountriesController < ApplicationController 
   
    #CREATE
    get "/countries/cities/new" do 
        if logged_in?
            # This allow us to pick from any country Created
            @countries = Country.all
            erb :"/countries/new"
        else 
            redirect "/login"
        end 
    end 
    
    post "/countries/cities" do 
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
                    redirect '/countries/cities/new'
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
                    country = current_user.countries.create(name: params[:country][:name_new].titleize)                  
                    redirect "/countries/#{country.id}/cities"
                end
                country = current_user.countries.build(name: params[:country][:name_new].titleize)
                if country.save
                    cities_array.each { |city|
                        if !city[:name].empty? && !city[:trip_details].empty?
                            new_city = current_user.cities.create(name: city[:name].titleize, trip_details: city[:trip_details])
                            country.cities << new_city 
                        end 
                    }
                end               
            
            else
                
                redirect '/countries/cities/new'
            end
            redirect "/countries/#{country.id}/cities"

        else 
            redirect "/login"
        end 
            
        
    end 

    #READ
    get "/countries/cities" do 
        if logged_in? 
            @countries = current_user.countries.uniq
            erb :"/countries/index"
        else 
            redirect "/login"
        end 
    end 

    get "/countries/:id/cities" do 
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id])
            erb :"/countries/show"
        else 
            redirect "/login"
        end 
    end 

    #EDIT
    get "/cities/:id/edit" do 
        if logged_in?
            @country = current_user.countries.find_by(id: params[:id])
            erb :"/cities/edit"
        else 
            redirect "/login"
        end 
    end

    patch "/cities/:id" do 
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id]) 
            if @country
                # country is change 
                if @country.name != params[:country][:name_new]
                    # will need to check if is submitted empty
                    if params[:country][:name_new].empty?
                        redirect "/cities/#{@country.id}/edit"
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
                    redirect "/cities/#{@country.id}"
                # country is the same 
                elsif @country.name == params[:country][:name_new]

                    @country.cities.each_with_index do |city, index|
                        # city and trip details is the same 
                        if city.name == params[:country][:cities][index][:name] && city.trip_details == params[:country][:cities][index][:trip_details]
                            redirect "/cities/#{@country.id}"
                        elsif city.name != params[:country][:cities][index][:name] && city.trip_details == params[:country][:cities][index][:trip_details]
                            city.name = params[:country][:cities][index][:name]
                            city.save
                            redirect "/cities/#{@country.id}"
                        elsif city.name == params[:country][:cities][index][:name] && city.trip_details != params[:country][:cities][index][:trip_details]
                            city.trip_details = params[:country][:cities][index][:trip_details]
                            city.save
                            redirect "/cities/#{@country.id}"
                        else
                            city.name = params[:country][:cities][index][:name]
                            city.trip_details = params[:country][:cities][index][:trip_details]
                            city.save
                            redirect "/cities/#{@country.id}"
                        end 
                    end 
        
                end 
            else 
                redirect "/cities"
            end 
        else 
            redirect "/login"
        end 
    end 

    #DELETE
    delete "/cities/:id" do 
        if logged_in?
            @country = current_user.countries.find_by(id: params[:id])
            if @country
                #@country.cities.clear consider activating this line also. 
                current_user.countries.delete(@country)
                #@country.cities.delete_all
                #@country.delete
            end 
            redirect '/cities'
        else 
            redirect 'login'
        end
    end 

end 