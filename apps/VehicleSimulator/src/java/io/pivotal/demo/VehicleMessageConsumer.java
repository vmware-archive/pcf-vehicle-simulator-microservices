package io.pivotal.demo;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.GetResponse;

public class VehicleMessageConsumer 
{
	private String rabbitUri;
	private String rabbitQueueName;
	private Connection rabbitConnection;
	private Channel rabbitChannel;
	
	public VehicleMessageConsumer(String rabbitUri, String queueName)
	{
		this.rabbitUri = rabbitUri;
		this.rabbitQueueName = queueName;
	}
	
	public VehicleMessageConsumer() { }
	
	public String getUri() {
		return rabbitUri;
	}
	
	public void setUri(String uri) {
		rabbitUri = uri;
	}
	
	public String getQueueName() {
		return rabbitQueueName;
	}
	
	public void setQueueName(String queueName) {
		rabbitQueueName = queueName;
	}
	
	public void openConnection()
	{
		if (rabbitConnection == null)
		{
			try
			{
				ConnectionFactory factory = new ConnectionFactory();
				// TODO: make this PCF friendly
				factory.setUri(this.rabbitUri);
				rabbitConnection = factory.newConnection();
				rabbitChannel = rabbitConnection.createChannel();
			}
			catch(Exception ex)
			{
				if (rabbitConnection != null)
				{
					try
					{
						rabbitConnection.close();
					}
					catch(IOException ioe)
					{
						// don't like this but eat the exception
					}
					rabbitConnection = null;
				}
				
				throw new IllegalStateException("Unable to create connection to rabbit-mq", ex);
			}
		}
	}
	
	public void closeConnection()
	{
		try
		{
			if (rabbitChannel != null)
				rabbitChannel.close();
	
			if (rabbitConnection != null)
				rabbitConnection.close();
		}
		catch(Exception ex)
		{
			rabbitChannel = null;
			rabbitConnection = null;
		}
	}
	
	public String retrieveMessage()
	{
		try
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
			
			if (rabbitConnection == null || rabbitChannel == null)
			{
				System.out.println("INFO: Conneciton is not already opened. Opening the connection...");
				openConnection();
			}
			
			boolean autoAck = false;
System.out.println("here 1: " + sdf.format(new Date()));			
			GetResponse response = rabbitChannel.basicGet(rabbitQueueName, autoAck);
System.out.println("here 2: " + sdf.format(new Date()));			
			if (response == null)
			{
				return null;
			}
			
			byte[] body = response.getBody();
			long deliveryTag = response.getEnvelope().getDeliveryTag();
			
			// convert bytes to a string
			String bodyAsString = new String(body);
			
			// acknowledge receipt of message
System.out.println("here 3: " + sdf.format(new Date()));			
			rabbitChannel.basicAck(deliveryTag, false); 
System.out.println("here 4: " + sdf.format(new Date()));			
	
			return bodyAsString;				
		}
		catch(IOException ioex)
		{
			throw new IllegalStateException("Unable to retrieve message: ", ioex);
		}
	}
	
	/***
	 * Retrieves vehicle information until it finds a lat/long pair
	 * Note: Fuel Level and Odometer may not be set, but Lat/Long should be - as long as we have enough data on the queue
	 * @return
	 */
	public VehicleInfo retrieveVehicleInfo()
	{
		try
		{
			VehicleInfo vehicleInfo = new VehicleInfo();
			String msg = retrieveMessage();
			boolean haveLatitude = false;
			boolean haveLongitude = false;
			while (msg != null)
			{				
				VehicleData vehicleData = convertToPojo(msg);
				System.out.println(vehicleData);
				
				if (vehicleData.isLatitude())
				{
					haveLatitude = true;
					vehicleInfo.setLatitude(vehicleData.getValue());
				}
				else if (vehicleData.isLongitude())
				{
					haveLongitude = true;
					vehicleInfo.setLongitude(vehicleData.getValue());
				}
				else if (vehicleData.isFuelLevel())
				{
					vehicleInfo.setFuelLevel(vehicleData.getValue());
				}
				else if (vehicleData.isOdometer())
				{
					vehicleInfo.setOdometer(vehicleData.getValue());
				}
				
				if (haveLatitude && haveLongitude)
					break;
				
				msg = retrieveMessage();
			}
			return vehicleInfo;
		}
		catch(Exception ex)
		{
			throw new IllegalStateException("An error occurred while retrieving vehicle info", ex);
		}
	}
	
	private VehicleData convertToPojo(String json)
	{
		try
		{
			ObjectMapper mapper = new ObjectMapper();
			mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
			VehicleData vehicleData = mapper.readValue(json, VehicleData.class);
			return vehicleData;
		}
		catch(Exception ex)
		{
			throw new IllegalStateException("An error occurred while parsing the JSON response", ex);
		}
		
	}
	
	public static void main(String[] args)
	{
		// an example usage
		VehicleMessageConsumer vmc = new VehicleMessageConsumer("amqp://dzmmizcc:v-tY2b5xjrjqgkC3TJ9rbbHgyKOlZDSM@tiger.cloudamqp.com/dzmmizcc", "vehicle-data-queue");
		vmc.openConnection();
		try
		{
			// example of retrieving just a single message
			/*
			String message = vmc.retrieveMessage();
			System.out.println("The message was: " + message);
			*/
			
			VehicleInfo info = vmc.retrieveVehicleInfo();
			System.out.println("Latitude: " +  info.getLatitude());
			System.out.println("Longitude: "+  info.getLongitude());
			System.out.println("Fuel Level: " + info.getFuelLevel());
			System.out.println("Odometer: " + info.getOdometer());
		}
		finally
		{
			vmc.closeConnection();
		}
	}	
}
