package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.ChatService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ChatTestController {

	@Autowired
	ChatService chatService;

	@RequestMapping("/chat.do")
	public String chatPage() {
		return "product/chatting";
	}

	// ✅ 채팅방 조회: orderId가 있으면 orderId로, 없으면 (productNo+buyerId+sellerId)로
	@RequestMapping(value = "/chat/room.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getChatRoom(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = chatService.getChatRoom(map);
		Gson gson = new GsonBuilder().registerTypeAdapter(java.time.LocalDateTime.class,
				(com.google.gson.JsonSerializer<java.time.LocalDateTime>) (src, typeOfSrc,
						context) -> new com.google.gson.JsonPrimitive(src.toString()))
				.create();

		return gson.toJson(resultMap);

	}

	// ✅ 채팅방 생성: 이미 있으면 기존 방 반환
	@RequestMapping(value = "/chat/room/create.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String createChatRoom(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = chatService.createChatRoom(map);

		Gson gson = new GsonBuilder().registerTypeAdapter(java.time.LocalDateTime.class,
				(com.google.gson.JsonSerializer<java.time.LocalDateTime>) (src, typeOfSrc,
						context) -> new com.google.gson.JsonPrimitive(src.toString()))
				.create();

		return gson.toJson(resultMap);
	}

	@RequestMapping(value = "/chat/message/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String messageList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = chatService.getMessageList(map);
		Gson gson = new GsonBuilder().registerTypeAdapter(java.time.LocalDateTime.class,
				(com.google.gson.JsonSerializer<java.time.LocalDateTime>) (src, typeOfSrc,
						context) -> new com.google.gson.JsonPrimitive(src.toString()))
				.create();

		return gson.toJson(resultMap);
	}

	@RequestMapping(value = "/chat/message/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String messageAdd(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = chatService.addMessage(map);
		Gson gson = new GsonBuilder().registerTypeAdapter(java.time.LocalDateTime.class,
				(com.google.gson.JsonSerializer<java.time.LocalDateTime>) (src, typeOfSrc,
						context) -> new com.google.gson.JsonPrimitive(src.toString()))
				.create();

		return gson.toJson(resultMap);

	}

	@RequestMapping(value = "/chat/rooms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rooms(HttpServletRequest request) {
		String userId = (String) request.getSession().getAttribute("sessionId");
		HashMap<String, Object> resultMap = chatService.listMyRooms(userId);

		Gson gson = new GsonBuilder().registerTypeAdapter(java.time.LocalDateTime.class,
				(com.google.gson.JsonSerializer<java.time.LocalDateTime>) (src, typeOfSrc,
						context) -> new com.google.gson.JsonPrimitive(src.toString()))
				.create();

		return gson.toJson(resultMap);
	}

	@RequestMapping(value = "/chat/room/byRoomId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRoomByRoomId(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> result = chatService.getChatRoomByRoomId(map);
		Gson gson = new GsonBuilder().create();
		return gson.toJson(result);
	}

}