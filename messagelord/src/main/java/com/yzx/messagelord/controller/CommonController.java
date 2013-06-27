package com.yzx.messagelord.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class CommonController {
	
	@RequestMapping(value = "/")
	public ModelAndView manageCenter(){
		return new ModelAndView(new RedirectView("message/index.do"));
	}
	
	@RequestMapping(value = "index.do")
	public ModelAndView indexPage(){
		return manageCenter();
	}
}
