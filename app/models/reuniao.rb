class Reuniao < ApplicationRecord
  belongs_to :user
  validates :titulo, presence: true
  validates :data, presence: true
end
