package main

import (
	"encoding/json"
	"os"
	"log"
	"strconv"
	"net/http"
	"github.com/gorilla/mux"
)

type JsonError struct {
	Code	int		`json:"code"`
	Error	string	`json:"error"`
}

type GeocodeResponse struct {
	PostalCode	string `json:"postalCode"`
}

type Route struct {
	Name		string
	Method		string
	Pattern		string
	HandlerFunc	http.HandlerFunc
}

type Routes []Route

var routes = Routes{
	Route{
		"Home",
		"GET",
		"/{lat}/{lng}",
		HomeHandler,
	},
}

func main() {
	log.Print("Starting Google Reverse Geocode Service..");
	var port = os.Getenv("PORT");
	
	if port == "" {
		log.Fatal("The PORT environment variable has not been set.");
	}
	
	var mapsApiKey = os.Getenv("GOOGLE_MAPS_API_KEY")
	if mapsApiKey == "" {
		log.Fatal("The GOOGLE_MAPS_API_KEY environment variable has not been set.")
	}
	SetGoogleAPIKey(mapsApiKey)
		
	log.Print("Google Reverse Geocode Service is starting and listening on port ", port);
	
	router := mux.NewRouter()
	for _, route := range routes {
		var handler http.Handler
		
		handler = route.HandlerFunc
		handler = Logger(handler, route.Name)
		
		router.Methods(route.Method).Path(route.Pattern).Name(route.Name).Handler(handler)
	}
		
	err := http.ListenAndServe(":" + port, router)
	if err != nil {
		log.Fatal("An error occurred while attempting to listen and serve: ", err)
	}
	
	log.Print("Google Reverse Geocode Service has been terminated")
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	vars := mux.Vars(r)	
	lat, latErr := strconv.ParseFloat(vars["lat"], 32)
	if latErr != nil {
		ReturnErrorToClient(w, latErr, "Invalid latitude value. Expecting a floating point number")
		return;
	}
	
	lng, lngErr := strconv.ParseFloat(vars["lng"], 32)
	if lngErr != nil {
		ReturnErrorToClient(w, lngErr, "Invalid longitude value. Expecting a floating point number")
		return
	}
	
	log.Print("Lat is ", lat);
	log.Print("Lng is ", lng);
	postalCode, postaCodeErr := LatLngToPostalCode(lat, lng);
	if postaCodeErr != nil {
		ReturnErrorToClient(w, postaCodeErr, "Error determining zip code from given coordinates")
		
		return
	}
	
	log.Print("Postal Code is ", postalCode)
	var response = GeocodeResponse{ postalCode }
	
	w.WriteHeader(http.StatusOK)
	var err error
	if err = json.NewEncoder(w).Encode(response); err != nil {
		panic(err)
	}
}

func LatLngToPostalCode(lat float64, lng float64) (postalCode string, err error) {
	postCode, err := ReverseGeocodeToPostalCode( lat, lng )
	
	return postCode, err
}

func ReturnErrorToClient(w http.ResponseWriter, err error, msg string) {
	
	log.Println("An error occurred: ",msg, err)
	
	w.WriteHeader(http.StatusBadRequest)
	
	if encodeError := json.NewEncoder(w).Encode(JsonError{Code: http.StatusBadRequest, Error: msg}); encodeError != nil {
		log.Panic(encodeError);
	}
}

func Logger(inner http.Handler, name string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		
		log.Printf(
			"%s\t%s\t%s",
			r.Method,
			r.RequestURI,
			name,
			)

		inner.ServeHTTP(w, r)
	})
}