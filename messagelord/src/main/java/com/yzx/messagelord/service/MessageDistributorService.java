package com.yzx.messagelord.service;

import java.util.List;

import com.yzx.messagelord.model.MessageDetail;

public interface MessageDistributorService {
	public List<MessageDetail> getUnpostedMessage(int size);
	public void markPosted(List<MessageDetail> messageDetailList);
	public void markUnposted(List<MessageDetail> messageDetailList);
	public void submitNewList(List<MessageDetail> messageDetailList, String messageContent);
	public void restoreTimeoutedMessages();
}
