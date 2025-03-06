module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-800 text-green-100 border border-green-700"
    when :alert, :error
      "bg-red-800 text-red-100 border border-red-700"
    when :warning
      "bg-yellow-800 text-yellow-100 border border-yellow-700"
    else
      "bg-purple-800 text-purple-100 border border-purple-700"
    end
  end

  def service_card(title:, description:, icon1:, icon2:, alert_text:)
    content_tag :div, 
      class: "service-card bg-white/10 p-6 rounded-lg w-full min-h-[400px] flex flex-col justify-between transform transition-all duration-300 hover:scale-105 hover:shadow-xl", 
      data: { 
        controller: "service-alert",
        "service-alert-title-value": title,
        "service-alert-text-value": alert_text
      } do
        # Wrapper principal com flex
        content_tag :div, class: "flex flex-col h-full" do
          # Ícones no topo com tamanho fixo
          concat(content_tag(:div, class: "h-24 flex items-center space-x-2 justify-center") do
            concat content_tag(:i, nil, class: "#{icon1} text-5xl text-white")
            concat content_tag(:i, nil, class: "#{icon2} text-3xl text-yellow-400")
          end)
          
          # Conteúdo central com flex-grow
          concat(content_tag(:div, class: "flex-grow flex flex-col items-center justify-center py-4") do
            concat content_tag(:h2, title, class: "text-xl font-semibold text-white mb-4 text-center")
            concat content_tag(:p, description, class: "text-gray-200 text-center")
          end)
          
          # Botão na parte inferior com altura fixa
          concat(content_tag(:div, class: "h-16 flex items-center justify-center") do
            concat(content_tag(:button, 
              "Ver mais",
              class: "w-full px-4 py-2 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition-colors duration-300",
              data: {
                action: "click->service-alert#showAlert"
              }
            ))
          end)
        end
    end
  end
end
