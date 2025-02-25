class AddCollectedAtIndexToApiData < ActiveRecord::Migration[8.0]
  def change
    unless index_exists?(:api_data, :collected_at)
      add_index :api_data, :collected_at
    end
  end
end
