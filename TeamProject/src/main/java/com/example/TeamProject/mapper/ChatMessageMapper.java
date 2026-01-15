package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.ChatMessage;

@Mapper
public interface ChatMessageMapper {
	
	List<ChatMessage> findByRoomId(HashMap<String, Object> map);

    int insertMessage(HashMap<String, Object> map);

}
