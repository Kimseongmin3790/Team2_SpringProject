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
	// 상품 이미지 포함 리스트
	List<Product> selectAllProductList(HashMap<String, Object> map);
	// 상품 카테고리 필터
	List<ProductCategory> selectFilteredCategoryList(HashMap<String, Object> map);
	// 필터링 된 상품 리스트
	List<Product> selectFilteredProductList(HashMap<String, Object> map);
}
