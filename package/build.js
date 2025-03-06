











}).catch(() => process.exit(1))  // ...existing code...  external: [], // Remova chart.js dos externals se estiver presente  // ...existing code...require('esbuild').build({import "./channels"import "chartkick/chart.js"import "flowbite/dist/flowbite.turbo.js";import "./controllers"import "@hotwired/turbo-rails"// Entry point for the build script in your package.json