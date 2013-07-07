package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.iMessageUserDao;
import com.yzx.messagelord.model.iMessageUser;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class iMessageUserDaoImpl extends JdbcTemplateSupport implements iMessageUserDao {

	public void createTableIfNotExists(){
		String sql = "create table if not exists imessage_users(uid integer PRIMARY KEY auto_increment " +
				", number TEXT" +
				", state integer" +
				", registered boolean" + 
				", distributedDate bigint" + 
				")engine=innodb default charset=utf8";
		this.getJdbcTemplate().execute(sql);
	}
	
	@Override
	public void add(iMessageUser user) {
		// TODO Auto-generated method stub
		String sql = "insert into imessage_users(number, state, registered) values(?, ?, ?)";
		this.getJdbcTemplate().update(sql, user.getNumber(), user.getState(), user.isRegistered());
	}

	@Override
	public int count() {
		// TODO Auto-generated method stub
		String sql = "select count(uid) from imessage_users";
		Integer count = this.getJdbcTemplate().queryForObject(sql, Integer.class);
		return count.intValue();
	}

	public static void processMessageUserRow(ResultSet rs, iMessageUser user) throws SQLException{
		user.setUid(rs.getString("uid"));
		user.setNumber(rs.getString("number"));
		user.setState(rs.getInt("state"));
		user.setDistributedDate(rs.getLong("distributedDate"));
		user.setRegistered(rs.getBoolean("registered"));
	}
	
	@Override
	public List<iMessageUser> listAll() {
		// TODO Auto-generated method stub
		final ArrayList<iMessageUser> list = new ArrayList<iMessageUser>();
		String sql = "select * from imessage_users";
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				iMessageUser user = new iMessageUser();
				processMessageUserRow(rs, user);
				list.add(user);
			}});
		return list;
	}

	@Override
	public void update(iMessageUser user) {
		// TODO Auto-generated method stub
		String sql = "update imessage_users set number=?, state=?, distributedDate=?, registered=? where uid=?";
		this.getJdbcTemplate().update(sql, user.getNumber(), user.getState(), user.getDistributedDate(), user.isRegistered(), user.getUid());
	}

	@Override
	public List<iMessageUser> list(int pageIndex, int pageSize) {
		// TODO Auto-generated method stub
		final ArrayList<iMessageUser> list = new ArrayList<iMessageUser>();
		String sql = "select * from imessage_users limit " + (pageIndex * pageSize) + ", " + pageSize;
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				iMessageUser user = new iMessageUser();
				processMessageUserRow(rs, user);
				list.add(user);
			}});
		return list;
	}

	private synchronized List<iMessageUser> getOutOfDateList(){
		int minute = 10;
		long dateTime = System.currentTimeMillis() - minute * 60 * 1000;
		String sql = "select * from imessage_users where state=" + iMessageUser.STATE_DISTRIBUTED 
				+ " and distributedDate < " + dateTime;
		final ArrayList<iMessageUser> list = new ArrayList<iMessageUser>();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				iMessageUser user = new iMessageUser();
				processMessageUserRow(rs, user);
				list.add(user);
			}});
		return list;
	}
	
	@Override
	public synchronized List<iMessageUser> distribute(int size) {
		// TODO Auto-generated method stub
		List<iMessageUser> outOfDateList = this.getOutOfDateList();
		System.out.println(new Date() + "\tstart restore imessage users");
		for(iMessageUser user : outOfDateList){
			System.out.println("restore state of number:" + user.getNumber() + ", " + user.getUid());
			user.setState(iMessageUser.STATE_UNHANDLED);
			this.update(user);
		}
		System.out.println(new Date() + "\tfinish restore imessage users" + "\n");
		
		final ArrayList<iMessageUser> list = new ArrayList<iMessageUser>();
		String sql = "select * from imessage_users where state=" 
				+ iMessageUser.STATE_UNHANDLED + " limit 0," + size;
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				iMessageUser user = new iMessageUser();
				processMessageUserRow(rs, user);
				list.add(user);
			}});
		for(iMessageUser user : list){
			user.setState(iMessageUser.STATE_DISTRIBUTED);
			user.setDistributedDate(System.currentTimeMillis());
			this.update(user);
		}
		return list;
	}

	@Override
	public iMessageUser getIMessageUser(String uid) {
		// TODO Auto-generated method stub
		final iMessageUser user = new iMessageUser();
		String sql = "select * from imessage_users where uid=?";
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				processMessageUserRow(rs, user);
			}
			
		}, uid);
		return user;
	}

	@Override
	public void mark(String uid, boolean registered) {
		// TODO Auto-generated method stub
		String sql = "update imessage_users set registered=?, state=? where uid=?";
		this.getJdbcTemplate().update(sql, registered, iMessageUser.STATE_PROBED, uid);
	}

	@Override
	public int numberOfImessageUsers() {
		// TODO Auto-generated method stub
		String sql = "select count(uid) from imessage_users where registered=1";
		Integer count = this.getJdbcTemplate().queryForObject(sql, Integer.class);
		return count.intValue();
	}

	@Override
	public int numberOfCheckedImessageUsers() {
		// TODO Auto-generated method stub
		String sql = "select count(uid) from imessage_users where state=" + iMessageUser.STATE_PROBED;
		Integer count = this.getJdbcTemplate().queryForObject(sql, Integer.class);
		return count.intValue();
	}
	
}
