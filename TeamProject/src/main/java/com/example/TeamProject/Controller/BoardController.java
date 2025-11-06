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

import jakarta.servlet.http.HttpServletRequest;
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
    public String inquiryDetail(Model model) throws Exception{

        return "board/inquiryInfo"; 
    }
	
	@RequestMapping("/inquiry/write.do") 
    public String inquiryWrite(Model model) throws Exception{

        return "board/inquiryWrite";
    }
	
	@RequestMapping("/inquiry/edit.do") 
    public String inquiryEdit(Model model) throws Exception{

        return "board/inquiryEdit";
    }
	
	@RequestMapping("/productQna/detail.do") 
    public String productQnaDetail(Model model) throws Exception{

        return "board/productQnaInfo"; 
    }
	
	@RequestMapping("/productQna/write.do") 
    public String productQnaWrite(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("productNo", map.get("productNo"));
		request.setAttribute("productName", map.get("productName"));
        return "board/productQnaWrite"; 
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
	public String inquiryInfo(Model model, @RequestParam int inquiryNo, HttpSession session) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
				
		resultMap = boardService.getInquiryInfo(inquiryNo, session);
		
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
		boolean match = boardService.inquiryCheckPassword(inquiryNo, pw);
		System.out.println(match);
		if (match) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiryInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryInsert(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    resultMap = boardService.addInquiry(map);

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiryUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryUpdate(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    resultMap = boardService.updateInquiry(map);

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiryDelete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryDelete(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    resultMap = boardService.deleteInquiry(map);

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productQnaList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productQnaList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
	    resultMap = boardService.getProductQnaList(map);
	    
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productQnaInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productQnaInfo(@RequestParam int qnaNo, HttpSession session) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
	    resultMap = boardService.getProductQnaInfo(qnaNo, session);
	    
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productQna/checkPwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaCheckPwd(Model model, @RequestParam int qnaNo, @RequestParam String pw) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		boolean match = boardService.qnaCheckPassword(qnaNo, pw);
		System.out.println(match);
		if (match) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productQnaAnswerInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productQnaAnswerInfo(Model model, @RequestParam int qnaNo) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getQnaAnswer(qnaNo);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productQnaInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productQnaInsert(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.productQnaInsert(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
}
	
	

