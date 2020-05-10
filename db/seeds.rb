User.create(username:"juan", email: "juan@email.com", password: "juan") 
User.create(username:"susan", email: "susan@email.com", password: "susan") 

Country.create(name: "Colombia")
Country.create(name: "United States - Hawaii")
Country.create(name: "Greece")
Country.create(name: "Canada")

# Juan bucket list 
colombia = Country.find_by(name: "Colombia")
colombia.cities.create(name: "Santa Rosa", trip_details: "Visit viejito and Mom", completed: false)
colombia.cities.create(name: "Cartagena", trip_details: "Have fun at the beach", completed: false)

canada = Country.find_by(name: "Canada") 
canada.cities.create(name: "Quebec", trip_details: "Snow board and learn about the history of the city", completed: false)

juan = User.find_by(username: "juan") 
santa_rosa = City.find_by(name: "Santa Rosa") 
cartagena =  City.find_by(name: "Cartagena") 
quebec =     City.find_by(name: "Quebec") 
juan.cities << santa_rosa
juan.cities << cartagena
juan.cities << quebec

# Susans bucket list 
hawaii = Country.find_by(name: "United States - Hawaii")
hawaii.cities.create(name: "Honolulu", trip_details: "relax at the beach", completed: false)
hawaii.cities.create(name: "Hilo", trip_details: "visit the natural park", completed: false)

greece = Country.find_by(name: "Greece") 
greece.cities.create(name: "Santorini", trip_details: "drink wine and eat cheese", completed: false)

susan = User.find_by(username: "susan") 
honolulu = City.find_by(name: "Honolulu") 
hilo =  City.find_by(name: "Hilo") 
santorini =     City.find_by(name: "Santorini") 
susan.cities << honolulu
susan.cities << hilo
susan.cities << santorini
