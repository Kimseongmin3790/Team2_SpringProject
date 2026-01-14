package com.example.TeamProject.Controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.dao.CommonService;
import com.example.TeamProject.dao.MailService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class CommonController {
	 
	@Autowired
	CommonService commonService;
	
	@Autowired
	MailService mailService;
	
	@RequestMapping("/index.do") 
    public String home(Model model) throws Exception{

        return "index"; 
    }
	// 고객센터
	@RequestMapping("/customerService.do") 
    public String customerService(Model model) throws Exception{

        return "main/customerService"; 
    }
	// 이용약관
	@RequestMapping("/terms.do")
	public String termsPage() {
	    return "main/TermsOfService";
	}
	// 개인정보처리방침
	@RequestMapping("/privacy.do")
	public String privacyPolicy() {
	    return "main/PrivacyPolicy";
	}
	// 제휴/입점 문의
	@RequestMapping("/partnership.do")
	public String partnership() {
	    return "main/Partnership";
	}
	// 브랜드 스토리
	@RequestMapping("/brandStory.do")
	public String brandStory() {
	    return "main/brandStory";
	}

	@RequestMapping(value = "/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = commonService.getOrdersByBuyerId(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquiry-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiry(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = commonService.inquiryAdd(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/categoryList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String categoryList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = commonService.allCategory(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 파일 업로드
	@RequestMapping("fileUpload.dox")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> sellerApply(
	    @RequestParam("farmName") String farmName,
	    @RequestParam("bizNo") String bizNo,
	    @RequestParam("bankName") String bankName,
	    @RequestParam("account") String account,
	    @RequestParam("bizLicense") MultipartFile bizLicense,
	    @RequestParam(value="userId", required=false) String userId,
	    HttpSession session,
	    HttpServletRequest request) {
		
	    
	    Map<String, Object> response = new HashMap<>();
	    
	    String sessionUserId = (String) session.getAttribute("sessionId");
	    if (sessionUserId != null) {
	        userId = sessionUserId;
	    }
	    System.out.println(userId);
	    if (userId == null || userId.isEmpty()) {
	  
	        response.put("status", "fail");
	        return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
	    }

	    String fileWebPath = null;

	    if (bizLicense != null && !bizLicense.isEmpty()) {
	        try {
	            String uploadDir = request.getServletContext().getRealPath("/resources/uploads/licenses");
	            File dir = new File(uploadDir);
	            if (!dir.exists()) {
	                dir.mkdirs();
	            }
	            String originalFilename = bizLicense.getOriginalFilename();
	            String extName = originalFilename.substring(originalFilename.lastIndexOf("."));
	            String savedFileName = genSaveFileName(extName);
	            File serverFile = new File(uploadDir, savedFileName);
	            bizLicense.transferTo(serverFile);
	            fileWebPath = "/resources/uploads/licenses/" + savedFileName;
	        } catch (Exception e) {
	            System.out.println("파일 업로드 중 오류 발생: " + e.getMessage());
	        
	            response.put("status", "error");
	            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
	            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); 
	        }
	    } else {
	        
	        response.put("status", "fail");
	        response.put("message", "사업자 등록증 파일이 필요합니다.");
	        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); 
	    }

	    HashMap<String, Object> sellerData = new HashMap<>();
	    sellerData.put("userId", userId);
	    sellerData.put("businessName", farmName);
	    sellerData.put("businessNumber", bizNo);
	    sellerData.put("bankName", bankName);
	    sellerData.put("account", account);
	    sellerData.put("businessLi", fileWebPath);
	    sellerData.put("verified", "N");

	 
	    try {
	        commonService.registerSeller(sellerData);
	        response.put("status", "success");
	        response.put("message", "입점 신청이 완료되었습니다.");
	        return new ResponseEntity<>(response, HttpStatus.OK); 
	    } catch (Exception e) {
	        System.out.println("DB 저장 중 오류 발생: " + e.getMessage());
	        response.put("status", "error");
	        response.put("message", "데이터 저장 중 오류가 발생했습니다.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	 
	// 현재 시간을 기준으로 파일 이름 생성
		private String genSaveFileName(String extName) {
			String fileName = "";
			
			Calendar calendar = Calendar.getInstance();
			fileName += calendar.get(Calendar.YEAR);
			fileName += calendar.get(Calendar.MONTH);
			fileName += calendar.get(Calendar.DATE);
			fileName += calendar.get(Calendar.HOUR);
			fileName += calendar.get(Calendar.MINUTE);
			fileName += calendar.get(Calendar.SECOND);
			fileName += calendar.get(Calendar.MILLISECOND);
			fileName += extName;
			
			return fileName;
		}
		
		// 제휴 신청
	    @PostMapping("/partner/inquiry.dox") 
		@ResponseBody
		public ResponseEntity<Map<String, Object>> handlePartnershipInquiry(@RequestBody Map<String, String>inquiryData) {
	    	Map<String, Object> response = new HashMap<>();
		    try {
		         	mailService.sendPartnershipInquiryEmail(inquiryData);
		            response.put("status", "success");
		            return new ResponseEntity<>(response, HttpStatus.OK);
		    } catch (Exception e) {
		    	System.err.println("제휴 문의 이메일 발송 중 오류 발생: " + e.getMessage());
		        response.put("status", "error");
		        response.put("message", "이메일 발송 중 오류가 발생했습니다.");
		        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		    }
		}
	    	    
}