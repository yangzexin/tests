import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.MessageContentDao;
import com.yzx.messagelord.model.MessageContent;


public class TestMessageContent {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		MessageContentDao dao = (MessageContentDao)context.getBean("messageContentDAO");
		MessageContent mc = new MessageContent();
		mc.setContent("testeste");
		System.out.println(dao.add(mc));
	}
}
