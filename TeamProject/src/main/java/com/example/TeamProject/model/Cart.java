package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Cart {
	
	private Long cartNo;
    private Long productNo;
    private String pName;
    private String sellerId;
    private Integer basePrice;
    private Integer addPrice;
    private Integer unitPrice;
    private Long optionNo;
    private String optionUnit;
    private Integer stockQty;
    private String thumbPath;
    private Integer quantity;
    private String fulfillment;
    private Integer shippingFee;
    private String unit;
	
}
