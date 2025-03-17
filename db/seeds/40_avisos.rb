require 'colorize'

# Função para normalizar texto
def normalizar_texto(texto)
    return nil if texto.nil?
    texto.to_s
         .unicode_normalize(:nfkd)
         .gsub(/[^\x00-\x7F]/, '')
         .gsub(/[^\w\s-]/, ' ')
         .squeeze(' ')
         .strip
end

# Contadores para estatísticas
total_avisos = 0
avisos_criados = 0
avisos_com_erro = 0

puts "\n Iniciando criação de avisos do sistema...".colorize(:blue)

# Lista de avisos para serem criados
avisos = [
  {
    titulo: "Atualização do Sistema - Versão 2.5",
    descricao: "Informamos que no próximo domingo (17/03/2025), o sistema Genius360 será atualizado para a versão 2.5. Durante a atualização, que ocorrerá das 02:00 às 04:00 da manhã, o sistema ficará temporariamente indisponível. A nova versão traz melhorias de performance e novas funcionalidades, incluindo relatórios avançados e exportação de dados em novos formatos. Recomendamos que os usuários finalizem suas atividades no sistema antes do início da manutenção."
  },
  {
    titulo: "Novo Módulo de Análise Preditiva",
    descricao: "Temos o prazer de anunciar o lançamento do novo módulo de Análise Preditiva, disponível para todos os usuários a partir de hoje. Com esta nova ferramenta, será possível realizar previsões baseadas em histórico de dados, identificar tendências e tomar decisões estratégicas com maior precisão. Para conhecer mais sobre esta funcionalidade, acesse o menu Ajuda > Tutoriais > Análise Preditiva."
  },
  {
    titulo: "Treinamento Online - Funcionalidades Avançadas",
    descricao: "Estamos organizando um treinamento online sobre funcionalidades avançadas do Genius360, que será realizado na próxima terça-feira (19/03/2025), das 14:00 às 16:00. Para participar, inscreva-se através do link disponível na página inicial do sistema. Vagas limitadas!"
  },
  {
    titulo: "Migração para Servidor de Alta Performance",
    descricao: "Informamos que na próxima semana realizaremos a migração do sistema para servidores de alta performance, visando melhorar a velocidade de resposta e estabilidade do Genius360. A migração está programada para ocorrer no dia 20/03/2025, entre 23:00 e 01:00. Durante este período, o acesso ao sistema poderá sofrer instabilidades. Pedimos desculpas pelo inconveniente."
  },
  {
    titulo: "Nova Política de Segurança",
    descricao: "A partir do dia 01/04/2025, entrarão em vigor novas políticas de segurança para o acesso ao sistema. As senhas deverão conter no mínimo 8 caracteres, incluindo letras maiúsculas, minúsculas, números e caracteres especiais. Além disso, será implementada a autenticação em dois fatores para todos os usuários. Mais informações serão enviadas por e-mail."
  },
  {
    titulo: "Disponibilidade de Novos Relatórios Financeiros",
    descricao: "Acabamos de disponibilizar novos modelos de relatórios financeiros, que permitem uma análise mais detalhada dos indicadores de desempenho. Para acessá-los, vá ao módulo Relatórios > Financeiro > Novos Modelos. Sugestões e feedback são bem-vindos através do canal de suporte."
  },
  {
    titulo: "Manutenção Preventiva - Sistema de Backup",
    descricao: "No próximo sábado (15/03/2025), realizaremos manutenção preventiva em nosso sistema de backup, entre 10:00 e 12:00. Durante este período, o sistema permanecerá disponível, mas poderá apresentar lentidão em algumas operações. Recomendamos agendar atividades críticas para outro horário."
  },
  {
    titulo: "Documentação Técnica Atualizada",
    descricao: "Informamos que a documentação técnica do sistema foi completamente atualizada e está disponível na Base de Conhecimento. Os novos documentos incluem guias passo a passo para todas as funcionalidades, FAQ atualizado e vídeos tutoriais. Acesse através do menu Ajuda > Base de Conhecimento."
  },
  {
    titulo: "Alterações no Suporte Técnico",
    descricao: "A partir de 01/04/2025, o horário de atendimento do suporte técnico será estendido, passando a funcionar das 07:00 às 22:00, de segunda a sexta-feira. Além disso, implementaremos um sistema de chat online para atendimento em tempo real. Contamos com sua compreensão durante o período de transição."
  },
  {
    titulo: "Parceria Estratégica com Amazon Web Services",
    descricao: "Temos o prazer de anunciar nossa nova parceria estratégica com a Amazon Web Services (AWS), que permitirá maior escalabilidade, segurança e disponibilidade para o sistema Genius360. A migração para a infraestrutura AWS ocorrerá de forma gradual nos próximos meses, sem impacto para os usuários."
  },
  {
    titulo: "Pesquisa de Satisfação Anual",
    descricao: "Convidamos todos os usuários a participar de nossa Pesquisa de Satisfação Anual, que estará disponível de 20/03 a 05/04/2025. Sua opinião é fundamental para continuarmos evoluindo o Genius360 de acordo com as necessidades dos nossos clientes. Os participantes concorrerão a um treinamento exclusivo sobre as funcionalidades avançadas do sistema."
  },
  {
    titulo: "Novo Aplicativo Mobile",
    descricao: "Lançamos o novo aplicativo Genius360 para dispositivos móveis, disponível para download nas plataformas Android e iOS. Com o app, é possível acessar relatórios, receber notificações e aprovar solicitações mesmo quando estiver fora do escritório. Baixe agora e mantenha-se conectado!"
  },
  {
    titulo: "Mudanças na Interface do Usuário",
    descricao: "Baseados no feedback dos usuários, implementamos melhorias na interface do sistema, tornando a navegação mais intuitiva e acessível. As alterações incluem um novo menu lateral retrátil, atalhos personalizáveis e modo escuro. Para conhecer todas as novidades, acesse o tutorial disponível na página inicial."
  },
  {
    titulo: "Integração com Microsoft Teams",
    descricao: "Agora o Genius360 conta com integração nativa com o Microsoft Teams! Esta nova funcionalidade permite receber notificações, compartilhar relatórios e colaborar em tempo real sem sair do ambiente do Teams. Para configurar a integração, acesse Configurações > Integrações > Microsoft Teams."
  },
  {
    titulo: "Webinar: Tendências em Business Intelligence",
    descricao: "Convidamos todos os usuários para o webinar 'Tendências em Business Intelligence para 2025', que será apresentado pelo nosso Diretor de Tecnologia no dia 22/03/2025, às 16:00. Serão discutidas as principais novidades do mercado e como o Genius360 está se preparando para o futuro. Inscrições pelo portal do cliente."
  }
]

