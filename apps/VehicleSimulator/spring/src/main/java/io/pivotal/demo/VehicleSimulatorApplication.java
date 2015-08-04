package io.pivotal.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.context.annotation.Configuration;

@Configuration
@SpringBootApplication
@EnableFeignClients
@EnableAutoConfiguration
public class VehicleSimulatorApplication {

    public static void main(String[] args) {
        SpringApplication.run(VehicleSimulatorApplication.class, args);
    }
}
