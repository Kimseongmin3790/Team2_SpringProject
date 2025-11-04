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
    
    // 댓글 수정
    public HashMap<String, Object> updateComment(NoticeComment comment, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String loginUserId = (String) session.getAttribute("sessionId");
            String userRole = (String) session.getAttribute("userRole");

            if (loginUserId == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            //(권한 확인용)
            NoticeComment existingComment = noticeCommentMapper.findById(comment.getCommentNo());
            if (existingComment == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "댓글을 찾을 수 없습니다.");
                return resultMap;
            }

            // 작성자 본인이거나 관리자인 경우에만 수정 가능
            if (!(loginUserId.equals(existingComment.getUserId()) || "ADMIN".equals(userRole))) {
                resultMap.put("result", "fail");
                resultMap.put("message", "수정 권한이 없습니다.");
                return resultMap;
            }

            int updatedRows = noticeCommentMapper.update(comment);
            if (updatedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "댓글 수정에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 댓글 삭제
    public HashMap<String, Object> deleteComment(int commentNo, HttpSession session) { 
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String loginUserId = (String) session.getAttribute("sessionId");
            String userRole = (String) session.getAttribute("sessionStatus");
           
            if (loginUserId == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            // 권한 확인용
            NoticeComment existingComment = noticeCommentMapper.findById(commentNo);
            if (existingComment == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "댓글을 찾을 수 없습니다.");
                return resultMap;
            }

            // 작성자 본인이거나 관리자인 경우에만 삭제 가능
            if (!(loginUserId.equals(existingComment.getUserId()) || "ADMIN".equals(userRole))) {
                resultMap.put("result", "fail");
                resultMap.put("message", "삭제 권한이 없습니다.");
                return resultMap;
            }

            int deletedRows = noticeCommentMapper.delete(commentNo);
            if (deletedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "댓글 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
    
}
