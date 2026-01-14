package com.example.TeamProject.model;

import java.util.List;

import lombok.Data;

@Data
public class Order {
	private int orderNo;
	private String buyerId;
	private String orderDate;
	private Integer totalPrice;
	private String status;
	private String receivName;
	private String receivPhone;
	private String deliverAddr;
	private String memo;
	private String uDatetime;
	private List<OrderItem> items;
	
	private String productName;
	private int productCount;
	private String buyerName;
	
	private String paymentMethod;
	private String courier;
	private String trackingNo;
	private String primaryRefundStatus;
	
	private int totalItemCount; 
	private int processedRefundItemCount; 
	private int pendingRefundItemCount; 
	
}