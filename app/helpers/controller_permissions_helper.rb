module ControllerPermissionsHelper
  def controller_permission_status_badge(controller_permission)
    if controller_permission.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def controller_permission_actions(controller_permission)
    links = []
    
    links << link_to(controller_permission, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_controller_permission_path(controller_permission), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if controller_permission.discarded?
      links << link_to(undiscard_controller_permission_path(controller_permission),
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
      links << link_to(discard_controller_permission_path(controller_permission),
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