import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.CommercialUserDao;
import com.yzx.messagelord.model.CommercialUser;


public class TestCommercialUserDao {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		CommercialUserDao dao = (CommercialUserDao)context.getBean("commercialUserDao");
		CommercialUser user = new CommercialUser();
		user.setUsername("test");
		user.setPassword("123456");
		dao.add(user);
		
		List<CommercialUser> list = dao.list(0, 10);
		for(CommercialUser tmpUser : list){
			System.out.println(tmpUser.getUid() + "," + tmpUser.getUsername() + "," 
					+ tmpUser.getPassword() + ", " + tmpUser.getNumberOfPurchasedMessage() + ", " + tmpUser.getNumberOfSendedMessage());
			//dao.remove(tmpUser);
			tmpUser.setPassword("123456789");
			tmpUser.setNumberOfSendedMessage(100);
			tmpUser.setNumberOfPurchasedMessage(200);
			dao.update(tmpUser);
		}
	}
}
