package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.ProductCategory;

@Mapper
public interface ProductCategoryMapper {
	// 카테고리 목록
	List<HashMap<String,Object>> selectCategoryList(HashMap<String,Object> p);
    // 카테고리 추가
	int insertCategory(HashMap<String,Object> p);
    // 카테고리 수정
	int updateCategory(HashMap<String,Object> p);
    // 카테고리 삭제
	int deleteCategory(HashMap<String,Object> p);
    // 하위 카테고리 카운트
	int countChildren(HashMap<String,Object> p);
	int existsByNo(HashMap<String,Object> p);
    int existsNameUnderParent(HashMap<String,Object> p);
    int parentExists(HashMap<String,Object> p);
}
