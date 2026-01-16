package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.ChatRoom;

@Mapper
public interface ChatRoomMapper {	
	
	ChatRoom findByOrderId(HashMap<String, Object> map);
	
	int updateLastMessage(HashMap<String, Object> map);

	// ✅ productNo + buyerId + sellerId 로 찾기
	ChatRoom findByParticipants(HashMap<String, Object> map);

	// ✅ 방 생성 (roomId selectKey로 map에 넣어줌)
	void insertRoom(HashMap<String, Object> map);
	
	List<ChatRoom> listMyChatRooms(HashMap<String, Object> map);

}
	