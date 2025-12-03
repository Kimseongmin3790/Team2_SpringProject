package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.RegionMapper;

@Service
public class RegionService {
	@Autowired
	RegionMapper regionMapper;
	
	public HashMap<String, Object> getRegionSpecialList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> list = regionMapper.selectRegionSpecialList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("regionMapper.selectRegionSpecialList 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getRegionSpecialById(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			HashMap<String, Object> header = regionMapper.selectRegionSpecialById(map);
			List<HashMap<String, Object>> products = regionMapper.selectRegionSpecialProducts(map);
			
			resultMap.put("header", header);
			resultMap.put("products", products);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("regionMapper.selectRegionSpecialById 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getRegionSpecialProducts(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> list = regionMapper.selectRegionSpecialProducts(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("regionMapper.selectRegionSpecialProducts 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
}
