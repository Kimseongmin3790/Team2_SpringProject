package com.example.TeamProject.model;

import lombok.Data; // Lombok 임포트 추가

@Data 
public class SalesHistoryDTO {
    private String period;      
    private long totalSales;    
    private long platformFee;
}