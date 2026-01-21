package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.BoardMapper;
import com.example.TeamProject.mapper.ProductMapper;
import com.example.TeamProject.model.Answer;
import com.example.TeamProject.model.Board;

import jakarta.servlet.http.HttpSession;

@Service
public class BoardService {
	
	@Autowired
	BoardMapper boardMapper;
	
	@Autowired
	private NotificationService notificationService;

	@Autowired
	ProductMapper productMapper;
	
	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int page = Integer.parseInt(map.getOrDefault("page", "1").toString());
			int pageSize = Integer.parseInt(map.getOrDefault("pageSize", "10").toString());
		    int offset = (page - 1) * pageSize;
			
			map.put("offset", offset);
			map.put("limit", pageSize);
			
			List<Board> list = boardMapper.selectInquiryList(map);
			
			for (Board inquiry : list) {
				inquiry.setUserId(maskUserId(inquiry.getUserId()));
			}
						
			int totalCount =  boardMapper.countInquiry(map);			
			int totalPage = (int) Math.ceil((double) totalCount / pageSize);
			
			resultMap.put("list", list);
			resultMap.put("page", page);
			resultMap.put("totalPage", totalPage);
			resultMap.put("totalCount", totalCount);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getInquiryInfo(Integer inquiryNo, HttpSession session) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			@SuppressWarnings("unchecked")
			Set<String> viewedInquiries = (Set<String>) session.getAttribute("VIEWED_INQUIRIES");
			if (viewedInquiries == null) {
	            viewedInquiries = new HashSet<>();
	            session.setAttribute("VIEWED_INQUIRIES", viewedInquiries);
	        }
			
			String key = String.valueOf(inquiryNo);
			if (!viewedInquiries.contains(key)) {
	            boardMapper.updateInquiryCount(inquiryNo);
	            viewedInquiries.add(key);
	        }
			
			Board info = boardMapper.selectInquiryDetail(inquiryNo);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getAnswerByInquiryNo(Integer inquiryNo) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
	        Answer answer = boardMapper.selectAnswer(inquiryNo);
	        
	        resultMap.put("info", answer);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public void insertAnswerAndUpdateStatus(HashMap<String, Object> map) {
	    try {
	        // 답변 등록
	        boardMapper.insertAnswer(map);

	        // 문의 상태 '답변완료'로 업데이트
	        int inquiryNo = Integer.parseInt(map.getOrDefault("inquiryNo", "1").toString());
	        boardMapper.updateInquiryStatusAnswered(inquiryNo);
	        // 소비자에게 답변 알림 발송
	        Board inquiry = boardMapper.selectInquiryDetail(inquiryNo);
	        if (inquiry != null) {
	            notificationService.sendNotification(inquiry.getUserId(), "NOTICE", "[문의답변] 남겨주신 1:1 문의에 대한 답변이 등록되었습니다.", "/customerCenter.do");
	        }

	        System.out.println("답변 등록 및 상태 업데이트 완료");
	    } catch (Exception e) {
	        System.out.println("답변 등록 중 오류 발생: " + e.getMessage());
	    }
	}
	
	public HashMap<String, Object> addInquiry(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
	        boardMapper.insertInquiry(map);   
	        notificationService.sendNotification("admin", "NOTICE", "[고객문의] 새로운 1:1 문의가 등록되었습니다.","/admin/inquiryList.do");
	        resultMap.put("result", "success");   
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> updateInquiry(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
	        boardMapper.updateInquiry(map);	        
	        resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> deleteInquiry(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			boardMapper.deleteInquiryAnswer(map);
	        boardMapper.deleteInquiry(map);	        
	        resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getProductQnaList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        int page = Integer.parseInt(map.getOrDefault("page", "1").toString());
	        int pageSize = Integer.parseInt(map.getOrDefault("pageSize", "10").toString());
	        int offset = (page - 1) * pageSize;
	        
	        map.put("offset", offset);
	        map.put("limit", pageSize);
	        
	        List<Board> list = boardMapper.selectProductQnaList(map);
	        
	        for (Board qna : list) {
	        	qna.setUserId(maskUserId(qna.getUserId()));
			}
	        
	        int totalCount = boardMapper.countProductQna(map);	        
	        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	        resultMap.put("list", list);
	        resultMap.put("page", page);
	        resultMap.put("totalPage", totalPage);
	        resultMap.put("totalCount", totalCount);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        e.printStackTrace();
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> getProductQnaInfo(Integer qnaNo, HttpSession session) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			boardMapper.updateProductQnaCount(qnaNo);
			
			Board info = boardMapper.selectProductQnaDetail(qnaNo);
			resultMap.put("info", info);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getQnaAnswer(Integer qnaNo) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
	        Answer answer = boardMapper.selectQnaAnswer(qnaNo);
	        
	        resultMap.put("info", answer);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	// 상품 문의 등록 시 (판매자 알림)
	public HashMap<String, Object> productQnaInsert(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        boardMapper.productQnaInsert(map);

	     
	        com.example.TeamProject.model.Product p = productMapper.selectProduct(map);

	        if (p != null) {
	            String msg = "[상품문의] '" + p.getPName() + "' 상품에 새로운 문의가 접수되었습니다.";
	            notificationService.sendNotification(p.getSellerId(), "NOTICE", msg, "/board.do?tab=qna");
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        System.out.println(e.getMessage());
	    }
	    return resultMap;
	}
	
	// 문의 답변 등록 시 (소비자 알림)
	public HashMap<String, Object> productQnaAnswerInsert(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        Board idCheck = boardMapper.qnaIdCheck(map);
	        if (idCheck != null) {
	            boardMapper.productQnaAnswerInsert(map);

	            String msg = "[문의답변] '" + idCheck.getPname() + "' 문의에 대한 판매자의 답변이 등록되었습니다.";
	            notificationService.sendNotification(idCheck.getUserId(), "NOTICE", msg, "/board.do?tab=qna");
	            resultMap.put("result", "success");
	        } else {
	            resultMap.put("result", "notSeller");
	        }
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        System.out.println(e.getMessage());
	    }
	    return resultMap;
	}
	
	public boolean inquiryCheckPassword(Integer inquiryNo, String pw) {		
		String dbPw = boardMapper.selectInquiryPwd(inquiryNo);
		return dbPw != null && dbPw.equals(pw);
	}
	
	public boolean qnaCheckPassword(Integer qnaNo, String pw) {		
		String dbPw = boardMapper.selectQnaPwd(qnaNo);
		return dbPw != null && dbPw.equals(pw);
	}
	
	private String maskUserId(String userId) {
	    if (userId == null || userId.length() < 3) {
	        return "***";
	    }
	    int visible = 3; // 앞에서 3글자만 보이게
	    String prefix = userId.substring(0, visible);
	    String masked = "*".repeat(userId.length() - visible);
	    return prefix + masked;
	}
}
