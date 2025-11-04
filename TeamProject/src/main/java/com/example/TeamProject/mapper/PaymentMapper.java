package com.example.TeamProject.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {
	// 주문 정보 저장
	void insertOrder(HashMap<String, Object> map);
	
	// 결제 정보 저장
	void insertPayment(HashMap<String, Object> map);
}
