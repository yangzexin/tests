package com.yzx.messagelord.model;

public class CommercialUser {
	private String uid;
	private String username;
	private String password;
	private long numberOfSendedMessage;
	private long numberOfPurchasedMessage;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public long getNumberOfSendedMessage() {
		return numberOfSendedMessage;
	}
	public void setNumberOfSendedMessage(long numberOfSendedMessage) {
		this.numberOfSendedMessage = numberOfSendedMessage;
	}
	public long getNumberOfPurchasedMessage() {
		return numberOfPurchasedMessage;
	}
	public void setNumberOfPurchasedMessage(long numberOfPurchasedMessage) {
		this.numberOfPurchasedMessage = numberOfPurchasedMessage;
	}
	
}
