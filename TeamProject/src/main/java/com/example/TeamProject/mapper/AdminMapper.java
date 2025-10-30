package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;

@Mapper
public interface AdminMapper {
	// 유저 목록
	List<User> selectUserList(HashMap<String, Object> map);
	// 판매자 승인
	int approveSeller(HashMap<String, Object> map);
	// 모든 유저 수
	int allUserCount();
	// 모든 상품 수
	int allProductCount();
	// 총 주문 수
	int allOrdersCount();
	// 오늘 주문 수
	int todayOrders();
	// 상품 목록
	List<Product> selectProductList(HashMap<String, Object> map);
	// 카테고리 목록
	List<ProductCategory> selectCategoryList(HashMap<String, Object> map);
	// 소비자기준 가장 가까운 판매자 3명 거리계산
	List<SellerVO> selectNearestSellers(HashMap<String, Object> map);
}
