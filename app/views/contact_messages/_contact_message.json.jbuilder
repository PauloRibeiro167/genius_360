json.extract! contact_message, :id, :name, :email, :message, :status, :created_at, :updated_at
json.url contact_message_url(contact_message, format: :json)
