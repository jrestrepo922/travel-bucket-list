class CitiesController < ApplicationController 


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
            @country = current_user.countries.find_by(id: params[:id])
            erb :"/cities/show"
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