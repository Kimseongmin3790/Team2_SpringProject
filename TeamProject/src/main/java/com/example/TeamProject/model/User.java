package com.example.TeamProject.model;

import lombok.Data;

@Data
public class User {
	private String userId;
	private String name;	
	private String password;
	private String email;
	private String phone;
	private String userRole;
	private String address;
	private String cdatetime;
	private String totalPoint;
	private String lat;
	private String lng;
	private String status;
	private String userBirth;
	private String userGender;
	private String verified;
	private String sellerType;
	private String teleSaleNo;
	private String saleRawAgri;
	private String saleProcessed;
	private String saleLivestock;
	private String saleSeafood;
	private String saleOther;
	private String foodBizType;
	private String foodBizNo;
	private String livestockBizType;
	private String livestockBizNo;
	private String seafoodBizType;
	private String seafoodBizNo;
}
