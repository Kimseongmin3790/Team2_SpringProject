package com.example.TeamProject.model;

import lombok.Data;

@Data
public class ChatSocketMessage {
	
	private int roomId;
    private String senderId;
    private String content;
    private String messageType;

}
