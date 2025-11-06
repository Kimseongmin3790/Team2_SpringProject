package com.example.TeamProject.model;

import lombok.Data;

@Data
public class ChatRoom {

	private Long roomNo;
    private String sellerId;
    private String customerId;
    private String cdatetime; // 조회용(문자열 정형), 필요하면 LocalDateTime으로 바꿔도 됨
	
}
