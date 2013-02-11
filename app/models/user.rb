class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :location
  belongs_to :game
end
