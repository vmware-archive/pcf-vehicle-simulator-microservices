# IoT Apps 

## Back End Services

### GoogleReverseGeocodeService 
A GoLang service that puts a lightweight wrapper around Google's Reverse Geocode Service (https://developers.google.com/maps/documentation/geocoding/#reverse-example). Using a google account, go to https://console.developers.google.com, create a project, then once tha project is created, navigate to APIs & auth | Credentials and create a public API access key. The type of key is a Server Key. You can optionally limit the IP address(es) from which the requests are made. 

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_MAPS_API_KEY - the API Key from a server application from the Google Developers Console (see above)

The url to access this service when running locally is http://localhost:<port>/<lat>/<lng> or http://localhost:8080/42.501157/-83.285681 which returns the following

```
{"postalCode":"48034"}
```
### GooglePlacesService
A GoLang service that puts a lightweight wrapper around Google's Places Service (https://developers.google.com/places/webservice/search). Using the same Project that you created above, be sure you enable Google Places API Web Service by navigating to your project's APIs section and searching for places. Click on Google Places API Web Service and Enable the API. By doing these steps you can use the same API_KEY that was created for the Reverse Geocode Service above. Alternatively, you can create a new project and use a different key specific for Google Places.

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_PLACES_API_KEY - the API key from a server application from the Google Developers Console (see above)
	
The URL to access this service when running locally is http://localhost:<port>/nearby/<places type>/<lat>/<lng> or http://localhost:8080/nearby/gas_station/42.501157/-83.285681 which returns the following:

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

### DealerService
A GoLang service that puts a lightweight wrapper around the Edmunds Web Services (http://developer.edmunds.com/)
	Requires an API Key (sign up for one above)
	
	Environment variables needed: 
	PORT - which port the service should run on
	EDMUNDS_API_KEY - API Key provided from the Edmunds API after signing up for an account
	
The URL to access this service when running locally is http://localhost:<port>/<make>/<postalCode> or http://localhost:8080/ford/48116 which returns the following:

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
  // additional sytles
]
```
