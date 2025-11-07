package com.example.TeamProject.Controller;

import java.util.Map;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ChatWsController {

	private final SimpMessagingTemplate template;

	public ChatWsController(SimpMessagingTemplate template) {
		this.template = template;
	}

	// 클라: stomp.send("/app/chat.sendMessage", {}, JSON)
	@MessageMapping("/chat.sendMessage")
	public void relay(@Payload Map<String, Object> msg) {
		// 필요시 여기서 roomNo 검증/가공 가능
		template.convertAndSend("/topic/public", msg); // 클라: subscribe("/topic/public")
	}
}