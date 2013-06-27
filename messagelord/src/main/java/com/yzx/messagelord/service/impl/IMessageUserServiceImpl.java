package com.yzx.messagelord.service.impl;

import java.util.List;

import com.yzx.messagelord.dao.iMessageUserDao;
import com.yzx.messagelord.model.iMessageUser;
import com.yzx.messagelord.service.IMessageUserService;

public class IMessageUserServiceImpl implements IMessageUserService {

	private iMessageUserDao userDao; 
	
	@Override
	public List<iMessageUser> distribute() {
		// TODO Auto-generated method stub
		return this.userDao.distribute(10);
	}

	@Override
	public void mark(iMessageUser user) {
		// TODO Auto-generated method stub		
		this.userDao.mark(user.getUid(), user.isRegistered());
	}

	public iMessageUserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(iMessageUserDao userDao) {
		this.userDao = userDao;
	}

}
