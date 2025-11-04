package com.example.TeamProject.mapper;

import com.example.TeamProject.model.Review;
import com.example.TeamProject.model.ReviewImage;
import org.apache.ibatis.annotations.Mapper;


public interface ReviewMapper {

	// 리뷰 작성
    int insertReview(Review review);
   // 리뷰 이미지 등록
    int insertReviewImage(ReviewImage reviewImage);
}