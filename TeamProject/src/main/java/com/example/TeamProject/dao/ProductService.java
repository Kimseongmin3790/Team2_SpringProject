package com.example.TeamProject.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.ProductMapper;

@Service
public class ProductService {
	
	@Autowired
	ProductMapper productMapper;
	
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
}
