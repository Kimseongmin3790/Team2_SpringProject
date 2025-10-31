package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Answer;
import com.example.TeamProject.model.Board;

@Mapper
public interface BoardMapper {
	
	// 고객문의 글 리스트
	List<Board> selectInquiryList(HashMap<String, Object> map);
	// 고객문의 글 카운트(페이지네이션용)
	int countInquiry(HashMap<String, Object> map);
	// 고객문의 글 조회수 증가
	int updateInquiryCount(int inquiryNo);
	// 고객문의 상세내용 조회
	Board selectInquiryDetail(int inquiryNo);
	// 잠금 문의 비밀번호 확인
	String selectInquiryPwd(int inquiryNo);
	// 문의 답변 글 조회
	Answer selectAnswer(int inquiryNo);
	// 답변 등록
	int insertAnswer(HashMap<String, Object> map);
	// 문의 글 상태 변경
	int updateInquiryStatusAnswered(int inquiryNo);
	// 문의 글 등록
	int insertInquiry(HashMap<String, Object> map);
	// 문의 글 수정
	int updateInquiry(HashMap<String, Object> map);
	// 문의 글 삭제
	int deleteInquiry(HashMap<String, Object> map);
	// 문의 글 답변 삭제
	int deleteInquiryAnswer(HashMap<String, Object> map);
}
