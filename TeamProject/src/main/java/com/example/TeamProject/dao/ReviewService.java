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
import com.example.TeamProject.model.ReviewComment;
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
                dataMap.put("pname", data.getPName());
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
            // 리뷰 기본 정보 조회
            Review review = reviewMapper.selectReviewDetailByReviewNo(reviewNo);

            if (review != null) {
                // 리뷰 이미지 목록 조회
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
            // 리뷰 기본 정보(별점, 내용) 수정
            reviewMapper.updateReview(params);

            int reviewNo = Integer.parseInt((String) params.get("reviewNo"));

            // 선택한 기존 이미지 삭제
            if (deletedImageNosJson != null && !deletedImageNosJson.isEmpty()) {
                List<Integer> deletedImageNos = new Gson().fromJson(deletedImageNosJson, new com.google.gson.reflect.TypeToken<List<Integer>>() {}.getType());
                if (deletedImageNos != null && !deletedImageNos.isEmpty()) {
                    reviewMapper.deleteSpecificReviewImages(deletedImageNos); 
                }
            }
            // 새로 추가된 이미지 등록
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
    
    // 상품별 리뷰 목록 가져오기 
    public HashMap<String, Object> getProductReviews(int productNo, String currentUserId, int page, int pageSize) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 페이징을 위한 offset 계산
            int offset = (page - 1) * pageSize;

            // 해당 페이지의 리뷰 목록과 전체 리뷰 개수를 매퍼에서 가져옴
            List<Review> reviewList = reviewMapper.selectReviewsByProductNo(productNo, offset, pageSize);
            int totalReviews = reviewMapper.countReviewsByProductNo(productNo);        

                for (Review review : reviewList) {
                    if (currentUserId != null && !currentUserId.isEmpty()) {
                        boolean isRecommended = reviewMapper.checkIfUserRecommended(review.getReviewNo(),currentUserId);
                        review.setRecommendedByMe(isRecommended);
                    }
                    List<ReviewComment> comments = reviewMapper.selectCommentsByReviewNo(review.getReviewNo());
                    review.setComments(comments);
                }

            // 리뷰 통계 정보 계산
            double averageRating = 0;
            Map<Integer, Integer> ratingDistribution = new HashMap<>();
            for (int i = 1; i <= 5; i++) {
                ratingDistribution.put(i, 0); // 1~5점까지 0으로 초기화
            }

            if (totalReviews > 0) {
                // DB에서 별점 분포도 가져오기
                List<Map<String, Object>> distributionList = reviewMapper.getRatingDistributionByProductNo(productNo);
                long totalRatingSum = 0;

                for (Map<String, Object> item : distributionList) {
              
                    int rating = ((BigDecimal) item.get("RATING")).intValue();
                    int count = ((BigDecimal) item.get("COUNT")).intValue();

                    ratingDistribution.put(rating, count);
                    totalRatingSum += (long) rating * count;
                }
                // 평균 평점 계산
                averageRating = (double) totalRatingSum / totalReviews;
            }

            // 최종 결과 resultMap에 담기
            resultMap.put("result", "success");
            resultMap.put("reviews", reviewList);
            resultMap.put("totalReviews", totalReviews);
            resultMap.put("totalCount", totalReviews);
            resultMap.put("averageRating", averageRating);
            resultMap.put("ratingDistribution", ratingDistribution);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
   
    // 리뷰 추천
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> toggleRecommendStatus(int reviewNo, String userId, String action) {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "fail");

        if (userId == null || userId.isEmpty()) {
            resultMap.put("message", "로그인이 필요합니다.");
            return resultMap;
        }

        try {
            // 사용자가 이미 추천했는지 확인 
            boolean isRecommended = reviewMapper.checkIfUserRecommended(reviewNo, userId);

            if ("increment".equals(action)) {
                if (isRecommended) {
                    resultMap.put("message", "이미 추천한 리뷰입니다.");
                    resultMap.put("result", "already_recommended"); 
                } else {
                    // 추천 기록 추가
                    reviewMapper.insertReviewRecommend(reviewNo, userId);
                    // 리뷰의 추천 수 증가
                    reviewMapper.incrementReviewRecommend(reviewNo);
                    resultMap.put("result", "success");
                    resultMap.put("message", "리뷰를 추천했습니다.");
                }
            } else if ("decrement".equals(action)) {
                if (!isRecommended) {
                    resultMap.put("message", "추천하지 않은 리뷰입니다.");
                    resultMap.put("result", "not_recommended"); 
                } else {
                    // 추천 기록 삭제 
                    reviewMapper.deleteReviewRecommend(reviewNo, userId);
                    // 리뷰의 추천 수 감소 
                    reviewMapper.decrementReviewRecommend(reviewNo);
                    resultMap.put("result", "success");
                    resultMap.put("message", "리뷰 추천을 취소했습니다.");
                }
            } else {
                resultMap.put("message", "유효하지 않은 action 값입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("message", "추천 처리 중 오류 발생: " + e.getMessage());
            throw new RuntimeException("리뷰 추천 처리 중 오류 발생", e); 
        }
        return resultMap;
    }
    
    // 해당 판매자 상품 리뷰 조회
    public List<Review> getReviewsBySellerId(String sellerId) {
        // 판매자의 리뷰 목록을 기본 정보와 함께 가져옵니다.
        List<Review> reviewList = reviewMapper.selectReviewsBySellerId(sellerId);

        // 각 리뷰에 해당하는 이미지 URL 목록을 조회하여 설정합니다.
        for (Review review : reviewList) {
            // review_no를 사용하여 해당 리뷰의 이미지들을 가져옵니다.
            List<ReviewImage> images = reviewMapper.selectReviewImagesByReviewNo(review.getReviewNo());

            // ReviewImage 객체 리스트에서 URL(String)만 추출하여 reviewImages 필드에 설정합니다.
            List<String> imageUrls = new ArrayList<>();
            for (ReviewImage img : images) {
                imageUrls.add(img.getImageUrl());
            }
            review.setReviewImages(imageUrls);
            
            // 리뷰 답글 목록 
            List<ReviewComment> comments = reviewMapper.selectCommentsByReviewNo(review.getReviewNo());
            review.setComments(comments);
            
        }
        return reviewList;
    }
    
    // 리뷰 답글
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> addCommentToReview(ReviewComment reviewComment) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // DB에 답글을 삽입합니다.
            reviewMapper.insertReviewComment(reviewComment);
            resultMap.put("result", "success");

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "답글 등록 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
            // 트랜잭션 롤백을 위해 예외를 다시 던져줍니다.
            throw new RuntimeException(e);
        }
        return resultMap;
    }
    
    // 답글 삭제
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> deleteComment(int commentNo, String sellerId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        if (sellerId == null || sellerId.isEmpty()) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
            return resultMap;
        }

        try {
            HashMap<String, Object> params = new HashMap<>();
            params.put("commentNo", commentNo);
            params.put("userId", sellerId); 

            int affectedRows = reviewMapper.deleteComment(params);

            if (affectedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "답글을 삭제할 수 없습니다. (권한 없음)");
            }

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "답글 삭제 중 오류가 발생했습니다.");
            e.printStackTrace();
            throw new RuntimeException(e); // 트랜잭션 롤백
        }

        return resultMap;
    }
    
    // 답글 수정
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> updateComment(int commentNo, String contents, String sellerId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        if (sellerId == null || sellerId.isEmpty()) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
            return resultMap;
        }

        try {
            HashMap<String, Object> params = new HashMap<>();
            params.put("commentNo", commentNo);
            params.put("contents", contents);
            params.put("userId", sellerId); 

            int affectedRows = reviewMapper.updateComment(params);

            if (affectedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "답글을 수정할 수 없습니다. (권한 없음)");
            }

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "답글 수정 중 오류가 발생했습니다.");
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return resultMap;
    }
    
}