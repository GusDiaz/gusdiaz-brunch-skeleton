module.exports =
  server:
    hostname: '0.0.0.0'
  files:
    javascripts:
      joinTo: 'weather.js'
    stylesheets:
      joinTo: 'weather.css'
  plugins:
    autoReload:
      enabled:
        css: true,
        js: true,
        assets: true
   modules:
        wrapper: 'commonjs'
        definition: 'commonjs'
  npm:
    enabled: off,
    globals:
      jQuery: 'jquery',
      $: 'jquery',
      bootstrap: 'bootstrap'
      moment: 'moment'
    styles:
      bootstrap: ['dist/css/bootstrap.css'],
      "lato-font": ['css/lato-font.css']
