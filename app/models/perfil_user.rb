class PerfilUser < ApplicationRecord  
  self.table_name = 'perfil_users'

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id perfil_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user perfil]
  end

  belongs_to :user, required: true
  belongs_to :perfil, required: true
end
