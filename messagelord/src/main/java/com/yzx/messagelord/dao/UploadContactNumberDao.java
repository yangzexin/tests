package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.UploadContactNumber;
import com.yzx.messagelord.model.UploadContactNumberGroup;

public interface UploadContactNumberDao {
	public void add(UploadContactNumber num);
	public void update(UploadContactNumber num);
	public void remove(UploadContactNumber num);
	public void removeByGroup(UploadContactNumberGroup group);
	public List<UploadContactNumber> list(int beginIndex, int endIndex);
	public List<UploadContactNumber> list(int beginIndex, int endIndex, String commercialUserId);
	public long count();
	public long count(String commercialUserId);
	public long countByGroupId(String groupId);
}
