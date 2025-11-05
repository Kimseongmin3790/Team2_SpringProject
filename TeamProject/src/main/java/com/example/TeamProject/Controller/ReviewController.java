package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.dao.ReviewService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

    @Autowired
    private ReviewService reviewService; 

    @RequestMapping(value = "/reviewWrite.do", method = RequestMethod.GET)
    public String showReviewWritePage(@RequestParam("productNo") int productNo,
                                      @RequestParam("orderItemNo") int orderItemNo,
                                      Model model) {

        model.addAttribute("productNo", productNo);
        model.addAttribute("orderItemNo", orderItemNo);

        return "board/reviewWrite";
    }
    
    @RequestMapping(value = "/reviewUpdate.do", method = RequestMethod.GET)
    public String showReviewUpdatePage(@RequestParam("reviewNo") int reviewNo, Model model) {
        model.addAttribute("reviewNo", reviewNo);
        return "board/reviewEdit";
    }
    
    

    
    // 리뷰 작성
    @RequestMapping(value = "/review/write.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String submitReview(@RequestParam HashMap<String, Object> params,
                               @RequestParam(value = "images", required = false) List<MultipartFile> images,
                               HttpSession session,
                               HttpServletRequest request) {

        
        String userId = (String) session.getAttribute("sessionId");
        params.put("userId", userId);
        
        String uploadPath = request.getServletContext().getRealPath("/resources/uploads/review-images/");

        HashMap<String, Object> resultMap = reviewService.addReview(params, images, uploadPath);

        return new Gson().toJson(resultMap);
    }
    
    @RequestMapping(value = "/review/data.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String getReviewData(@RequestParam HashMap<String, Object> params) throws Exception {
    	
    	HashMap<String, Object> resultMap = reviewService.getReviewProductInfo(params);
    	
    	return new Gson().toJson(resultMap);
    }
    
    // 사용자 리뷰 목록 가져오기
    @RequestMapping(value = "/review/list.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String getReviews(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> resultMap = reviewService.getReviewsByUserId(userId);
        return new Gson().toJson(resultMap);
    }
    
    // 리뷰 상세 정보 가져오기 (수정 페이지)
    @RequestMapping(value = "/review/detail.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String getReviewDetail(@RequestParam("reviewNo") int reviewNo) throws Exception {
        HashMap<String, Object> resultMap = reviewService.getReviewDetail(reviewNo);
        return new Gson().toJson(resultMap);
    }
    
    // 리뷰 수정
    @RequestMapping(value = "/review/update.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String updateReview(@RequestParam HashMap<String, Object> params,
    @RequestParam(value = "newImages", required = false) List<MultipartFile> newImages,
	@RequestParam(value = "deletedImageNos", required = false) String deletedImageNosJson, HttpSession session, HttpServletRequest request) throws Exception {
	
    	String userId = (String) session.getAttribute("sessionId");
		params.put("userId", userId);
					
		String uploadPath = request.getServletContext().getRealPath("/resources/uploads/review-images/");
					
					
		HashMap<String, Object> resultMap = reviewService.updateReview(params, newImages, deletedImageNosJson, uploadPath);
					
		return new Gson().toJson(resultMap);
	}
    
    // 리뷰 삭제
    @RequestMapping(value = "/review/delete.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String deleteReview(@RequestParam("reviewNo") int reviewNo, HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");

        HashMap<String, Object> params = new HashMap<>();
        params.put("reviewNo", reviewNo);
        params.put("userId", userId);

        HashMap<String, Object> resultMap = reviewService.deleteReview(params);

        return new Gson().toJson(resultMap);
    }
    
    // 상품별 리뷰 목록 가져오기
    @RequestMapping(value = "/product/reviews.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getProductReviews(
            @RequestParam("productNo") int productNo,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "pageSize", defaultValue = "5") int pageSize, 
            HttpSession session) throws Exception {

        String userId = (String) session.getAttribute("sessionId");

        // 서비스 호출 시 모든 파라미터 전달
        HashMap<String, Object> resultMap = reviewService.getProductReviews(productNo, userId, page, pageSize);

        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create();
        return gson.toJson(resultMap);
    }
    
    // 리뷰 추천
    @RequestMapping(value = "/review/toggleRecommend.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String toggleRecommend(
            @RequestParam("reviewNo") int reviewNo,
            @RequestParam("action") String action,
            HttpSession session) {

        String userId = (String) session.getAttribute("sessionId");

        HashMap<String, Object> resultMap = reviewService.toggleRecommendStatus(reviewNo, userId, action);

        return new Gson().toJson(resultMap);
    }
 
}