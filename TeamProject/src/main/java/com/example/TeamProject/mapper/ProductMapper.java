package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Product;



@Mapper
public interface ProductMapper {
	// 상품 등록
	int insertProduct(HashMap<String, Object> map);
	// 상품 이미지 등록
	int insertProductImage(HashMap<String, Object> map);
	// 상품 상세보기
	Product selectProduct(HashMap<String, Object> map);
	//첨부파일 목록
	List<Product> selectImageList(HashMap<String, Object> map);
}
