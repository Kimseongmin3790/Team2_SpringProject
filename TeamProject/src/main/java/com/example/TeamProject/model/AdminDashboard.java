package com.example.TeamProject.model;

import lombok.Data;

@Data
public class AdminDashboard {
	
	private String userRole;
	private int cnt;
	private String ageGroup;
	private String userGender;
	private String region;
	private String orderMonth;
	private int totalSales;
	private String joinMonth;
}
