package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Board {
	private int inquiryNo;
	private int qnaNo;
	private String title;
	private String category;
	private String userId;
	private String content;
	private String regDate;
	private int cnt;
	private String status;
	private String isSecret;
	private String pname;
	private String thumbUrl;
	private String sellerId;
}
