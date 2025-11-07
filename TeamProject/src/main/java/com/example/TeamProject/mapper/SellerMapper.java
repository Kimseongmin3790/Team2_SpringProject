package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.TeamProject.model.Order;
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
	List<Order> getRecentOrders(String sellerId);
	// 매출 내역 조회 (일별, 월별, 연도별)
	List<HashMap<String, Object>> getSalesHistory(HashMap<String, Object> paramMap);
	// 판매자 인증 상태 변경
	void updateSellerVerification(@Param("userId") String userId, @Param("status") String status);
	
}
