package io.pivotal.demo.service;

import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import io.pivotal.demo.Geo;

@FeignClient(url="http://google-reverse-geocode-service.cfapps.io")
public interface GeocodeClient {

    @RequestMapping(method = RequestMethod.GET, value = "/{lat}/{lng}")
    Geo geocode(@RequestParam("lat") String lat, @RequestParam("lng") String lng);

}