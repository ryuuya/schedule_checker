class User < ActiveRecord::Base
  has_many :plans
  has_secure_password
end
