import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.AppleIdDao;
import com.yzx.messagelord.model.AppleId;


public class TestAppleIdDAO {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/applicationContext.xml");
		AppleIdDao appleIdDAO = (AppleIdDao)context.getBean("appleIdDAO");
//		AppleIdDAOImpl impl = (AppleIdDAOImpl)appleIdDAO;
//		impl.createTableIfNotExists();
		AppleId tmp = new AppleId();
		tmp.setAppleID("a8613727270001@163.com");
		tmp.setPassword("Mima1204512045");
//		appleIdDAO.add(tmp);
		System.out.println(appleIdDAO.exists(tmp) ? "exits" : "not exits");
		System.out.println(appleIdDAO.getAppleID("1").getAppleID());
	}

}
