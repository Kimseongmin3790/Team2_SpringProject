package com.example.TeamProject.model;

import java.util.Date;

import lombok.Data;

@Data
public class ChatRoomParticipant {
	private Long roomNo;
	private String userId;
	private String role;
	private String joinDate;
	private String leaveDate;
}