package com.yzx.messagelord.model;

public class MessageContent {
	private String uid;
	private String content;
	private String commercialUserId;
	private long addDate;
	
	public String getCommercialUserId() {
		return commercialUserId;
	}
	public void setCommercialUserId(String commercialUserId) {
		this.commercialUserId = commercialUserId;
	}
	public long getAddDate() {
		return addDate;
	}
	public void setAddDate(long addDate) {
		this.addDate = addDate;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}
