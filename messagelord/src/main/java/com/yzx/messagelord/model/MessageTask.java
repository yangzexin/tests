package com.yzx.messagelord.model;

public class MessageTask {
	public static final int STATE_UNHANDLED = 0;
	public static final int STATE_DISTRIBUTED = 1;
	public static final int STATE_SUCCESS = 2;
	public static final int STATE_FAIL = 3;
	
	private String uid;
	private String groupId;
	private String destinationNumber;
	private long deliverDate;
	private int state;
	private long distributeDate;
	private String appleIdOfHandler;
	
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
	public long getDeliverDate() {
		return deliverDate;
	}
	public void setDeliverDate(long deliverDate) {
		this.deliverDate = deliverDate;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public long getDistributeDate() {
		return distributeDate;
	}
	public void setDistributeDate(long distributeDate) {
		this.distributeDate = distributeDate;
	}
	public String getAppleIdOfHandler() {
		return appleIdOfHandler;
	}
	public void setAppleIdOfHandler(String appleIdOfHandler) {
		this.appleIdOfHandler = appleIdOfHandler;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
}
