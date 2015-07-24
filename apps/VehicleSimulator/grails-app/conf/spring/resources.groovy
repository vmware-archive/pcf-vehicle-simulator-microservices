import grails.util.Environment
import io.pivotal.demo.VehicleMessageConsumer

// Place your Spring DSL code here
beans = {
	vehicleMessageConsumer(VehicleMessageConsumer) {
		uri = application.config.io.pivotal.demo.rabbitmq.uri
		queueName = application.config.io.pivotal.demo.rabbitmq.queue
	}
	
	cloudFactory(org.springframework.cloud.CloudFactory)
}
