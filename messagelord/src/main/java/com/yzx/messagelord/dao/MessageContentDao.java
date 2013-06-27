package com.yzx.messagelord.dao;

import com.yzx.messagelord.model.MessageContent;

public interface MessageContentDao {
	public MessageContent getMessageContent(String uid);
	public int add(MessageContent mc);
	public void update(MessageContent mc);
}
