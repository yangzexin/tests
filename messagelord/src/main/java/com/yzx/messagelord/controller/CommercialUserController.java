package com.yzx.messagelord.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.context.Constants;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.service.CommercialUserService;
import com.yzx.messagelord.util.SharedContext;

@Controller
public class CommercialUserController {
	
	@RequestMapping("/doCommercialUserRegister")
	public ModelAndView doRegister(@RequestParam String username, @RequestParam String password1, @RequestParam String password2){
		if(!StringUtils.isEmpty(username) && !StringUtils.isEmpty(password1) && !StringUtils.isEmpty(password2)){
			if(password1.equals(password2)){
				CommercialUserService service = (CommercialUserService)SharedContext.getApplicationContext().getBean("commercialUserService");
				CommercialUser user = new CommercialUser();
				user.setUsername(username);
				user.setPassword(password1);
				boolean registered = service.register(user);
				ModelAndView mv = new ModelAndView();
				if(registered){
					mv.addObject("errorMsg", "注册成功");
					mv.setViewName("redirect:commercialLogin.do");
				}else{
					mv.addObject("errorMsg", "用户名已经存在");
					mv.setViewName("commercial_user_register");
				}
				return mv;
			}else{
				ModelAndView mv = new ModelAndView();
				mv.addObject("errorMsg", "两次密码输入不正确");
				mv.setViewName("commercial_user_register");
				return mv;
			}
		}else{
			ModelAndView mv = new ModelAndView();
			mv.addObject("errorMsg", "用户名或密码不能为空");
			mv.setViewName("commercial_user_register");
			return mv;
		}
	}
	
	@RequestMapping("/commercialUserRegister")
	public String register(){
		return "commercial_user_register";
	}
	
	@RequestMapping("/commercialLogin")
	public ModelAndView login(@RequestParam(required=false)String errorMsg, HttpServletRequest req){
		ModelAndView mv = new ModelAndView();
		if(req.getSession().getAttribute(Constants.commercialUserSessionKey) != null){
			mv.setViewName("redirectToCommercialCenter");
		}else{
			mv.setViewName("commercial_user_login");
			if(errorMsg != null){
				System.out.println("login errorMsg:" + errorMsg);
				mv.addObject("errorMsg", errorMsg);
			}
		}
		return mv;
	}
	
	@RequestMapping("/doCommercialLogin")
	public ModelAndView doLogin(HttpServletRequest request, @RequestParam() String username,@RequestParam String password){
		if(!StringUtils.isEmpty(username) && !StringUtils.isEmpty(password)){
			CommercialUserService service = (CommercialUserService)SharedContext.getApplicationContext().getBean("commercialUserService");
			CommercialUser user = new CommercialUser();
			user.setUsername(username);
			user.setPassword(password);
			user = service.login(user);
			ModelAndView mv = new ModelAndView();
			if(user != null){
				request.getSession().setAttribute(Constants.commercialUserSessionKey, user);
				System.out.println("登录成功：" + user.getUsername());
				mv.setViewName("redirect:commercialCenter.do");
				return mv;
			}else{
				System.out.println("用户名或密码错误");
				return this.login("用户名或密码错误", request);
			}		
		}
		System.out.println("用户名或密码不能为空");
		return this.login("用户名或密码不能为空", request);
	}
	
	@RequestMapping("/redirectToLogin.do")
	public String redirectToLogin(){
		return "redirectToCommercialLogin";
	}
	
	@RequestMapping("/commercialCenter")
	public String commercialCenter(HttpServletRequest request, HttpServletResponse response){
		return "commercial_center";
	}
	
	@RequestMapping("/commercialLogout")
	public String commercialLogout(HttpServletRequest req){
		req.getSession().removeAttribute(Constants.commercialUserSessionKey);
		return this.redirectToLogin();
	}
}
