package com.example.TeamProject.model;

import lombok.Data;

@Data
public class BestProduct {

    private int productNo;   // 상품 번호
    private String name;     // 상품 이름
    private String category; // 상품 카테고리
    private long price;      // 상품 가격

}