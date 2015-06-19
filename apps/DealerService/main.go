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
		"/{brand}/{postalCode}",
		HomeHandler,
	},
}

func main() {
	tracelog.Start(tracelog.LevelInfo)
	 
	var port = os.Getenv("PORT");
	
	if port == "" {
		tracelog.Error(nil, "The PORT environment variable has not been set.", "main")
		os.Exit(1)
	}
	
	var edmundsApiKey = os.Getenv("EDMUNDS_API_KEY")
	if edmundsApiKey == "" {
		tracelog.Error(nil, "The EDMUNDS_API_KEY enviornment variable has not been set.", "main")
	}
	SetEdmundsApiKey(edmundsApiKey)
	
	tracelog.Info("Started", "main", "Dealer Service is starting and listening on port %s", port);
	
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
	
	tracelog.Info("Stopped", "main", "Dealer Service has been terminated")
	tracelog.Stop()
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	vars := mux.Vars(r)
	brand := vars["brand"]
	postalCode := vars["postalCode"]
	
	tracelog.Trace("Brand Value","main", "Brand is %s", brand);
	tracelog.Trace("Postal Code", "main", "PostalCode is %s", postalCode)

	// now call the Edmunds API
	dealers, dealerErr := DealersAroundZipCode( postalCode, 100, brand, true)
	if dealerErr != nil {
		ReturnErrorToClient(w, dealerErr, "Error calling dealer service with zip code " + postalCode)
		tracelog.Error(dealerErr, "DealersAroundZipCode failed", "HomeHandler")
		return
	}
	
	w.WriteHeader(http.StatusOK)
	var err error
	if err = json.NewEncoder(w).Encode(dealers); err != nil {
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