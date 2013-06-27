package com.yzx.messagelord.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import com.yzx.messagelord.dao.MessageContentDao;
import com.yzx.messagelord.model.MessageContent;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class MessageContentDaoImpl extends JdbcTemplateSupport implements MessageContentDao {

	public void createTableIfNotExists(){
		String createTableSql = "create table if not exists messagecontents(uid INTEGER PRIMARY KEY AUTO_INCREMENT, " +
				"content TEXT)engine=innodb default charset=utf8";
		this.getJdbcTemplate().update(createTableSql);
	}
	
	@Override
	public MessageContent getMessageContent(String uid) {
		// TODO Auto-generated method stub
		String sql = "select * from messagecontents where uid=?";
		final MessageContent tmp = new MessageContent();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				tmp.setUid(rs.getString("uid"));
				tmp.setContent(rs.getString("content"));
			}}, uid);
		return tmp;
	}

	@Override
	public int add(final MessageContent mc) {
		// TODO Auto-generated method stub
		final String sql = "insert into messagecontents(content) values(?)";
		
		KeyHolder keyHolder = new GeneratedKeyHolder(); 
		this.getJdbcTemplate().update(new PreparedStatementCreator() {
			
			@Override
			public PreparedStatement createPreparedStatement(Connection con)
					throws SQLException {
				// TODO Auto-generated method stub
				PreparedStatement stat = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				stat.setString(1, mc.getContent());
				return stat;
			}
		}, keyHolder);
		return keyHolder.getKey().intValue();
	}

	@Override
	public void update(MessageContent mc) {
		// TODO Auto-generated method stub
		String sql = "update messagecontents set content=? where uid=?";
		this.getJdbcTemplate().update(sql, mc.getContent(), mc.getUid());
	}

}
