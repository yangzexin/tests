package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.MessageTaskDao;
import com.yzx.messagelord.model.MessageTask;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class MessageTaskDaoImpl extends JdbcTemplateSupport implements MessageTaskDao {

	public void createTableIfNotExists(){
		Map<String, String> keyFieldValueAttribute = new HashMap<String, String>();
		keyFieldValueAttribute.put("uid", "bigint primary key auto_increment");
		keyFieldValueAttribute.put("groupId", "integer");
		keyFieldValueAttribute.put("destinationNumber", "text");
		keyFieldValueAttribute.put("deliverDate", "bigint");
		keyFieldValueAttribute.put("state", "integer");
		keyFieldValueAttribute.put("distributeDate", "bigint");
		keyFieldValueAttribute.put("appleIdOfHandler", "text");
		
		this.getJdbcTemplate().execute(this.sqlForCreateTable("message_tasks", keyFieldValueAttribute));
	}
	
	@Override
	public void add(MessageTask mt) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("insert into message_tasks(groupId, destinationNumber, state) values(?,?,?)", 
				mt.getGroupId(), mt.getDestinationNumber(), mt.getState());
	}

	@Override
	public void remove(MessageTask mt) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from message_tasks where uid=?", mt.getUid());
	}

	@Override
	public void update(MessageTask mt) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("update message_tasks set destinationNumber=?, deliverDate=?, state=?, distributeDate=?, appleIdOfHandler=? where uid=?", 
				mt.getDestinationNumber(), mt.getDeliverDate(), mt.getState(), mt.getDistributeDate(), mt.getAppleIdOfHandler(), mt.getUid());
	}

	private static void processMessageTask(ResultSet rs, MessageTask mt) throws SQLException{
		mt.setAppleIdOfHandler(rs.getString("appleIdOfHandler"));
		mt.setDeliverDate(rs.getLong("deliverDate"));
		mt.setDestinationNumber(rs.getString("destinationNumber"));
		mt.setDistributeDate(rs.getLong("distributeDate"));
		mt.setGroupId(rs.getString("groupId"));
		mt.setState(rs.getInt("state"));
		mt.setUid(rs.getString("uid"));
	}
	
	private synchronized void restoreState(){
		final ArrayList<MessageTask> list = new ArrayList<MessageTask>();
		System.out.println("start restore message task state");
		int minute = 1;
		long dateTime = System.currentTimeMillis() - minute * 60 * 1000;
		this.getJdbcTemplate().query("select * from message_tasks where state=? and distributeDate<?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageTask task = new MessageTask();
				processMessageTask(rs, task);
				list.add(task);
			}
		}, MessageTask.STATE_DISTRIBUTED, dateTime);
		
		if(!list.isEmpty()){
			for(MessageTask task : list){
				task.setState(MessageTask.STATE_UNHANDLED);
				this.update(task);
				System.out.println(task.getUid() + ", " + task.getDestinationNumber() + ", " + task.getGroupId());
			}
		}
		System.out.println("finish restore message task state");
	}
	
	@Override
	public List<MessageTask> distribute(int amount) {
		// TODO Auto-generated method stub
		this.restoreState();
		final ArrayList<MessageTask> list = new ArrayList<MessageTask>();
		this.getJdbcTemplate().query("select * from message_tasks where state=? limit 0, ?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageTask task = new MessageTask();
				processMessageTask(rs, task);
				list.add(task);
			}
		}, MessageTask.STATE_UNHANDLED, amount);
		for(MessageTask tmp : list){
			tmp.setState(MessageTask.STATE_DISTRIBUTED);
			tmp.setDistributeDate(System.currentTimeMillis());
			this.update(tmp);
		}
		
		return list;
	}

	@Override
	public List<MessageTask> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<MessageTask> list = new ArrayList<MessageTask>();
		this.getJdbcTemplate().query("select * from message_tasks limit ?, ?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageTask task = new MessageTask();
				processMessageTask(rs, task);
				list.add(task);
			}
		}, beginIndex, endIndex - beginIndex);
		return list;
	}

}
