class Message < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Atualizar ransackable_attributes para incluir sender_id
  def self.ransackable_attributes(auth_object = nil)
    %w[id content sender_id recipient_id read created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :content, presence: true
  validates :sender, presence: true
  validates :recipient, presence: true
  
  scope :unread, -> { where(read: false) }
  scope :between_users, ->(sender_id, recipient_id) { 
    where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)", 
          sender_id, recipient_id, recipient_id, sender_id)
  }

  scope :unique_conversations, ->(sender_id) {
    select(Arel.sql('DISTINCT ON (LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id)) *'))
      .where('sender_id = ? OR recipient_id = ?', sender_id, sender_id)
      .order(Arel.sql('LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id), created_at DESC'))
  }

  scope :with_sender, ->(sender_id) { where(sender_id: sender_id) }

  scope :conversation_between, ->(user_id, other_user_id) {
    where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
          user_id, other_user_id, other_user_id, user_id)
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
      sender_name: sender.name,
      sender_id: sender_id,
      created_at: created_at.strftime("%H:%M"),
      recipient_id: recipient_id
    }

    ActionCable.server.broadcast "chat_#{recipient_id}", message_data
    ActionCable.server.broadcast "chat_#{sender_id}", message_data
  end
end
