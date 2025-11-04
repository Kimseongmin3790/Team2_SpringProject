package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.AdminMapper;
import com.example.TeamProject.mapper.ProductMapper;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;

@Service
public class ProductService {

	@Autowired
	ProductMapper productMapper;

	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> insertProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			productMapper.insertProduct(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		resultMap.put("productNo", map.get("productNo"));
		return resultMap;
	}

	public HashMap<String, Object> insertProductImage(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			productMapper.insertProductImage(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			Product product = productMapper.selectProduct(map);
			List<Product> fileList = productMapper.selectImageList(map);
			resultMap.put("info", product);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getProductAndCategoryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            List<Product> products = productMapper.selectProductList(map);
            List<ProductCategory> categories = productMapper.selectCategoryList(map);
            resultMap.put("list", products);
            resultMap.put("categories", categories);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println(e.getMessage());
        }
        return resultMap;
    }
	
}
