package com.example.TeamProject.model;

import lombok.Data; 

@Data
public class BestProduct {
    private int productNo; // PRODUCT 테이블의 PRODUCT_NO
    private String category; // 카테고리 이름 (조인 또는 별도 조회 필요하지만, 일단 임시로 필드 유지)
    private String name; // PNAME
    private long price; // PRICE
    private String imageUrl; // PRODUCT_IMAGE 테이블에서 가져와야 함
}