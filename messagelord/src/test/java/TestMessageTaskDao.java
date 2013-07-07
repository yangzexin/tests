import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.MessageTaskDao;
import com.yzx.messagelord.model.MessageTask;


public class TestMessageTaskDao {
	public static void main(String[] args){

		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		MessageTaskDao dao = (MessageTaskDao)context.getBean("messageTaskDao");
		MessageTask task = new MessageTask();
		task.setDestinationNumber("18607072317");
		task.setGroupId("12232");
		task.setState(MessageTask.STATE_UNHANDLED);
//		dao.add(task);
		
		task.setUid("1");
		task.setDestinationNumber("18697970876");
		task.setState(MessageTask.STATE_UNHANDLED);
//		dao.update(task);
		
		List<MessageTask> list = dao.list(0,20);
		for(MessageTask tmp : list){
			System.out.println(tmp.getUid() + ", " + tmp.getAppleIdOfHandler() + ", " + tmp.getDeliverDate()  + ", " + tmp.getDestinationNumber() + ", " + tmp.getDistributeDate()  + ", " + tmp.getGroupId()  + ", " + tmp.getState());
		}
		System.out.println();
		list = dao.distribute(10);
		for(MessageTask tmp : list){
			System.out.println("distribute:" + tmp.getUid() + ", " + tmp.getAppleIdOfHandler() + ", " + tmp.getDeliverDate()  + ", " + tmp.getDestinationNumber() + ", " + tmp.getDistributeDate()  + ", " + tmp.getGroupId()  + ", " + tmp.getState());
		}
	}
}
