package com.yzx.messagelord.service.impl;

import com.yzx.messagelord.dao.CommercialUserDao;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.service.CommercialUserService;

public class CommercialUserServiceImpl implements CommercialUserService {

	private CommercialUserDao commercialUserDao;
	
	@Override
	public CommercialUser login(CommercialUser user) {
		// TODO Auto-generated method stub
		CommercialUser targetUser = this.commercialUserDao.getByUsername(user.getUsername());
		if(targetUser != null && targetUser.getPassword().equals(user.getPassword())){
			return targetUser;
		}
		return null;
	}

	@Override
	public boolean register(CommercialUser user) {
		// TODO Auto-generated method stub
		if(this.commercialUserDao.getByUsername(user.getUsername()) == null){
			this.commercialUserDao.add(user);
			return true;
		}
		
		return false;
	}

	public CommercialUserDao getCommercialUserDao() {
		return commercialUserDao;
	}

	public void setCommercialUserDao(CommercialUserDao commercialUserDao) {
		this.commercialUserDao = commercialUserDao;
	}

}
