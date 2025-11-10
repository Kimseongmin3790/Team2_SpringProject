package com.example.TeamProject.model;

import lombok.Data;

@Data
public class OrderItem {
	private int orderItemNo;
	private int orderNo;
	private int productNo;
	private int quantity;
	private int price;
	private String productName;
	private String imageUrl;
	
	private int hasReview;
	private String optionUnit;  
	private int optionAddPrice; 
	private String refundStatus;
	private String refundReason;
	private int refundQuantity;
	
	
}