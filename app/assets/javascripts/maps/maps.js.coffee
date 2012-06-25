class @AdventureMap
  @initialize: ->
    AdventureMap.getCurrentLocation()

  @getCurrentLocation: ->
    navigator.geolocation.getCurrentPosition AdventureMap.display

  @display: (position) ->
    position = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    console.log "GETTING CALLED HERE"
    console.log "HELLO"
    myOptions = {
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    }

    map = new google.maps.Map(($('#map_canvas')[0]), myOptions)
    map.setCenter position 
