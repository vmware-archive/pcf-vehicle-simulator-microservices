package io.pivotal.demo

import grails.converters.JSON
import grails.plugins.rest.client.RestBuilder

import io.pivotal.demo.VehicleMessageConsumer

class MapController {
	
	// TODO: Don't hard code these values
	def vehicleMessageConsumer = new VehicleMessageConsumer("amqp://dzmmizcc:v-tY2b5xjrjqgkC3TJ9rbbHgyKOlZDSM@tiger.cloudamqp.com/dzmmizcc","vehicle-data-queue")
	
    def index() 
	{ 
		flash.message = null
	}
	
	def startTracking()
	{
		println "startTracking()"
					
		flash.message = "Vehicle tracking has been STARTED."
		
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
	
	def nearestGasStations()
	{
		println "Nearest Gas Stations"
		
		def lat = params.lat
		def lng = params.lng
		
		println "Latitude, Longitude is ${lat}, ${lng}"

		def restBuilder = new RestBuilder()
		def url = 'http://google-places-service.cfapps.io/nearby/gas_station/' + lat + '/' + lng
		
		println "The google places URL is ${url}" 
		
		def response = restBuilder.get(url)
		
		println "The response is ${response.json}"
		
		render response.json
	}
}
