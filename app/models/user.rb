class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include Discard::Model

  belongs_to :perfil
  has_many :perfil_permissions, through: :perfil
  has_many :permissions, through: :perfil_permissions
  has_one_attached :avatar

  # Mensagens enviadas
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  # Mensagens recebidas
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :notifications, dependent: :destroy
  has_and_belongs_to_many :avisos
  has_many :disponibilidades, dependent: :destroy

  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :perfil_id, presence: true
  validates :cpf, presence: true, uniqueness: { message: "já está cadastrado no sistema" }
  validates :phone, presence: true, uniqueness: true

  # Validações do avatar
  # validates :avatar,
  #          content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'], message: 'deve ser uma imagem PNG ou JPEG' },
  #          size: { less_than: 5.megabytes, message: 'deve ser menor que 5MB' },
  #          if: :avatar_attached?

  validate :validate_cpf_format
  validate :validate_cpf_valido
  validate :validate_phone_format
  validate :cpf_must_be_unique
  
  belongs_to :hierarquia, optional: true

  def avatar_attached?
    avatar.attached?
  end

  def admin?
    admin == true
  end

  def public_user?
    perfil&.name == 'Public'
  end

  # Adicione perfil aos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id email perfil_id created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[perfil]
  end

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

  def avatar_thumbnail
    return nil unless avatar.attached?
    
    avatar.variant(resize_to_fill: [100, 100]).processed
  rescue StandardError
    nil
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def unread_messages_count
    received_messages.unread.count
  end

  def unread_messages_count_for(current_user)
    received_messages.where(sender_id: current_user.id, read: false).count
  end

  def last_message_with(other_user)
    Message.where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)", 
                  id, other_user.id, other_user.id, id)
           .order(created_at: :desc)
           .first
  end

  def conversations
    Message.select("DISTINCT CASE 
                    WHEN sender_id = #{id} THEN recipient_id 
                    WHEN recipient_id = #{id} THEN sender_id 
                   END as user_id")
          .where("sender_id = ? OR recipient_id = ?", id, id)
  end

  def nivel_hierarquico
    hierarquia&.nivel
  end
  
  def nome_hierarquia
    hierarquia&.nome || "Sem hierarquia definida"
  end

  private

  def validate_cpf_format
    return if cpf.blank?
    
    # Remove caracteres não numéricos
    formatted_cpf = cpf.to_s.gsub(/[^\d]/, '')
    
    # Verifica se tem 11 dígitos
    unless formatted_cpf.match?(/\A\d{11}\z/)
      errors.add(:cpf, "deve conter exatamente 11 dígitos")
      return
    end
    
    # Normaliza o CPF removendo pontuação
    self.cpf = formatted_cpf
  end

  def validate_cpf_valido
    return if cpf.blank?
    
    unless cpf_valido?(cpf)
      errors.add(:cpf, "não é válido")
    end
  end

  def cpf_valido?(cpf)
    # Remove caracteres não numéricos
    cpf = cpf.to_s.gsub(/[^0-9]/, '')
    
    # Verifica o tamanho
    return false unless cpf.length == 11
    
    # Verifica CPFs com números repetidos (mais rigoroso)
    primeiro_digito = cpf[0]
    return false if cpf.chars.all? { |d| d == primeiro_digito }
    
    # Lista de CPFs inválidos conhecidos
    cpfs_invalidos = %w[
      00000000000 11111111111 22222222222 33333333333 44444444444
      55555555555 66666666666 77777777777 88888888888 99999999999
    ]
    return false if cpfs_invalidos.include?(cpf)
    
    # Cálculo do primeiro dígito verificador
    soma = 0
    9.times do |i|
      soma += cpf[i].to_i * (10 - i)
    end
    
    resto = soma % 11
    primeiro_dv = resto < 2 ? 0 : 11 - resto
    return false if primeiro_dv != cpf[9].to_i
    
    # Cálculo do segundo dígito verificador
    soma = 0
    10.times do |i|
      soma += cpf[i].to_i * (11 - i)
    end
    
    resto = soma % 11
    segundo_dv = resto < 2 ? 0 : 11 - resto
    return false if segundo_dv != cpf[10].to_i
    
    true
  end

  def validate_phone_format
    return if phone.blank?
    formatted_phone = phone.to_s.gsub(/[^\d]/, '')
    
    unless formatted_phone.match?(/\A\d{10,11}\z/)
      errors.add(:phone, "deve conter 10 ou 11 dígitos")
      return
    end
    
    self.phone = formatted_phone
  end

  def cpf_must_be_unique
    return unless cpf_changed?
    
    if User.where(cpf: cpf).where.not(id: id).exists?
      errors.add(:cpf, "já está em uso")
    end
  end
end
