package com.yzx.messagelord.service;

import java.util.List;

import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.model.UploadContactNumberGroup;

public interface CommercialUploadNumberService {
	public void uploadNumber(String title, String[] numbers, CommercialUser user);
	public void uploadNumber(String title, String[] numbers, CommercialUser user, String groupId);
	public List<UploadContactNumberGroup> groupList(CommercialUser user, int beginIndex, int amount);
	public void deleteGroup(String goupId);
	public UploadContactNumberGroup getGroupById(String groupId);
}
