class Review < ApplicationRecord
  belongs_to :user
  
  belongs_to :reviewable, polymorphic: true

  after_create do 
    user = User.find(self.user_id)
    user.update(review_count: user.review_count + 1)
  end

  after_destroy do
    user = User.find(self.user_id)
    user.update(review_count: user.review_count - 1)
  end

  validates :title, :body, presence: { message: 'Please write something!'}
  validates :title, length: {maximum: 40}
end
