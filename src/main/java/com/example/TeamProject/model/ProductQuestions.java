package com.example.TeamProject.model;

import lombok.Data;

@Data
public class ProductQuestions {
	private String title;
	private String content;
	private String userId;
	private String status;
	private String regDate;
	private String answer;
	private String isSecret;
	private String sellerId;
}
