package com.pivotal.auto;

public class Vehicle 
{
	private long   styleId;
	private String styleName;
	private String make;
	private String model;
	private int    year;
	private String trim;
	private String body;
	private double  baseMSRP;
	private String imageUrl;
	
	public Vehicle(long styleId, String styleName, String make, String model,int year, String trim, String body, double baseMSRP, String imageUrl)
	{	
		super();
		
		this.styleId = styleId;
		this.styleName = styleName;
		this.make = make;
		this.model = model;
		this.year = year;
		this.trim = trim;
		this.body = body;
		this.baseMSRP = baseMSRP;
		this.imageUrl = imageUrl;
	}
	
	public long getStyleId() {
		return styleId;
	}
	public void setStyleId(long styleId) {
		this.styleId = styleId;
	}
	public String getStyleName() {
		return styleName;
	}
	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}
	public String getMake() {
		return make;
	}
	public void setMake(String make) {
		this.make = make;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public String getTrim() {
		return trim;
	}
	public void setTrim(String trim) {
		this.trim = trim;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public double getBaseMSRP() {
		return baseMSRP;
	}
	public void setBaseMSRP(double baseMSRP) {
		this.baseMSRP = baseMSRP;
	}

	public String getBody() {
		return body;
	}
	public void setBody(String body) {
		this.body = body;
	}
	
	
}
