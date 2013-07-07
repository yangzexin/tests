package com.yzx.messagelord.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import com.yzx.messagelord.dao.MessageContentDao;
import com.yzx.messagelord.model.MessageContent;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class MessageContentDaoImpl extends JdbcTemplateSupport implements MessageContentDao {

	public void createTableIfNotExists(){
		Map<String, String> keyFieldValueAtrribute = new HashMap<String, String>();
		keyFieldValueAtrribute.put("uid", "INTEGER PRIMARY KEY AUTO_INCREMENT");
		keyFieldValueAtrribute.put("content", "text");
		keyFieldValueAtrribute.put("commercialUserId", "integer");
		keyFieldValueAtrribute.put("addDate", "bigint");
		this.getJdbcTemplate().update(this.sqlForCreateTable("message_contents", keyFieldValueAtrribute));
	}
	
	private static void processMessageContent(ResultSet rs, MessageContent tmp) throws SQLException{
		tmp.setUid(rs.getString("uid"));
		tmp.setContent(rs.getString("content"));
		tmp.setAddDate(rs.getLong("addDate"));
		tmp.setCommercialUserId(rs.getString("commercialUserId"));
	}
	
	@Override
	public MessageContent getMessageContent(String uid) {
		// TODO Auto-generated method stub
		String sql = "select * from message_contents where uid=?";
		final MessageContent tmp = new MessageContent();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				processMessageContent(rs, tmp);
			}}, uid);
		return tmp;
	}

	@Override
	public int add(final MessageContent mc) {
		// TODO Auto-generated method stub
		final String sql = "insert into message_contents(content, commercialUserId, addDate) values(?, ?, ?)";
		
		KeyHolder keyHolder = new GeneratedKeyHolder(); 
		this.getJdbcTemplate().update(new PreparedStatementCreator() {
			
			@Override
			public PreparedStatement createPreparedStatement(Connection con)
					throws SQLException {
				// TODO Auto-generated method stub
				PreparedStatement stat = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				stat.setString(1, mc.getContent());
				stat.setString(2, mc.getCommercialUserId());
				stat.setLong(3, System.currentTimeMillis());
				return stat;
			}
		}, keyHolder);
		return keyHolder.getKey().intValue();
	}

	@Override
	public void update(MessageContent mc) {
		// TODO Auto-generated method stub
		String sql = "update message_contents set content=?, commercialUserId=? where uid=?";
		this.getJdbcTemplate().update(sql, mc.getContent(), mc.getCommercialUserId(), mc.getUid());
	}

	@Override
	public void delete(MessageContent mc) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from message_contents where uid=?", mc.getUid());
	}

	@Override
	public List<MessageContent> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<MessageContent> list = new ArrayList<MessageContent>();
		this.getJdbcTemplate().query("select * from message_contents limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageContent mc = new MessageContent();
				list.add(mc);
				processMessageContent(rs, mc);
			}
		}, beginIndex, endIndex);
		return list;
	}

	@Override
	public List<MessageContent> list(int beginIndex, int endIndex,
			String commercialUserId) {
		// TODO Auto-generated method stub
		final ArrayList<MessageContent> list = new ArrayList<MessageContent>();
		this.getJdbcTemplate().query("select * from message_contents where commercialUserId=? limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageContent mc = new MessageContent();
				list.add(mc);
				processMessageContent(rs, mc);
			}
		}, commercialUserId, beginIndex, endIndex);
		return list;
	}

}
