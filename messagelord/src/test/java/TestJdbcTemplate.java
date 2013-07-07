import java.util.HashMap;
import java.util.Map;

import com.yzx.messagelord.util.JdbcTemplateSupport;


public class TestJdbcTemplate {
	public static void main(String[] args){
		JdbcTemplateSupport jts = new JdbcTemplateSupport();
		Map<String, String> map = new HashMap<String, String>();
		map.put("uid", "integer primary key auto_increment");
		map.put("username", "text");
		map.put("numberOfSendedMessage", "bigint");
		System.out.println(jts.sqlForCreateTable("test", map));
	}
}
