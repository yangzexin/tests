import java.util.List;

import org.aspectj.bridge.Message;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.MessageContentDao;
import com.yzx.messagelord.model.MessageContent;


public class TestMessageContentDao {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		MessageContentDao dao = (MessageContentDao)context.getBean("messageContentDAO");
		MessageContent mc = new MessageContent();
		mc.setContent("testeste");
		mc.setCommercialUserId("1222");
		System.out.println(dao.add(mc));
		
		mc.setUid("1");
		mc.setCommercialUserId("1333");
		mc.setContent("contennte");
//		dao.update(mc);
		
		MessageContent m = dao.getMessageContent("2");
		System.out.println(m.getUid() + ", " + m.getContent() + ", " + m.getCommercialUserId() + ", " + m.getAddDate());
		List<MessageContent> list = dao.list(0, 10);
		for(MessageContent tmp : list){
			System.out.println(tmp.getUid() + ", " + tmp.getContent() + ", " + tmp.getCommercialUserId() + ", " + tmp.getAddDate());
		}
		
		list = dao.list(0, 2, "1222");
		for(MessageContent tmp : list){
			System.out.println(tmp.getUid() + ", " + tmp.getContent() + ", " + tmp.getCommercialUserId() + ", " + tmp.getAddDate());
		}
	}
}
