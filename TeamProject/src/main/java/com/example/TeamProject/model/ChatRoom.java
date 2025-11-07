package com.example.TeamProject.model;


import java.util.Date;

import lombok.Data;

@Data
public class ChatRoom {
	private Long roomNo;
    private String title;
    private Long productNo;
    private String ownerId;
    private String isPrivate;
    private String cdate; // TO_CHAR로 문자열 매핑
}