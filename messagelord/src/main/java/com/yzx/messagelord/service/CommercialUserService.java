package com.yzx.messagelord.service;

import com.yzx.messagelord.model.CommercialUser;

public interface CommercialUserService {
	public CommercialUser login(CommercialUser user);
	public boolean register(CommercialUser user);
}
