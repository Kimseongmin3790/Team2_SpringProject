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

    // (아래는 추후 구현)
    // int update(NoticeComment comment);
    // int delete(int commentNo);
}
