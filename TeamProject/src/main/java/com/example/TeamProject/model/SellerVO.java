package com.example.TeamProject.model;

import lombok.Data;

@Data
public class SellerVO {
	private String userId;
    private String businessName;
    private String businessLi;  // 사업자등록증 경로
    private String verified;    // 'Y' or 'N'
    private String businessNumber;
    private String account;
    private String bankName;       
    private Double lat;
    private Double lng;
    private Double distance;    // 거리 (쿼리 결과용)
    
    private User user;  
}