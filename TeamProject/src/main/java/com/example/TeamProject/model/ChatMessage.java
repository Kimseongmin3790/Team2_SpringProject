package com.example.TeamProject.model;

import java.util.Date;

import lombok.Data;

@Data
public class ChatMessage {
	 private Long msgNo;
	    private Long roomNo;
	    private String userId;       // SENDER_ID
	    private String contents;
	    private String cdate;        // TO_CHAR
}