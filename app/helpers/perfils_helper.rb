module PerfilsHelper
  def perfil_status_badge(perfil)
    if perfil.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def perfil_actions(perfil)
    links = []
    
    links << link_to(perfil, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_perfil_path(perfil), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if perfil.discarded?
      links << link_to(undiscard_perfil_path(perfil),
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
      links << link_to(discard_perfil_path(perfil),
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