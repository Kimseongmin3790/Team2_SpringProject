package com.example.TeamProject.dao;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.mapper.ReviewMapper;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.Review;
import com.example.TeamProject.model.ReviewImage;
import com.nimbusds.jose.shaded.gson.Gson;

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
    
    public HashMap<String, Object> getReviewProductInfo(HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            Product data = reviewMapper.selectReviewProductInfo(params);
                            
            if (data != null) {
                resultMap.put("result", "success");

                HashMap<String, Object> dataMap = new HashMap<>();
                dataMap.put("pname", data.getPname());
                dataMap.put("sellerName", data.getSellerName());
                dataMap.put("imageUrl", data.getImageUrl());
                dataMap.put("orderdate", data.getOrderdate());

                resultMap.put("data", dataMap);
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "상품 정보를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }
    
    public HashMap<String, Object> getReviewsByUserId(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            if (userId == null || userId.isEmpty()) {
                throw new Exception("로그인이 필요합니다.");
            }
            // Mapper를 호출하여 특정 사용자의 리뷰 목록을 조회합니다.
            List<Review> reviewList = reviewMapper.selectReviewsByUserId(userId);

            resultMap.put("result", "success");
            resultMap.put("list", reviewList);

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }
    
    public HashMap<String, Object> getReviewDetail(int reviewNo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 1. 리뷰 기본 정보 조회
            Review review = reviewMapper.selectReviewDetailByReviewNo(reviewNo);

            if (review != null) {
                // 2. 리뷰 이미지 목록 조회
            	List<ReviewImage> images = reviewMapper.selectReviewImagesByReviewNo(reviewNo);

                
                HashMap<String, Object> data = new HashMap<>();
                data.put("reviewNo", review.getReviewNo());
                data.put("userId", review.getUserId());
                data.put("productNo", review.getProductNo());
                data.put("orderItemNo", review.getOrderItemNo());
                data.put("rating", review.getRating());
                data.put("content", review.getContent());
                data.put("productName", review.getProductName());
                data.put("sellerName", review.getSellerName()); 
                data.put("productImageUrl", review.getImageUrl()); 
                data.put("orderdate", review.getCdate()); 
                data.put("images", images);

                resultMap.put("result", "success");
                resultMap.put("data", data);
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "리뷰 정보를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }
    
    // 리뷰 수정   
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> updateReview(HashMap<String, Object> params, List<MultipartFile> newImages,
    	     String deletedImageNosJson, String uploadPath) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 1. 리뷰 기본 정보(별점, 내용) 수정
            reviewMapper.updateReview(params);

            int reviewNo = Integer.parseInt((String) params.get("reviewNo"));

            // 2. 선택한 기존 이미지 삭제
            if (deletedImageNosJson != null && !deletedImageNosJson.isEmpty()) {
                List<Integer> deletedImageNos = new Gson().fromJson(deletedImageNosJson, new com.google.gson.reflect.TypeToken<List<Integer>>() {}.getType());
                if (deletedImageNos != null && !deletedImageNos.isEmpty()) {
                    reviewMapper.deleteSpecificReviewImages(deletedImageNos); 
                }
            }
            // 3. 새로 추가된 이미지 등록
            if (newImages != null && !newImages.isEmpty()) {
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                for (MultipartFile image : newImages) {
                    if (image.isEmpty()) continue; 

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

            throw new RuntimeException(e); 
        }
        return resultMap;
    }
    
    // 리뷰 삭제
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> deleteReview(HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
         
            int affectedRows = reviewMapper.deleteReview(params);

            if (affectedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "리뷰를 삭제할 수 없습니다. (권한 없음)");
            }
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return resultMap;
    }
    
    // 상품별 리뷰 목록 가져오기 (이미지 URL 추가 로직 포함)
    public HashMap<String, Object> getProductReviews(int productNo) { // 기존 메서드 이름 유지
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 1. 특정 상품의 리뷰 목록을 가져옵니다. (이제 List<Map<String, Object>>를 반환)
            List<Map<String, Object>> rawReviewList = reviewMapper.selectReviewsByProductNo(productNo);

            // 2. 각 리뷰에 이미지 URL 목록을 추가하고 통계를 계산합니다.
            List<Map<String, Object>> processedReviews = new ArrayList<>();
            int totalReviews = rawReviewList.size();
            double sumRatings = 0;
            Map<Integer, Integer> ratingDistribution = new HashMap<>();
            for (int i = 1; i <= 5; i++) {
                ratingDistribution.put(i, 0); // 1점부터 5점까지 초기화
            }

            for (Map<String, Object> review : rawReviewList) {
                // 해당 리뷰의 이미지 URL 목록을 가져와 추가
                // Integer reviewNo = (Integer) review.get("REVIEW_NO"); // <-- 이 부분이 문제일 수 있습니다.
                Integer reviewNo = null;
                Object reviewNoObj = review.get("REVIEW_NO");
                if (reviewNoObj instanceof BigDecimal) {
                    reviewNo = ((BigDecimal) reviewNoObj).intValue();
                } else if (reviewNoObj instanceof Integer) {
                    reviewNo = (Integer) reviewNoObj;
                }

                List<String> imageUrls = new ArrayList<>();
                if (reviewNo != null) {
                    imageUrls = reviewMapper.selectReviewImageUrlsByReviewNo(reviewNo);
                }
                review.put("images", imageUrls); // "images" 키로 이미지 URL 리스트 추가

                processedReviews.add(review); // 이미 Map 형태이므로 그대로 추가

                // 통계 계산 (RATING 처리 부분은 그대로 유지)
                Object ratingObj = review.get("RATING");
                int rating = 0; // 기본값 설정
                if (ratingObj != null) {
                    if (ratingObj instanceof BigDecimal) {
                        rating = ((BigDecimal) ratingObj).intValue();
                    } else if (ratingObj instanceof Integer) {
                        rating = (Integer) ratingObj;
                    } else {
                        try {
                            rating = Integer.parseInt(String.valueOf(ratingObj));
                        } catch (NumberFormatException e) {
                            System.err.println("Error parsing RATING to int: " + ratingObj + " - " +e.getMessage());
                        }
                    }
                }
                sumRatings += rating;
                if (rating >= 1 && rating <= 5) {
                    ratingDistribution.put(rating, ratingDistribution.get(rating) + 1);
                }
            }

            double averageRating = (totalReviews > 0) ? (sumRatings / totalReviews) : 0;
            averageRating = Math.round(averageRating * 10.0) / 10.0; // 소수점 첫째 자리까지 반올림

            resultMap.put("result", "success");
            resultMap.put("reviews", processedReviews); // "reviews" 키로 변경
            resultMap.put("averageRating", averageRating);
            resultMap.put("totalReviews", totalReviews);
            resultMap.put("ratingDistribution", ratingDistribution);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            // 오류 발생 시 클라이언트에서 처리할 수 있도록 빈 리스트나 기본값으로 채워 반환
            resultMap.put("reviews", new ArrayList<>());
            resultMap.put("averageRating", 0.0);
            resultMap.put("totalReviews", 0);
            resultMap.put("ratingDistribution", new HashMap<Integer, Integer>() {{
                put(5, 0); put(4, 0); put(3, 0); put(2, 0); put(1, 0);
            }});
        }
        return resultMap;
    }
}