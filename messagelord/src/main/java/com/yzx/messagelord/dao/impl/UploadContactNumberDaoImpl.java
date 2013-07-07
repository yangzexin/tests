package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.UploadContactNumberDao;
import com.yzx.messagelord.model.UploadContactNumber;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class UploadContactNumberDaoImpl extends JdbcTemplateSupport implements UploadContactNumberDao {

	public void createTableIfNotExists(){
		Map<String, String> keyFieldValueAttr = new HashMap<String, String>();
		keyFieldValueAttr.put("uid", "bigint primary key auto_increment");
		keyFieldValueAttr.put("destinationNumber", "text");
		keyFieldValueAttr.put("commercialUserId", "integer");
		keyFieldValueAttr.put("imessageUser", "boolean");
		
		this.getJdbcTemplate().execute(this.sqlForCreateTable("upload_contact_number", keyFieldValueAttr));
	}
	
	@Override
	public void add(UploadContactNumber num) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("insert into upload_contact_number(destinationNumber, commercialUserId, imessageUser) values(?,?,?)", 
				num.getDestinationNumber(), num.getCommercialUserId(), num.isImessageUser());
	}

	@Override
	public void update(UploadContactNumber num) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("update upload_contact_number set destinationNumber=?, commercialUserId=?, imessageUser=? where uid=?", 
				num.getDestinationNumber(), num.getCommercialUserId(), num.isImessageUser(), num.getUid());
	}

	@Override
	public void remove(UploadContactNumber num) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from upload_contact_number where uid=?", num.getUid());
	}

	private static void processUploadContactNumber(ResultSet rs, UploadContactNumber num) throws SQLException{
		num.setUid(rs.getString("uid"));
		num.setCommercialUserId(rs.getString("commercialUserId"));
		num.setDestinationNumber(rs.getString("destinationNumber"));
		num.setImessageUser(rs.getBoolean("imessageUser"));
	}
	
	@Override
	public List<UploadContactNumber> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<UploadContactNumber> list = new ArrayList<UploadContactNumber>();
		this.getJdbcTemplate().query("select * from upload_contact_number limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				UploadContactNumber num = new UploadContactNumber();
				processUploadContactNumber(rs, num);
				list.add(num);
			}
		}, beginIndex, endIndex - beginIndex);
		return list;
	}

	@Override
	public List<UploadContactNumber> list(int beginIndex, int endIndex,
			String commercialUserId) {
		// TODO Auto-generated method stub
		final ArrayList<UploadContactNumber> list = new ArrayList<UploadContactNumber>();
		this.getJdbcTemplate().query("select * from upload_contact_number where commercialUserId=? limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				UploadContactNumber num = new UploadContactNumber();
				processUploadContactNumber(rs, num);
				list.add(num);
			}
		}, commercialUserId, beginIndex, endIndex - beginIndex);
		return list;
	}

	@Override
	public long count() {
		// TODO Auto-generated method stub
		Long count = this.getJdbcTemplate().queryForObject("select count(uid) from upload_contact_number", Long.class);
		return count.longValue();
	}

	@Override
	public long count(String commercialUserId) {
		// TODO Auto-generated method stub
		Long count = this.getJdbcTemplate().queryForObject("select count(uid) from upload_contact_number where commercialUserId=?", Long.class, commercialUserId);
		return count.longValue();
	}

}
