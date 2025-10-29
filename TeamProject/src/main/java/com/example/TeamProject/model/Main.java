package com.example.TeamProject.model;

import lombok.Data; // Lombok 사용 가정

// 메인 페이지 관련 모든 VO(Value Object)를 담는 컨테이너 클래스
public class Main {
    
    // 1. 메인 배너 데이터 구조
    @Data
    public static class MainBannerVO {
        private int id; 
        private String title;
        private String imageUrl; // DB 컬럼: IMAGE_URL
        private String linkUrl;  // DB 컬럼: LINK_URL
    }
    
    // 2. 입점 업체 데이터 구조
    @Data
    public static class ProducerVO {
        private int id; 
        private String name;
        private String description;
        private String logoUrl; // DB 컬럼: LOGO_URL
    }
    
    // 3. 베스트 상품 데이터 구조
    @Data
    public static class BestProductVO {
        private int id; // PRODUCT_NO
        private String name;
        private String category;
        private long price;
    }
}