import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.iMessageUserDao;
import com.yzx.messagelord.model.iMessageUser;


public class TestGenerateMessageUser {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		iMessageUserDao userDao = (iMessageUserDao)context.getBean("imessageUserDao");
//		iMessageUser user = new iMessageUser();
//		user.setNumber("18607072318");
////		userDao.add(user);
//		
//		List<iMessageUser> users = userDao.distribute(10);
//		for(iMessageUser tmp : users){
//			tmp.setState(iMessageUser.STATE_PROBED);
////			userDao.update(tmp);
//			System.out.println(tmp.getUid() + ", " + tmp.getNumber() + ", " + tmp.getState() + "," + tmp.getDistributedDate());
//		}
		String numberPath = "/Users/yangzexin/Downloads/numbers.txt";
		try {
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(numberPath)));
			String number = null;
			int count = 0;
//			int max = 1000;
			while((number = br.readLine()) != null){
//				System.out.println(++count + ", " + number);
				iMessageUser tmp = new iMessageUser();
				tmp.setNumber(number);
				userDao.add(tmp);
//				if(count > max){
//					break;
//				}
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
