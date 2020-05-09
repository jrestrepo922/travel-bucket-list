class User < ActiveRecord::Base
    has_many :cities
    has_many :countries, :through => :cities
    has_secure_password
end 