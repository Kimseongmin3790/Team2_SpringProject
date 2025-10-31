package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.NoticeCommentMapper;
import com.example.TeamProject.model.NoticeComment;

import jakarta.servlet.http.HttpSession;

@Service
public class NoticeCommentService {

    @Autowired
    private NoticeCommentMapper noticeCommentMapper;

    // 댓글 목록 불러오기
    public HashMap<String, Object> getCommentList(int noticeNo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<NoticeComment> commentList = noticeCommentMapper.findByNoticeNo(noticeNo);
            resultMap.put("list", commentList);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 댓글 작성
    public HashMap<String, Object> saveComment(NoticeComment comment, HttpSession session) {
    	    HashMap<String, Object> resultMap = new HashMap<>();
    	    try {
    	        String loginUserId = (String) session.getAttribute("sessionId");
    	        if (loginUserId == null) {
    	            resultMap.put("result", "fail");
    	            resultMap.put("message", "로그인이 필요합니다.");
    	            return resultMap;
    	        }
    	        comment.setUserId(loginUserId); 
    	        noticeCommentMapper.save(comment);
    	        resultMap.put("result", "success");
    	    } catch (Exception e) {
    	        e.printStackTrace();
    	        resultMap.put("result", "fail");
    	        resultMap.put("message", e.getMessage());
    	    }
    	    return resultMap;
    	}
}
