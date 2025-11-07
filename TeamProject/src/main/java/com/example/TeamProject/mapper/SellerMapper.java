package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

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
	// 오늘 주문 건수 조회
	int getTodayOrdersCount(String sellerId);
	// 오늘 매출액 조회
	Long getTodaySalesAmount(String sellerId);
	// 총 등록 상품 수 조회
	int getTotalProductsCount(String sellerId);
	// 상품 평균 평점 조회
	Double getAverageRating(String sellerId);
	// 최근 주문 목록 조회
	List<HashMap<String, Object>> getRecentOrders(String sellerId);
}
