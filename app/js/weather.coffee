$ () ->
  corsProxy = ""
  window.autoremoveImage = (imageToRemove) ->
    $(imageToRemove).remove()
  window.showTab = (tabClass) ->
    window.counters = window.counters || {}
    window.counters[tabClass] = (window.counters[tabClass] || 0) + 1
    if $(".#{tabClass} img").length && window.counters[tabClass] >= $(".#{tabClass} img").length
      $(".#{tabClass}").removeClass('hide')
  rotate_images = ($image_container_css_class) ->
    current = 0
    setInterval(
      () ->
        images = $(".#{$image_container_css_class} img")
        imageCurrent = $(".#{$image_container_css_class} img.current")
        imagePrevious = $(".#{$image_container_css_class} img.previous")
        imagePrevious.removeClass("previous")
        imageCurrent.addClass("previous")
        imageCurrent.removeClass("current")
        length = images.length
        $e = $(images[current])
        $e.addClass("current")
        if current >= length - 1
          current = 0
        else
          current++
      ,450
    )

  smnSatScrapper = () ->
    date = moment().format "YYYYMMDD"
    timestamp = moment().format "x"
    queryImages = "#{corsProxy}https://smn.cna.gob.mx/tools/PHP/GetImagenesReproductor.php?dir=../RESOURCES/GOES/GOES%20Este/Golfo%20de%20M%E9xico/Topes%20de%20Nubes/&periodo=2&horario=UTC&dif=0&fechahora=#{date}2400&fmin=&fmax=&ndias=0&nimg=0&nipd=0&_=#{timestamp}"

    $.getJSON queryImages, (data) ->
      $.each data.imagenes, (i,e) ->
        $(".smnSatScrapper").append("<img class='img-responsive' onerror='autoremoveImage(this);' onload='showTab(\"panel_smnSatScrapper\")' src='https://smn.cna.gob.mx/tools/PHP/#{e.image}'/>")
      rotate_images("smnSatScrapper")

  smnRadarSabancuyScrapper = () ->
    date = moment().format "YYYYMMDD"
    timestamp = moment().format "x"
    queryImages = "#{corsProxy}https://smn.cna.gob.mx/tools/PHP/GetImagenesReproductor.php?dir=..%2FRESOURCES%2FImagen%2520de%2520Radar%2FSabancuy%2FPPI%2F&periodo=1&horario=UTC&dif=0&fechahora=#{date}2400&fmin=&fmax=&ndias=0&nimg=0&nipd=0&_=#{timestamp}"
    $.getJSON queryImages, (data) ->
      $.each data.imagenes, (i,e) ->
        $(".smnRadarSabancuyScrapper").append("<img class='img-responsive' onerror='autoremoveImage(this);' onload='showTab(\"panel_smnRadarSabancuyScrapper\")' src='https://smn.cna.gob.mx/tools/PHP/#{e.image}'/>")

      rotate_images("smnRadarSabancuyScrapper")

  smnPotencialTormentasScrapper = () ->
    scraper =
      iterator: 'div.t3-content.col-xs-12'
      data:	fecha: () ->
       		$(this).find("span#visforms_contenedor_encabezado_emision_lugar_emision:first").text()
       	,numero: () ->
        	$(this).find("span#visforms_contenedor_encabezado_noaviso_valor").text()
       	,emision: () ->
        	$(this).find("span#visforms_contenedor_encabezado_emision_lugar_emision:eq(1)").text()
       	,img: () ->
         	$(this).find("img.Img_Estilo.Img_Centrar_Formu").attr("src")

    artoo.ajaxSpider ((i, $data) ->
      "#{corsProxy}https://smn.cna.gob.mx/es/pronosticos/avisos/mapa-de-areas-con-potencial-de-tormentas"
    ),
      limit: 1
      scrape: scraper
      concat: true
      done: (data) ->
        $("img.smn_potencial_tormentas").attr("src","https://smn.cna.gob.mx#{data[0].img}")
        $("img.smn_potencial_tormentas").attr("onload",'showTab("panel_smn_potencial_tormentas")')
        $(".caption.smn_potencial_tormentas_data span.fecha").html(data[0].fecha);
        $(".caption.smn_potencial_tormentas_data span.numero").html(data[0].numero);
        $(".caption.smn_potencial_tormentas_data span.emision").html(data[0].emision);

  smnScrapper = () ->
    scraper =
      iterator: 'div#visforms_contenedor_cuerpo div.frm-img-center > a'
      data: src:
        sel: 'img'
        attr: 'src'

    artoo.ajaxSpider ((i, $data) ->
      "#{corsProxy}https://smn.cna.gob.mx/es/pronosticos/pronosticossubmenu/imagen-interpretada"
    ),
      limit: 1
      scrape: scraper
      concat: true
      done: (data) ->
        $(".smn_interpretada").attr("src","https://smn.cna.gob.mx" + data[0].src);
        $(".smn_interpretada").attr("onload",'showTab("panel_smn_interpretada")')
        return

  noaaScrapper = () ->
    scraper =
      iterator: 'div#DayViewerAnimationBlock > div'
      data: src:
        sel: 'img'
        attr: 'src'

    artoo.ajaxSpider ((i, $data) ->
      "#{corsProxy}https://www.star.nesdis.noaa.gov/GOES/GOES16_CONUS_Band.php?band=13&length=24"
    ),
      limit: 1
      scrape: scraper
      concat: true
      done: (data) ->
        $.each data, (i,e) ->
          $(".noaaGulfSatellite").append("<img class='img-responsive' onerror='autoremoveImage(this);' onload='showTab(\"panel_noaaGulfSatellite\")' src='#{e.src}'/>")
        rotate_images("noaaGulfSatellite")

  smnSatScrapper()
  smnRadarSabancuyScrapper()
  artoo.on "ready", () ->
    smnScrapper()
    smnPotencialTormentasScrapper()
    noaaScrapper();
