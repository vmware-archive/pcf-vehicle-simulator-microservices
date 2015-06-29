package io.pivotal.demo;

import org.apache.log4j.Level;

import groovy.util.logging.Log4j;
import groovy.json.JsonSlurper;

import com.budjb.rabbitmq.consumer.MessageContext;

@Log4j
class VehicleMessageConsumer {
	static {
		println "static init block"
		
	}

	// tried moving this into Config.groovy but it didn't work :( 	
	static rabbitConfig = 
	[
		"queue" : "vehicle-data-queue"
	]
	
	def handleMessage(def body, MessageContext context)
	{
		println "handleMessage"
		
		println "The body is ${body}"
		println "The context is ${context}"
		
		def jsonSlurper = new JsonSlurper()
		def object = jsonSlurper.parseText( body );
		
		println "The name is ${object.name}"
		println "The value is ${object.value}"
		println "The timestamp is {$object.timestamp}"

		// TODO: implement
	}

}
