module.exports =
  npm:
    enabled: off
  files:
    javascripts:
      joinTo: 'app.js'
    stylesheets:
      joinTo: 'app.css'
  plugins:
    autoReload:
      enabled:
        css: true,
        js: true,
        assets: true
      match:
        stylesheets: ['*.scss','*.css'],
        javascripts: ['*.coffee','*.js'],
        assets:      ['*.html','*.jade']
   modules:
        wrapper: 'amd'
        definition: 'amd'
