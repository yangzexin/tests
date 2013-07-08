package com.yzx.messagelord.model;

public class UploadContactNumberGroup {
	private String uid;
	private String title;
	private String commercialUserId;
	private long numberOfNumbers;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCommercialUserId() {
		return commercialUserId;
	}
	public void setCommercialUserId(String commercialUserId) {
		this.commercialUserId = commercialUserId;
	}
	public long getNumberOfNumbers() {
		return numberOfNumbers;
	}
	public void setNumberOfNumbers(long numberOfNumbers) {
		this.numberOfNumbers = numberOfNumbers;
	}
}
