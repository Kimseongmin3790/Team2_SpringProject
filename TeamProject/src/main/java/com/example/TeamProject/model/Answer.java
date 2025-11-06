package com.example.TeamProject.model;

import lombok.Data;

@Data
public class Answer {
	private int answerNo;
    private int inquiryNo;
    private int qnaNo;
    private String sellerId;
    private String content;
    private String cdatetime;
}
