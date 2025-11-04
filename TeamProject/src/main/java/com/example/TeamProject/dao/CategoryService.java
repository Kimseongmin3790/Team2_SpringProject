package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.CategoryMapper;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;

@Service
public class CategoryService {
	
	@Autowired
    private CategoryMapper categoryMapper;
    
    public HashMap<String, Object> getProductAndCategoryList() {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<Product> products = categoryMapper.selectProductList();
            List<ProductCategory> categories = categoryMapper.selectCategoryList();
            resultMap.put("list", products);
            resultMap.put("categories", categories);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println("[Service Error] " + e.getMessage());
        }
        return resultMap;
    }

}
