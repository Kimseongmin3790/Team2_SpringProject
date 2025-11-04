package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.Review;
import com.example.TeamProject.model.ReviewImage;


public interface ReviewMapper {

	// 리뷰 작성
    int insertReview(Review review);
    // 리뷰 이미지 등록
    int insertReviewImage(ReviewImage reviewImage);
    // 상품정보 가져오기
    Product selectReviewProductInfo(HashMap<String, Object> params);
    // 사용자 리뷰 목록 가져오기
    List<Review> selectReviewsByUserId(String userId);
    // 사용자 리뷰 상세정보 가져오기
    Review selectReviewDetailByReviewNo(int reviewNo);
    // 사용자 리뷰 이미지 가져오기
    List<ReviewImage> selectReviewImagesByReviewNo(int reviewNo);
    // 리뷰 수정
    int updateReview(HashMap<String, Object> params);
    // 선택한 리뷰 이미지 삭제
    int deleteSpecificReviewImages(List<Integer> imageNos);
    // 리뷰 삭제
    int deleteReview(HashMap<String, Object> params);
}