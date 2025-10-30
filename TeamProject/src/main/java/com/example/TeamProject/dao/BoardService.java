package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.BoardMapper;
import com.example.TeamProject.model.Board;

@Service
public class BoardService {
	
	@Autowired
	BoardMapper boardMapper;
	
	public HashMap<String, Object> getNoticeList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Board> list = boardMapper.selectNoticeList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
