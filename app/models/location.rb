class Location < ActiveRecord::Base
  has_many :users, :foreign_key => "location_id"
end
