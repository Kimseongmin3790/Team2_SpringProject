package com.example.TeamProject.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;

@Mapper
public interface SellerMapper {
    
	// 판매자 정보 
	SellerVO getSellerInfo(String userId);
	// 농가 정보 수정 
	void updateSellerInfo(SellerVO sellerVO);
	// 사용자 정보 수정
	void updateUserInfo(User user);
	// 사용자 전화번호 수정
	void updateUserPhone(User user);
	// 판매자 계좌 정보 수정
	void updateSellerAccountInfo(SellerVO sellerVO);
}
