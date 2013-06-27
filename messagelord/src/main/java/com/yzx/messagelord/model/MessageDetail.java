package com.yzx.messagelord.model;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "message")
public class MessageDetail {
	public static final int STATE_UNPOSTED = 0;
	public static final int STATE_DISTRIBUTED = -1;
	public static final int STATE_POSTED = 1;
	
	private String uid;
	private String destinationNumber;
	private String messageContent;
	private int state;
	private int postedAppleID;
	private AppleId speacifiedAppleID;
	private String distributeDate;
	
	public String getDestinationNumber() {
		return destinationNumber;
	}
	public void setDestinationNumber(String destinationNumber) {
		this.destinationNumber = destinationNumber;
	}
	public String getMessageContent() {
		return messageContent;
	}
	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}
	public AppleId getSpeacifiedAppleID() {
		return speacifiedAppleID;
	}
	public void setSpeacifiedAppleID(AppleId speacifiedAppleID) {
		this.speacifiedAppleID = speacifiedAppleID;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public int getPostedAppleID() {
		return postedAppleID;
	}
	public void setPostedAppleID(int postedAppleID) {
		this.postedAppleID = postedAppleID;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getDistributeDate() {
		return distributeDate;
	}
	public void setDistributeDate(String distributeDate) {
		this.distributeDate = distributeDate;
	}
	
}
