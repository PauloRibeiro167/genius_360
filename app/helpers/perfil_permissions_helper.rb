module PerfilPermissionsHelper
  def create_perfil_permission_status_badge(create_perfil_permission)
    if create_perfil_permission.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def create_perfil_permission_actions(create_perfil_permission)
    links = []
    
    links << link_to(create_perfil_permission, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_create_perfil_permission_path(create_perfil_permission), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if create_perfil_permission.discarded?
      links << link_to(undiscard_create_perfil_permission_path(create_perfil_permission),
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
      links << link_to(discard_create_perfil_permission_path(create_perfil_permission),
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