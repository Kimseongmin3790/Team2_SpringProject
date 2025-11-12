package com.example.TeamProject.model;

import lombok.Data;

@Data
public class SocketMessage {
	
	private String type;     // CHAT/JOIN/LEAVE
    private Long roomNo;
    private String userId;
    private String sender;
    private String contents;
    private String cdate;

}
