package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Cart;
import com.example.TeamProject.model.User;

@Mapper
public interface PaymentMapper {
	// 주문 정보 저장
	void insertOrder(HashMap<String, Object> map);
	
	// 결제 정보 저장
	void insertPayment(HashMap<String, Object> map);

	// 결제 리스트
	List<Cart> selectPaymentLines(Map<String, Object> map);
	
	// 유저 정보
	User selectUserInfo(HashMap<String, Object> map);
	
	// 주문 및 결제 정보 저장
	void insertOrderItem(HashMap<String, Object> map);
}
