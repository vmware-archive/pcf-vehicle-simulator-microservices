# RepairService

This service is written in Java as a Spring Boot application. 

## Prerequisites
1. Java
2. Maven 

## Usage

The url to access this service when running locally is http://localhost:[port]/ServiceOpenings/[dealer id] or http://localhost:8080/ServiceOpenings/456 which returns the following:

```
[
  {
    "dealerId": "123",
    "date": "07\/02\/2015",
    "startTime": "8:30 AM",
    "duration": "30 minutes",
    "durationInMinutes": 30
  },
  // more openings
]
```

## Assumptions
1. The dealer ID can be any valid string and is not checked
2. The returned date is always today's date
3. If the current date lands on a Sunday, no openings are returned because they are closed
4. The openings are random 30 minute slots between 8:00 AM and 6:00 PM
5. The duration is always 30 minutes
