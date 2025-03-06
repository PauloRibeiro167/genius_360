module Devise::SessionsHelper
  def devise_session_status_badge(devise_session)
    if devise_session.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def devise_session_actions(devise_session)
    links = []
    
    links << link_to(devise_session, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_devise_session_path(devise_session), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if devise_session.discarded?
      links << link_to(undiscard_devise_session_path(devise_session),
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
      links << link_to(discard_devise_session_path(devise_session),
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