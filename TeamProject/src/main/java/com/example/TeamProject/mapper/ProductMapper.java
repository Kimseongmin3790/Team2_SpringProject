package com.example.TeamProject.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;



@Mapper
public interface ProductMapper {
	// 상품 등록
	int insertProduct(HashMap<String, Object> map);
	// 상품 이미지 등록
	int insertProductImage(HashMap<String, Object> map);
}
