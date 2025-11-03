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
}