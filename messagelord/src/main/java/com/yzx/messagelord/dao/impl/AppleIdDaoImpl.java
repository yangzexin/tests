package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.AppleIdDao;
import com.yzx.messagelord.model.AppleId;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class AppleIdDaoImpl extends JdbcTemplateSupport implements AppleIdDao {

	public void createTableIfNotExists(){
		String createTableSql = "create table if not exists appleids(uid INTEGER PRIMARY KEY AUTO_INCREMENT, " +
				"appleID TEXT, " +
				"password TEXT, " +
				"sendTotal INTEGER," +
				"lastUseTime TEXT, " + 
				"state INTEGER)engine=innodb default charset=utf8";
		this.getJdbcTemplate().update(createTableSql);
	}
	
	public void add(AppleId appleId) {
		// TODO Auto-generated method stub
		String sql = "insert into appleids(appleID, password, state) values(?, ?, ?)";
		appleId.setState(AppleId.STATE_UNUSED);
		this.getJdbcTemplate().update(sql, appleId.getAppleID(), appleId.getPassword(), appleId.getState());
	}

	public boolean exists(AppleId appleId){
		String sql = "select count(uid) from appleids where appleID=?";
		Object[] args = {appleId.getAppleID()};
		Integer n = this.getJdbcTemplate().queryForObject(sql, args, Integer.class);
		return n.intValue() != 0;
	}
	
	public void update(AppleId appleId) {
		// TODO Auto-generated method stub
		String sql = "update appleids set appleID=?, password=?, state=?, sendTotal=?, lastUseTime=? where uid=?";
		this.getJdbcTemplate().update(sql, appleId.getAppleID(), appleId.getPassword(), 
				appleId.getState(), appleId.getSendTotal(), appleId.getLastUseTime(), appleId.getUid());
	}

	public void remove(AppleId appleId) {
		// TODO Auto-generated method stub
		String sql = "delete from appleids where uid=?";
		this.getJdbcTemplate().update(sql, appleId.getUid());
	}

	public AppleId getUnused() {
		// TODO Auto-generated method stub
		String sql = "select * from appleids where state=? limit 0, 1";
		final AppleId tmp = new AppleId();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				AppleIdDaoImpl.processRow(rs, tmp);
			}}, AppleId.STATE_UNUSED);
		tmp.setState(AppleId.STATE_USING);
		if(tmp.getUid() != null){
			this.update(tmp);
			return tmp;			
		}
		return null;
	}
	
	private static void processRow(ResultSet rs, AppleId tmp) throws SQLException{
		tmp.setUid(rs.getString("uid"));
		tmp.setAppleID(rs.getString("appleID"));
		tmp.setPassword(rs.getString("password"));
		tmp.setSendTotal(rs.getInt("sendTotal"));
		tmp.setState(rs.getInt("state"));
		tmp.setLastUseTime(rs.getString("lastUseTime"));
	}

	public AppleId getAppleID(String uid) {
		// TODO Auto-generated method stub
		String sql = "select * from appleids where uid=?";
		final AppleId tmpAppleID = new AppleId();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				AppleIdDaoImpl.processRow(rs, tmpAppleID);
			}}, uid);
		if(tmpAppleID.getUid() != null){
			return tmpAppleID;
		}
		return null;
	}

	@Override
	public List<AppleId> getAllAppleID() {
		// TODO Auto-generated method stub
		String sql = "select * from appleids";
		final ArrayList<AppleId> list = new ArrayList<AppleId>();
		this.getJdbcTemplate().query(sql, new RowCallbackHandler(){

			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				AppleId tmp = new AppleId();
				AppleIdDaoImpl.processRow(arg0, tmp);
				list.add(tmp);
			}});
		return list;
	}

}
