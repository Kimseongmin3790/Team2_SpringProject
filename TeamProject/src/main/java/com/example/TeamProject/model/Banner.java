package com.example.TeamProject.model;

import lombok.Data; 

@Data
public class Banner {
    private int id; 
    private String title;
    private String imageUrl; // DB 컬럼과 일치하지 않으므로 SQL에서 별칭 사용 예정
    private String linkUrl;
}