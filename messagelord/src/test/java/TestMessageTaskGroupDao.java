import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.MessageTaskGroupDao;
import com.yzx.messagelord.model.MessageTaskGroup;


public class TestMessageTaskGroupDao {
	public static void main(String[] args){

		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		MessageTaskGroupDao dao = (MessageTaskGroupDao)context.getBean("messageTaskGroupDao");
		MessageTaskGroup group = new MessageTaskGroup();
		group.setAddDate(System.currentTimeMillis());
		group.setCommercialUserId("1222");
		group.setMessageContentId("0001");
		group.setNumberOfTasks(1000000);
		group.setTitle("tititit");
		dao.add(group);
		
		group.setUid("1");
		group.setTitle("testest");
		group.setMessageContentId("0002");
		group.setNumberOfTasks(100);
		dao.update(group);
		
		List<MessageTaskGroup> list = dao.list(0, 10);
		for(MessageTaskGroup tmp : list){
			System.out.println(tmp.getUid() + ", " +tmp.getAddDate() + ", " +tmp.getCommercialUserId()+ ", " +tmp.getMessageContentId() + ", " +tmp.getNumberOfTasks() + ", " +tmp.getTitle() + ", ");
		}
		System.out.println();
		list = dao.list(0, 10, "1223");
		for(MessageTaskGroup tmp : list){
			System.out.println(tmp.getUid() + ", " +tmp.getAddDate() + ", " +tmp.getCommercialUserId()+ ", " +tmp.getMessageContentId() + ", " +tmp.getNumberOfTasks() + ", " +tmp.getTitle() + ", ");
		}
	}
}
