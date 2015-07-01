<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <style type="text/css">
      html, body, #map-canvas { height: 90%; margin: 0; padding: 0;}
      
      #map-canvas {width: 50%; float: left;}
      #vehicle-data { padding: 5px; background-color: #eeeeee; width: 45%; float: left;}
      
      .rTable 					{ display: table; width: 100%; } 
      .rTableRow 				{ display: table-row; } 
      .rTableHeading 			{ display: table-header-group; background-color: #ddd; } 
      .rTableCell, .rTableHead 	{ display: table-cell; padding: 3px 10px; border: 1px solid #999999; } 
      .rTableHeading 			{ display: table-header-group; background-color: #ddd; font-weight: bold; } 
      .rTableFoot 				{ display: table-footer-group; font-weight: bold; background-color: #ddd; } 
      .rTableBody 				{ display: table-row-group; }
    </style>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <!-- TODO: move key out of the HTML -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBywCGRuSOk1a0hJed2vOn3lZH6OIZbQ0E"
            type="text/javascript"></script>
            
    <g:javascript>
    	window.grailsSupport = {
    		assetsRoot : '${ raw(asset.assetPath(src: '')) }'
    	};
    </g:javascript>
    
    <script type="text/javascript">

    function initialize() 
    {
        var mapOptions = 
        {
          center: { lat: 39.833333, lng: -98.583333},
          zoom: 5
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    }
    google.maps.event.addDomListener(window, 'load', initialize);

    // TODO: consider not hardcoding this
    var BRAND = "ford";
    
    </script>
  </head>
  <body>
  	<div id="commands">
		<form id="frmCommands">
			<input id="callVehicleWSButton" type="submit" value="Retrieve Vehicle Info">
		</form>
  		<g:if test="${flash.message}">
  			<div class="message">${flash.message}</div>
  		</g:if>
  	</div>
    <div id="map-canvas">
    </div>
    <div id="vehicle-data">
    	<div class="rTable">
    		<div class="rTableRow">
    			<div class="rTableHead"><strong>Odometer</strong></div>
    			<div class="rTableHead"><strong>Fuel Level</strong></div>
    			<div class="rTableHead"><strong>Latitude, Longitude</strong></div>    			
    		</div>
    		<div class="rTableRow">
    			<div id="tcOdometer" class="rTableCell"></div>
    			<div id="tcFuelLevel" class="rTableCell"></div>
    			<div id="tcLatLng" class="rTableCell"></div>
    		</div>
    	</div>
    	<div id="debugText"></div>
    </div>
    
    <script type="text/javascript">
    	$(document).ready(function () {
        	// hook into the vehicle WS button
        	$( "#callVehicleWSButton").click( function (event) {
            	// stop the browser from submtting the form
            	event.preventDefault();

            	callRetreiveVehicleInfo( vehicleInfoSuccessCallback, vehicleInfoErrorCallback)
            	
            });
        });

    	function vehicleInfoSuccessCallback( data, textStatus, jqXHR )
    	{
        	console.debug("vehicleInfoSuccessCallback()");
        	console.debug( data, textStatus, jqXHR );

        	console.debug( data.latitude );
        	console.debug( data.longitude );
        	console.debug( data.fuelLevel );
        	console.debug( data.odometer  );

        	$( "#tcOdometer").html( data.odometer == null ? "n/a" : data.odometer);
        	$( "#tcFuelLevel").html( data.fuelLevel == null ? "n/a" : data.fuelLevel);

        	var latlngStr = "";
        	if (data.latitude != null && data.longitude != null)
           	{
               	latlngStr = data.latitude + ", " + data.longitude;
               	
               	// update the Google Map
               var map = addLatLngToNewMap( data.latitude, data.longitude);

               // find the nearest gas stations
               callNearestGasSations( map, data.latitude, data.longitude, nearestGasStationErrorCallback)

               // find the nearest dealerships
               callNearestDealerships( map, BRAND, data.latitude, data.longitude, nearestDealershipErrorCallback)
               
            }

            $( "#tcLatLng").html( latlngStr );
        	        	
        }

        function addLatLngToNewMap( latitude, longitude)
        {
            console.debug("adding latlng to map");
            
        	var mapCanvas = $( "#map-canvas")[0];
           	var latlng = new google.maps.LatLng (latitude, longitude);
           	var mapOptions = {
                   	center: latlng,
                   	zoom: 12,
                   	mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map( mapCanvas, mapOptions);

            var markerOptions = {
                    position: latlng,
                    title: "Current Vehicle Location",
                    map: map
            }

            var marker = new google.maps.Marker( markerOptions );

            return map;
        }

        function vehicleInfoErrorCallback( jqXHR, textStatus, errorThrown)
        {
        	// TODO: show an alert??
            console.debug("(vehicleInfo) An error occurred");
            console.debug( jqXHR, textStatus, errorThrown );
        }
      
        function callRetreiveVehicleInfo(successCallback, errorCallback)
        {
            console.debug("Calling vehicle stats web service...");
            $.ajax({
                	 url: 'map/vehicleStats',
                     cache: false,
                     success: successCallback,
                     error: errorCallback
                });
        }

        function nearestDealershipErrorCallback(jqXHR, textStatus, errorThrown)
        {
            // TODO: show an alert??
            console.debug("(nearestDealership) An error occurred");
            console.debug( jqXHR, textStatus, errorThrown );   
        }

        function callNearestDealerships(map, brand, lat, lng, errorCallback)
        {
			console.debug("Calling the nearest dealerships service")
			var theUrl = 'map/nearestDealerships?brand=' + brand + '&lat=' + lat + "&lng=" + lng
            console.debug('The url is ' + theUrl);

            $.ajax({
                url: theUrl,
                type: 'GET',
                cache: false,
                success: function (data, textStatus, jqXHR) {
                    console.debug("nearestDealershipSuccessCallback()");
                    console.debug(data);

                    var iconUrl = window.grailsSupport.assetsRoot + 'dealership.png';

					console.debug('the icon url is ' + iconUrl);
                    
                    console.debug("There are " + data.dealers.length + " dealerships nearby");
                    
                    for(var i=0; i<data.dealers.length;i++)
                    {
                        var dealership = data.dealers[i];

                        console.debug("Adding dealership " + dealership.name + " to the map (" + dealership.address.latitude + ", " + dealership.address.longitude + ")");

                        var title = dealership.name + "\n" + 
                        	dealership.address.street + ", " + dealership.address.city + ", " + dealership.address.stateCode + " " + dealership.address.zipcode;

                        addMarkerToMap(map, dealership.address.latitude, dealership.address.longitude, iconUrl, title); 
                    }
                    
                },
                error: errorCallback
            
            });
			// TODO: Implement
           
        }

        function nearestGasStationErrorCallback( jqXHR, textStatus, errorThrown)
        {
            // TODO: show an alert??
            console.debug("(nearestGasStation) An error occurred");
            console.debug( jqXHR, textStatus, errorThrown );            
        }

        function addMarkerToMap(map, lat, lng, iconUrl, title)
        {
            var latlng = new google.maps.LatLng ( lat, lng );
            
            var mapIcon = {
                    url: iconUrl,
                    size: new google.maps.Size(71,71),
                    orign: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(50,50)
            
            }

            var markerOptions = {
                    icon: mapIcon,
                    position: latlng,
                    title: title,
                    map: map
            }

            var marker = new google.maps.Marker( markerOptions );
        }

        function callNearestGasSations(map, lat, lng, errorCallback)
        {
            console.debug("Calling the nearest gas station service")
            var theUrl = 'map/nearestGasStations?lat=' + lat + "&lng=" + lng
            console.debug('The url is ' + theUrl);
            
            $.ajax({
                url: theUrl,
                type: 'GET',
                cache: false,
                success: function (data, textStatus, jqXHR) {

                    console.debug("nearestGasStationSuccessCallback()");
                    console.debug( data );
                    console.debug("textstatus...")
                    console.debug( textStatus );
                    console.debug("jqXHR...");
                    console.debug( jqXHR );

                    var iconUrl = window.grailsSupport.assetsRoot + 'gasstation.png';
                    
                    console.debug('the icon url is ' + iconUrl);
                    
                    console.debug("There are " + data.length + " gas stations nearby");
                    
                    for(var i=0; i<data.length;i++)
                    {
                        var gasStation = data[i];

                        console.debug("Adding gas station " + gasStation.Name + " to the map. (" + gasStation.Lat + ", " + gasStation.Lng + ")");

                        addMarkerToMap(map, gasStation.Lat, gasStation.Lng, iconUrl, gasStation.Name + "\n" + gasStation.Address + "\n");
                    }
                },
                error: errorCallback
            })
        }  
        
    </script>
  </body>
</html>
