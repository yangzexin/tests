package com.yzx.messagelord.model.list;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.yzx.messagelord.model.MessageDetail;

@XmlRootElement(name = "messages")
public class MessageDetails {
	private List<MessageDetail> message;

	public List<MessageDetail> getMessage() {
		return message;
	}

	public void setMessage(List<MessageDetail> list) {
		this.message = list;
	}
}
