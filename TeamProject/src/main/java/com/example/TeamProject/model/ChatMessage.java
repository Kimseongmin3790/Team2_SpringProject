package com.example.TeamProject.model;

import lombok.Data;

@Data
public class ChatMessage {
    private Long chatId;
    private Long roomId;
    private String userId;
    private String type;     // JOIN / LEAVE / CHAT
    private String content;
    private String cdate;    // 포맷된 문자열
}
