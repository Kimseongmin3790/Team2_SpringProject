package com.example.TeamProject.dao;

import com.example.TeamProject.mapper.ReviewMapper;
import com.example.TeamProject.model.Review;
import com.example.TeamProject.model.ReviewImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

   // 리뷰 등록
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> addReview(HashMap<String, Object> params, List<MultipartFile> images, String uploadPath) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            Review review = new Review();
            review.setUserId((String) params.get("userId"));
            review.setProductNo(Integer.parseInt((String) params.get("productNo")));
            review.setOrderItemNo(Integer.parseInt((String) params.get("orderItemNo")));
            review.setRating(Integer.parseInt((String) params.get("rating")));
            review.setContent((String) params.get("content"));

            reviewMapper.insertReview(review);
            int reviewNo = review.getReviewNo();

            if (images != null && !images.isEmpty()) {
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                for (MultipartFile image : images) {
                    String originalName = image.getOriginalFilename();
                    String extension = originalName.substring(originalName.lastIndexOf("."));
                    String savedName = genSaveFileName(extension); 

                    File dest = new File(uploadPath + savedName);
                    image.transferTo(dest);

                    ReviewImage reviewImage = new ReviewImage();
                    reviewImage.setReviewNo(reviewNo);
                    reviewImage.setImageUrl("/resources/uploads/review-images/" + savedName); 

                    reviewMapper.insertReviewImage(reviewImage);
                }
            }

            resultMap.put("result", "success");

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }

    private String genSaveFileName(String extName) {
        String fileName = "";
        Calendar calendar = Calendar.getInstance();
        fileName += calendar.get(Calendar.YEAR);
        fileName += calendar.get(Calendar.MONTH) + 1; 
        fileName += calendar.get(Calendar.DATE);
        fileName += calendar.get(Calendar.HOUR_OF_DAY);
        fileName += calendar.get(Calendar.MINUTE);
        fileName += calendar.get(Calendar.SECOND);
        fileName += calendar.get(Calendar.MILLISECOND);
        fileName += extName;
        return fileName;
    }
}