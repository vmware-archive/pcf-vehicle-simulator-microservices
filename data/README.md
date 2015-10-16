# IoT Data 
# 
## Data Ingestion
Data ingestion is performed using [Spring XD]
(http://docs.spring.io/spring-xd/docs/current/reference/html/).  Once ingested, the data is filtered for fuel, location, and odometer reading.  The data is then piped to a RabbitMQ message queue.

## Requirements
For the immediate future, this can be done locally on a laptop, from an image capable of running Spring XD.  Spring XD should target a RabbitMQ queue either running locally, or in a hosted solution such as [CloudAMQP] (http://www.cloudamqp.com).  

* Spring XD 1.1.0 or later ([Instructions](https://github.com/SpringSource/spring-xd/wiki/Getting-Started))
* CloudAMQP account using a free plan ([Instructions] (https://www.cloudamqp.com/plans.html))
  * Alternatively, choose the free CloudAMQP plan within the [Pivotal Web Services] (http://run.pivotal.io) marketplace to use for this demo.

## Ingesting Data
Data that contains route and vehicle information needs to be ingested from a source.  For this demo, use the sample data in this project.  There are two version of each data file, a full file, and a smaller one consisting of a subset of data for testing.  This speeds up testing and is necessary if using a hosted RabbitMQ instance with a free plan. 

Create a queue within RabbitMQ name `vehicle-data-queue`.

Once you have Spring XD installed and a RabbitMQ destination configured, start a *Spring XD single-node instance*.

	xd/bin>$ ./xd-singlenode

Now start the *Spring XD Shell* in a separate window:

	shell/bin>$ ./xd-shell
	
In the *Spring XD shell*, create a new stream that reads data in `/tmp/openxc-input.json` performs a filter, and writes the results to your RabbitMQ queue:

	stream create --name openxc-ingest --definition "http | rabbit --addresses='<Rabbit URL>' --vhost='<Rabbit Virtual Host>' --username='<Rabbit Username>' --password='<Rabbit Password>' --routingKey='\"vehicle-data-queue\"'" --deploy
  
Once the stream is created, copy one of the sample input files to `/tmp/openxc-input.json`. Then, run the groovy script, OpenXCFileParser.groovy, found in apps/VehicleSimulator/scripts folder
