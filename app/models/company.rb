class Company < ApplicationRecord
  validates :name, :country, presence: { message: 'Please write something!'}
  validates :name, uniqueness: true

  has_many :involved_companies
  has_many :games, through: :involved_companies

  has_many :reviews, as: :reviewable
end
