class Admin::DashboardController < ApplicationController
  layout 'kanban'
  
  def index
    # Inicializar variáveis usadas na view
    @today_clients_count = User.where(role: 'attendant')
                              .where('created_at >= ?', Date.today.beginning_of_day)
                              .distinct.count rescue 0
    
    # Garantir que o dashboard tenha dados mesmo se o modelo Order não existir ainda
    @monthly_orders = if defined?(Order)
      {
        'Janeiro' => Order.by_month('January').count,
        'Fevereiro' => Order.by_month('February').count,
        'Março' => Order.by_month('March').count,
        'Abril' => Order.by_month('April').count,
        'Maio' => Order.by_month('May').count,
        'Junho' => Order.by_month('June').count,
        'Julho' => Order.by_month('July').count,
        'Agosto' => Order.by_month('August').count,
        'Setembro' => Order.by_month('September').count,
        'Outubro' => Order.by_month('October').count
      }
    else
      Hash.new(0)
    end

    @monthly_data = mock_monthly_data
    @chart_options = chart_options
    @tasks_data = mock_tasks_data
  end

  private

  def mock_monthly_data
    {
      'Janeiro' => 150,
      'Fevereiro' => 280,
      'Março' => 310,
      'Abril' => 340,
      'Maio' => 290,
      'Junho' => 380,
      'Julho' => 420,
      'Agosto' => 390,
      'Setembro' => 450,
      'Outubro' => 480
    }
  end

  def mock_tasks_data
    {
      pending: {
        count: 15,
        percentage: "+12%",
        label: "Pendentes"
      },
      in_progress: {
        count: 8,
        percentage: "+5%",
        label: "Em Progresso"
      },
      completed: {
        count: 23,
        percentage: "+15%",
        label: "Concluídas"
      }
    }
  end

  def chart_options
    {
      colors: ['#3b82f6'],
      legend: false,
      library: {
        scales: {
          x: { ticks: { color: '#ffffff' } },
          y: { ticks: { color: '#ffffff' } }
        }
      }
    }
  end
end
