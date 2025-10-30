package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Board;

@Mapper
public interface BoardMapper {
	
	// 공지사항 글 리스트
	List<Board> selectNoticeList(HashMap<String, Object> map);
	// 공지사항 게시물 수
	int selectNoticeCount(HashMap<String, Object> map);
	// 공지사항 글 리스트
	
	
}
