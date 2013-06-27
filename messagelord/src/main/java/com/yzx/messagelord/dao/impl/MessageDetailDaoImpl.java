package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.MessageDetailDao;
import com.yzx.messagelord.model.MessageDetail;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class MessageDetailDaoImpl extends JdbcTemplateSupport implements MessageDetailDao {
	
	public MessageDetailDaoImpl(){
		super();
	}
	
	public void createTableIfNotExists(){
		String createTableSql = "create table if not exists messages(uid INTEGER PRIMARY KEY AUTO_INCREMENT, " +
				"destinationNumber TEXT, " +
				"messageContent TEXT, " +
				"postedAppleID TEXT," +
				"distributeDate TEXT," + 
				"state INTEGER)engine=innodb default charset=utf8";
		this.getJdbcTemplate().update(createTableSql);
	}
	
	public void add(MessageDetail message) {
		// TODO Auto-generated method stub
		message.setState(MessageDetail.STATE_UNPOSTED);
		String sql = "insert into messages(destinationNumber,messageContent,state) values(?,?,?)";
		this.getJdbcTemplate().update(sql, message.getDestinationNumber(), message.getMessageContent(), message.getState());
	}

	public void update(MessageDetail message) {
		// TODO Auto-generated method stub
		String sql = "update messages set state=?, postedAppleID=?, distributeDate=? where uid=?";
		this.getJdbcTemplate().update(sql, message.getState(), message.getPostedAppleID(), message.getDistributeDate(), message.getUid());
	}

	public void remove(MessageDetail message) {
		// TODO Auto-generated method stub
		String sql = "delete from messages where uid=?";
		this.getJdbcTemplate().update(sql, message.getUid());
	}

	public static void processMessageDetail(ResultSet rs, MessageDetail tmp) throws SQLException{
		tmp.setUid(rs.getString("uid"));
		tmp.setDestinationNumber(rs.getString("destinationNumber"));
		tmp.setMessageContent(rs.getString("messageContent"));
		tmp.setState(rs.getInt("state"));
		tmp.setDistributeDate(rs.getString("distributeDate"));
	}
	
	public List<MessageDetail> distribute(int size) {
		// TODO Auto-generated method stub
		final ArrayList<MessageDetail> list = new ArrayList<MessageDetail>();
		String sql = "select * from messages where state=? limit 0,?";
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageDetail tmp = new MessageDetail();
				processMessageDetail(rs, tmp);
				list.add(tmp);
			}}, MessageDetail.STATE_UNPOSTED, size);
		
		for(MessageDetail tmp : list){
			tmp.setState(MessageDetail.STATE_DISTRIBUTED);
			tmp.setDistributeDate("" + System.currentTimeMillis());
			this.update(tmp);
		}
		return list;
	}
	
	public List<MessageDetail> distributedList() {
		// TODO Auto-generated method stub
		final ArrayList<MessageDetail> list = new ArrayList<MessageDetail>();
		String sql = "select * from messages where state=?";
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageDetail tmp = new MessageDetail();
				processMessageDetail(rs, tmp);
				list.add(tmp);
			}}, MessageDetail.STATE_DISTRIBUTED);
		return list;
	}
}
