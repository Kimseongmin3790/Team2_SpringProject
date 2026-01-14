package com.example.TeamProject.model;

import lombok.Data; 

@Data
public class Banner {
    private String title; 
    private String imageUrl;
    private String linkUrl;
    private String displayOrder;
    private String isActive;
}