package com.yzx.messagelord.model;

public class MessageTaskGroup {
	private String uid;
	private long addDate;
	private String title;
	private long numberOfTasks;
	private String messageContentId;
	private String commercialUserId;
	
	public String getMessageContentId() {
		return messageContentId;
	}
	public void setMessageContentId(String messageContentId) {
		this.messageContentId = messageContentId;
	}
	public String getCommercialUserId() {
		return commercialUserId;
	}
	public void setCommercialUserId(String commercialUserId) {
		this.commercialUserId = commercialUserId;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public long getAddDate() {
		return addDate;
	}
	public void setAddDate(long addDate) {
		this.addDate = addDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public long getNumberOfTasks() {
		return numberOfTasks;
	}
	public void setNumberOfTasks(long numberOfTasks) {
		this.numberOfTasks = numberOfTasks;
	}
}
