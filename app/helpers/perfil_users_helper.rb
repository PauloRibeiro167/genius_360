module PerfilUsersHelper
  def perfil_user_status_badge(perfil_user)
    if perfil_user.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def perfil_user_actions(perfil_user)
    links = []
    
    links << link_to(perfil_user, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_perfil_user_path(perfil_user), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if perfil_user.discarded?
      links << link_to(undiscard_perfil_user_path(perfil_user),
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
      links << link_to(discard_perfil_user_path(perfil_user),
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