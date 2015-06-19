package main

import (
	"encoding/json"
	"os"
	"github.com/goinggo/tracelog"
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
		"Nearby",
		"GET",
		"/nearby/{type}/{lat}/{lng}",
		NearbyHandler,
	},
}

func main() {
    tracelog.Start(tracelog.LevelInfo)
	var port = os.Getenv("PORT");
	
	if port == "" {
		tracelog.Error(nil, "The PORT environment variable has not been set.", "main")
		os.Exit(1)
	}
	
	var placesApiKey = os.Getenv("GOOGLE_PLACES_API_KEY")
	if placesApiKey == "" {
	    tracelog.Error(nil, "The GOOGLE_PLACES_API_KEY enviornment variable has not been set.", "main")
		os.Exit(2)
	}
	SetGoogleAPIKey(placesApiKey)
		
	tracelog.Info("Started", "main", "Google Places Service is starting and listening on port %s", port);
	
	router := mux.NewRouter()
	for _, route := range routes {
		var handler http.Handler
		
		handler = route.HandlerFunc
		handler = Logger(handler, route.Name)
		
		router.Methods(route.Method).Path(route.Pattern).Name(route.Name).Handler(handler)
	}
		
	err := http.ListenAndServe(":" + port, router)
	if err != nil {
	    tracelog.Error(err, "An error occurred while attempting to listen and serve.", "main")
	}
	
	tracelog.Info("Stopped", "main", "Google Places Service has been terminated")
	tracelog.Stop()
}

func NearbyHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	vars := mux.Vars(r)	
	var placeType = vars["type"]
	// TODO: may want to validate type
	
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
	
	tracelog.Trace("Type Value","main", "Type is %s", placeType);
	tracelog.Trace("Lat Value", "main", "Lat is %f", lat)
	tracelog.Trace("Lng Value", "main", "Lng is %f", lng)

	response, nearbyErr := NearbySearch( placeType, lat, lng )
	if nearbyErr != nil {
		ReturnErrorToClient(w, nearbyErr, "Nearby Search returned an error")
		return
	}
	
	w.WriteHeader(http.StatusOK)
	var err error
	if err = json.NewEncoder(w).Encode(response); err != nil {
		tracelog.Error(err, "An error occurred while encoding json response", "NearbyHandler")
		panic(err)
	}
}

func ReturnErrorToClient(w http.ResponseWriter, err error, msg string) {
	
	tracelog.Error(err, msg, "ReturnErrorToClient")
	
	w.WriteHeader(http.StatusBadRequest)
	
	if encodeError := json.NewEncoder(w).Encode(JsonError{Code: http.StatusBadRequest, Error: msg}); encodeError != nil {
		tracelog.Error(encodeError, "JSON encoding failed", "ReturnErrorToClient")
		panic("JSON encoding failed")
	}
}

func Logger(inner http.Handler, name string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		
		tracelog.Info("HTTP Request", "Handler",
			"%s\t%s\t%s",
			r.Method,
			r.RequestURI,
			name,
			)

		inner.ServeHTTP(w, r)
	})
}
