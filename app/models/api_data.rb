class ApiData < ActiveRecord::Base
  validates :source, presence: true
    validates :data, presence: true
    validates :collected_at, presence: true

    # Scopes úteis
    scope :by_source, ->(source) { where(source: source) }
    scope :recent, -> { order(collected_at: :desc) }
    scope :between_dates, ->(start_date, end_date) { 
        where(collected_at: start_date..end_date) 
    }
end
