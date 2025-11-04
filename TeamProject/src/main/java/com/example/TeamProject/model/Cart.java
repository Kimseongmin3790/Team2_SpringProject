package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Cart {
	
	private String cartNo;
	private String productNo;
	private String userId;
	private String quantity;
	private String addedAt;
	private String pName;
	private String price;
	private String lineTotal;
	private String thumbPath;
}
