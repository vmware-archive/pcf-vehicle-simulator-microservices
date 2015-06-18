package main

import (
	"encoding/json"
	"os"
	"log"
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
	var port = os.Getenv("PORT");
	
	if port == "" {
		log.Fatal("The PORT environment variable has not been set.");
	}
	
	var edmundsApiKey = os.Getenv("EDMUNDS_API_KEY")
	if edmundsApiKey == "" {
		log.Fatal("The EDMUNDS_API_KEY enviornment variable has not been set.")
	}
	SetEdmundsApiKey(edmundsApiKey)
	
	log.Print("Dealer Service is starting and listening on port ", port);
	
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
	
	log.Print("Dealer Service has been terminated")
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	vars := mux.Vars(r)
	brand := vars["brand"]
	postalCode := vars["postalCode"]
	
	log.Print("Brand is ", brand);
	log.Print("PostalCode is ", postalCode);
	
	// now call the Edmunds API
	dealers, dealerErr := DealersAroundZipCode( postalCode, 100, brand, true)
	if dealerErr != nil {
		ReturnErrorToClient(w, dealerErr, "Error calling dealer service with zip code " + postalCode)
		
		return
	}
	
	w.WriteHeader(http.StatusOK)
	var err error
	if err = json.NewEncoder(w).Encode(dealers); err != nil {
		panic(err)
	}
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