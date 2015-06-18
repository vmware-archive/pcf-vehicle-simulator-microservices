package main

import (
	"fmt"
	"encoding/json"
	"net/http"
	"io/ioutil"
	"errors"
	"bytes"
)

type AddressComponent struct {
   LongName		string		`json:"long_name"`
   ShortName	string		`json:"short_name"`
   Types		[]string	`json:"types"`	
}

type GoogleReverseGeocodeResponse struct {
   Results []struct {
   	 AddressComponents []AddressComponent	`json:"address_components"`
   	 FormattedAddress  string				`json:"formatted_address"`
   }
   Status   string  						`json:"status"`
}

var googleZeroResultsError = errors.New("ZERO_RESULTS")

// This contains the base URL for the Google Geocoder API.
var googleGeocodeURL = "https://maps.googleapis.com/maps/api/geocode/json"

var GoogleAPIKey = ""

func SetGoogleGeocodeURL(newGeocodeURL string) {
	googleGeocodeURL = newGeocodeURL
}

func SetGoogleAPIKey(newAPIKey string) {
	GoogleAPIKey = newAPIKey
}

func ReverseGeocodeToPostalCode(lat float64, lng float64 ) (string, error) {
	queryStr, err := googleReverseGeocodeQueryStr(lat, lng)
	if err != nil {
		return "", err
	}

	resp, err := http.Get( queryStr )
	if err != nil {
		return "", err
	}
	
	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	
	resp.Body.Close()
	
	response := &GoogleReverseGeocodeResponse{}
	err = json.Unmarshal(data, response)
	if err != nil {
		return "", err
	}

	if len(response.Results) == 0 {
		return "", googleZeroResultsError
	}
	
	for _, addressComp := range response.Results[0].AddressComponents {
		for _, aType := range addressComp.Types {
			if aType == "postal_code" {
				return addressComp.ShortName, nil
			}
		}
	}

	return "", googleZeroResultsError
}


func googleReverseGeocodeQueryStr(lat float64, lng float64) (string, error) {
	var queryStr = bytes.NewBufferString(googleGeocodeURL + "?")
	_, err := queryStr.WriteString(fmt.Sprintf("latlng=%f,%f", lat, lng))
	if err != nil {
		return "", err
	}

	if GoogleAPIKey != "" {
		_, err := queryStr.WriteString(fmt.Sprintf("&key=%s", GoogleAPIKey))
		if err != nil {
			return "", err
		}
	}
	
	// log.Print("The query string is ", queryStr.String()); 

	return queryStr.String(), err
}