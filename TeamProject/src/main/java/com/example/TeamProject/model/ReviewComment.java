package com.example.TeamProject.model;

import lombok.Data;

@Data
public class ReviewComment {
	private int commentNo;
	private int reviewNo;
	private String contents;
	private String userId;
	private String cDatetime; 
    private String uDatetime;
	
}