class Movie < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :comments
  has_many :movieusergroups
  has_many :members, through: :movieusergroups, source: :user
end
