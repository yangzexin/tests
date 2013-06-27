package com.yzx.messagelord.model;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "appleid")
public class AppleId {
	public static final int STATE_UNUSED = 1;
	public static final int STATE_USING = 2;
	private String uid;
	private int state;
	private String appleID;
	private String password;
	private int sendTotal;
	private String lastUseTime;
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getSendTotal() {
		return sendTotal;
	}
	public void setSendTotal(int sendTotal) {
		this.sendTotal = sendTotal;
	}
	public String getAppleID() {
		return appleID;
	}
	public void setAppleID(String appleID) {
		this.appleID = appleID;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public String getLastUseTime() {
		return lastUseTime;
	}
	public void setLastUseTime(String lastUseTime) {
		this.lastUseTime = lastUseTime;
	}
}
