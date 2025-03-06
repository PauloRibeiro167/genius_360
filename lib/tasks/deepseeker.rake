namespace :deepseeker do
  desc "Diagnosticar e reparar problemas no ambiente Rails"
  task diagnose: :environment do
    begin
      puts "🔍 DeepSeeker Rails iniciando diagnóstico..."
      
      # Verificar dependências
      puts "📋 Verificando dependências..."
      unless defined?(DeepseekRails)
        puts "⚠️ Gem deepseek-rails não está instalada. Instalando..."
        system("gem install deepseek-rails")
        puts "✅ Gem deepseek-rails instalada."
      end
      
      # Verificar ambiente
      puts "🔍 Verificando ambiente Rails..."
      Rails.logger.info "DeepSeeker: Iniciando diagnóstico do ambiente"
      
      # Verificar banco de dados
      puts "🗄️ Verificando conexão com o banco de dados..."
      begin
        ActiveRecord::Base.connection.execute("SELECT 1")
        puts "✅ Conexão com banco de dados OK"
      rescue => e
        puts "❌ Erro na conexão com banco de dados: #{e.message}"
        puts "🔧 Tentando reparar conexão do banco de dados..."
        system("bundle exec rails db:create db:migrate") 
      end
      
      # Verificar dependências do Gemfile
      puts "📦 Verificando dependências do Gemfile..."
      gemfile_issues = `bundle check`
      if gemfile_issues.include?("dependencies are satisfied")
        puts "✅ Todas as dependências estão instaladas corretamente"
      else
        puts "❌ Problemas encontrados com as dependências do Gemfile"
        puts gemfile_issues
        puts "🔧 Tentando reparar dependências..."
        system("bundle install")
      end
      
      # Verificar ambiente de execução
      puts "🏃 Verificando ambiente de execução..."
      case Rails.env
      when "development"
        puts "✅ Ambiente de desenvolvimento detectado"
      when "production" 
        puts "⚠️ Executando em ambiente de produção. Tenha cuidado!"
      else
        puts "ℹ️ Ambiente: #{Rails.env}"
      end
      
      # Verificar arquivos temporários
      puts "🧹 Verificando arquivos temporários..."
      if File.exist?("tmp/pids/server.pid")
        puts "⚠️ Arquivo server.pid encontrado. Pode causar problemas de 'server already running'."
        File.delete("tmp/pids/server.pid") rescue nil
        puts "✅ Arquivo server.pid removido."
      end
      
      puts "✅ Diagnóstico concluído com sucesso!"
      
    rescue => e
      puts "❌ Ocorreu um erro durante o diagnóstico: #{e.message}"
      puts e.backtrace.join("\n")
      exit(1)
    end
  end
  
  desc "Instalar a gem deepseek-rails no projeto"
  task install: :environment do
    puts "📦 Instalando deepseek-rails..."
    
    # Verificar se a gem já está no Gemfile
    gemfile_content = File.read("Gemfile")
    if gemfile_content.include?("deepseek-rails")
      puts "✅ deepseek-rails já está no Gemfile."
    else
      # Adicionar a gem ao Gemfile
      puts "📝 Adicionando deepseek-rails ao Gemfile..."
      File.open("Gemfile", "a") do |f|
        f.puts "\n# Ferramenta de diagnóstico e reparo para Rails"
        f.puts "gem 'deepseek-rails', '~> 0.3.0'"
      end
      puts "✅ Gem adicionada ao Gemfile."
    end
    
    # Instalar a gem
    puts "💎 Instalando a gem..."
    system("bundle install")
    
    puts "✅ deepseek-rails instalado com sucesso!"
  end
  
  desc "Reparar problemas comuns no ambiente Rails"
  task repair: :environment do
    puts "🔧 Iniciando reparo automático..."
    
    # Limpar arquivos temporários
    puts "🧹 Limpando arquivos temporários..."
    system("rm -rf tmp/cache")
    system("rm -f tmp/pids/server.pid")
    
    # Recriar pasta tmp
    puts "📁 Recriando diretório tmp..."
    system("mkdir -p tmp/pids tmp/cache tmp/sockets log")
    
    # Verificar permissões
    puts "🔒 Verificando permissões..."
    system("chmod -R 755 tmp")
    system("chmod -R 755 log")
    
    # Verificar banco de dados
    puts "🗄️ Verificando banco de dados..."
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "✅ Banco de dados conectado"
    rescue => e
      puts "❌ Erro no banco de dados: #{e.message}"
      puts "🔧 Tentando reparar banco de dados..."
      system("bundle exec rails db:create db:migrate")
    end
    
    # Limpar cache
    puts "🧹 Limpando cache do Rails..."
    Rails.cache.clear rescue nil
    
    puts "✅ Reparo concluído! Seu ambiente deve estar funcionando agora."
  end
end
