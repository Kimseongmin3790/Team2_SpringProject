package com.example.TeamProject.model;

import lombok.Data; 

@Data // @Getter, @Setter, @ToString 등을 자동으로 생성합니다.
public class Main {
    
    private int productNo;
    private String pname;
    private String pinfo;
    private int price;
    private int categoryNo;
    private String recommend;
    private String imageUrl;
    
}