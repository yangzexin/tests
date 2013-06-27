package com.yzx.messagelord.service.impl;

import java.util.List;

import com.yzx.messagelord.dao.AppleIdDao;
import com.yzx.messagelord.model.AppleId;
import com.yzx.messagelord.service.AppleIdService;

public class AppleIdServiceImpl implements AppleIdService {

	private AppleIdDao appleIdDAO;
	
	public void add(AppleId newAppleId) {
		// TODO Auto-generated method stub
		appleIdDAO.add(newAppleId);
	}

	public void remove(AppleId appleId) {
		// TODO Auto-generated method stub
		appleIdDAO.remove(appleId);
	}

	public void update(AppleId appleId) {
		// TODO Auto-generated method stub
		appleIdDAO.update(appleId);
	}

	public AppleId getUnused() {
		// TODO Auto-generated method stub
		AppleId id = appleIdDAO.getUnused();
		id.setState(AppleId.STATE_USING);
		appleIdDAO.update(id);
		return id;
	}

	public AppleIdDao getAppleIdDAO() {
		return appleIdDAO;
	}

	public void setAppleIdDAO(AppleIdDao appleIdDAO) {
		this.appleIdDAO = appleIdDAO;
	}

	@Override
	public List<AppleId> getAllAppleID() {
		// TODO Auto-generated method stub
		return this.appleIdDAO.getAllAppleID();
	}

	@Override
	public AppleId getAppleID(String uid) {
		// TODO Auto-generated method stub
		return this.appleIdDAO.getAppleID(uid);
	}
	
}
