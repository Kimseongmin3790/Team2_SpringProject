package com.example.TeamProject.model;

import lombok.Data;

import java.util.Date; 

@Data
public class ReviewImage {
    private int imageNo;
    private int reviewNo;
    private String imageUrl;
    private Date cdatetime; 
    private Date udatetime; 
}