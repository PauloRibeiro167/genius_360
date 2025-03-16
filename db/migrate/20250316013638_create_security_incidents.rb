class CreateSecurityIncidents < ActiveRecord::Migration[8.0]
  def change
    create_table :security_incidents do |t|
      t.string :incident_type
      t.string :severity
      t.text :details
      t.string :source_ip
      t.text :user_agent

      t.timestamps
    end
  end
end
