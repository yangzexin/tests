package com.yzx.messagelord.intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.yzx.messagelord.context.Constants;

public class CommercialSessionIntercepter extends HandlerInterceptorAdapter  {

	private static String[] nonLoginPages = {"commercialLogin.do", 
		"doCommercialLogin.do", 
		"commercialUserRegister.do", 
		"doCommercialUserRegister.do", 
		"redirectToLogin.do"};
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		String url = request.getRequestURI().toString();
		Object user = request.getSession().getAttribute(Constants.commercialUserSessionKey);
		boolean valid = this.isUrlValid(url);
		if(user != null || valid){
			return super.preHandle(request, response, handler);
		}
		
		request.getRequestDispatcher("redirectToLogin.do").forward(request, response);
		return true;
	}
	
	private boolean isUrlValid(String url){
		boolean valid = false;
		for(String nonLoginPage : nonLoginPages){
			valid = url.endsWith(nonLoginPage);
			if(valid){
				break;
			}
		}
		return valid;
	}
	
}
