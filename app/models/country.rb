class Country < ActiveRecord::Base
    has_many :cities
    has_many :users, :through => :cities
end 