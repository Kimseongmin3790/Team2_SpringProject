package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.ChatMessage;

@Mapper
public interface ChattingMapper {
    int insertChat(HashMap<String, Object> map);
    List<ChatMessage> selectHistory(HashMap<String, Object> map);
    int selectHistoryCnt(HashMap<String, Object> map);
}
