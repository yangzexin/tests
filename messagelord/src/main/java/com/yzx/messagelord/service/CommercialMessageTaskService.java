package com.yzx.messagelord.service;

import java.util.List;

import com.yzx.messagelord.model.MessageTaskGroup;
import com.yzx.messagelord.model.UploadContactNumberGroup;

public interface CommercialMessageTaskService {
	public void createTask(List<UploadContactNumberGroup> numberGroup);
	public void startTask(MessageTaskGroup group);
	public void stopTask(MessageTaskGroup group);
}
