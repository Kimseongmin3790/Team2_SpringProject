package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Order;
import com.example.TeamProject.model.ProductCategory;

@Mapper
public interface CommonMapper {
	
	// 고객 주문 리스트
	List<Order> selectOrdersByBuyerId(HashMap<String, Object> map);
	// 문의글 추가
	int inquiryInsert(HashMap<String, Object> map);
	// 최상위 카테고리 목록 가져오기
	List<ProductCategory> getAllCategory(HashMap<String, Object> map);
	// 입점 등록
	int insertSellerInfo(HashMap<String, Object> map);
}
