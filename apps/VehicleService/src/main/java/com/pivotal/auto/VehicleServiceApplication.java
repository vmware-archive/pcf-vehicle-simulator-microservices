package com.pivotal.auto;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableAutoConfiguration
public class VehicleServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(VehicleServiceApplication.class, args);
    }
}
