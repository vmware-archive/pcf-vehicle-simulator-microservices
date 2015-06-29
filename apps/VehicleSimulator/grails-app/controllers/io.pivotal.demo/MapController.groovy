package io.pivotal.demo

class MapController {
	
	boolean isRunning = false
	def rabbitContext

    def index() 
	{ 
		flash.message = null
	}
	
	def startTracking()
	{
		println "startTracking()"
		if (rabbitContext == null) 
		{
			println "Warning rabbit context is null!"
		}
		
		println "rabbitContext is ${rabbitContext}"
		
		rabbitContext.startConsumers()
			
		flash.message = "Vehicle tracking has been STARTED."
		
		render view: 'index'
	}
	
	def stopTracking()
	{
		println "stopTracking"
		if (rabbitContext == null)
		{
			println "Warning rabbit context is null!"
		}
		
		println "rabbitContext is ${rabbitContext}"
		
		rabbitContext.stopConsumers()
		
		flash.message = "Vehicle tracking has been STOPPED."
		render view: 'index'
	}
	
}
