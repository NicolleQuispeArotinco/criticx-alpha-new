class User < ApplicationRecord
  has_many :reviews

  before_save do |user|
    user.review_count = 0
  end
end
