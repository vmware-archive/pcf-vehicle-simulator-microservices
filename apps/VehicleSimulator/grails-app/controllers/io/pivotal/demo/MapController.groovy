package io.pivotal.demo

import org.codehaus.groovy.grails.commons.GrailsApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import grails.converters.JSON
import grails.plugins.rest.client.RestBuilder
import io.pivotal.demo.VehicleMessageConsumer

@Component
class MapController {
	
	def grailsApplication
	
	def static vehicleMessageConsumer
			
    def index() 
	{ 
		flash.message = null
	}
	
	def startTracking()
	{
		println "startTracking()"
		
		if (!grailsApplication.config.io.pivotal.demo.rabbitmq.available)
		{
			flash.message "Application not bound to RabbitMQ"
		}
		else
		{
			flash.message = "Vehicle tracking has been STARTED."
		}
		
		render view: 'index'
	}
	
	def stopTracking()
	{
		println "stopTracking"
		
		flash.message = "Vehicle tracking has been STOPPED."
		
		render view: 'index'
	}
	
	def vehicleStats()
	{
		println "vehicleStats"
		
		def info = vehicleMessageConsumer.retrieveVehicleInfo();
		
		println "Vehicle Stats {$info}"
		
		render info as JSON
	}
	
	// URL Example: /VehicleSimulator/map/nearestGasStations?lat=42.221786&lng=-83.414139
	def nearestGasStations()
	{
		println "Nearest Gas Stations"
		
		def lat = params.lat
		def lng = params.lng
		
		println "Latitude, Longitude is ${lat}, ${lng}"

		def restBuilder = new RestBuilder()
		
		def url = grailsApplication.config.io.pivotal.demo.google.places.gas.url + lat + '/' + lng
		
		println "The google places URL is ${url}" 
		
		def response = restBuilder.get(url)
		
		println "The response is ${response.json}"
		
		render response.json as JSON
	}
	
	// URL Example: /VehicleSimulator/map/nearestDealerships?lat=42.221786&lng=-83.414139&brand=ford
	def nearestDealerships()
	{
		println "Nearest Dealerships"
		
		def lat = params.lat
		def lng = params.lng
		def brand = params.brand
		
		println "Latitude, Longitude is ${lat}, ${lng}. Brand is ${brand}"
		
		// first we need to get the zip code...
		def restBuilder = new RestBuilder()
		
		def url = grailsApplication.config.io.pivotal.demo.google.geocode.url + lat + '/' + lng
		
		println "The reverse geo URL is {$url}"
		
		def response = restBuilder.get(url)
		
		def postalCode = response.json.postalCode
		
		// TODO: make sure postalCode is okay and if not, return an error
		
		def dealerUrl = grailsApplication.config.io.pivotal.demo.dealer.service.url + brand + '/' + postalCode
		def rest = new RestBuilder();
		def dealerResponse = rest.get(dealerUrl);
		
		println "The dealer response (JSON) is {$dealerResponse.json}"
		
		render dealerResponse.json as JSON
	}
	
	// URL Example: /VehicleSimulator/map/nearestGasStationsWithPrices?lat=42.221786&lng=-83.414139&distance=5
	def nearestGasStationsWithPrices()
	{
		println "Nearest Gas Stations with Prices"
		
		def lat = params.lat
		def lng = params.lng
		def distance = params.distance
		
		println "Latitude, Longitude is {$lat}, ${lng}. Distance is ${distance}"
		
		def restBuilder = new RestBuilder();
		
		def url = grailsApplication.config.io.pivotal.demo.gas.price.service.url + lat + "/" + lng + "/" + distance
		
		def response = restBuilder.getAt(url);
		
		println "The gas station prices response (JSON) is ${response.json}"
		
		render response.json as JSON 
	}
	
	// URL Example: /VehicleSimulator/map/dealershipOpenings?id=123
	def dealershipOpenings()
	{
		println "Dealership Openings"
		
		def dealerId = params.id
		
		println "The dealer ID is ${dealerId}"
		
		def restBuilder = new RestBuilder();
		
		def url = grailsApplication.config.io.pivotal.demo.repair.service.url + dealerId
		
		println "The url is ${url}"
		
		def response = restBuilder.get(url);
		
		println "The repair service response (JSON) is ${response.json}"
		
		render response.json as JSON
	}
	
	def killApp()
	{
		println "killing App()"
					
		flash.message = "Shutdown of the Vehicle App."
		
		render view: 'index'
			   
		System.exit(1);
	}
}
