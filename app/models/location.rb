class Location < ActiveRecord::Base
  has_many :users, :foreign_key => "location_id"
  has_many :chats, :foreign_key => "location_id"
  has_many :games, :foreign_key => "location_id"
end
