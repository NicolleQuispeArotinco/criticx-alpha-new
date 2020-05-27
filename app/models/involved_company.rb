class InvolvedCompany < ApplicationRecord
  belongs_to :company
  belongs_to :game

  validates :developer, :publisher, presence: { message: 'Please write something!'}
end
