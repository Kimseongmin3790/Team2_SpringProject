package com.example.TeamProject.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.TeamProject.model.NoticeComment;

@Mapper
public interface NoticeCommentMapper {

	// 댓글 조회
    List<NoticeComment> findByNoticeNo(int noticeNo);
    // 댓글 작성
    int save(NoticeComment comment);
    // 댓글 수정
    int update(NoticeComment comment);
    // 댓글 삭제
    int delete(int commentNo);
    // 댓글 조회
    NoticeComment findById(int commentNo);
}
