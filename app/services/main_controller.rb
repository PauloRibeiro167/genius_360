require_relative "api/pbc_controller"
require_relative "api/servCe_controller"
require_relative "api/servFederal_controller"
require_relative "api/servPi_controller"
require 'singleton'

class MainController < ApplicationController
  include Singleton
  INTERVAL_DAYS = 10

  def initialize
    @controllers = [
      PbcController.new,
      ServCeController.new,
      ServFederalController.new,
      ServPiController.new
    ]
  end

  def start
    if should_run_today?
      Rails.logger.info("Iniciando coleta programada de dados das APIs...")
      run_controllers
    else
      Rails.logger.info("Aguardando próximo período de coleta...")
    end
    schedule_next_check
  rescue => e
    Rails.logger.error("Erro na execução principal: #{e.message}")
  end

  private

  def should_run_today?
    last_run = ApiData.maximum(:collected_at)
    return true if last_run.nil?
    
    days_since_last_run = ((Time.current - last_run) / 1.day).floor
    days_since_last_run >= INTERVAL_DAYS
  end

  def schedule_next_check
    Thread.new do
      sleep(86400) # Verifica uma vez por dia (24 horas)
      start
    end
  end

  def run_controllers
    @controllers.each do |controller|
      begin
        Rails.logger.info("Executando #{controller.class.name}")
        controller.run
      rescue => e
        Rails.logger.error("Erro ao executar #{controller.class.name}: #{e.message}")
      end
    end
  end
end
