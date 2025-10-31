package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Notice {
	private int noticeNo;
	private String title;
	private String contents;
	private String userId;
	private String regDate;
	private String uDatetime;
	private int cnt;
	private int commentCount;
}
