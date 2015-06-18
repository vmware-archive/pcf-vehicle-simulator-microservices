# IoT Apps 

## Back End Services

**DealerService** - a GoLang service that puts a lightweight wrapper around the Edmunds Web Services (http://developer.edmunds.com/)
	Requires an API Key (sign up for one above)
	
	Environment variables needed: 
	PORT - which port the service should run on
	EDMUNDS_API_KEY - API Key provided from the Edmunds API after signing up for an account
	
The URL to access this service when running locally is http://localhost:<port>/<make>/<postalCode> or http://localhost:8080/ford/48116 which returns this:

```
{"dealers":[{"dealerId":"8353","name":"Avis Ford","niceName":"AvisFord","distance":2.138886,"active":true,"address":{"street":"29200 Telegraph Rd","city":"Southfield","stateCode":"MI","stateName":"Michigan","zipcode":"48034"},"operations":{"Monday":"9:00 AM-9:00 PM","Tuesday":"9:00 AM-6:00 PM","Wednesday":"9:00 AM-6:00 PM","Thursday":"9:00 AM-9:00 PM","Friday":"9:00 AM-6:00 PM","Saturday":"10:00 AM-3:00 PM","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8394","name":"Royal Oak Ford","niceName":"RoyalOakFord","distance":6.8710656,"active":true,"address":{"street":"27550 Woodward Ave","city":"Royal Oak","stateCode":"MI","stateName":"Michigan","zipcode":"48067"},"operations":{"Monday":"9:00 AM-9:00 PM","Tuesday":"9:00 AM-6:00 PM","Wednesday":"9:00 AM-6:00 PM","Thursday":"9:00 AM-9:00 PM","Friday":"9:00 AM-6:00 PM","Saturday":"9:00 AM-3:00 PM","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8613","name":"Tom Holzer Ford","niceName":"TomHolzerFord","distance":7.145946,"active":true,"address":{"street":"39300 W 10 Mile Rd","city":"Farmington Hills","stateCode":"MI","stateName":"Michigan","zipcode":"48335"},"operations":{"Monday":"8:30 AM-9:00 PM","Tuesday":"8:30 AM-6:00 PM","Wednesday":"8:30 AM-6:00 PM","Thursday":"8:30 AM-9:00 PM","Friday":"8:30 AM-6:00 PM","Saturday":"9:00 AM-3:00 PM","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8563","name":"Pat Milliken Ford","niceName":"PatMillikenFord","distance":7.447891,"active":true,"address":{"street":"9600 Telegraph Rd","city":"Redford","stateCode":"MI","stateName":"Michigan","zipcode":"48239"},"operations":{"Monday":"7:30 AM-9:00 PM","Tuesday":"7:30 AM-6:00 PM","Wednesday":"7:30 AM-6:00 PM","Thursday":"7:30 AM-9:00 PM","Friday":"7:30 AM-6:00 PM","Saturday":"Day off","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8406","name":"Dean Sellers Ford","niceName":"DeanSellersFord","distance":7.738357,"active":true,"address":{"street":"2600 W Maple Rd","city":"Troy","stateCode":"MI","stateName":"Michigan","zipcode":"48084"},"operations":{"Monday":"8:30 AM-9:00 PM","Tuesday":"8:30 AM-6:00 PM","Wednesday":"8:30 AM-6:00 PM","Thursday":"8:30 AM-9:00 PM","Friday":"8:30 AM-6:00 PM","Saturday":"Day off","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8479","name":"Bill Brown Ford","niceName":"BillBrownFord","distance":7.9931684,"active":true,"address":{"street":"32222 Plymouth Rd","city":"Livonia","stateCode":"MI","stateName":"Michigan","zipcode":"48150"},"operations":{"Monday":"9:00 AM-9:00 PM","Tuesday":"9:00 AM-6:00 PM","Wednesday":"9:00 AM-6:00 PM","Thursday":"9:00 AM-9:00 PM","Friday":"9:00 AM-6:00 PM","Saturday":"Day off","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"851442","name":"Suburban Ford Of Ferndale","niceName":"SuburbanFordOfFerndale","distance":8.597593,"active":true,"address":{"street":"21600 Woodward Ave","city":"Ferndale","stateCode":"MI","stateName":"Michigan","zipcode":"48220"},"operations":{"Monday":"9:00 AM-8:00 PM","Tuesday":"9:00 AM-6:00 PM","Wednesday":"9:00 AM-6:00 PM","Thursday":"9:00 AM-8:00 PM","Friday":"9:00 AM-6:00 PM","Saturday":"9:00 AM-3:00 PM","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8498","name":"Blackwell Ford","niceName":"BlackwellFord","distance":10.280639,"active":true,"address":{"street":"41001 Plymouth Rd","city":"Plymouth","stateCode":"MI","stateName":"Michigan","zipcode":"48170"},"operations":{"Monday":"8:30 AM-9:00 PM","Tuesday":"8:30 AM-6:00 PM","Wednesday":"8:30 AM-6:00 PM","Thursday":"8:30 AM-9:00 PM","Friday":"8:30 AM-6:00 PM","Saturday":"Day off","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8402","name":"Elder Ford","niceName":"ElderFord","distance":10.619854,"active":true,"address":{"street":"777 John R Rd","city":"Troy","stateCode":"MI","stateName":"Michigan","zipcode":"48083"},"operations":{"Monday":"9:00 AM-9:00 PM","Tuesday":"9:00 AM-6:00 PM","Wednesday":"9:00 AM-6:00 PM","Thursday":"9:00 AM-9:00 PM","Friday":"9:00 AM-6:00 PM","Saturday":"Day off","Sunday":"Day off"},"type":"ROOFTOP"},{"dealerId":"8523","name":"North Brothers Ford","niceName":"NorthBrothersFord","distance":10.913946,"active":true,"address":{"street":"33300 Ford Rd","city":"Westland","stateCode":"MI","stateName":"Michigan","zipcode":"48185"},"operations":{"Monday":"8:30 AM-9:00 PM","Tuesday":"8:30 AM-6:00 PM","Wednesday":"8:30 AM-6:00 PM","Thursday":"8:30 AM-9:00 PM","Friday":"8:30 AM-6:00 PM","Saturday":"9:00 AM-3:00 PM","Sunday":"Day off"},"type":"ROOFTOP"}]
```

**GoogleReverseGeocodeService** - A GoLang service that puts a lightweight wrapper around Google's Reverse Geocode Service (https://developers.google.com/maps/documentation/geocoding/#reverse-example). Using a google account, go to https://console.developers.google.com, create a project, then once tha project is created, navigate to APIs & auth | Credentials and create a public API access key. The type of key is a Server Key. You can optionally limit the IP address(es) from which the requests are made. 

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_MAPS_API_KEY - the API Key from a server application from the Google Developers Console (see above)

The url to access this service when running locally is http://localhost:<port>/<lat>/<lng> or http://localhost:8080/42.501157/-83.285681 which returns this

```
{"postalCode":"48034"}
```

**VehicleService** - a Java SpringBoot application that returns a hard coded list of featured vehicles and some details about each vehicle including an image url.

	No additional environment variables needed at this time
