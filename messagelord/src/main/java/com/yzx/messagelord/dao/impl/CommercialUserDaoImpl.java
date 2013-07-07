package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.CommercialUserDao;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class CommercialUserDaoImpl extends JdbcTemplateSupport implements CommercialUserDao {
	
	public void createTableIfNotExists(){
		Map<String, String> keyFeildValueAttribute = new HashMap<String, String>();
		keyFeildValueAttribute.put("uid", "integer PRIMARY KEY auto_increment");
		keyFeildValueAttribute.put("username", "TEXT");
		keyFeildValueAttribute.put("password", "TEXT");
		keyFeildValueAttribute.put("numberOfSendedMessage", "bigint");
		keyFeildValueAttribute.put("numberOfPurchasedMessage", "bigint");
		String sql = this.sqlForCreateTable("commercial_users", keyFeildValueAttribute);
		this.getJdbcTemplate().execute(sql);
	}
	
	@Override
	public void add(CommercialUser user) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("insert into commercial_users(username, password, numberOfSendedMessage, numberOfPurchasedMessage) values(?, ?, ?, ?)", 
				user.getUsername(), user.getPassword(), user.getNumberOfSendedMessage(), user.getNumberOfSendedMessage());
	}

	@Override
	public void remove(CommercialUser user) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from commercial_users where uid=?", user.getUid());
	}

	@Override
	public void update(CommercialUser user) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("update commercial_users set username=?, password=?, numberOfSendedMessage=?, numberOfPurchasedMessage=? where uid=?",  
				user.getUsername()
				,user.getPassword()
				,user.getNumberOfSendedMessage()
				,user.getNumberOfPurchasedMessage()
				,user.getUid());
	}
	
	private static void processCommercialUser(ResultSet rs, CommercialUser user) throws SQLException{
		user.setUid(rs.getString("uid"));
		user.setUsername(rs.getString("username"));
		user.setPassword(rs.getString("password"));
		user.setNumberOfSendedMessage(rs.getLong("numberOfSendedMessage"));
		user.setNumberOfPurchasedMessage(rs.getLong("numberOfPurchasedMessage"));
	}

	@Override
	public CommercialUser getById(String uid) {
		// TODO Auto-generated method stub
		final CommercialUser user = new CommercialUser();
		this.getJdbcTemplate().query("select * from commercial_users where uid=?", new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				processCommercialUser(arg0, user);
			}
			
		}, uid);

		return user.getUid() == null ? null : user;
	}

	@Override
	public List<CommercialUser> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<CommercialUser> list = new ArrayList<CommercialUser>();
		this.getJdbcTemplate().query("select * from commercial_users limit ?, ?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				CommercialUser user = new CommercialUser();
				processCommercialUser(arg0, user);
				list.add(user);
			}
		}, beginIndex, endIndex - beginIndex);
		return list;
	}

	@Override
	public CommercialUser getByUsername(String username) {
		// TODO Auto-generated method stub
		final CommercialUser user = new CommercialUser();
		this.getJdbcTemplate().query("select * from commercial_users where username=?", new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				processCommercialUser(arg0, user);
			}
			
		}, username);
		
		return user.getUid() == null ? null : user;
	}

}
