package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.BoardService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@RequestMapping("/board.do") 
    public String community(Model model) throws Exception{

        return "board/customerCenter"; 
    }
	
	@RequestMapping("/inquiry/detail.do") 
    public String detail(Model model) throws Exception{

        return "board/inquiryInfo"; 
    }
	
	@RequestMapping(value = "/inquiryList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getInquiryList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiryInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryInfo(Model model, @RequestParam int inquiryNo) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getInquiryInfo(inquiryNo);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/answerInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String answerInfo(Model model, @RequestParam int inquiryNo) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getAnswerByInquiryNo(inquiryNo);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/answerInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String answerInsert(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    boardService.insertAnswerAndUpdateStatus(map);
	    
	    resultMap.put("result", "success");

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiry/checkPwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkPwd(Model model, @RequestParam int inquiryNo, @RequestParam String pw) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		boolean match = boardService.checkPassword(inquiryNo, pw);
		System.out.println(match);
		if (match) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		
		return new Gson().toJson(resultMap);
	}
	
	
}
	
	

