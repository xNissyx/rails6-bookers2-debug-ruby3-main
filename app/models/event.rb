class Event < ApplicationRecord
  has_many :users, dependent: :destroy, through: :atendees
  has_many :atendees, dependent: :destroy
  belongs_to :creator, class_name: "User"
end
