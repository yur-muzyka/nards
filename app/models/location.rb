class Location < ActiveRecord::Base
  has_many :users, :foreign_key => "location_id"
  has_many :chats, :foreign_key => "location_id"
  has_many :games, :foreign_key => "location_id"
  
  def online(id)
    
    users = Location.find(id).users
    active_users = []
    users.each do |user|
      if user.last_visit > (Time.now - 30.seconds)
        active_users << user
      end
    end
    active_users.count    
  end
end
