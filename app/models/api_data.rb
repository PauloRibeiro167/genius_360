class ApiData < ActiveRecord::Base
  validates :source, presence: true
  validates :data, presence: true
  validates :collected_at, presence: true
end
