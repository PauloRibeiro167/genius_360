class PwaController < ApplicationController
  def pwa
  end

  def manifest
    render json: {
      "name": "Genius 360°",
      "short_name": "Genius 360°",
      "description": "Plataforma integrada para análise e contratação de crédito",
      "start_url": "/",
      "display": "standalone",
      "background_color": "#ffffff",
      "theme_color": "#000000",
      "icons": [
      {
        "src": "/icon.png",
        "sizes": "192x192",
        "type": "image/png"
      },
      {
        "src": "/icon.png",
        "sizes": "512x512",
        "type": "image/png"
      }
      ]
    }
  end
end
