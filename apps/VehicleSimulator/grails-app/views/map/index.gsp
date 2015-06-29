<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <style type="text/css">
      html, body, #map-canvas { height: 90%; margin: 0; padding: 0;}
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBywCGRuSOk1a0hJed2vOn3lZH6OIZbQ0E"
            type="text/javascript"></script>
    <script type="text/javascript">

    function initialize() 
    {
        var mapOptions = 
        {
          center: { lat: 39.833333, lng: -98.583333},
          zoom: 5
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);
    }
    google.maps.event.addDomListener(window, 'load', initialize);
    
    </script>
  </head>
  <body>
  	<div id="commands">
  		<g:form name="" url="[controller:'map']">
  			<g:actionSubmit value="Start Tracking Vehicle" action="startTracking"/>
  			<g:actionSubmit value="Stop Tracking Vehicle" action="stopTracking"/>
  		</g:form>
  		<g:if test="${flash.message}">
  			<div class="message">${flash.message}</div>
  		</g:if>
  	</div>
    <div id="map-canvas"></div>
  </body>
</html>
