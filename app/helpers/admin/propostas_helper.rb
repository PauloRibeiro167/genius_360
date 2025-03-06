module Admin::PropostasHelper
  def admin_proposta_status_badge(admin_proposta)
    if admin_proposta.discarded?
      content_tag(:span, "Inativo", class: "badge bg-danger")
    else
      content_tag(:span, "Ativo", class: "badge bg-success")
    end
  end

  def admin_proposta_actions(admin_proposta)
    links = []
    
    links << link_to(admin_proposta, class: "text-dark") do
      content_tag(:i, "", class: "fa-regular fa-eye")
    end

    links << link_to(edit_admin_proposta_path(admin_proposta), class: "text-warning") do
      content_tag(:i, "", class: "fa-regular fa-edit")
    end

    if admin_proposta.discarded?
      links << link_to(undiscard_admin_proposta_path(admin_proposta),
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
      links << link_to(discard_admin_proposta_path(admin_proposta),
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