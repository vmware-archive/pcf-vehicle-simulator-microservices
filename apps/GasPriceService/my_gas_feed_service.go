package main

import (
	"fmt"
	"bytes"
	"net/http"
	"io/ioutil"	
	"encoding/json"
	"github.com/goinggo/tracelog"
)

type GasPriceResponse struct {
	Status struct {
		Error			string		`json:"error"`
		Code			int32		`json:"code"`
		Description		string		`json:"description"`
		Message			string		`json:"message"`
	}								`json:"status"`
	Stations []struct {
		Id				string		`json:"id"`
		Latitude		string		`json:"lat"`
		Longitude		string		`json:"lng"`
		Name			string		`json:"station"`
		Address			string		`json:"address"`
		City			string		`json:"city"`
		Region			string		`json:"region"`
		ZipCode			string		`json:"zip"`
		Distance		string		`json:"distance"`
		RegularPrice	string		`json:"reg_price"`
		MidPrice		string		`json:"mid_price"`
		PremiumPrice	string		`json:"pre_price"`
		DieselPrice		string		`json:"diesel_price"`
		RegularDate		string		`json:"reg_date"`
		MidDate			string		`json:"mid_date"`
		PremiumDate		string		`json:"pre_date"`
		DieselDate		string		`json:"diesel_date"`
	}								`json:"stations"`
	
}

var myGasFeedBaseUrl = ""

func SetMyGasFeedBaseUrl(newUrl string) {
    myGasFeedBaseUrl = newUrl
}

var myGasFeedApiKey = ""

func SetMyGasFeedApiKey(newApiKey string) {
   myGasFeedApiKey = newApiKey
}

func NearbyGasStations(lat string, lng string, distance string) (GasPriceResponse, error) {
	queryStr, err := NearbyGasStationQueryString(lat, lng, distance)
	if err != nil {
		return GasPriceResponse{}, err
	}
	
	tracelog.Trace("Query String", "NearbyGasStations", queryStr)
	
	resp, err := http.Get( queryStr )
	if err != nil {
		return GasPriceResponse{}, err
	}
	
	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return GasPriceResponse{}, err
	}
	
	resp.Body.Close()	
	
	response := &GasPriceResponse{}
	err = json.Unmarshal(data, response)
	if err != nil {
		return GasPriceResponse{}, err
	}
	
	return *response, err
}

func NearbyGasStationQueryString(lat string, lng string, distance string) (string, error) {

	var queryStr = bytes.NewBufferString(myGasFeedBaseUrl)
	
	// add the lat, lng and distance and api
	_, err := queryStr.WriteString(fmt.Sprintf("/stations/radius/%s/%s/%s/reg/distance/%s.json",
				lat, lng, distance, myGasFeedApiKey))
	if err != nil {
		return "", err
	}
	
	return queryStr.String(), err
}
