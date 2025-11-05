package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

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
    // 상품별 리뷰목록 가져오기
    List<Review> selectReviewsByProductNo(@Param("productNo") int productNo, @Param("offset") int offset, @Param("pageSize") int pageSize);
    // 상품별 전체 리뷰 개수 조회
    int countReviewsByProductNo(@Param("productNo") int productNo);
    // 특정 리뷰의 이미지 URL 목록을 가져오는 메서드 추가
    List<String> selectReviewImageUrlsByReviewNo(int reviewNo);
    // 추천 기록 확인
    boolean checkIfUserRecommended(@Param("reviewNo") int reviewNo, @Param("userId") String userId);
    // 추천 기록 추가
    int insertReviewRecommend(@Param("reviewNo") int reviewNo, @Param("userId") String userId);
    // 추천 기록 삭제
    int deleteReviewRecommend(@Param("reviewNo") int reviewNo, @Param("userId") String userId);
    // 리뷰 추천 수 증가
    int incrementReviewRecommend(int reviewNo);
    // 리뷰 추천 수 감소
    int decrementReviewRecommend(int reviewNo);
    
    List<Map<String, Object>> getRatingDistributionByProductNo(@Param("productNo") int productNo);
    
}