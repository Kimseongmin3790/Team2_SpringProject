package com.example.TeamProject.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.ChatMessageMapper;
import com.example.TeamProject.mapper.ChatRoomMapper;
import com.example.TeamProject.model.ChatRoom;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class ChatService {

	@Autowired
	ChatRoomMapper chatRoomMapper;

	@Autowired
	ChatMessageMapper chatMessageMapper;

	@Autowired
	private NotificationService notificationService;

	// ✅ 공통: 빈 값 정리 + 숫자 변환(필요할 때만)
	private Integer toIntOrNull(Object v) {
		if (v == null)
			return null;
		String s = String.valueOf(v).trim();
		if (s.isEmpty())
			return null;
		return Integer.valueOf(s);
	}

	private void normalizeParams(HashMap<String, Object> map) {
		// productNo (필수)
		Integer productNo = toIntOrNull(map.get("productNo"));
		if (productNo == null) {
			// productNo가 없으면 아예 처리 불가
			throw new IllegalArgumentException("productNo is required");
		}
		map.put("productNo", productNo);

		// orderId (선택) → 없으면 map에서 제거
		Integer orderId = toIntOrNull(map.get("orderId"));
		if (orderId == null) {
			map.remove("orderId");
		} else {
			map.put("orderId", orderId);
		}

		// buyerId / sellerId (필수)
		String buyerId = map.get("buyerId") == null ? "" : String.valueOf(map.get("buyerId")).trim();
		String sellerId = map.get("sellerId") == null ? "" : String.valueOf(map.get("sellerId")).trim();

		if (buyerId.isEmpty())
			throw new IllegalArgumentException("buyerId is required");
		if (sellerId.isEmpty())
			throw new IllegalArgumentException("sellerId is required");

		map.put("buyerId", buyerId);
		map.put("sellerId", sellerId);
	}

	public HashMap<String, Object> listMyRooms(String sessionId) {

		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> param = new HashMap<>();

		param.put("userId", sessionId);

		try {
			result.put("list", chatRoomMapper.listMyChatRooms(param));
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}

		return result;
	}

	public HashMap<String, Object> getChatRoom(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			normalizeParams(map);

			ChatRoom room = null;

			// 1) orderId가 있으면 orderId로 조회
			if (map.get("orderId") != null) {
				room = chatRoomMapper.findByOrderId(map);
			}

			// 2) 없으면 (productNo + buyerId + sellerId)
			if (room == null) {
				room = chatRoomMapper.findByParticipants(map);
			}

			resultMap.put("room", room);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> createChatRoom(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			normalizeParams(map);

			// ✅ 이미 있으면 기존 방 반환
			ChatRoom existing = chatRoomMapper.findByParticipants(map);
			if (existing != null) {
				resultMap.put("roomId", existing.getRoomId());
				resultMap.put("room", existing);
				resultMap.put("result", "success");
				return resultMap;
			}

			// ✅ orderId 없으면 insert 시 null로 들어가야 함 (map에 키가 없거나 null이면 OK)
			chatRoomMapper.insertRoom(map);

			resultMap.put("roomId", map.get("roomId"));
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getMessageList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("list", chatMessageMapper.findByRoomId(map));
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> addMessage(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			// 1) 메시지 저장
			chatMessageMapper.insertMessage(map);

			// 2) 방 last_message 갱신
			chatRoomMapper.updateLastMessage(map);

			// 3) 방 정보 조회해서 상대방 계산
			ChatRoom room = chatRoomMapper.findByRoomId(map);
			String senderId = String.valueOf(map.get("senderId"));

			String receiverId;
			if (senderId.equals(room.getBuyerId())) {
				receiverId = room.getSellerId();
			} else {
				receiverId = room.getBuyerId();
			}

			// 4) 알림 생성 (상대방에게)
			String pName = room.getPName(); // 너 ChatRoom에 pName 매핑돼있다고 가정
			String encPName = URLEncoder.encode(pName == null ? "" : pName, StandardCharsets.UTF_8);
			String msgPreview = String.valueOf(map.get("content"));
			if (msgPreview.length() > 30)
				msgPreview = msgPreview.substring(0, 30) + "...";

			String message = "[" + pName + "] 새 채팅: " + msgPreview;
			String linkUrl = "/chat.do" + "?roomId=" + room.getRoomId() + "&productNo=" + room.getProductNo()
					+ "&sellerId=" + URLEncoder.encode(room.getSellerId(), StandardCharsets.UTF_8) + "&buyerId="
					+ URLEncoder.encode(room.getBuyerId(), StandardCharsets.UTF_8) + "&pName=" + encPName;

			notificationService.sendNotification(receiverId, "CHAT", message, linkUrl);

			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> getChatRoomByRoomId(HashMap<String, Object> map) {
		HashMap<String, Object> res = new HashMap<>();
		try {
			ChatRoom room = chatRoomMapper.findByRoomId(map);
			res.put("room", room);
			res.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			res.put("result", "fail");
			res.put("message", e.getMessage());
		}
		return res;
	}

}
