package com.yzx.messagelord.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.dao.iMessageUserDao;
import com.yzx.messagelord.model.iMessageUser;
import com.yzx.messagelord.model.list.IMessageUsers;
import com.yzx.messagelord.service.IMessageUserService;
import com.yzx.messagelord.util.SharedContext;
import com.yzx.messagelord.util.clientstat.ClientStatistic;

@Controller
public class iMessageUserController {
	
	@RequestMapping(value = "submitiMessageUsers")
	public String submit(@RequestParam String users){
		iMessageUserDao dao = (iMessageUserDao)SharedContext.getApplicationContext().getBean("imessageUserDao");
		String[] lines = users.split("\n");
		for(String number : lines){
			if(number.trim().length() != 0){
				iMessageUser tmp = new iMessageUser();
				tmp.setNumber(number);
				dao.add(tmp);
			}
		}
		return "submitiMessageUsersComplete";
	}
	
	@RequestMapping(value = "userProbeList")
	public @ResponseBody IMessageUsers userProbeList(HttpServletRequest req){
		System.out.println(new Date() + "\tuserProbeList:" + req.getRemoteAddr());
		boolean blocked = false;
		if(SharedContext.blockedIpList() != null){
			for(String ip : SharedContext.blockedIpList()){
				if(ip.equals(req.getRemoteAddr())){
					blocked = true;
					break;
				}
			}
		}
		if(blocked){
			System.out.println(new Date() + "\tblocked ip:" + req.getRemoteAddr());
			return new IMessageUsers();
		}
		
		IMessageUserService userService = (IMessageUserService)SharedContext.getApplicationContext().getBean("imessageUserService");
		IMessageUsers users = new IMessageUsers();
		users.setUser(userService.distribute());
		return users;
	}
	
	@RequestMapping(value = "markProbeResult")
	public String markProbeResult(@RequestParam String params, HttpServletRequest req){
		String[] results = params.split(",");
		IMessageUserService userService = (IMessageUserService)SharedContext.getApplicationContext().getBean("imessageUserService");
		iMessageUser user = new iMessageUser();
		ClientStatistic cs = (ClientStatistic)SharedContext.getApplicationContext().getBean("probeClientStatistic");
		cs.markResult(req.getRemoteAddr());
		for(String result : results){
			String[] attributes = result.split("-");
			if(attributes.length == 2){
				String uid = attributes[0].trim();
				String register = attributes[1].trim();
				if(uid.length() != 0 && register.length() != 0){
					user.setUid(uid);
					user.setRegistered(register.equals("1"));
					System.out.println(new Date() + "\t" + req.getRemoteAddr() + " mark:" + uid + ", " + register);
					userService.mark(user);
					
					if(user.isRegistered()){
						cs.markSuccess(req.getRemoteAddr());
					}
				}
			}
		}
		return "markProbeResult";
	}
	
	@RequestMapping(value = "stat")
	public ModelAndView statistics(){
		ModelAndView mv = new ModelAndView("imessage_user_stat");
		iMessageUserDao dao = (iMessageUserDao)SharedContext.getApplicationContext().getBean("imessageUserDao");
		mv.addObject("probed", dao.numberOfCheckedImessageUsers());
		mv.addObject("numOfiMessageUser", dao.numberOfImessageUsers());
		List<String> list = SharedContext.blockedIpList();
		if(list != null){
			mv.addObject("blockedIps", SharedContext.blockedIpList());	
		}
		
		ClientStatistic cs = (ClientStatistic)SharedContext.getApplicationContext().getBean("probeClientStatistic");
		mv.addObject("clients", cs.clients());
		return mv;
	}
	
	@RequestMapping(value="clearStat")
	public ModelAndView clearStat(@RequestParam String ip){
		ClientStatistic cs = (ClientStatistic)SharedContext.getApplicationContext().getBean("probeClientStatistic");
		cs.clear(ip);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("redirect:stat.do");
		return mv;
	}
	
	@RequestMapping(value="blockIp")
	public ModelAndView blockIp(@RequestParam String ip){
		SharedContext.addBlockedIp(ip);
		return new ModelAndView("redirect:stat.do");
	}
	
	@RequestMapping(value="removeBlockIp")
	public ModelAndView removeBlockIp(@RequestParam String ip){
		SharedContext.removeBlockedIp(ip);
		return new ModelAndView("redirect:stat.do");
	}
}
