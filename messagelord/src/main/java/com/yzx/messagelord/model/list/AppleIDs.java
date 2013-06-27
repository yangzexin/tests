package com.yzx.messagelord.model.list;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.yzx.messagelord.model.AppleId;

@XmlRootElement(name = "appleids")
public class AppleIDs {
	private List<AppleId> appleid;

	public List<AppleId> getAppleid() {
		return appleid;
	}

	public void setAppleid(List<AppleId> appleid) {
		this.appleid = appleid;
	}
}
