package com.yzx.messagelord.model.list;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.yzx.messagelord.model.iMessageUser;

@XmlRootElement(name = "users")
public class IMessageUsers {
	private List<iMessageUser> user;

	public List<iMessageUser> getUser() {
		return user;
	}

	public void setUser(List<iMessageUser> users) {
		this.user = users;
	} 
}
