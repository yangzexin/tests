package com.yzx.messagelord.service.impl;

import java.util.List;

import org.springframework.util.StringUtils;

import com.yzx.messagelord.dao.UploadContactNumberDao;
import com.yzx.messagelord.dao.UploadContactNumberGroupDao;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.model.UploadContactNumber;
import com.yzx.messagelord.model.UploadContactNumberGroup;
import com.yzx.messagelord.service.CommercialUploadNumberService;

public class CommercialUploadNumberServiceImpl implements CommercialUploadNumberService {

	private UploadContactNumberDao uploadNumberDao;
	private UploadContactNumberGroupDao uploadNumberGroupDao;
	
	@Override
	public void uploadNumber(String title, String[] numbers, CommercialUser user) {
		// TODO Auto-generated method stub
		UploadContactNumberGroup group = new UploadContactNumberGroup();
		group.setCommercialUserId(user.getUid());
		group.setTitle(title);
		int groupId = this.uploadNumberGroupDao.add(group);
		group.setUid(String.valueOf(groupId));
		this.uploadNumber(numbers, group);
	}
	
	private void uploadNumber(String []numbers, UploadContactNumberGroup group){
		if(group == null){
			return;
		}
		for(String num : numbers){
			num = num.trim();
			if(!StringUtils.isEmpty(num)){
				UploadContactNumber number = new UploadContactNumber();
				number.setCommercialUserId(group.getCommercialUserId());
				number.setDestinationNumber(num);
				number.setGroupId(group.getUid());
				number.setImessageUser(false);
				this.uploadNumberDao.add(number);
			}
		}
	}

	@Override
	public void uploadNumber(String title, String[] numbers,
			CommercialUser user, String groupId) {
		// TODO Auto-generated method stub
		UploadContactNumberGroup group = this.getGroupById(groupId);
		this.uploadNumber(numbers, group);
	}

	public UploadContactNumberGroupDao getUploadNumberGroupDao() {
		return uploadNumberGroupDao;
	}

	public void setUploadNumberGroupDao(UploadContactNumberGroupDao uploadNumberGroupDao) {
		this.uploadNumberGroupDao = uploadNumberGroupDao;
	}

	public UploadContactNumberDao getUploadNumberDao() {
		return uploadNumberDao;
	}

	public void setUploadNumberDao(UploadContactNumberDao uploadNumberDao) {
		this.uploadNumberDao = uploadNumberDao;
	}

	@Override
	public List<UploadContactNumberGroup> groupList(CommercialUser user,
			int beginIndex, int amount) {
		// TODO Auto-generated method stub
		List<UploadContactNumberGroup> groupList = this.uploadNumberGroupDao.list(beginIndex, beginIndex + amount, user.getUid());
		for(UploadContactNumberGroup group : groupList){
			group.setNumberOfNumbers(this.uploadNumberDao.countByGroupId(group.getUid()));
		}
		return groupList;
	}

	@Override
	public void deleteGroup(String goupId) {
		// TODO Auto-generated method stub
		UploadContactNumberGroup group = new UploadContactNumberGroup();
		group.setUid(goupId);
		this.uploadNumberGroupDao.remove(group);
		this.uploadNumberDao.removeByGroup(group);
	}

	@Override
	public UploadContactNumberGroup getGroupById(String groupId) {
		// TODO Auto-generated method stub
		return this.uploadNumberGroupDao.getById(groupId);
	}

}
