package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.AppleId;

public interface AppleIdDao {
	public void add(AppleId appleId);
	public void update(AppleId appleId);
	public void remove(AppleId appleId);
	public boolean exists(AppleId appleId);
	public AppleId getUnused();
	public AppleId getAppleID(String uid);
	public List<AppleId> getAllAppleID();
}
