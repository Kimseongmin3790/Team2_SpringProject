package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.ChattingService;
import com.google.gson.Gson;

@Controller
public class ChattingRestController {

    @Autowired private ChattingService chattingService;
    @Autowired private SimpMessagingTemplate messagingTemplate;

    // ✅ POST 로 페이지 진입 (너가 원한 형태)
    @PostMapping("/chatting.do")
    public String chatting(@RequestParam String sessionId, Model model) {
        model.addAttribute("sessionId", sessionId);
        return "chatMessage"; // /WEB-INF/views/chatMessage.jsp
    }

    // 채팅 저장
    @PostMapping(value="/chat/save.dox", produces="application/json;charset=UTF-8")
    @ResponseBody
    public String saveChat(@RequestParam HashMap<String,Object> map){
        HashMap<String,Object> result = chattingService.saveChat(map);
        return new Gson().toJson(result);
    }

    // 히스토리
    @PostMapping(value="/chat/history.dox", produces="application/json;charset=UTF-8")
    @ResponseBody
    public String history(@RequestParam HashMap<String,Object> map){
        HashMap<String,Object> result = chattingService.history(map);
        return new Gson().toJson(result);
    }

    // STOMP → 브로드캐스트
    @MessageMapping("/chat.sendMessage")
    public void relayViaStomp(@Payload Map<String, Object> payload) {
        // 서버 시간/표시 필드는 프런트에서 렌더하거나, 필요시 여기서 추가해도 됨
        if(!payload.containsKey("sender") && payload.containsKey("userId")){
            payload.put("sender", payload.get("userId"));
        }
        // 단일 공개 topic (방 개념 필요시 /topic/room/{roomId} 로 바꿔)
        messagingTemplate.convertAndSend("/topic/public", payload);
    }
}
