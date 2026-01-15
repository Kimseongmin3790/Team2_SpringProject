package com.example.TeamProject.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatMessage {
	private int messageId;
    private int roomId;
    private String senderId;

    private String messageType; // TEXT/IMAGE/FILE/SYSTEM
    private String content;     // CLOB

    private LocalDateTime cdatetime;

}
