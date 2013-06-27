package com.yzx.messagelord.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.yzx.messagelord.model.MessageDetail;
import com.yzx.messagelord.model.list.MessageDetails;
import com.yzx.messagelord.service.MessageDistributorService;
import com.yzx.messagelord.util.MessageServiceContext;
import com.yzx.messagelord.util.SharedContext;

@Controller
@RequestMapping("/message")
public class MessageDistributor {
	
	@RequestMapping(value = "/distributor")
	public @ResponseBody MessageDetails distributor(){
		MessageDetails mds = new MessageDetails();
		
		if(MessageServiceContext.isServiceStarted()){
			MessageDistributorService distributor = (MessageDistributorService)SharedContext.getApplicationContext().getBean("messageDistributorService");
			List<MessageDetail> msg = distributor.getUnpostedMessage(20);
			System.out.println("distribute:" + msg.size());
			mds.setMessage(msg);
		}else{
			System.out.println("message service is stoped");
		}
		return mds;
	}
	
	@RequestMapping(value = "/test")
	public String test(HttpServletRequest request){
		return "index";
	}
	
	@RequestMapping(value = "/generateTestMessages")
	public @ResponseBody MessageDetails generateTestMessages(){
		MessageDistributorService msgService = (MessageDistributorService)SharedContext.getApplicationContext().getBean("messageDistributorService");
		ArrayList<MessageDetail> tmpList = new ArrayList<MessageDetail>();
		for(int i = 0; i < 1000; ++i){
			MessageDetail tmp = new MessageDetail();
			tmp.setDestinationNumber("+8618607072318");
			tmp.setMessageContent("messageContent");
			tmpList.add(tmp);
		}
		msgService.submitNewList(tmpList, "test");
		MessageDetails mds = new MessageDetails();
		mds.setMessage(tmpList);
		return mds;
	}
	
	@RequestMapping(value = "submitMessageTask")
	public String submitMessageTask(){
		return "uploadMessageTask";
	}
	
	@RequestMapping(value = "doUploadMessageTask")
	public ModelAndView doUploadMessageTask(@RequestParam(value = "txtFile") MultipartFile file, 
			@RequestParam(value = "messageContent") String content){
		ModelAndView mv = new ModelAndView();
		try {
			ArrayList<MessageDetail> list = new ArrayList<MessageDetail>();
			String text = new String(file.getBytes(), "UTF-8");
			String[] lines = text.split("\n");
			for(String line : lines){
				line = line.trim();
				if(StringUtils.isNumeric(line) && !line.startsWith("+86")){
					line = "+86" + line;
				}
				if(line.length() != 0){
					MessageDetail md = new MessageDetail();
					md.setDestinationNumber(line);
					list.add(md);
				}
			}

			MessageDistributorService msgService = (MessageDistributorService)SharedContext.getApplicationContext().getBean("messageDistributorService");
			msgService.submitNewList(list, content);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mv.setViewName("redirect:submitMessageTask.do");
		return mv;
	}
	
	@RequestMapping(value = "/index")
	public ModelAndView index(){
		ModelAndView mv = new ModelAndView();
		mv.addObject("serviceStarted", MessageServiceContext.isServiceStarted());
		mv.setViewName("redirect:/manageCenter.jsp");
		
		return mv;
	}
	
	@RequestMapping(value = "/switchService")
	public ModelAndView switchMessageService(){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("redirect:index.do");
		if(MessageServiceContext.isServiceStarted()){
			MessageServiceContext.stopService();
		}else{
			MessageServiceContext.startService();
		}
		return mv;
	}
}
