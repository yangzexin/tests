import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.yzx.messagelord.dao.UploadContactNumberGroupDao;
import com.yzx.messagelord.model.UploadContactNumberGroup;


public class TestUploadContactNumberGroupDao {
	public static void main(String[] args){
		ApplicationContext context = new FileSystemXmlApplicationContext("/src/main/webapp/WEB-INF/dataSourceContext.xml");
		UploadContactNumberGroupDao dao = (UploadContactNumberGroupDao)context.getBean("uploadContactNumberGroupDao");
		
		UploadContactNumberGroup grou = new UploadContactNumberGroup();
		grou.setCommercialUserId("1222");
		grou.setTitle("titititi");
		dao.add(grou);
		
		grou.setUid("1");
		grou.setTitle("titit");
		grou.setCommercialUserId("1333");
		dao.update(grou);
		dao.remove(grou);
		
		List<UploadContactNumberGroup> list = dao.list(0, 10);
		for(UploadContactNumberGroup tmp : list){
			System.out.println(tmp.getUid() + ", " + tmp.getTitle() + "," + tmp.getCommercialUserId());
		}
		
		list = dao.list(0, 10, "1222");
		for(UploadContactNumberGroup tmp : list){
			System.out.println(tmp.getUid() + ", " + tmp.getTitle() + "," + tmp.getCommercialUserId());
		}
	}
}
