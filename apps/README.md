# IoT Apps 

## Back End Services

### GoogleReverseGeocodeService 
A GoLang service that puts a lightweight wrapper around Google's Reverse Geocode Service (https://developers.google.com/maps/documentation/geocoding/#reverse-example). Using a google account, go to https://console.developers.google.com, create a project, then once tha project is created, navigate to APIs & auth | Credentials and create a public API access key. The type of key is a Server Key. You can optionally limit the IP address(es) from which the requests are made. 

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_MAPS_API_KEY - the API Key from a server application from the Google Developers Console (see above)

The url to access this service when running locally is http://localhost:[port]/[lat]/[lng] or http://localhost:8080/42.501157/-83.285681 which returns the following

```
{"postalCode":"48034"}
```
### GooglePlacesService
A GoLang service that puts a lightweight wrapper around Google's Places Service (https://developers.google.com/places/webservice/search). Using the same Project that you created above, be sure you enable Google Places API Web Service by navigating to your project's APIs section and searching for places. Click on Google Places API Web Service and Enable the API. By doing these steps you can use the same API_KEY that was created for the Reverse Geocode Service above. Alternatively, you can create a new project and use a different key specific for Google Places.

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_PLACES_API_KEY - the API key from a server application from the Google Developers Console (see above)
	
The URL to access this service when running locally is http://localhost:[port]/nearby/[places type]/[lat]/[lng] or http://localhost:8080/nearby/gas_station/42.501157/-83.285681 which returns the following:

```
[
  {
    "Name": "Tel Twelve Sunoco",
    "Id": "ChIJkZcMKpu3JIgRW9mgScyK0KY",
    "Address": "29001 Telegraph Road, Southfield",
    "Lat": 42.5008,
    "Lng": -83.285709
  },
  {
    "Name": "Sunoco Gas Station",
    "Id": "ChIJYV10Jpu3JIgR5lZFT4Lp66A",
    "Address": "28995 Telegraph Road, Southfield",
    "Lat": 42.500616,
    "Lng": -83.285732
  },
  // more stations
 ]
```

### GasPriceService
A GoLang service that puts a lightweight wrapper around the My Gas Feed API (http://www.mygasfeed.com/)
	Requires an API key (sign up for one here: http://www.mygasfeed.com/keys/submit
	
	Environment variables needed:
	PORT - which port the service should run on
	MY_GAS_FEED_BASE_URL - the base endpoint. For produciton this should be http://api.mygasfeed.com)
	MY_GAS_FEED_API_KEY - the API key provided from the MyGasFeed API after signing up for an account
	
The URL to access this service when running locally is http://localhost:[PORT]/[lat]/[lng]/[distance] or http://localhost:8080/42.501157/-83.285681/10 which returns

```
{
  "status": {
    "error": "NO",
    "code": 200,
    "description": "none",
    "message": "Request ok"
  },
  "stations": [
    {
      "id": "53330",
      "lat": "42.501438",
      "lng": "-83.284988",
      "station": "Mobil",
      "address": "29014 Telegraph Rd",
      "city": "Southfield",
      "region": "Michigan",
      "zip": "48034",
      "distance": "0 miles",
      "reg_price": "2.91",
      "mid_price": "2.85",
      "pre_price": "3.10",
      "diesel_price": "N\/A",
      "reg_date": "3 weeks ago",
      "mid_date": "3 weeks ago",
      "pre_date": "3 weeks ago",
      "diesel_date": "3 weeks ago"
    },
    // more stations
  ]
}
```  
		
### DealerService
A GoLang service that puts a lightweight wrapper around the Edmunds Web Services (http://developer.edmunds.com/)
	Requires an API Key (sign up for one at the URL listed above)
	
	Environment variables needed: 
	PORT - which port the service should run on
	EDMUNDS_API_KEY - API Key provided from the Edmunds API after signing up for an account
	
The URL to access this service when running locally is http://localhost:[port]/[make]/[postalCode] or http://localhost:8080/ford/48116 which returns the following:

```
{
  "dealers": [
    {
      "dealerId": "8353",
      "name": "Avis Ford",
      "niceName": "AvisFord",
      "distance": 2.138886,
      "active": true,
      "address": {
        "street": "29200 Telegraph Rd",
        "city": "Southfield",
        "stateCode": "MI",
        "stateName": "Michigan",
        "zipcode": "48034"
      },
      "operations": {
        "Monday": "9:00 AM-9:00 PM",
        "Tuesday": "9:00 AM-6:00 PM",
        "Wednesday": "9:00 AM-6:00 PM",
        "Thursday": "9:00 AM-9:00 PM",
        "Friday": "9:00 AM-6:00 PM",
        "Saturday": "10:00 AM-3:00 PM",
        "Sunday": "Day off"
      },
      "type": "ROOFTOP"
    },
    // more dealers ..
   ]
}
```

### RepairService
A Java Spring Boot application that returns a list of openings for maintenance (e.g oil changes).

	No additional environment variables needed at this time
	
The url to access this service when running locally is http://localhost:[port]/ServiceOpenings/[dealer id] or http://localhost:8080/ServiceOpenings/456 which returns the following:

```
[
  {
    "dealerId": "123",
    "date": "07\/02\/2015",
    "startTime": "8:30 AM",
    "duration": "30 minutes",
    "durationInMinutes": 30
  },
  // more openings
]
```
#### Assumptions
1. The dealer ID can be any valid string and is not checked
2. The returned date is always today's date
3. If the current date lands on a Sunday, no openings are returned because they are closed
4. The openings are random 30 minute slots between 8:00 AM and 6:00 PM
5. The duration is always 30 minutes

### VehicleService
A Java Spring Boot application that returns a hard coded list of featured vehicles and some details about each vehicle including an image url.

	No additional environment variables needed at this time

The url to access this service when running locally is http://localhost:<port>/featured or http://localhost:8080/featured which returns the following:

```
[
  {
    "styleId": 200714331,
    "styleName": "SE 4dr Hatchback (2.0L 4cyl 5M)",
    "make": "Ford",
    "model": "Focus",
    "year": 2015,
    "trim": "SE",
    "body": "Hatchback",
    "baseMSRP": 18960,
    "imageUrl": "http:\/\/assets.forddirect.fordvehicles.com\/assets\/2015_Ford_Focus_J1\/NGBS\/Model_Image3\/Model_Image3_136B520A-19F5-6A18-59C1-84CF59C184CF.jpg"
  },
  // additional styles
]
```
