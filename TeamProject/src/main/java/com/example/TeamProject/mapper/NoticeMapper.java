package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Notice;

@Mapper
public interface NoticeMapper {
	
	// 공지사항 글 리스트
	List<Notice> selectNoticeList(HashMap<String, Object> map);
	// 공지사항 게시물 수
	int selectNoticeCount(HashMap<String, Object> map);
	// 공지사항 상세 정보 조회
	Notice selectNoticeInfo(int noticeNo);
	// 공지사항 조회수 증가
	void updateNoticeCnt(int noticeNo);
	// 공지사항 삭제
	void deleteNotice(int noticeNo);
	// 공지 수정
	int updateNotice(HashMap<String, Object> map);
	// 공지 작성
	int saveNotice(HashMap<String, Object> map);
	// 최신 공지사항 n개 가져오기
	List<Notice> selectLatestNotices(HashMap<String, Object> map);
	
}
