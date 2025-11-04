package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;



@Mapper
public interface ProductMapper {
	// 상품 등록
	int insertProduct(HashMap<String, Object> map);
	// 상품 이미지 등록
	int insertProductImage(HashMap<String, Object> map);
	// 상품 상세보기
	Product selectProduct(HashMap<String, Object> map);
	// 첨부파일 목록
	List<Product> selectImageList(HashMap<String, Object> map);
	// 추천 상품 목록
	List<Product> selectRecommendList(HashMap<String, Object> map);
	// 신 상품 목록
	List<Product> selectNewList();
	// 상품 리스트
	List<Product> selectProductList(HashMap<String, Object> map);
	// 상품 카테고리
    List<ProductCategory> selectCategoryList(HashMap<String, Object> map);
}
