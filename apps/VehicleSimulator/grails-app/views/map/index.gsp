<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Vehicle Simulator</title>
    
	<!-- Latest Bootstrap compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
	<asset:stylesheet href="main.css"/>
  </head>
  <body>
  	<div class="container logo">
		<g:img dir="images" file="ford_logo.png"/><label>Vehicle Simulator</label>
	</div>
	<nav class="navbar navbar-default">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
			</div>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
				</ul>
				<div class="row" style="width:95%;float:right;">
					<div class="col-xs-2">
						<div class="input-group buttons">
							<span class="input-group-addon" id="lblFuel">Fuel</span>
							<input class="form-control" id="fuelThreshold" name="fuelThreshold" type="number" value="20" aria-describedby="lblFuel">
							<span class="input-group-addon">%</span>
						</div>
					</div>
					<div class="col-xs-3">
						<div class="input-group buttons">
							<span class="input-group-addon" id="lblSvcFrequency">Svc</span>
							<input class="form-control" id="serviceFrequency" name="serviceFrequency" type="number" value="5000" aria-describedby="lblSvcFrequency">
							<span class="input-group-addon">Miles</span>							
						</div>
					</div>
					<div class="col-xs-1 buttons">
						<button id="btnResetService" type="button" class="btn btn-primary" title="Mark the vehicle as serviced" onclick="serviceVehicle();">Svc</button>
					</div>
					<div class="col-xs-4 alerts">
						<div id="currentCondition" class="alert alert-success" role="alert"><strong>Good Condition</strong> - Performing as expected.</div>
					</div>
					<div class="col-xs-1 buttons">
						<button id="btnStart" type="button" class="btn btn-success" onclick="startTimer();">Start</button>
					</div>
					<div class="col-xs-1 buttons">
						<button id="btnStop" type="button" class="btn btn-danger" onclick="stopTimer();">Stop</button>
				  		<g:if test="${flash.message}">
				  			<div class="message">${flash.message}</div>
				  		</g:if>
				  	</div>
				</div>
				
			</div><!--/.nav-collapse -->
		</div>
	</nav>  	
  	<div class="container">
		<div class="row main-content-row">
			<div class="col-xs-6 vehicle-info-container">
			    <div class="map-container">
				    <div id="map-canvas">
				    </div>
				</div>
			    <div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">Vehicle Stats</h3>
					</div>
					<div class="panel-body">
						<ul class="list-group">
							<li class="list-group-item">
								<label>Odometer:</label> <span id="tcOdometer">Not Available</span>
							</li>
							<li class="list-group-item">
								<label>Fuel Level:</label> 
								<div class="progress">
									<div id="fuelLevel" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"><span class="sr-only">40% Complete (success)</span></div>
								</div>
							</li>
							<li class="list-group-item">
								<label>Location (lat,lng):</label> <span id="tcLatLng">Not Available</span>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="col-xs-6">		

				<ul class="nav nav-pills">
				  <li id="gasStationsPill" role="presentation" class="active" onclick="activeTab('dealerships', 'gasStations');"><a href="#">Gas Stations</a></li>
				  <li id="dealershipsPill" role="presentation" onclick="activeTab('gasStations', 'dealerships');"><a href="#">Dealers</a></li>
				</ul>

				<div id="data-tables">
				    <div class="panel panel-primary">
						<div class="panel-heading">
							<h3 class="panel-title">Nearby Locations</h3>
						</div>
						<div class="panel-body">
					    	<table id="gasStations" class="table table-striped">
					    		<thead>
					    		</thead>					    	
					    		<tbody>
					    			<tr><td>No Information Available</td></tr>
					    		</tbody>
					    	</table>
					    	<table id="dealerships" class="table table-striped" style="display:none;">
					    		<tbody>
					    			<tr><td>No Information Available</td></tr>
					    		</tbody>
					    	</table>
				    	</div>
				    </div>
			    </div>
		    </div>
	  	</div>
	</div>    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>    
    <asset:javascript src="jquery.timer.js"/>
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
          zoom: 4
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    }
    google.maps.event.addDomListener(window, 'load', initialize);

    // TODO: consider not hardcoding this
    var BRAND = "ford";
    
    </script>
	    
    <script type="text/javascript">

    	var map;
    	var marker;
    	
        var timer = $.timer(function() {
        	callRetreiveVehicleInfo( vehicleInfoSuccessCallback, vehicleInfoErrorCallback)
        });

        // The timer used to consistently retrieve Vehicle Data
        // Note: The time is in milliseconds
        timer.set( { time: 5000, autstart: false });

        // set the buttons to their appropriate inital state
        $( '#btnStart').prop("disabled",false);
        $( '#btnStop').prop("disabled", true);
    	
        function startTimer() 
        {
            $( '#btnStart').prop("disabled",true);
            $( '#btnStop').prop("disabled", false);
        	timer.play()
        } 

        function stopTimer()
        {
            $( '#btnStart').prop("disabled",false);
            $( '#btnStop').prop("disabled", true);
            timer.pause();
        }
        
        var currentOdometer = 0;
        
    	function vehicleInfoSuccessCallback( data, textStatus, jqXHR )
    	{
        	console.debug("vehicleInfoSuccessCallback()");
        	console.debug( data, textStatus, jqXHR );

        	console.debug( data.latitude );
        	console.debug( data.longitude );
        	console.debug( data.fuelLevel );
        	console.debug( data.odometer  );
        	
        	currentOdometer = data.odometer;

        	$( "#tcOdometer").html( data.odometer == null ? "n/a" : data.odometer);
        	$( "#tcFuelLevel").html( data.fuelLevel == null ? "n/a" : data.fuelLevel);
        	$('#fuelLevel').css('width', data.fuelLevel+'%').attr('aria-valuenow', data.fuelLevel);
        	
        	var fuelThresholdPct = getFuelThresholdPercentage();
        	console.debug("The current fuel threshold percentage is " + fuelThresholdPct);

        	var latlngStr = "";
        	if (data.latitude != null && data.longitude != null)
           	{
               	latlngStr = data.latitude + ", " + data.longitude;
               	
               	// create a new google map or update it if one already exists
               if (marker != null && map != null) {
                 map = updateMap( data.latitude, data.longitude );
               }
               else {
                 map = addLatLngToNewMap( data.latitude, data.longitude);
               }
               
               var fuelOk = true;
               var serviceOk = true;
               
               if (data.fuelLevel < fuelThresholdPct)
               {
               		console.debug("Fuel threshold reached... displaying gas stations..");

					updateConditionTolowFuel();
               		
               		// find the nearest gas stations (old version)
               		// callNearestGasSations( map, data.latitude, data.longitude, nearestGasStationErrorCallback);
               
               		// find the nearest gas stations with prices..
               		callNearestGasStationsWithPrices( map, data.latitude, data.longitude, nearestGasStationWithPricesErrorCallback);
               		
               		fuelOk = false;
               	}
               	else
               	{
               		fuelOk = true;	
               		
               		// TODO: How can we hide the tab?
               		
               		// clear the gas stations               		
               		$( "#gasStations thead").empty();
                    $( "#gasStations tbody").empty();   
                    $( "#gasStations tbody").append('<tr><td>No Information Available</td></tr>');            		
               	}

               // find the nearest dealerships
               if (needService(data.odometer))
               {
               		serviceOk = false;
               		
               		updateConditionToNeedService(fuelOk);
               		
               		callNearestDealerships( map, BRAND, data.latitude, data.longitude, nearestDealershipErrorCallback);
               }
               else
               {
               		serviceOk = true;
               		
               		// TODO: How can we hide the tab?
               		
               		// clear the dealerships
               		$( "#dealerships tbody").empty();
               		$( "#dealerships tbody").append('<tr><td>No Information Available</td></tr>');
               }
               
               if (fuelOk && serviceOk)
               {
                   updateConditionToNormal();              
               }
            }

            $( "#tcLatLng").html( latlngStr );
        }
        
        var lastServicedAt = 0.0
        
        function serviceVehicle()
        {
            console.debug("The vehicle has been served at "+ currentOdometer);
        	lastServicedAt = currentOdometer;
        }
        
        function needService(odometer)
        {
            console.debug("the last time the vehicle was serviced was at " + lastServicedAt);
        	// is it time to service the vehicle?
        	var delta = odometer - lastServicedAt;
        	console.debug("The odometer delta is " + delta);
        	return (delta > getServiceFrequency())
        }
        
        function getServiceFrequency()
        {            
        	var serviceFrequencyText = $( "#serviceFrequency").val();
        	console.debug("The current service frequency is " + serviceFrequencyText);
        	
        	return inputFieldToNumber( serviceFrequencyText, 5000);        	
        }
        
        function updateConditionToNormal()
        {
        	var conditionDiv = $( "#currentCondition");
        	conditionDiv.html("<strong>Good Condition</strong> - Performing as expected.");
        	conditionDiv.removeClass("alert-warning");
        	conditionDiv.addClass("alert-success");
        }
        
        function updateConditionTolowFuel()
        {
        	var conditionDiv = $( "#currentCondition");
        	conditionDiv.html("<strong>Yellow Condition</strong> - Low Fuel");
        	conditionDiv.removeClass("alert-success");
        	conditionDiv.addClass("alert-warning");        	
        }
        
        function updateConditionToNeedService(fuelOk)
        {
        	var conditionDiv = $( "#currentCondition");
        	
        	if (fuelOk)
        	{
        	    conditionDiv.html("<strong>Yellow Condition</strong> - Time for Oil Change");
        		conditionDiv.removeClass("alert-success");
        		conditionDiv.addClass("alert-warning");        
        	}
        	else
        	{
        		conditionDiv.html("<strong>Yellow Condition</strong> - Low Fuel & Time for Oil Change");
        	}
        }
        
        function getFuelThresholdPercentage()
        {
        	var fuelThresholdText = $( "#fuelThreshold").val()
        	console.debug("The current fuel threshold pct is " + fuelThresholdText);
        	
        	return inputFieldToNumber( fuelThresholdText, 20 );   	
        }
        
        function inputFieldToNumber( fieldValue, defaultValue )
        {
        	if (fieldValue == "")
        	{
        		console.debug("No value in field. returning default value");
        		return defaultValue;
        	}
        	
        	// parse it
        	var valueAsNumber = parseFloat( fieldValue );
        	if (valueAsNumber == NaN)
        	{
        		console.debug("Unable to parse field...returning default value");
        		return defaultValue;
        	}
        	
        	return valueAsNumber;
        }

        function addLatLngToNewMap( latitude, longitude)
        {
            console.debug("adding latlng to map");
            
        	var mapCanvas = $( "#map-canvas")[0];
           	var latlng = new google.maps.LatLng (latitude, longitude);
           	var mapOptions = {
                   	center: latlng,
                   	zoom: 13,
                   	mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map( mapCanvas, mapOptions);

            var markerOptions = {
                    position: latlng,
                    title: "Current Vehicle Location",
                    map: map
            }

            marker = new google.maps.Marker( markerOptions );

            return map;
        }

        function updateMap(latitude, longitude)
        {
            var latlng = new google.maps.LatLng( latitude, longitude );
            marker.setPosition( latlng );
            map.panTo( latlng );
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

                    var iconUrl = window.grailsSupport.assetsRoot + 'dealershipicon.png';

					console.debug('the icon url is ' + iconUrl);
                    
                    console.debug("There are " + data.dealers.length + " dealerships nearby");

                    // clear the gas stations div
                    $( "#dealerships tbody").empty();
                    
                    for(var i=0; i<data.dealers.length;i++)
                    {
                        var dealership = data.dealers[i];

                        console.debug("Adding dealership " + dealership.name + " to the map (" + dealership.address.latitude + ", " + dealership.address.longitude + ")");

                        var title = dealership.name + "\n" + 
                        	dealership.address.street + ", " + dealership.address.city + ", " + dealership.address.stateCode + " " + dealership.address.zipcode;

                        addMarkerToMap(map, dealership.address.latitude, dealership.address.longitude, iconUrl, 21, 28, title); 

                        $( "#dealerships tbody").append(buildDealershipList(dealership.name, dealership.address.street, dealership.address.city, dealership.address.stateCode, dealership.address.zipcode, dealership.distance));
                    }

                    if (data.dealers.length=0)
                    {
                        $( "#dealerships tbody").append('<tr><td>No Nearby Dealerships</td></tr>');
                    }
                    
                },
                error: errorCallback
            
            });           
        }

        function nearestGasStationErrorCallback( jqXHR, textStatus, errorThrown)
        {
            // TODO: show an alert??
            console.debug("(nearestGasStation) An error occurred");
            console.debug( jqXHR, textStatus, errorThrown );            
        }

        function addMarkerToMap(map, lat, lng, iconUrl, iconSizeX, iconSizeY, title)
        {
            var latlng = new google.maps.LatLng ( lat, lng );
            
            var mapIcon = {
                    url: iconUrl,
                    size: new google.maps.Size(iconSizeX, iconSizeY),
                    orign: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(0, iconSizeY)
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

                    var iconUrl = window.grailsSupport.assetsRoot + 'gasstationicon.png';
                    
                    console.debug('the icon url is ' + iconUrl);
                    
                    console.debug("There are " + data.length + " gas stations nearby");
                    
                    $( "#gasStations tbody").empty();
                    
                    for(var i=0; i<data.length;i++)
                    {
                        var gasStation = data[i];

                        console.debug("Adding gas station " + gasStation.Name + " to the map. (" + gasStation.Lat + ", " + gasStation.Lng + ")");                        

                        addMarkerToMap(map, gasStation.Lat, gasStation.Lng, iconUrl, 20, 20, gasStation.Name + "\n" + gasStation.Address);

                        $( "#gasStations tbody").append(buildGasStationList( gasStation.Name, gasStation.Address));
                    }

                    if (data.length=0)
                    {
                        $( "#gasStations tbody").append('<tr><td>No Nearby Gas Stations</td></tr>');
                    }
                },
                error: errorCallback
            })
        }
        
        function nearestGasStationWithPricesErrorCallback( jqXHR, textStatus, errorThrown)
        {
            // TODO: show an alert??
            console.debug("(nearestGasStation) An error occurred");
            console.debug( jqXHR, textStatus, errorThrown );            
        }

        function callNearestGasStationsWithPrices(map, lat, lng, errorCallback)
        {
            console.debug("Calling the nearest gas stations with prices service");
            var theUrl = 'map/nearestGasStationsWithPrices?lat=' + lat + '&lng=' + lng + '&distance=5';
            console.debug('The url is ' + theUrl);

            $.ajax({
                url: theUrl,
                type: 'GET',
                cache: false,
                success: function (data, textStatus, jqXHR) {
                    
                    console.debug("nearestGasStationWithPrices SuccessCallback()");
                    console.debug( data );
                    console.debug("textstatus...")
                    console.debug( textStatus );
                    console.debug("jqXHR...");
                    console.debug( jqXHR );

                    var iconUrl = window.grailsSupport.assetsRoot + 'gasstationicon.png';
                    
                    console.debug('the icon url is ' + iconUrl);
                    
                    console.debug("There are " + data.stations.length + " gas stations w/price nearby");
                    
                    $( "#gasStations thead").empty();
                    $( "#gasStations tbody").empty();
                    
                    if (data.stations.length > 0)
                    {
                    	$( "#gasStations thead").append("<tr><td>&nbsp;</td><td><strong>Regular</strong></td><td><strong>Mid Grade</strong></td><td><strong>Premium</strong></td></tr>");
                    }
                    
                    for(var i=0; i<data.stations.length;i++)
                    {
                        var gasStation = data.stations[i];

                        console.debug("Adding gas station " + gasStation.station + " to the map. (" + gasStation.lat + ", " + gasStation.lng + ")");                        

                        addMarkerToMap(map, gasStation.lat, gasStation.lng, iconUrl, 20, 20, gasStation.station + "\n" + gasStation.address);

                        $( "#gasStations tbody").append(buildGasStationListWithPrices( gasStation.station, gasStation.address, gasStation.distance, 
                        	gasStation.reg_price, gasStation.reg_date,
                        	gasStation.mid_price, gasStation.mid_date,
                        	gasStation.pre_price, gasStation.pre_date));
                    }

                    if (data.stations.length=0)
                    {
                        $( "#gasStations tbody").append('<tr><td>No Nearby Gas Stations</td></tr>');
                    }
                    
                },
                error: errorCallback
            })
        }  

        function buildGasStationListWithPrices(name, address, distance, regPrice, regDate, midPrice, midDate, premiumPrice, premiumDate)        
        {
        	var html = "<tr><td><strong>" + name + "</strong><br/>" + address + "<br/>" + distance + "</td><td>" +  
        		buildPriceFieldText( regPrice, regDate ) + "</td><td>" + 
        		buildPriceFieldText( midPrice, midDate ) + "</td><td>" + 
        		buildPriceFieldText( premiumPrice, premiumDate ) + "</td></tr>";
        		
        	return html; 
        }
        
        function buildPriceFieldText( price, date)
        {
           var text = price;
           if (price != "N/A")
           	   text = "$" + price;
           	   
           text = text + "<br/>" + date;
           
           return text;
        }

        function buildGasStationList(name, address)
        {
            var html = '<tr><td><strong>' + name + '</strong></td><td>' + address + '</td></tr>';
            return html;
        }

        function buildDealershipList(name, street, city, state, zipCode, distance)
        {
            var html = '<tr><td><strong>' + name + "</strong></td><td>" + street + " " + city + " " + state + " " + zipCode + "<br/>" + "Distance: " + distance + " miles" + "</td></tr>";
            return html;
        }

        function activeTab(disabledId, activeId) {
			$('#' + disabledId).hide();
			$('#' + disabledId + "Pill").removeClass('active');
			$('#' + activeId).show();
			$('#' + activeId + "Pill").addClass('active');
        }
        
    </script>
  </body>
</html>
