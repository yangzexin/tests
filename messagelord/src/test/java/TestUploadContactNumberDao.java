import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.UploadContactNumberDao;
import com.yzx.messagelord.model.UploadContactNumber;


public class TestUploadContactNumberDao {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		UploadContactNumberDao dao = (UploadContactNumberDao)context.getBean("uploadContactNumberDao");
		UploadContactNumber num = new UploadContactNumber();
		num.setCommercialUserId("1222");
		num.setDestinationNumber("18607070838");
		num.setImessageUser(true);
		dao.add(num);
		
		num.setUid("1");
		num.setDestinationNumber("18798987654");
		num.setCommercialUserId("1223");
		dao.update(num);
		
		List<UploadContactNumber> list = dao.list(0, 10);
		for(UploadContactNumber tmp : list){
			System.out.println(tmp.getUid() + "," + tmp.getCommercialUserId() + ", " + tmp.getDestinationNumber() + "," + tmp.isImessageUser());
		}
		System.out.println(dao.count());
		System.out.println(dao.count("1222"));
	}
}
