package com.yzx.messagelord.util;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.JdbcTemplate;

public class JdbcTemplateSupport {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	public String sqlForCreateTable(String tableName, Map<String, String> keyFieldValueAttribute) throws IllegalArgumentException{
		if(keyFieldValueAttribute == null ||  keyFieldValueAttribute.isEmpty()){
			throw new IllegalArgumentException("key field value attribute map cannot be empty");
		}
		StringBuffer sb = new StringBuffer("create table if not exists " + tableName + "(\n");
		Set<String> keySet = keyFieldValueAttribute.keySet();
		Iterator<String> keyIterator = keySet.iterator();
		while(keyIterator.hasNext()){
			String field = keyIterator.next();
			sb.append("\t" + field + " " + keyFieldValueAttribute.get(field) + ",\n");
		}
		sb.delete(sb.length() - 2, sb.length() - 1);
		sb.append(")engine=innodb default charset=utf8;");
		
		return sb.toString();
	}
}
