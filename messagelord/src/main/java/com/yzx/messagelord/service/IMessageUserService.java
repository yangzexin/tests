package com.yzx.messagelord.service;

import java.util.List;

import com.yzx.messagelord.model.iMessageUser;

public interface IMessageUserService {
	public List<iMessageUser> distribute();
	public void mark(iMessageUser user);
}
