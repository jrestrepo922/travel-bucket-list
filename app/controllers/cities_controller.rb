class CitiesController < ApplicationController 
    #Edit
    get "/countries/:id/cities/new" do  #ask Nancy if this works
        if logged_in? 
            @country = current_user.countries.find_by(id: params[:id])
            erb :"cities/new"
        else 
            redirect "/login"
        end
    end 

    post "/countries/:id/cities" do 
        if logged_in? 
            binding.pry
            redirect "/countries/#{country.id}"
        else 
            redirect "/login"
        end
    end 
end 