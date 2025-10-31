package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.NoticeCommentService;
import com.example.TeamProject.dao.NoticeService;
import com.example.TeamProject.model.Notice;
import com.example.TeamProject.model.NoticeComment;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class NoticeController {
	
	@Autowired
	NoticeService noticeService;
	
	 @Autowired
	 private NoticeCommentService noticeCommentService;
	
	@RequestMapping("/noticeView.do")
	public String noticeView(Model model) throws Exception{
	    return "board/noticeView";
	}	
	
	@RequestMapping(value = "/notice/edit.do", method = RequestMethod.GET)
	public String noticeEdit(Model model, @RequestParam("noticeNo") int noticeNo) {
	   
	    HashMap<String, Object> resultMap = noticeService.getNoticeInfo(noticeNo);
	    model.addAttribute("notice", resultMap.get("info"));

	    return "board/noticeEdit";
	}
	
	@RequestMapping(value = "/notice/update.do", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
	@ResponseBody
	public String update(@RequestBody HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = noticeService.noticeUpdate(map);
   
		return new Gson().toJson(resultMap);
	}
    
    @RequestMapping(value = "/notice/write.do", method = RequestMethod.GET)
    public String noticeWrite(Model model) {
       
        return "board/noticeWrite"; 
    }
	
	
	@RequestMapping(value = "/noticeList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = noticeService.getNoticeList(map);
		
		return new Gson().toJson(resultMap);
	}
	
    @RequestMapping(value = "/noticeInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String noticeInfo(Model model, @RequestParam("noticeNo") int noticeNo) throws Exception {
        // 1. 조회수 1 증가
    	noticeService.updateCnt(noticeNo); 

        // 2. 상세 정보 조회
        HashMap<String, Object> resultMap = noticeService.getNoticeInfo(noticeNo); 

        return new Gson().toJson(resultMap);
    }
    

    @RequestMapping(value = "/notice/comments.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getCommentList(@RequestParam("noticeNo") int noticeNo) {
    	HashMap<String, Object> resultMap = noticeCommentService.getCommentList(noticeNo);
    	return new Gson().toJson(resultMap);
    }
    
    @RequestMapping(value = "/notice/comments/save.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String saveComment(@RequestBody NoticeComment comment, HttpSession session) {
    		  HashMap<String, Object> resultMap = noticeCommentService.saveComment(comment, session);
    		  return new Gson().toJson(resultMap);
    }
    
    @RequestMapping(value = "/notice/save.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    		@ResponseBody
    		public String saveNotice(@RequestBody Notice notice, HttpSession session) {
    		    
    		    HashMap<String, Object> resultMap = noticeService.saveNotice(notice, session);
    		    return new Gson().toJson(resultMap);
    		}
    
    
    
    
}
	
	

