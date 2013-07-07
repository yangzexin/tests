package com.yzx.messagelord.model;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "user")
public class iMessageUser {
	public static final int STATE_PROBED = 1;
	public static final int STATE_UNHANDLED = 0;
	public static final int STATE_DISTRIBUTED = 2;
	private String uid;
	private String number;
	private int state;
	private boolean registered;
	private long distributedDate;
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public long getDistributedDate() {
		return distributedDate;
	}
	public void setDistributedDate(long distributedDate) {
		this.distributedDate = distributedDate;
	}
	public boolean isRegistered() {
		return registered;
	}
	public void setRegistered(boolean registered) {
		this.registered = registered;
	}
}
