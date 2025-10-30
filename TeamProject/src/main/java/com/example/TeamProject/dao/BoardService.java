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
	     HashMap<String, Object> resultMap = new HashMap<String, Object>();
	     try {
	         // 1. 페이지 번호 설정 (없으면 1)
	         int page = 1;
	         if (map.get("page") != null && !map.get("page").equals("")) {
	             page = Integer.parseInt(String.valueOf(map.get("page")));
	         }

	         // 2. 페이지 사이즈 설정
	         int pageSize = 10; // 한 페이지에 10개씩 표시

	         // 3. 검색 조건에 맞는 전체 게시물 수 조회
	         int totalCount = boardMapper.selectNoticeCount(map);

	         // 4. 총 페이지 수 계산
	         int totalPage = (int) Math.ceil((double) totalCount / pageSize);
	         if (totalPage == 0) {
	             totalPage = 1;
	         }

	         // 5. 현재 페이지에 보여줄 시작/끝 행 번호 계산
	         int startRow = (page - 1) * pageSize + 1;
	         int endRow = page * pageSize;

	         // 6. DB 조회를 위한 파라미터 추가
	         map.put("startRow", startRow);
	         map.put("endRow", endRow);

	         // 7. 페이지에 해당하는 게시물 목록 조회
	         List<Board> list = boardMapper.selectNoticeList(map);
	         
	         // System.out.println("### 디버깅: totalCount = " + totalCount);
	         // System.out.println("### 디버깅: totalPage = " + totalPage);

	         // 8. 뷰로 전달할 결과 맵에 데이터 추가
	         resultMap.put("list", list);
	         resultMap.put("page", page);
	         resultMap.put("totalPage", totalPage);
	         resultMap.put("totalCount", totalCount);
	         resultMap.put("result", "success");

	     } catch (Exception e) {
	         e.printStackTrace(); 
	         resultMap.put("result", "fail");
	     }
	     return resultMap;
	 }
}
