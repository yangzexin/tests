package com.yzx.messagelord.model;

public class UploadContactNumber {
	private String uid;
	private String destinationNumber;
	private String commercialUserId;
	private boolean imessageUser;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getDestinationNumber() {
		return destinationNumber;
	}
	public void setDestinationNumber(String destinationNumber) {
		this.destinationNumber = destinationNumber;
	}
	public String getCommercialUserId() {
		return commercialUserId;
	}
	public void setCommercialUserId(String commercialUserId) {
		this.commercialUserId = commercialUserId;
	}
	public boolean isImessageUser() {
		return imessageUser;
	}
	public void setImessageUser(boolean imessageUser) {
		this.imessageUser = imessageUser;
	}
}
