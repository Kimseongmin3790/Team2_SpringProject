package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.ChattingMapper;
import com.example.TeamProject.model.ChatMessage;
// import com.example.TeamProject.model.ChatMessage; // 필요 없으면 지워도 됨
import com.example.TeamProject.model.ChatRoom;

@Service
public class ChattingService {

	@Autowired
	ChattingMapper chattingMapper;

	// 방 생성 (room + owner upsert)
	// @Transactional // 정말 묶어야 한다면 주석 해제
	public HashMap<String, Object> createRoom(HashMap<String, Object> map) {
		HashMap<String, Object> out = new HashMap<>();
		try {
			int cnt = chattingMapper.insertChatRoom(map);
			// 같은 커넥션에서 CURRVAL 회수
			Long roomNo = chattingMapper.selectRecentRoomNo();
			// OWNER 참가 업서트
			if (roomNo != null && map.get("ownerId") != null) {
				HashMap<String, Object> p = new HashMap<>();
				p.put("roomNo", roomNo);
				p.put("userId", String.valueOf(map.get("ownerId")));
				p.put("role", "OWNER");
				chattingMapper.upsertParticipant(p);
			}
			out.put("result", (cnt > 0 && roomNo != null) ? "success" : "fail");
			out.put("roomNo", roomNo);
		} catch (Exception e) {
			out.put("result", "error");
			out.put("message", e.getMessage());
		}
		return out;
	}

	// 내 방 목록
	public HashMap<String, Object> myRooms(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<ChatRoom> list = chattingMapper.selectMyRooms(map);
			resultMap.put("result", "success");
			resultMap.put("list", list);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 입장 (없으면 insert, 있으면 상태만 갱신)
	// @Transactional
	public HashMap<String, Object> join(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = chattingMapper.upsertParticipant(map); // roomNo, userId, role(선택)
			resultMap.put("result", cnt >= 0 ? "success" : "fail");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 퇴장
	// @Transactional
	public HashMap<String, Object> leave(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = chattingMapper.leaveParticipant(map); // roomNo, userId
			resultMap.put("result", cnt > 0 ? "success" : "fail");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 메시지 저장
	// @Transactional
	public HashMap<String, Object> saveMessage(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// roomNo 숫자 강제
			Object r = map.get("roomNo");
			if (r != null)
				map.put("roomNo", Long.parseLong(String.valueOf(r)));

			System.out.println("[saveMessage] " + map);
			int cnt = chattingMapper.insertChatMessage(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
			resultMap.put("cnt", cnt);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 히스토리 (페이지네이션)
	public HashMap<String, Object> history(HashMap<String, Object> map) {
		HashMap<String, Object> out = new HashMap<>();
		try {
			int page = parseIntSafe(map.get("page"), 0);
			int pageSize = parseIntSafe(map.get("pageSize"), 50);
			map.put("offset", page * pageSize);
			map.put("pageSize", pageSize);

			List<ChatMessage> list = chattingMapper.selectHistory(map);
			out.put("result", "success");
			out.put("list", list);
		} catch (Exception e) {
			out.put("result", "error");
			out.put("message", e.getMessage());
		}
		return out;
	}

	private int parseIntSafe(Object v, int def) {
		try {
			return Integer.parseInt(String.valueOf(v));
		} catch (Exception e) {
			return def;
		}
	}
}
