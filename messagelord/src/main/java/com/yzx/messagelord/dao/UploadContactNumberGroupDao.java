package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.UploadContactNumberGroup;

public interface UploadContactNumberGroupDao {
	public int add(UploadContactNumberGroup group);
	public void remove(UploadContactNumberGroup group);
	public void update(UploadContactNumberGroup group);
	public UploadContactNumberGroup getById(String uid);
	public List<UploadContactNumberGroup> list(int beginIndex, int endIndex);
	public List<UploadContactNumberGroup> list(int beginIndex, int endIndex, String commercialUserId); 
}
