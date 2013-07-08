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

import com.yzx.messagelord.dao.UploadContactNumberGroupDao;
import com.yzx.messagelord.model.UploadContactNumberGroup;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class UploadContactNumberGroupDaoImpl extends JdbcTemplateSupport implements UploadContactNumberGroupDao {

	public void createTableIfNotExists(){
		Map<String, String> keyFieldValueAttr = new HashMap<String, String>();
		keyFieldValueAttr.put("uid", "integer primary key auto_increment");
		keyFieldValueAttr.put("title", "text");
		keyFieldValueAttr.put("commercialUserId", "integer");
		
		this.getJdbcTemplate().execute(this.sqlForCreateTable("upload_contact_number_group", keyFieldValueAttr));
	}
	
	@Override
	public int add(final UploadContactNumberGroup group) {
		// TODO Auto-generated method stub
		KeyHolder keyHolder = new GeneratedKeyHolder(); 
		this.getJdbcTemplate().update(new PreparedStatementCreator(){

			@Override
			public PreparedStatement createPreparedStatement(Connection arg0)
					throws SQLException {
				// TODO Auto-generated method stub
				PreparedStatement stmt = arg0.prepareStatement("insert into upload_contact_number_group(title, commercialUserId) values(?, ?)", Statement.RETURN_GENERATED_KEYS);
				stmt.setString(1, group.getTitle());
				stmt.setString(2, group.getCommercialUserId());
				return stmt;
			}}, keyHolder);
		return keyHolder.getKey().intValue();
	}

	@Override
	public void remove(UploadContactNumberGroup group) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from upload_contact_number_group where uid=?", group.getUid());
	}

	@Override
	public void update(UploadContactNumberGroup group) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("update upload_contact_number_group set title=? where uid=?", group.getTitle(), group.getUid());
	}

	private static void processUploadContactNumberGroup(ResultSet rs, UploadContactNumberGroup group) throws SQLException{
		group.setUid(rs.getString("uid"));
		group.setTitle(rs.getString("title"));
		group.setCommercialUserId(rs.getString("commercialUserId"));
	}
	
	@Override
	public List<UploadContactNumberGroup> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<UploadContactNumberGroup> list = new ArrayList<UploadContactNumberGroup>();
		this.getJdbcTemplate().query("select * from upload_contact_number_group limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				UploadContactNumberGroup group = new UploadContactNumberGroup();
				processUploadContactNumberGroup(arg0, group);
				list.add(group);
			}
		}, beginIndex, endIndex - beginIndex);
		return list;
	}

	@Override
	public List<UploadContactNumberGroup> list(int beginIndex, int endIndex,
			String commercialUserId) {
		// TODO Auto-generated method stub
		final ArrayList<UploadContactNumberGroup> list = new ArrayList<UploadContactNumberGroup>();
		this.getJdbcTemplate().query("select * from upload_contact_number_group where commercialUserId=? limit ?,?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				UploadContactNumberGroup group = new UploadContactNumberGroup();
				processUploadContactNumberGroup(arg0, group);
				list.add(group);
			}
		}, commercialUserId, beginIndex, endIndex - beginIndex);
		return list;
	}

	@Override
	public UploadContactNumberGroup getById(String uid) {
		// TODO Auto-generated method stub
		final UploadContactNumberGroup group = new UploadContactNumberGroup();
		this.getJdbcTemplate().query("select * from upload_contact_number_group where uid=?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet arg0) throws SQLException {
				// TODO Auto-generated method stub
				processUploadContactNumberGroup(arg0, group);
			}
		}, uid);
		return group.getUid() == null ? null : group;
	}

}
