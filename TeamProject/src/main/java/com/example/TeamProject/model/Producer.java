package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Producer {

    private String userId;         // 입점 업체 ID (SELLER_ID)
    private String businessName;     // 입점 업체 이름
    private String profileImg;  // 입점 업체 로고 이미지 경로
    private String addrDo; // 주소 중 시,도 추출
    private String addrCity; // 주소 중 시,군,구 추출
    private double lat; // 위도
    private double lng; // 경도
    private double distance; // 거리(km)
    private double avgRating; // 평균 별점
    private int productCnt; // 판매자가 판매하는 상품 개수
}