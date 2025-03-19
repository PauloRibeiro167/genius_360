module PropostasHelper
  def render_form_fields(fields)
    content_tag(:div, class: 'space-y-3') do
      fields.map do |field|
        render_field(field)
      end.join.html_safe
    end
  end

  private

  def render_field(field)
    case field[:type]
    when :select
      render_select_field(field)
    when :grid
      render_grid_fields(field)
    else
      render_text_field(field)
    end
  end

  def render_text_field(field)
    content_tag(:div, class: 'space-y-2') do
      label = label_tag(field[:name], field[:label], class: 'block mb-2 text-sm font-medium text-gray-100 text-center')
      
      # Determina a classe de borda e placeholder com segurança
      if field[:tipo] && CARD_STYLES[field[:tipo]]
        border_class = CARD_STYLES[field[:tipo]][:container].sub('bg-', 'border-')
        placeholder_class = CARD_STYLES[field[:tipo]][:container].sub('bg-', 'placeholder-')
      else
        border_class = 'border-gray-500' # Estilo padrão quando tipo não existe
        placeholder_class = 'placeholder-gray-400' # Placeholder padrão
      end
      
      input = text_field_tag(
        field[:name], 
        field[:value], 
        class: "border #{border_class} border-opacity-30 text-gray-100 text-sm rounded-lg focus:ring-opacity-50 focus:border-opacity-50 block w-full p-2.5 #{placeholder_class} placeholder-opacity-70",
        placeholder: field[:placeholder],
        type: field[:type],
        required: field[:required]
      )
      
      label + input
    end
  end

  def render_select_field(field)
    content_tag(:div, class: 'space-y-2') do
      label = label_tag(field[:name], field[:label], class: 'block mb-2 text-sm font-medium text-gray-100 text-center')
      
      # Passa o tipo do card para o campo para garantir consistência visual
      field_with_tipo = field.clone
      field_with_tipo[:tipo] ||= get_tipo_from_form # Obtém o tipo do card a partir do formulário pai se não estiver definido
      
      # Determina os estilos com base no tipo do card
      if field_with_tipo[:tipo] && CARD_STYLES[field_with_tipo[:tipo]]
        border_class = CARD_STYLES[field_with_tipo[:tipo]][:container].sub('bg-', 'border-')
        bg_class = CARD_STYLES[field_with_tipo[:tipo]][:container] # Usa a cor do card correspondente
        text_color = 'text-gray-100'
      else
        border_class = 'border-gray-500' # Estilo padrão quando tipo não existe
        bg_class = 'bg-gray-700' # Cor de fundo padrão (não transparente)
        text_color = 'text-gray-100'
      end
      
      # Aplica estilos ao select, incluindo background semi-transparente
      select = select_tag(
        field[:name],
        options_for_select(field[:options], field[:selected]),
        class: "border #{border_class} border-opacity-30 #{text_color} text-sm rounded-lg 
                focus:ring-opacity-50 focus:border-opacity-50 block w-full p-2.5 
                #{bg_class} bg-opacity-50 text-center appearance-none"
      )
      
      # Adiciona um wrapper para criar o ícone de seta personalizado
      select_wrapper = content_tag(:div, class: 'relative') do
        concat(select)
        # Adiciona o ícone de seta customizado
        concat(content_tag(:div, class: "absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none #{text_color}") do
          content_tag(:svg, class: "w-5 h-5", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20", fill: "currentColor") do
            content_tag(:path, "", fill_rule: "evenodd", d: "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 011.414 1.414l-4 4a1 1 01-1.414 0l-4-4a1 1 010-1.414z", clip_rule: "evenodd")
          end
        end)
      end
      
      label + select_wrapper
    end
  end

  # Método auxiliar para obter o tipo do card a partir do contexto atual
  def get_tipo_from_form
    # Tenta obter o tipo a partir do parâmetro hidden ou do contexto do card atual
    # Este é um método stub que pode ser implementado conforme a necessidade específica
    return :inss # Valor padrão para teste
  end

  def render_grid_fields(field)
    content_tag(:div, class: 'grid grid-cols-2 gap-3') do
      field[:fields].map do |sub_field|
        render_field(sub_field)
      end.join.html_safe
    end
  end

  CARD_STYLES = {
    inss: {
      container: "bg-indigo-900",
      shadow: "hover:shadow-indigo-500/25",
      button: "from-blue-500 to-blue-700 hover:from-blue-600 hover:to-blue-800 focus:ring-blue-500"
    },
    loas_bpc: {
      container: "bg-purple-900",
      shadow: "hover:shadow-purple-500/25",
      button: "from-purple-500 to-purple-700 hover:from-purple-600 hover:to-purple-800 focus:ring-purple-500"
    },
    servidor_federal: {
      container: "bg-green-900",
      shadow: "hover:shadow-green-500/25",
      button: "from-green-500 to-green-700 hover:from-green-600 hover:to-green-800 focus:ring-green-500"
    },
    servidor_estadual_municipal: {
      container: "bg-amber-900",
      shadow: "hover:shadow-amber-500/25",
      button: "from-amber-500 to-amber-700 hover:from-amber-600 hover:to-amber-800 focus:ring-amber-500"
    }
  }

  def render_consulta_card(tipo:, titulo:, icon_path:, fields:, button_text:)
    styles = CARD_STYLES[tipo]
    content_tag(:div, class: "p-10 ml-6 mr-6 mb-2 #{styles[:container]} rounded-lg backdrop-blur border-transparent bg-clip-padding hover:shadow-lg #{styles[:shadow]} transition duration-300 text-center") do
      concat(render_card_header(titulo, icon_path))
      concat(render_card_form(tipo, fields, button_text, "#{styles[:button]} flex justify-center w-full p-6 rounded-md"))
    end
  end

  private

  def render_card_header(titulo, icon_path)
    content_tag(:h3, class: "text-white font-bold text-lg mb-3 flex items-center justify-center w-full") do
      concat(content_tag(:svg, class: "h-6 w-6 mr-2", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", xmlns: "http://www.w3.org/2000/svg") do
        content_tag(:path, nil, stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: icon_path)
      end)
      concat(titulo)
    end
  end

  def render_card_form(tipo, fields, button_text, button_styles)
    form_tag(buscar_beneficios_admin_propostas_path, method: :post, class: "space-y-3") do
      concat(hidden_field_tag(:tipo_consulta, tipo))
      concat(render_form_fields(fields))
      concat(submit_tag(button_text, class: "px-3 py-1.5 bg-gradient-to-r #{button_styles} text-white rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 transition-all duration-200 text-sm"))
    end
  end
end
