package com.example.TeamProject.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatRoom {
	 private int roomId;
	 private int orderId;
	 private String buyerId;
	 private String sellerId;

	 private int lastMessageId;
	 private LocalDateTime lastMessageAt;

	 private int buyerLastReadMessageId;
	 private int sellerLastReadMessageId;
	 private int productNo;
}
