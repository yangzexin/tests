package com.yzx.messagelord.util.clientstat;

public class ClientStatInfo {
	private String ipAddress;
	private int count;
	private int successCount;
	private long lastRequestTime;
	private long firstRequestTime;
	
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public long getLastRequestTime() {
		return lastRequestTime;
	}
	public void setLastRequestTime(long lastRequestTime) {
		this.lastRequestTime = lastRequestTime;
	}
	public int getSuccessCount() {
		return successCount;
	}
	public void setSuccessCount(int successCount) {
		this.successCount = successCount;
	}
	public long getFirstRequestTime() {
		return firstRequestTime;
	}
	public void setFirstRequestTime(long firstRequestTime) {
		this.firstRequestTime = firstRequestTime;
	}
}
