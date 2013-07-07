package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.MessageTask;

public interface MessageTaskDao {
	public void add(MessageTask mt);
	public void remove(MessageTask mt);
	public void update(MessageTask mt);
	public List<MessageTask> distribute(int amount);
	public List<MessageTask> list(int beginIndex, int endIndex);
}
