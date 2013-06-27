package com.yzx.messagelord.util;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class SharedContext implements ApplicationContextAware {
	private static ApplicationContext ctx = null;

	private static ArrayList<String> blockedIpList;
	
	public static ApplicationContext getApplicationContext(){
		return ctx;
	}
	
	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		// TODO Auto-generated method stub
		ctx = context;
	}
	
	public synchronized static void addBlockedIp(String ip){
		if(blockedIpList == null){
			blockedIpList = new ArrayList<String>();
		}
		blockedIpList.add(ip);
	}
	
	public static List<String> blockedIpList(){
		return blockedIpList;
	}
	
	public synchronized static void removeBlockedIp(String ip){
		if(blockedIpList == null){
			blockedIpList = new ArrayList<String>();
		}
		blockedIpList.remove(ip);
	}
	
}
