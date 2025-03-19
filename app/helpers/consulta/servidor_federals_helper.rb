module Consulta::ServidorFederalsHelper
  def consulta_servidor_federal_status_badge(consulta_servidor_federal)
    if consulta_servidor_federal.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def consulta_servidor_federal_actions(consulta_servidor_federal)
    links = []
    
    links << link_to(consulta_servidor_federal, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_consulta_servidor_federal_path(consulta_servidor_federal), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if consulta_servidor_federal.discarded?
      links << link_to(undiscard_consulta_servidor_federal_path(consulta_servidor_federal),
        class: "text-success",
        data: {
          controller: "sweetalert",
          action: "click->sweetalert#confirmAlert",
          sweetalert_confirm: "Tem certeza que deseja reativar?",
          turbo_method: :patch
        }) do
        content_tag(:i, "", class: "fa-regular fa-trash-restore")
      end
    else
      links << link_to(discard_consulta_servidor_federal_path(consulta_servidor_federal),
        class: "text-danger",
        data: {
          controller: "sweetalert",
          action: "click->sweetalert#confirmAlert",
          sweetalert_confirm: "Tem certeza que deseja desativar?",
          turbo_method: :patch
        }) do
        content_tag(:i, "", class: "fa-regular fa-trash-can")
      end
    end

    safe_join(links, " ")
  end
end