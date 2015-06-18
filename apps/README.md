Apps Readme

Back End Services

DealerService - a GoLang service that puts a lightweight wrapper around the Edmunds Web Services (http://developer.edmunds.com/)
	Requires an API Key (sign up for one above)
	Environment variables needed: 
		PORT - which port the service should run on
		EDMUNDS_API_KEY - API Key provided from the Edmunds API after signing up for an account

GoogleReverseGeocodeService - A GoLang service that puts a lightweight wrapper around Google's Reverse Geocode Service (https://developers.google.com/maps/documentation/geocoding/#reverse-example). Using a google account, go to https://console.developers.google.com, create a project, then once tha project is created, navigate to APIs & auth | Credentials and create a public API access key. The type of key is a Server Key. You can optionally limit the IP address(es) from which the requests are made. 

	Environment variables needed:
	PORT - which port the service should run on
	GOOGLE_MAPS_API_KEY - the API Key from a server application from the Google Developers Console (see above)

VehicleService - a Java SpringBoot application that returns a hard coded list of featured vehicles and some details about each vehicle including an image url.

