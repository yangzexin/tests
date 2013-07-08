package com.yzx.messagelord.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowCallbackHandler;

import com.yzx.messagelord.dao.MessageTaskGroupDao;
import com.yzx.messagelord.model.MessageTaskGroup;
import com.yzx.messagelord.util.JdbcTemplateSupport;

public class MessageTaskGroupDaoImpl extends JdbcTemplateSupport implements MessageTaskGroupDao {

	public void createTableIfNotExists(){
		Map<String, String> keyFieldValueAttribute = new HashMap<String, String>();
		keyFieldValueAttribute.put("uid", "integer primary key auto_increment");
		keyFieldValueAttribute.put("addDate", "bigint");
		keyFieldValueAttribute.put("title", "text");
		keyFieldValueAttribute.put("numberOfTasks", "bigint");
		keyFieldValueAttribute.put("messageContentId", "integer");
		keyFieldValueAttribute.put("commercialUserId", "integer");
		this.getJdbcTemplate().execute(this.sqlForCreateTable("message_task_groups", keyFieldValueAttribute));
	}
	
	@Override
	public void add(MessageTaskGroup group) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("insert into message_task_groups(addDate, title, numberOfTasks, messageContentId, commercialUserId) values(?, ?, ?, ?, ?)", 
				group.getAddDate(), group.getTitle(), group.getNumberOfTasks(), group.getMessageContentId(), group.getCommercialUserId());
	}

	@Override
	public void remove(MessageTaskGroup group) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("delete from message_task_groups where uid=?", group.getUid());
	}

	@Override
	public void update(MessageTaskGroup group) {
		// TODO Auto-generated method stub
		this.getJdbcTemplate().update("update message_task_groups set title=?, numberOfTasks=?, messageContentId=? where uid=?", 
				group.getTitle(), group.getNumberOfTasks(), group.getMessageContentId(), group.getUid());
	}

	private static void processMessageGroup(ResultSet rs, MessageTaskGroup tmp) throws SQLException{
		tmp.setUid(rs.getString("uid"));
		tmp.setAddDate(rs.getLong("addDate"));
		tmp.setCommercialUserId(rs.getString("commercialUserId"));
		tmp.setMessageContentId(rs.getString("messageContentId"));
		tmp.setNumberOfTasks(rs.getLong("numberOfTasks"));
		tmp.setTitle(rs.getString("title"));		
	}
	
	@Override
	public List<MessageTaskGroup> list(int beginIndex, int endIndex) {
		// TODO Auto-generated method stub
		final ArrayList<MessageTaskGroup> list = new ArrayList<MessageTaskGroup>();
		this.getJdbcTemplate().query("select * from message_task_groups limit ?, ?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageTaskGroup group = new MessageTaskGroup();
				processMessageGroup(rs, group);
				list.add(group);
			}
		}, beginIndex, endIndex);
		return list;
	}

	@Override
	public List<MessageTaskGroup> list(int beginIndex, int endIndex,
			String commercialUserId) {
		// TODO Auto-generated method stub
		final ArrayList<MessageTaskGroup> list = new ArrayList<MessageTaskGroup>();
		this.getJdbcTemplate().query("select * from message_task_groups where commercialUserId=? limit ?, ?", new RowCallbackHandler() {
			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				// TODO Auto-generated method stub
				MessageTaskGroup group = new MessageTaskGroup();
				processMessageGroup(rs, group);
				list.add(group);
			}
		}, commercialUserId, beginIndex, endIndex);
		return list;
	}

}
