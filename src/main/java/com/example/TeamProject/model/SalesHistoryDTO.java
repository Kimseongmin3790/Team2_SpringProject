package com.example.TeamProject.model;

import lombok.Data; 

@Data 
public class SalesHistoryDTO {
    private String period;      
    private long totalSales;    
    private long platformFee;
    private int orderCount;
    
    
}