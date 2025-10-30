package com.example.TeamProject.model;

import lombok.Data; 

@Data
public class Producer {
    // SELLER_INFO 테이블 컬럼 구조를 알 수 없으나, JSP의 Vue 데이터 구조에 맞춰 임시 정의
    private int id; // SELLER_ID 또는 SELLER_NO로 예상
    private String name; 
    private String description;
    private String logoUrl; // DB 컬럼: LOGO_URL로 예상
    private String linkUrl = "#"; // JSP에서 사용하므로 기본값 설정
}