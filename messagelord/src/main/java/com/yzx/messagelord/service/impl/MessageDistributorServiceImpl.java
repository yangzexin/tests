package com.yzx.messagelord.service.impl;

import java.util.List;

import com.yzx.messagelord.dao.MessageContentDao;
import com.yzx.messagelord.dao.MessageDetailDao;
import com.yzx.messagelord.model.MessageContent;
import com.yzx.messagelord.model.MessageDetail;
import com.yzx.messagelord.service.MessageDistributorService;

public class MessageDistributorServiceImpl implements MessageDistributorService {

	private MessageDetailDao messageDAO;
	private MessageContentDao messageContentDAO;
	
	public List<MessageDetail> getUnpostedMessage(int size) {
		// TODO Auto-generated method stub
		List<MessageDetail> list = messageDAO.distribute(size);
		for(MessageDetail tmpMsg : list){
			MessageContent mc = this.messageContentDAO.getMessageContent(tmpMsg.getMessageContent());
			
			if(mc != null){
				tmpMsg.setMessageContent(mc.getContent());
			}
		}
		return list;
	}

	public void markPosted(List<MessageDetail> messageDetailList) {
		// TODO Auto-generated method stub
		for(MessageDetail tmp : messageDetailList){
			tmp.setState(MessageDetail.STATE_POSTED);
			messageDAO.update(tmp);
		}
	}

	public void submitNewList(List<MessageDetail> messageDetailList, String messageContent) {
		// TODO Auto-generated method stub
		MessageContent mc = new MessageContent();
		mc.setContent(messageContent);
		String contentId = ""+ this.getMessageContentDAO().add(mc);
		for(MessageDetail tmp : messageDetailList){
			tmp.setMessageContent(contentId);
			messageDAO.add(tmp);
		}
	}

	public void markUnposted(List<MessageDetail> messageDetailList) {
		// TODO Auto-generated method stub
		for(MessageDetail tmp : messageDetailList){
			tmp.setState(MessageDetail.STATE_UNPOSTED);
			messageDAO.update(tmp);
		}
	}

	public MessageDetailDao getMessageDAO() {
		return messageDAO;
	}

	public void setMessageDAO(MessageDetailDao messageDAO) {
		this.messageDAO = messageDAO;
	}

	public MessageContentDao getMessageContentDAO() {
		return messageContentDAO;
	}

	public void setMessageContentDAO(MessageContentDao messageContentDAO) {
		this.messageContentDAO = messageContentDAO;
	}

	@Override
	public synchronized void restoreTimeoutedMessages() {
		// TODO Auto-generated method stub
		List<MessageDetail> messages = this.getMessageDAO().distributedList();
		final int seconds = 10;
		final long timeInterval = 1000 * 60L * seconds;
		for(MessageDetail md : messages){
			long distributeTime = 0;
			if(md.getDistributeDate() != null){
				distributeTime = Long.parseLong(md.getDistributeDate());
			}
			if(md.getDistributeDate() == null || System.currentTimeMillis() - distributeTime > timeInterval){
				md.setState(MessageDetail.STATE_UNPOSTED);
				System.out.println("restoring:" + md.getDestinationNumber());
				this.getMessageDAO().update(md);
			}
		}
	}
	
}
