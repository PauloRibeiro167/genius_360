class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  include Discard::Model

  belongs_to :perfil
  has_many :perfil_permissions, through: :perfil
  has_many :permissions, through: :perfil_permissions
  has_one_attached :avatar

  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :perfil_id, presence: true

  # Validações do avatar
  # validates :avatar,
  #          content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'], message: 'deve ser uma imagem PNG ou JPEG' },
  #          size: { less_than: 5.megabytes, message: 'deve ser menor que 5MB' },
  #          if: :avatar_attached?

  validate :validate_cpf_format
  validate :validate_phone_format
  
  def avatar_attached?
    avatar.attached?
  end

  def admin?
    perfil == 'admin'
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

  private

  def validate_cpf_format
    return if cpf.blank?
    formatted_cpf = cpf.to_s.gsub(/[^\d]/, '')
    
    unless formatted_cpf.match?(/\A\d{11}\z/)
      errors.add(:cpf, "deve conter exatamente 11 dígitos")
      return
    end
    
    self.cpf = formatted_cpf
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
end
