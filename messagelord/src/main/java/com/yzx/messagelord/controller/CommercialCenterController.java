package com.yzx.messagelord.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.context.Constants;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.model.UploadContactNumberGroup;
import com.yzx.messagelord.service.CommercialUploadNumberService;
import com.yzx.messagelord.util.SharedContext;

@Controller
public class CommercialCenterController {
	
	@RequestMapping("/commercialReport")
	public ModelAndView commercialReport(HttpServletRequest req){
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("commercial_report");
		
		return mv;
	}
	
	@RequestMapping("/commercialTaskManage")
	public ModelAndView commercialTaskManage(HttpServletRequest req){
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("commercial_manage_task");
		
		return mv;
	}
	
	@RequestMapping("/commercialNumberManage")
	public ModelAndView commercialNumberManage(HttpServletRequest req){
		ModelAndView mv = new ModelAndView();
		CommercialUploadNumberService service = (CommercialUploadNumberService)SharedContext.getApplicationContext().getBean("commercialUploadNumberService");
		List<UploadContactNumberGroup> groupList = service.groupList((CommercialUser)req.getSession().getAttribute(Constants.commercialUserSessionKey), 0, 1000);
		mv.addObject("numberGroupList", groupList);
		mv.setViewName("commercial_number_manage");
		
		return mv;
	}
	
	@RequestMapping("/commercialNumberGroupDelete")
	public ModelAndView commercialNumberGroupDelete(String groupId){
		CommercialUploadNumberService service = (CommercialUploadNumberService)SharedContext.getApplicationContext().getBean("commercialUploadNumberService");
		service.deleteGroup(groupId);
		return CommonController.commonRedirect("commercialNumberManage.do", "删除成功");
	}
	
	@RequestMapping("/commercialNumberGroupEdit")
	public ModelAndView commercialNumberGroupEdit(String groupId){
		ModelAndView mv = new ModelAndView();
		CommercialUploadNumberService service = (CommercialUploadNumberService)SharedContext.getApplicationContext().getBean("commercialUploadNumberService");
		UploadContactNumberGroup group = service.getGroupById(groupId);
		mv.addObject("group", group);
		mv.setViewName("commercial_number_group_edit");
		return mv;
	}
}
