package com.example.TeamProject.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatRoom {
	 private Long roomId;
	 private Long orderId;
	 private String buyerId;
	 private String sellerId;
	 private String pName;

	 private Long lastMessageId;
	 private LocalDateTime lastMessageAt;

	 private Long buyerLastReadMessageId;
	 private Long sellerLastReadMessageId;
	 
	 private java.sql.Timestamp cdatetime;
	 private java.sql.Timestamp udatetime;
	 private Long productNo;
	 private String sellerProfileImg;
}
