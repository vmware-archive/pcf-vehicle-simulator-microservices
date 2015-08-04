package vehiclesimulator

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
class PivotalUtilTagLib {	
    static defaultEncodeAs = [taglib:'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]
	
	def ipAddress = { attrs, body -> 
		def ip = InetAddress.getLocalHost().getHostAddress();
		out << body() << " " << ip;
	}
	
	def haveRabbitMqConnection = { attrs, body ->
		out << body() << (grailsApplication.config.io.pivotal.demo.rabbitmq.available ? " Yes" : " No");
	}
}
