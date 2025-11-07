package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.ChatMessage;
import com.example.TeamProject.model.ChatRoom;

@Mapper
public interface ChattingMapper {
	int insertChatMessage(HashMap<String, Object> map);

	List<ChatMessage> selectHistory(HashMap<String, Object> map);

	int insertChatRoom(HashMap<String, Object> map);

	Long selectRecentRoomNo();

	ChatRoom selectRoom(HashMap<String, Object> map);

	List<ChatRoom> selectMyRooms(HashMap<String, Object> map);

	int upsertParticipant(HashMap<String, Object> map);

	int leaveParticipant(HashMap<String, Object> map);

}
