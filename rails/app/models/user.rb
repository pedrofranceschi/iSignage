class User < ActiveRecord::Base
  has_many :sessions
  validates_presence_of :all
end
