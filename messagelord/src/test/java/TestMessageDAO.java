import java.util.ArrayList;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.MessageDetailDao;
import com.yzx.messagelord.dao.impl.MessageDetailDaoImpl;
import com.yzx.messagelord.model.MessageDetail;
import com.yzx.messagelord.service.MessageDistributorService;


public class TestMessageDAO {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		MessageDetailDao messageDAO = (MessageDetailDao)context.getBean("messageDAO");
		MessageDetailDaoImpl impl = (MessageDetailDaoImpl)messageDAO;
		impl.createTableIfNotExists();
//		for(int i = 0; i < 100000; ++i){
//			MessageDetail tmp = new MessageDetail();
//			tmp.setDestinationNumber("+8618607072318");
//			tmp.setMessageContent("###############");
//			messageDAO.add(tmp);
//		}
		
		final MessageDistributorService distributor = (MessageDistributorService)context.getBean("messageDistributorService");
		
		for(int i = 0; i < 10; ++i){
			new Thread(){
				public void run(){
					ArrayList<MessageDetail> messageDetailList = new ArrayList<MessageDetail>();
					for(int i = 0; i < 1000; ++i){
						MessageDetail tmp = new MessageDetail();
						tmp.setDestinationNumber("+18607072318");
						tmp.setMessageContent("#####" + Thread.currentThread().toString() + ", " + i);
						messageDetailList.add(tmp);
					}
					distributor.submitNewList(messageDetailList, "aa");
				}
			}.start();
		}
		for(int i = 0; i < 20; ++i){
			new Thread(){
				public void run(){
					List<MessageDetail> list = distributor.getUnpostedMessage(500);
					for(MessageDetail tmp : list){
						try {
							Thread.sleep(2);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						System.out.println(tmp.getUid() + ", sending to:" + tmp.getDestinationNumber() + ":" + tmp.getMessageContent() + ", " + Thread.currentThread().toString());
					}
				}
			}.start();
		}
	}

}
