package com.example.TeamProject.model;

import lombok.Data;

@Data
public class NoticeComment {

    private int commentNo;
    private int noticeNo;
    private String userId;
    private String contents;
    private String cdatetime;
    private String udatetime;
    private Integer parentCommentNo;
    
    private int level;
}