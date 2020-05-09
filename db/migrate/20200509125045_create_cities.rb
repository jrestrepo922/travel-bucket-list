class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :user_id
      t.integer :country_id
      t.string :name 
      t.string :trip_details
      t.boolean :completed 
    end
  end
end
