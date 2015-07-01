package main

import (
	"fmt"
	"bytes"
	"net/http"
	"io/ioutil"	
	"encoding/json"
	"github.com/goinggo/tracelog"
)

type EdmundsDealerResponse struct {
	Dealers []struct {
		Id			string		`json:"dealerId"`
		Name 		string		`json:"name"`
		NiceName	string		`json:"niceName"`
		Distance	float32		`json:"distance"`
		Active		bool		`json:"active"`
		Address		struct {
			Street		string	`json:"street"`
			City		string	`json:"city"`
			StateCode	string	`json:"stateCode"`
			StateName	string	`json:"stateName"`
			ZipCode		string	`json:"zipcode"`
			Latitude	float32 `json:"latitude"`
			Longitude   float32 `json:"longitude"`
		} 						`json:"address"`
		Operations 	struct {
			Monday		string
			Tuesday		string
			Wednesday	string
			Thursday	string
			Friday		string
			Saturday	string
			Sunday		string
		} 						`json:"operations"`
		DealerType	string		`json:"type"`
	} 							`json:"dealers"`
}

// Base URL for the Edmnunds Dealer API
var edmundsDealerUrl = "http://api.edmunds.com/api/dealer/v2/dealers/"

var EdmundsApiKey = ""

func SetEdmundsApiKey(newApiKey string) {
	EdmundsApiKey = newApiKey
}

func DealersAroundZipCode(zipCode string, radius int32, make string, newCars bool) (EdmundsDealerResponse, error) {
	queryStr, err := DealerServiceQueryString( zipCode, radius, make, newCars )
	if err != nil {
		return EdmundsDealerResponse{}, err
	}
	
	tracelog.Trace("Query String", "DealersAroundZipCode", queryStr)
	
	resp, err := http.Get( queryStr )
	if err != nil {
		return EdmundsDealerResponse{}, err
	}
	
	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return EdmundsDealerResponse{}, err
	}
	
	resp.Body.Close()	
	
	tracelog.Trace("Response Returned", "DealersAroundZipCode", "%s", data)
	
	response := &EdmundsDealerResponse{}
	err = json.Unmarshal(data, response)
	if err != nil {
		return EdmundsDealerResponse{}, err
	}
	
	return *response, err
}

func DealerServiceQueryString(zipCode string, radius int32, make string, newCars bool) (string, error){
	var queryStr = bytes.NewBufferString(edmundsDealerUrl);
	
	// add the zip code & radius & make and new or used cars
	_, err := queryStr.WriteString(fmt.Sprintf("?zipcode=%s&radius=%d&make=%s&state=%s",
			zipCode, radius, make, NewOrUsed(newCars)))
	if err != nil {
		return "", err
	}
	
	// add other parameters (not the api key)
	_, err = queryStr.WriteString("&pageNum=1&pageSize=10&sortby=distance%3AASC&view=basic")
	if err != nil {
		return "", err
	}
	
	// add the API key now
	_, err = queryStr.WriteString(fmt.Sprintf("&api_key=%s", EdmundsApiKey))
	if err != nil {
		return "", err
	}
	
	return queryStr.String(), err		
}

func NewOrUsed(newCars bool) string {
	if newCars {
		return "new"
	}
	
	return "used"
}
