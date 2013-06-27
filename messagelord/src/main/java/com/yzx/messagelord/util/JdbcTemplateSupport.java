package com.yzx.messagelord.util;

import org.springframework.jdbc.core.JdbcTemplate;

public class JdbcTemplateSupport {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
}
