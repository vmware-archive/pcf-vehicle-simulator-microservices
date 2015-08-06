package io.pivotal.demo.config;

import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.cloud.Cloud;
import org.springframework.cloud.CloudFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("cloud")
public class CloudProfile 
{
	@Bean
	public CloudFactory cloudFactory()
	{
		return new CloudFactory();
	}
	
	@Bean
	public ConnectionFactory connectionFactory()
	{
		CloudFactory cloudFactory = new CloudFactory();
		Cloud cloud = cloudFactory.getCloud();
		ConnectionFactory connectionFactory = cloud.getSingletonServiceConnector(ConnectionFactory.class, null);
		
		return connectionFactory;		
	}
	
    @Bean
    public RabbitTemplate rabbitTemplate() {
        return new RabbitTemplate(connectionFactory());
    }
}
