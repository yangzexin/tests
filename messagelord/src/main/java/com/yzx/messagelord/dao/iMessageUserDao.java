package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.iMessageUser;

public interface iMessageUserDao {
	public void add(iMessageUser user);
	public int count();
	public void update(iMessageUser user);
	public void mark(String uid, boolean registered);
	public iMessageUser getIMessageUser(String uid);
	public List<iMessageUser> listAll();
	public List<iMessageUser> list(int pageIndex, int pageSize);
	public List<iMessageUser> distribute(int size);
	public int numberOfImessageUsers();
	public int numberOfCheckedImessageUsers();
}
