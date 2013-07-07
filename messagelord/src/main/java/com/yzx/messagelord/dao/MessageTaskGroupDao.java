package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.MessageTaskGroup;

public interface MessageTaskGroupDao {
	public void add(MessageTaskGroup group);
	public void remove(MessageTaskGroup group);
	public void update(MessageTaskGroup group);
	public List<MessageTaskGroup> list(int beginIndex, int endIndex);
	public List<MessageTaskGroup> list(int beginIndex, int endIndex, String commercialUserId);
}
