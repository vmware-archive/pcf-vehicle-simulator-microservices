package io.pivotal.demo;

public class VehicleInfo {
	private Double odometer;
	private Double fuelLevel;
	private Double latitude;
	private Double longitude;
	
	public Double getOdometer() {
		return odometer;
	}
	public void setOdometer(Double odometer) {
		this.odometer = odometer;
	}
	public Double getFuelLevel() {
		return fuelLevel;
	}
	public void setFuelLevel(Double fuelLevel) {
		this.fuelLevel = fuelLevel;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	
	@Override
	public String toString() {
		return "VehicleInfo [odometer=" + odometer + ", fuelLevel=" + fuelLevel
				+ ", latitude=" + latitude + ", longitude=" + longitude + "]";
	}
	
}
