package com.yzx.messagelord.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.context.Constants;
import com.yzx.messagelord.model.CommercialUser;
import com.yzx.messagelord.service.CommercialUploadNumberService;
import com.yzx.messagelord.util.SharedContext;

@Controller
public class CommercialUploadNumberController {
	
	@RequestMapping("/doCommercialUploadNumber")
	public ModelAndView doCommercialUploadNumber(@RequestParam(value = "txtFile") MultipartFile file, 
			@RequestParam String title, @RequestParam String groupId, HttpServletRequest req){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("commercial_upload_number_result");
		if(StringUtils.isEmpty(title)){
			title = "未命名分组-" + System.currentTimeMillis();
		}
		try {
			String text = new String(file.getBytes(), "UTF-8");
			String[] lines = text.split("\n");
			for(String tmp : lines){
				System.out.println(tmp);
			}
			System.out.println("upload number amount:" + lines.length);
			
			CommercialUploadNumberService service = (CommercialUploadNumberService)SharedContext.getApplicationContext().getBean("commercialUploadNumberService");
			CommercialUser user = (CommercialUser)req.getSession().getAttribute(Constants.commercialUserSessionKey);
			if(StringUtils.isEmpty(groupId)){
				service.uploadNumber(title, lines, user);
			}else{
				service.uploadNumber(title, lines, user, groupId);
			}
			
			mv.addObject("errorMsg", "上传成功");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mv.addObject("errorMsg", "上传失败，不是UTF－8编码的txt文件");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mv.addObject("errorMsg", "上传失败，文本读取错误");
		}
		return mv;
	}
}
