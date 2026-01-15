package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.example.TeamProject.dao.ChatService;
import com.example.TeamProject.model.ChatSocketMessage;

@Controller
public class ChatSocketController {
	
	@Autowired
	ChatService chatService;
	
	@Autowired
	SimpMessagingTemplate messagingTemplate;
	
	@MessageMapping("/chat/send")
    public void send(ChatSocketMessage msg) {

        HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", msg.getRoomId());
        map.put("senderId", msg.getSenderId());
        map.put("content", msg.getContent());
        map.put("messageType", msg.getMessageType());

        chatService.addMessage(map);

        messagingTemplate.convertAndSend(
            "/topic/chat/room/" + msg.getRoomId(),
            msg
        );
    }

}
