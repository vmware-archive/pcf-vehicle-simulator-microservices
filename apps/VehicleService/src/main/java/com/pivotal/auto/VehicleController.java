package com.pivotal.auto;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/")
public class VehicleController 
{
	private List<Vehicle> featuredVehicles = Arrays.asList(
			new Vehicle(200714331, "SE 4dr Hatchback (2.0L 4cyl 5M)", "Ford", "Focus", 2015, "SE", "Hatchback", 18960.0, "http://assets.forddirect.fordvehicles.com/assets/2015_Ford_Focus_J1/NGBS/Model_Image3/Model_Image3_136B520A-19F5-6A18-59C1-84CF59C184CF.jpg"),
			new Vehicle(200692519, "SE 4dr Sedan (1.6L 4cyl 5M)", "Ford", "Fiesta", 2015, "SE", "Sedan", 15685.0, "http://assets.forddirect.fordvehicles.com/assets/2014_Ford_Fiesta_J1/NGBS/Model_Image3/Model_Image3_136B520B-E1AE-4524-1ECE-F2431ECEF243.jpg"),
			new Vehicle(200699859, "GT Premium 2dr Coupe (5.0L 8cyl 6M)", "Ford", "Mustang", 2015, "GT Premium", "Coupe", 36100.0, "http://assets.forddirect.fordvehicles.com/assets/2015_Ford_Mustang_J1/NGBS/Model_Image3/Model_Image3_136B520D-5859-F40F-CE0F-0500CE0F0500.jpg"),
			new Vehicle(200706666, "XLT 2dr Regular Cab 4WD 8 ft. LB (3.5L 6cyl 6A)", "Ford", "F-150 Regular Cab", 2015, "XLT", "Regular Cab", 34810.0, "http://assets.forddirect.fordvehicles.com/assets/2015_Ford_F-150_J1/NGBS/Model_Image3/Model_Image3_136B520C-F14A-A0F5-EC09-6698EC096698.jpg")
			);
	
	@RequestMapping(method=RequestMethod.GET)
	@ResponseBody
	public String ping()
	{
		return "The server is up and running";
	}
		
	@RequestMapping(value="/featured")
	public @ResponseBody List<Vehicle> FeaturedVehicles()
	{		
		return featuredVehicles;
	}
}
