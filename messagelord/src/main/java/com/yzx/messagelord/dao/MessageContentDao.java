package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.MessageContent;

public interface MessageContentDao {
	public MessageContent getMessageContent(String uid);
	public int add(MessageContent mc);
	public void update(MessageContent mc);
	public void delete(MessageContent mc);
	public List<MessageContent> list(int beginIndex, int endIndex);
	public List<MessageContent> list(int beginIndex, int endIndex, String commercialUserId);
}
