puts "\nCriando usuário Super Admin..."

# Função para gerar CPFs válidos
def generate_valid_cpf
  numbers = 9.times.map { rand(10) }
  
  # Calcula o primeiro dígito verificador
  factor = 10
  sum = 0
  9.times do |i|
    sum += numbers[i] * factor
    factor -= 1
  end
  
  remainder = sum % 11
  first_validator = remainder < 2 ? 0 : 11 - remainder
  
  # Adiciona o primeiro dígito verificador
  numbers << first_validator
  
  # Calcula o segundo dígito verificador
  factor = 11
  sum = 0
  10.times do |i|
    sum += numbers[i] * factor
    factor -= 1
  end
  
  remainder = sum % 11
  second_validator = remainder < 2 ? 0 : 11 - remainder
  
  # Adiciona o segundo dígito verificador
  numbers << second_validator
  
  # Formata o CPF
  "#{numbers[0..2].join}.#{numbers[3..5].join}.#{numbers[6..8].join}-#{numbers[9..10].join}"
end

# Usuário principal com CPF gerado aleatoriamente
valid_cpf = generate_valid_cpf
user = User.new(
  email: 'paulorezende877@gmail.com',
  password: 'senha1',
  password_confirmation: 'senha1',
  first_name: 'Paulo',
  last_name: 'Ribeiro',
  cpf: valid_cpf,
  phone: '(85) 99686-1158',
  admin: true,
  perfil: Perfil.find_by(name: 'Super Admin')
)

if user.save
  puts "Usuário Super Admin principal criado com sucesso!"
else
  puts "Erro ao criar usuário principal: #{user.errors.full_messages.join(', ')}"
end

puts "\nCriando usuários para cada perfil..."

# Array de usuários baseados nos perfis disponíveis
user_examples = [
  {
    email: 'admin@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Admin',
    last_name: 'Principal',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-1111',
    admin: true,
    perfil_name: 'Super Admin'
  },
  {
    email: 'analista@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Ana',
    last_name: 'Dados',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-2222',
    admin: false,
    perfil_name: 'Analista de Dados'
  },
  {
    email: 'gerente_comercial@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Geraldo',
    last_name: 'Comercial',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-3333',
    admin: false,
    perfil_name: 'Gerente Comercial'
  },
  {
    email: 'gerente_exec@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Gustavo',
    last_name: 'Executivo',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-4433',
    admin: false,
    perfil_name: 'Gerente Executivo'
  },
  {
    email: 'diretor@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Diana',
    last_name: 'Executiva',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-4444',
    admin: false,
    perfil_name: 'Diretor Executivo'
  },
  {
    email: 'digitador@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Daniela',
    last_name: 'Digitação',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-5555',
    admin: false,
    perfil_name: 'Digitador'
  },
  {
    email: 'marketing@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Maria',
    last_name: 'Marketing',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-6666',
    admin: false,
    perfil_name: 'Gerente de Marketing'
  },
  {
    email: 'estrategia@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Estevão',
    last_name: 'Estratégico',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-7766',
    admin: false,
    perfil_name: 'Gerente de Estrategia'
  },
  {
    email: 'supervisor@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Sérgio',
    last_name: 'Supervisor',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-7777',
    admin: false,
    perfil_name: 'Supervisor'
  },
  {
    email: 'monitor@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Moacir',
    last_name: 'Fraudes',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-8888',
    admin: false,
    perfil_name: 'Monitor de Fraudes'
  },
  {
    email: 'crm@genius360.com',
    password: 'senha123',
    password_confirmation: 'senha123',
    first_name: 'Carlos',
    last_name: 'Relacionamento',
    cpf: generate_valid_cpf,
    phone: '(85) 99999-9999',
    admin: false,
    perfil_name: 'Gestor de CRM'
  }
]

user_examples.each do |user_data|
  perfil = Perfil.find_by(name: user_data[:perfil_name])
  unless perfil
    puts "Perfil '#{user_data[:perfil_name]}' não encontrado. Pulando criação do usuário #{user_data[:email]}"
    next
  end

  user = User.new(
    email: user_data[:email],
    password: user_data[:password],
    password_confirmation: user_data[:password_confirmation],
    first_name: user_data[:first_name],
    last_name: user_data[:last_name],
    cpf: user_data[:cpf],
    phone: user_data[:phone],
    admin: user_data[:admin],
    perfil: perfil
  )

  if user.save
    puts "Usuário #{user.email} (#{user_data[:perfil_name]}) criado com sucesso!"
  else
    puts "Erro ao criar usuário #{user.email}: #{user.errors.full_messages.join(', ')}"
  end
end

puts "\nCriação de usuários concluída!"
