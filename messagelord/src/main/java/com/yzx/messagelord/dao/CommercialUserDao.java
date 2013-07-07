package com.yzx.messagelord.dao;

import java.util.List;

import com.yzx.messagelord.model.CommercialUser;

public interface CommercialUserDao {
	public void add(CommercialUser user);
	public void remove(CommercialUser user);
	public void update(CommercialUser user);
	public CommercialUser getById(String uid);
	public CommercialUser getByUsername(String username);
	public List<CommercialUser> list(int beginIndex, int endIndex);
}
