package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.MessageDetail;

public interface MessageDetailDao {
	public void add(MessageDetail message);
	public void update(MessageDetail message);
	public void remove(MessageDetail message);
	public List<MessageDetail> distribute(int size);
	public List<MessageDetail> distributedList();
}
