require 'colorize'

class SeedLogger
  class << self
    def sucesso(msg)
      puts "#{timestamp} ✅ #{msg}".colorize(:green)
    end

    def erro(msg)
      puts "#{timestamp} ❌ #{msg}".colorize(:red)
    end

    def info(msg)
      puts "#{timestamp} ℹ️  #{msg}".colorize(:blue)
    end

    def alerta(msg)
      puts "#{timestamp} 🟡 #{msg}".colorize(:yellow)
    end

    def debug(msg)
      puts "#{timestamp} 🟣 #{msg}".colorize(:magenta)
    end

    def arquivo(msg)
      puts "#{timestamp} 📄 #{msg}".colorize(:cyan)
    end

    def log(msg)
      puts "#{timestamp} ⚫ #{msg}".colorize(:light_black)
    end

    def exibir_barra_progresso(atual, total, titulo)
      porcentagem = (atual.to_f / total * 100).round(1)
      barra_tamanho = 30
      completo = (porcentagem / 100.0 * barra_tamanho).round
      
      barra = "["
      barra += "=" * completo
      barra += ">" if completo < barra_tamanho
      barra += " " * (barra_tamanho - completo)
      barra += "]"
      
      print "\r#{timestamp} #{titulo}: #{barra} #{porcentagem}% (#{atual}/#{total})".colorize(:cyan)
    end

    private

    def timestamp
      "[#{Time.now.strftime('%H:%M:%S')}]"
    end
  end
end
