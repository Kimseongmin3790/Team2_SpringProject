package com.example.TeamProject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;

@Mapper
public interface CategoryMapper {
	List<Product> selectProductList();
    List<ProductCategory> selectCategoryList();
}
