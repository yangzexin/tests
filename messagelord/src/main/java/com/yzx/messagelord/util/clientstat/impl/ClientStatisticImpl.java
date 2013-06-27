package com.yzx.messagelord.util.clientstat.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.yzx.messagelord.util.clientstat.ClientStatInfo;
import com.yzx.messagelord.util.clientstat.ClientStatistic;

public class ClientStatisticImpl implements ClientStatistic {

	private Map<String, ClientStatInfo> keyIpAddressValueClientStatInfo;
	
	public void init(){
		keyIpAddressValueClientStatInfo = new HashMap<String, ClientStatInfo>();
	}
	
	@Override
	public List<ClientStatInfo> clients() {
		// TODO Auto-generated method stub
		ArrayList<ClientStatInfo> list = new ArrayList<ClientStatInfo>();
		Iterator<Entry<String, ClientStatInfo>> itr = keyIpAddressValueClientStatInfo.entrySet().iterator();
		while(itr.hasNext()){
			list.add(itr.next().getValue());
		}
		return list;
	}

	@Override
	public synchronized void markResult(String ipAddress) {
		// TODO Auto-generated method stub
		if(!keyIpAddressValueClientStatInfo.containsKey(ipAddress)){
			ClientStatInfo cs = new ClientStatInfo();
			cs.setIpAddress(ipAddress);
			cs.setCount(1);
			cs.setSuccessCount(0);
			cs.setLastRequestTime(System.currentTimeMillis());
			cs.setFirstRequestTime(System.currentTimeMillis());
			keyIpAddressValueClientStatInfo.put(cs.getIpAddress(), cs);
		}else{
			ClientStatInfo cs = keyIpAddressValueClientStatInfo.get(ipAddress);
			cs.setCount(cs.getCount() + 1);
			cs.setLastRequestTime(System.currentTimeMillis());
		}
	}

	@Override
	public synchronized void removeClient(ClientStatistic cs) {
		// TODO Auto-generated method stub
	}

	@Override
	public synchronized void markSuccess(String ipAddress) {
		// TODO Auto-generated method stub
		ClientStatInfo cs = keyIpAddressValueClientStatInfo.get(ipAddress);
		cs.setSuccessCount(cs.getSuccessCount() + 1);
	}

	@Override
	public void clear(String ipAddress) {
		// TODO Auto-generated method stub
		ClientStatInfo cs = keyIpAddressValueClientStatInfo.get(ipAddress);
		if(cs != null){
			cs.setCount(0);
			cs.setSuccessCount(0);
			cs.setFirstRequestTime(System.currentTimeMillis());
		}
	}

}
