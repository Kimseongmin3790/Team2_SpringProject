package com.example.TeamProject.model;

import lombok.Data;

import java.util.Date; 

@Data
public class Review {
    private int reviewNo;
    private String userId;
    private int productNo;
    private int orderItemNo;
    private int rating;
    private int recommend;
    private String content;
    private Date createdAt; 
    private Date uDatetime;
    
    private String productName;
    private String cdate;
    private String imageUrl;
    
    private String sellerName;
    private String orderdate;
    
}
