class User < ActiveRecord::Base
    has_many :cities
    has_many :countries, :through => :cities
    has_secure_password


    validates :username, :email, :password, presence: true
    validates :username, :email, uniqueness: true
end 