package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Board {
	private int inquiryNo;
	private String title;
	private String category;
	private String userId;
	private String content;
	private String regDate;
	private int cnt;
	private String status;
	private String isSecret;
}
