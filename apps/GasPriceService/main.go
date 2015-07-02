package main

import (
	"encoding/json"
	"os"
	"github.com/goinggo/tracelog"
	"net/http"
	"github.com/gorilla/mux"
)

type JsonError struct {
	Code	int		`json:"code"`
	Error	string	`json:"error"`
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
		"/{lat}/{lng}/{distance}",
		HomeHandler,
	},
}

func main() {
	tracelog.Start(tracelog.LevelTrace)
	//tracelog.Start(tracelog.LevelInfo)
	 
	var port = os.Getenv("PORT");
	
	if port == "" {
		tracelog.Error(nil, "The PORT environment variable has not been set.", "main")
		os.Exit(1)
	}
	
	var myGasFeedBaseUrl = os.Getenv("MY_GAS_FEED_BASE_URL")
	if myGasFeedBaseUrl == "" {
		tracelog.Error(nil, "The MY_GAS_FEED_BASE_URL environment variable has not been set.", "main")
	}	
	SetMyGasFeedBaseUrl( myGasFeedBaseUrl )	
	
	var myGasFeedApiKey = os.Getenv("MY_GAS_FEED_API_KEY")
	if myGasFeedApiKey == "" {
		tracelog.Error(nil, "The MY_GAS_FEED_API_KEY environment variable has not been set.", "main")
	}
	SetMyGasFeedApiKey( myGasFeedApiKey )
	
	tracelog.Info("Started", "main", "Gas Price Service is starting and listening on port %s", port);
	
	router := mux.NewRouter()
	for _, route := range routes {
		var handler http.Handler
		
		handler = route.HandlerFunc
		handler = Logger(handler, route.Name)
		
		router.Methods(route.Method).Path(route.Pattern).Name(route.Name).Handler(handler)
	}
		
	err := http.ListenAndServe(":" + port, router)
	if err != nil {
		tracelog.Error(err, "An error occurred while attempting to listen and serve", "main")
	}
	
	tracelog.Info("Stopped", "main", "Gas Price Service has been terminated")
	tracelog.Stop()
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	vars := mux.Vars(r)
	lat := vars["lat"]
	lng := vars["lng"]
	distance := vars["distance"]
	
	tracelog.Trace("Latitude","main", "Lat is %s", lat)
	tracelog.Trace("Longitude", "main", "Lng is %s", lng)
	tracelog.Trace("Distance", "main", "Distance is %s", distance)
	
	// call the GasFeed API

	stations, stationErr := NearbyGasStations( lat, lng, distance )
	if stationErr != nil {
		ReturnErrorToClient(w, stationErr, "Error calling gas station pricing service with lat " + lat + " lng " + lng + " and distance " + distance)
		tracelog.Error(stationErr, "NearbyGasStations failed", "HomeHandler")
		return
	}
	
	w.WriteHeader(http.StatusOK)
	var err error
	if err = json.NewEncoder(w).Encode(stations); err != nil {
		tracelog.Error(err, "JSON encoding failed", "HomeHandler")
		panic(err)
	}
}

func ReturnErrorToClient(w http.ResponseWriter, err error, msg string) {
	
	tracelog.Error(err, "msg", "ReturnErrorToClient")
	
	w.WriteHeader(http.StatusBadRequest)
	
	if encodeError := json.NewEncoder(w).Encode(JsonError{Code: http.StatusBadRequest, Error: msg}); encodeError != nil {
		tracelog.Error(err, "JSON encoding failed", "ReturnErrorToClient")
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