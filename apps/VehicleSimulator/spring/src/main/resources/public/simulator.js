angular.module('vehicleSimulator', [])
	.controller('VehicleSimulatorController', ['$scope', '$interval', '$http',
   function($scope, $interval, $http) {

		var BRAND = "ford";
		var stop;
		var lastServicedAt = 0;
		var fuelOk;
		var serviceOk;
    
	    $scope.fuelLevel = 0;
	    $scope.conditionClass = "alert-success";
	    $scope.conditionStrongText = "Good Condition";
	    $scope.conditionText = "Performing as expected";
	    $scope.serverIpAddress = "Unknown";
	    $scope.boundToRabbitMQ = "Unknown";

	    $scope.startTimer = function() {
	        $( '#btnStart').prop("disabled",true);
	        $( '#btnStop').prop("disabled", false);
	        intervalPromise = $interval(callRetreiveVehicleInfo, 8000);
	    }; 
	    
	    $scope.stopTimer = function() {
	        $( '#btnStart').prop("disabled",false);
	        $( '#btnStop').prop("disabled", true);
	        $interval.cancel(intervalPromise);
	    };
	    
	    $scope.showDealer = function(dealerId, dealerName, dealerAddress) {
	    	// set up the other text
			$scope.dealerId = dealerId;
	    	$scope.dealerName = dealerName;
	    	$scope.dealerAddress = dealerAddress;
	    	
	    	console.debug("Calling the dealer schedule availabiity service for "+ dealerId);
	    	var theUrl = "map/dealershipOpenings?dealerId=" + dealerId;
	    	console.debug("The url is " + theUrl);
	    	
	        $http.get(theUrl).
	        success(function(data) {                    
				$scope.openings = data;        			
	   			$("#DealerModal").modal('show');
	    	});
	    };
	    
	    $scope.serviceVehicle = function() {
	    	lastServicedAt = $scope.odometer;
	    };
	    
	    function callRetreiveVehicleInfo() {
	        $http.get('map/vehicleInfo').
	            success(function(data) {
	            	$scope.odometer = data.odometer == null ? "n/a" : data.odometer.toFixed(2);
	
	            	$scope.fuelLevel = (100 - data.fuel_level).toFixed(2);
	            	$('#fuelLevel').css('width', $scope.fuel_level+'%').attr('aria-valuenow', $scope.fuel_level);
	
	            	$scope.latitude = data.latitude;
	            	$scope.longitude = data.longitude;
	            	$scope.latlng = data.latitude + ", " + data.longitude;
	            	
	            	if ($scope.latitude != null && $scope.longitude != null)
	               	{
	                   	// create a new google map or update it if one already exists
	                   if (marker != null && map != null) {
	                     map = updateMap( data.latitude, data.longitude );
	                   }
	                   else {
	                     map = addLatLngToNewMap( data.latitude, data.longitude);
	                   }
	                   
	                   var fuelOk = checkFuel();
	                   var serviceOk = checkService();
	                                  
	                   if (fuelOk && serviceOk)
	                   {
	                       $scope.conditionClass = "alert-success";
	                       $scope.conditionStrongText = "Good Condition";
	                       $scope.conditionText = "Performing as expected";
	                   }
	                }
	            });
	    };     
	            
	    function checkFuel() {
			fuelOk = true;
			
	    	var fuelThresholdText = $("#fuelThreshold").val()
	    	var fuelThresholdPct = (fuelThresholdText == "") ? 20 : parseFloat( fuelThresholdText );
	
	    	if ($scope.fuelLevel < fuelThresholdPct) {
	            $scope.conditionClass = "alert-warning";
	            $scope.conditionStrongText = "Yellow Condition";
	            $scope.conditionText = "Low Fuel";
	    		
	    		callNearestGasStationsWithPrices( map, $scope.latitude, $scope.longitude);
				fuelOk = false;
			}
			else {
				// clear the gas stations               		
				$( "#gasStations thead").empty();
				$( "#gasStations tbody").empty();    
				
				clearGasStationMarkers();
			}
			
			return fuelOk;
	    };
	    
	    function callNearestGasStationsWithPrices(map, lat, lng)
	    {
	        console.debug("Calling the nearest gas stations with prices service");
	        var theUrl = 'map/nearestGasStationsWithPrices?lat=' + lat + '&lng=' + lng + '&distance=5';
	        console.debug('The url is ' + theUrl);
	
	        $http.get(theUrl).
	            success(function(data) {                    
	                var iconUrl = 'gasstationicon.png';
	                
	                $scope.stations = data.stations;
	                                    
	                for(var i=0; i< data.stations.length;i++) {
	                    var gasStation = data.stations[i];
	
	                    var title = gasStation.station + "\n" + gasStation.address;
	                    addMarkerToMap(map, gasStation.lat, gasStation.lng, iconUrl, 20, 20, title, true);
	                }
	                
	                // make the gas stations tab active
	                activeTab('dealerships', 'gasStations');
	                
				});
	    };          
	    
	    function checkService() {
			serviceOk = true;
	
	    	var serviceFrequencyText = $( "#serviceFrequency").val();
	    	var serviceFrequencyNum = (serviceFrequencyText == "") ? 5000 : parseFloat( serviceFrequencyText );
	    	var delta = $scope.odometer - lastServicedAt;
			
	    	if (delta > serviceFrequencyNum) {
				serviceOk = false;
	            $scope.conditionClass = "alert-warning";
	            $scope.conditionStrongText = "Yellow Condition";
	            $scope.conditionText = "Time for an oil change.";
	            
				callNearestDealerships( map, BRAND, $scope.latitude, $scope.longitude);
			}
			else {
				// clear the dealerships
				$( "#dealerships tbody").empty();
				
				clearDealershipMarkers();
			}
			        	
		};
		
		function callNearestDealerships(map, brand, lat, lng)
		{
			console.debug("Calling the nearest dealerships service")
			var theUrl = 'map/nearestDealerships?brand=' + brand + '&lat=' + lat + "&lng=" + lng
		    console.debug('The url is ' + theUrl);
	
	        $http.get(theUrl).
	            success(function(data) {                    
		            var iconUrl = 'dealershipicon.png';
	
	                $scope.dealers = data.dealers;
		            
		            for(var i=0; i< data.dealers.length; i++) {
		                var dealership = data.dealers[i];
	
		                var title = dealership.name + "\n" + 
		                	dealership.address.street + ", " + 
		                	dealership.address.city + ", " + 
		                	dealership.address.stateCode + " " + 
		                	dealership.address.zipcode;
	
		                addMarkerToMap(map, dealership.address.latitude, dealership.address.longitude, iconUrl, 21, 28, title, false); 
		            }
		            
		            // only switch to dealers if the fuel situation is fine
		            if (fuelOk) {
		            	activeTab('gasStations', 'dealerships');
		            }
		            
		        });
		};	
		
		$scope.killApp = function killApp()
        {
        	console.debug("Killing the app...");
        	var theUrl = "map/killApp";
        	
        	$http.get(theUrl).
        		success(function(data) {
        			console.debug("The call to kill the app was successful");
        	});
        };
        
        $scope.ipAddress = function retrieveIpAddress()
        {
        	console.debug("Retrieving the server IP address")
        	var theUrl = "map/ipAddress";
        	console.debug("The url is " + theUrl);
        	
        	$http.get(theUrl).
        		success(function(data) {
        			console.debug("Success!. The ipAddress is " + data.ipAddress);
        			$scope.serverIpAddress = data.ipAddress;
        		});
        }
    	            
}]);
    
function activeTab(disabledId, activeId) {
	$('#' + disabledId).hide();
	$('#' + disabledId + "Pill").removeClass('active');
	$('#' + activeId).show();
	$('#' + activeId + "Pill").addClass('active');
};  