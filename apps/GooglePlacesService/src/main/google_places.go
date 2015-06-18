package main

import (
	"fmt"
	"encoding/json"
	"net/http"
	"io/ioutil"
	"errors"
	"bytes"
	"log"
)

type GooglePlacesResponse struct {
	Results []struct {
		Geometry struct {
			Location struct {
				Lat	float64		`json:"lat"`
				Lng float64		`json:"lng"`
			}					`json:"location"`
		}						`json:"geometry"`
		Name string 			`json:"name"`
		PlaceId  string 		`json:"place_id"`
		Vicinity string 		`json:"vicinity"`
	} `json:"results"`
	Status   string  						`json:"status"`
}

type Place struct {
	Name 	string;
	Id		string;
	Address	string;
	Lat		float64;
	Lng		float64;
}

type Places []Place;

var googleZeroResultsError = errors.New("ZERO_RESULTS")

// This contains the base URL for the Google Places API.
var googlePlacesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

var GoogleAPIKey = ""

func SetGooglePlacesURL(newPlacesURL string) {
	googlePlacesURL = newPlacesURL
}

func SetGoogleAPIKey(newAPIKey string) {
	GoogleAPIKey = newAPIKey
}

func NearbySearch(placeType string, lat float64, lng float64) (Places, error) {
	queryStr, err := googlePlacesQueryStr(placeType, lat, lng)
	if err != nil {
		return Places{}, err
	}
	
	resp, err := http.Get( queryStr )
	if err != nil {
		return Places{}, err
	}
	
	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return Places{}, err
	}
	
	resp.Body.Close()
	
	response := &GooglePlacesResponse{}
	err = json.Unmarshal(data, response)
	if err != nil {
		return Places{}, err
	}

	if len(response.Results) == 0 {
		return Places{}, googleZeroResultsError
	}
	
	var listOfPlaces = Places{}
	for _, result := range response.Results {
		listOfPlaces = append(listOfPlaces, Place{
				Name: result.Name, 
				Id: result.PlaceId, 
				Address: result.Vicinity, 
				Lat: result.Geometry.Location.Lat, 
				Lng: result.Geometry.Location.Lng})  
	}
	
	return listOfPlaces, nil
}

func googlePlacesQueryStr(placeType string, lat float64, lng float64) (string, error) {
	var queryStr = bytes.NewBufferString(googlePlacesURL + "?")
	_, err := queryStr.WriteString(fmt.Sprintf("location=%f,%f&rankby=distance&types=%s", lat, lng, placeType))
	if err != nil {
		return "", err
	}

	if GoogleAPIKey != "" {
		_, err := queryStr.WriteString(fmt.Sprintf("&key=%s", GoogleAPIKey))
		if err != nil {
			return "", err
		}
	}
	
	log.Print("The query string is ", queryStr.String()); 

	return queryStr.String(), err
}