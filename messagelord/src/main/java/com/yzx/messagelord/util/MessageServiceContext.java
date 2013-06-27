package com.yzx.messagelord.util;

import java.util.Timer;
import java.util.TimerTask;

import com.yzx.messagelord.service.MessageDistributorService;

public class MessageServiceContext {
	private static boolean serviceStarted;
	private static Timer checkMessageTaskTimer;
	private static final long TIME_INTERVAL_CHECKING = 1000 * 20L;
	
	public synchronized static boolean isServiceStarted(){
		return serviceStarted;
	}
	
	public synchronized static void startService(){
		stopService();
		serviceStarted = true;
		checkMessageTaskTimer = new Timer();
		final MessageDistributorService msgDistributor = (MessageDistributorService)SharedContext.getApplicationContext().getBean("messageDistributorService");
		checkMessageTaskTimer.schedule(new TimerTask(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				System.out.println("checking");
				msgDistributor.restoreTimeoutedMessages();
			}}, TIME_INTERVAL_CHECKING, TIME_INTERVAL_CHECKING);
	}
	
	public synchronized static void stopService(){
		serviceStarted = false;
		if(checkMessageTaskTimer != null){
			checkMessageTaskTimer.cancel();
		}
	}
}
