module.exports =
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
   modules:
        wrapper: 'commonjs'
        definition: 'commonjs'
  npm:
    enabled: on,
    globals: 
      jQuery: 'jquery',
      $: 'jquery',
      bootstrap: 'bootstrap'    
    styles:
      bootstrap: ['dist/css/bootstrap.css']   
  
