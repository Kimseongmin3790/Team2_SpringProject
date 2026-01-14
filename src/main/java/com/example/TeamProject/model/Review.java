package com.example.TeamProject.model;

import java.util.Date;
import java.util.List;

import lombok.Data; 

@Data
public class Review {
    private int reviewNo;
    private String userId;
    private int productNo;
    private int orderItemNo;
    private int rating;
    private int recommend;
    private String content;
    private Date createdAt; 
    private Date uDatetime;
    
    private String productName;
    private String cdate;
    private String imageUrl;
    
    private String sellerName;
    private String orderdate;
    private List<String> reviewImages; // 리뷰에 첨부된 이미지 URL 목록
    private boolean isRecommendedByMe; // 리뷰 추천 여부 확인
    
    private List<ReviewComment> comments;
    
    
    
}
