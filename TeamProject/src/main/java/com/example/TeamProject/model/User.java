package com.example.TeamProject.model;

import lombok.Data;

@Data
public class User {
	private String userId;
	private String password;
	private String name;
	private String email;
	private String phone;
	private String userRole;
	private String address;
	private String cdatetime;
	private String totalPoint;
}
