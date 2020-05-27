class User < ApplicationRecord
  validates :username, :email, presence: { message: 'Please write something!'}, uniqueness: true

  has_many :reviews

  before_save do
    if self.review_count.nil?
      self.review_count = 0 
    end
  end

end
  
