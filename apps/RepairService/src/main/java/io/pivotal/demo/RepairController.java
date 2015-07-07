package io.pivotal.demo;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/")
public class RepairController {
	
	@RequestMapping(method=RequestMethod.GET, value="/")
	@ResponseBody
	public String ping()
	{
		return "The repair server is up and running";
	}
	
	@RequestMapping(value="/ServiceOpenings/{dealerId}")
	public @ResponseBody List<Schedule> findServiceOpenings(@PathVariable("dealerId") String dealerId)
	{
		ArrayList<Schedule> schedules = new ArrayList<Schedule>();
		
		Calendar today = Calendar.getInstance();
			
		// is today sunday? - if so, we're closed 
		if (Calendar.SUNDAY == today.get(Calendar.DAY_OF_WEEK))
			return schedules; 
		
		Random randomGenerator = new Random();
		
		// clear the time from the date
		today.clear(Calendar.HOUR);
		today.clear(Calendar.HOUR_OF_DAY);
		today.clear(Calendar.MINUTE);
		today.clear(Calendar.SECOND);
		today.clear(Calendar.MILLISECOND);
		
		// no? then lets go through slots of time in 30 min increments and randomly determine if we're open
		// we're hard coding the opening times from 8:00 AM - 6:00 PM 
		for(float i=(float) 8.5;i<18.0;i=(float) (i+0.5))
		{
			boolean isOpen = randomGenerator.nextBoolean();
			
			if (isOpen)
			{
				String startTime = convertFloatToTime(i);
								
				Schedule s = new Schedule(dealerId, convertCalendarToDateString(today), startTime, "30 minutes", 30);
				
				schedules.add(s);
			}
		}
		
		return schedules;
	}
	
	private static String convertCalendarToDateString(Calendar date)
	{
		if (date == null)
			return null;
		
		Date theDate = date.getTime();
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		return sdf.format(theDate);
	}
	
	private static String convertFloatToTime(float input)
    {
		float originalInput = input;
		float nonMilitaryTime = input;
		if (nonMilitaryTime >= 13)
			nonMilitaryTime = nonMilitaryTime - 12.0f;
		
        String input_string = Float.toString(nonMilitaryTime);
        BigDecimal inputBD = new BigDecimal(input_string);
        String hhStr = input_string.split("\\.")[0];
        BigDecimal output = new BigDecimal(Float.toString(Integer.parseInt(hhStr)));
        output = output.add(
        		(inputBD.subtract(output).multiply(BigDecimal.valueOf(60))).divide(BigDecimal.valueOf(100), 2, BigDecimal.ROUND_HALF_EVEN)
        );
        
        String amPm = originalInput < 12 ? " AM" : " PM";

        return output.toString().replace(".",":") + amPm;
    }
}