puts " Processando #{avisos.length} avisos...".colorize(:cyan)

# Criando os avisos no banco de dados
avisos.each_with_index do |aviso, index|
    begin
        # Define datas diferentes para os avisos
        dias_atras = index < 5 ? rand(0..7) : rand(8..30)
        created_at = Time.now - dias_atras.days
        
        # Normaliza os textos
        titulo_normalizado = normalizar_texto(aviso[:titulo])
        descricao_normalizada = normalizar_texto(aviso[:descricao])
        
        # Cria o aviso
        novo_aviso = Aviso.new(
            titulo: titulo_normalizado,
            descricao: descricao_normalizada,
            created_at: created_at,
            updated_at: created_at
        )
        
        if novo_aviso.save
            avisos_criados += 1
            puts "🟢 Aviso criado: #{titulo_normalizado}".colorize(:green)
        else
            avisos_com_erro += 1
            puts " Erro ao criar aviso: #{novo_aviso.errors.full_messages.join(', ')}".colorize(:red)
        end
    rescue => e
        avisos_com_erro += 1
        puts " Erro inesperado: #{e.message}".colorize(:red)
        puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
    end
end

# Criando aviso descartado para teste
begin
    puts "\n Criando aviso de teste para soft delete...".colorize(:cyan)
    aviso_descartado = Aviso.new(
        titulo: normalizar_texto("Aviso Temporário - Descartado"),
        descricao: normalizar_texto("Este é um aviso temporário que foi descartado. Usado apenas para fins de teste."),
        created_at: Time.now - 45.days,
        updated_at: Time.now - 45.days,
        discarded_at: Time.now - 15.days
    )

    if aviso_descartado.save
        avisos_criados += 1
        puts "🟢 Aviso descartado criado com sucesso".colorize(:green)
    else
        avisos_com_erro += 1
        puts " Erro ao criar aviso descartado: #{aviso_descartado.errors.full_messages.join(', ')}".colorize(:red)
    end
rescue => e
    avisos_com_erro += 1
    puts " Erro ao criar aviso descartado: #{e.message}".colorize(:red)
end

# Estatísticas finais
total_avisos = Aviso.count
total_descartados = Aviso.where.not(discarded_at: nil).count

puts "\n=== Resumo da Operação ===".colorize(:white)
puts "⚪ Total de avisos processados: #{avisos.length}".colorize(:white)
puts "🟢 Avisos criados com sucesso: #{avisos_criados}".colorize(:green)
puts " Avisos com erro: #{avisos_com_erro}".colorize(:red)
puts " Total no banco de dados: #{total_avisos} (#{total_descartados} descartados)".colorize(:cyan)
puts "⚫ Operação finalizada em: #{Time.now}".colorize(:light_black)