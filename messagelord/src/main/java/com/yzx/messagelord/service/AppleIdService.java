package com.yzx.messagelord.service;

import java.util.List;

import com.yzx.messagelord.model.AppleId;

public interface AppleIdService {
	public void add(AppleId newAppleId);
	public void remove(AppleId appleId);
	public void update(AppleId appleId);
	public AppleId getUnused();
	public List<AppleId> getAllAppleID();
	public AppleId getAppleID(String uid);
}
