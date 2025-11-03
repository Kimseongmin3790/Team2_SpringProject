package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Producer {

    private int id;         // 입점 업체 ID (SELLER_ID)
    private String name;     // 입점 업체 이름
    private String logoUrl;  // 입점 업체 로고 이미지 경로
    private String description; // 입점 업체 설명

}