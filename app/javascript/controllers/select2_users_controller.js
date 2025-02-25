import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import 'select2'

export default class extends Controller {
  connect() {
    $(this.element).select2({
      theme: "classic",
      ajax: {
        url: this.element.dataset.url,
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term
          };
        },
        processResults: function (data) {
          return {
            results: data.map(user => ({
              id: user.id,
              text: user.name
            }))
          };
        },
        cache: true
      },
      minimumInputLength: 2,
      placeholder: this.element.dataset.placeholder
    });
  }

  disconnect() {
    $(this.element).select2('destroy')
  }
}
