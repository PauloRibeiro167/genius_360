class Message < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id content user recipient read created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  belongs_to :user, required: true
  belongs_to :recipient, required: true, class_name: 'User'

  validates :content, presence: true
  
  scope :unread, -> { where(read: false) }
  scope :between_users, ->(user_id, recipient_id) { 
    where("(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)", 
          user_id, recipient_id, recipient_id, user_id)
  }

  has_noticed_notifications

  # Callbacks para quando o registro é descartado/restaurado
  before_discard do
    # Adicione ações a serem executadas antes de descartar
  end

  after_discard do
    # Adicione ações a serem executadas após descartar
  end

  before_undiscard do
    # Adicione ações a serem executadas antes de restaurar
  end

  after_undiscard do
    # Adicione ações a serem executadas após restaurar
  end

  after_create_commit :broadcast_message

  private

  def broadcast_message
    message_data = {
      content: content,
      sender_name: user.name,
      sender_id: user_id,
      created_at: created_at.strftime("%H:%M"),
      recipient_id: recipient_id
    }

    ActionCable.server.broadcast "chat_#{recipient_id}", message_data
    ActionCable.server.broadcast "chat_#{user_id}", message_data
  end
end
