import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  connect() {
    document.addEventListener("DOMContentLoaded", function () {
      var ctx = document.getElementById("monthlySalesChart").getContext("2d");
      new Chart(ctx, {
        type: "bar",
        data: {
          labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"],
          datasets: [{
            label: "Sales",
            data: [100, 350, 180, 280, 150, 170, 260, 90, 140, 300],
            backgroundColor: "#3b82f6",
            borderRadius: 4
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: { ticks: { color: "#ffffff" } },
            y: { ticks: { color: "#ffffff" } }
          }
        }
      });
    });
  }
}
