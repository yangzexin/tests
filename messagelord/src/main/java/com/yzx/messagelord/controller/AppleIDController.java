package com.yzx.messagelord.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.model.AppleId;
import com.yzx.messagelord.service.AppleIdService;
import com.yzx.messagelord.util.MessageServiceContext;
import com.yzx.messagelord.util.SharedContext;

@Controller
@RequestMapping("/appleid")
public class AppleIDController {
	// URIEncoding="UTF-8"
	@RequestMapping("/list")
	public ModelAndView appleIdList(
			@RequestParam(required = false) String resultMessage,
			HttpServletRequest request) {
//		 System.out.println(request.getRealPath("test.xml"));
		ModelAndView mv = new ModelAndView();
		AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
		mv.setViewName("appleIdList");
		mv.addObject("appleIdList", appleIdService.getAllAppleID());
		if (resultMessage != null) {
			mv.addObject("resultMessage", resultMessage);
		}
		return mv;
	}

	@RequestMapping("/addAppleId")
	public ModelAndView addAppleId(@RequestParam String appleid,
			@RequestParam String appleidPassword) {
		ModelAndView mv = new ModelAndView();
		AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
		AppleId newAppleId = new AppleId();
		newAppleId.setAppleID(appleid);
		newAppleId.setPassword(appleidPassword);
		appleIdService.add(newAppleId);
		mv.addObject("resultMessage", "添加:" + appleid + " 成功");
		mv.setViewName("redirect:list.do");
		return mv;
	}

	@RequestMapping("/deleteAppleId")
	public ModelAndView deleteAppleId(@RequestParam String uid) {
		ModelAndView mv = new ModelAndView();

		AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
		AppleId appleID = appleIdService.getAppleID(uid);
		appleIdService.remove(appleID);
		mv.addObject("resultMessage", "删除：" + appleID.getAppleID() + " 成功");
		mv.setViewName("redirect:list.do");
		return mv;
	}

	@RequestMapping("/updateAppleId")
	public ModelAndView updateAppleId(@RequestParam String uid, @RequestParam(required = false) String resultMessage) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("editAppleId");
		AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
		AppleId appleID = appleIdService.getAppleID(uid);
		mv.addObject("appleid", appleID);
		if(resultMessage != null){
			mv.addObject("resultMessage", resultMessage);
		}
		return mv;
	}
	
	@RequestMapping("/doUpdateAppleId")
	public ModelAndView doUpdateAppleId(@RequestParam String uid, @RequestParam String appleId, @RequestParam String password){
		if(StringUtils.isEmpty(appleId) || StringUtils.isEmpty(password)){
			ModelAndView mv = new ModelAndView();
			mv.setViewName("redirect:updateAppleId.do?uid=" + uid);
			mv.addObject("resultMessage", "账号或者密码不能修改为空");
			return mv;
		}else{
			ModelAndView mv = new ModelAndView();
			AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
			AppleId appleID = new AppleId();
			appleID.setUid(uid);
			appleID.setAppleID(appleId);
			appleID.setPassword(password);
			appleIdService.update(appleID);
			mv.addObject("resultMessage", "修改:"+ appleId +" 成功");
			mv.setViewName("redirect:list.do");
			
			return mv;
		}
	}
	
	@RequestMapping(value = "/index")
	public ModelAndView index(){
		ModelAndView mv = new ModelAndView();
		mv.addObject("serviceStarted", MessageServiceContext.isServiceStarted());
		mv.setViewName("redirect:/manageCenter.jsp");
		
		return mv;
	}
	
	@RequestMapping(value = "/usableAppleId")
	public @ResponseBody AppleId usableAppleId(){
		AppleIdService appleIdService = (AppleIdService) SharedContext.getApplicationContext().getBean("appleIdService");
		return appleIdService.getUnused();
	}
}
