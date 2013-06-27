package com.yzx.messagelord.util.clientstat;

import java.util.List;

public interface ClientStatistic {
	public List<ClientStatInfo> clients();
	public void markResult(String ipAddress);
	public void markSuccess(String ipAddress);
	public void removeClient(ClientStatistic cs);
	public void clear(String ipAddress);
}
