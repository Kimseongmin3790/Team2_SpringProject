package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.MainMapper; // MainMapper를 사용합니다.
import com.example.TeamProject.model.Main;       // 배너 데이터를 담을 모델
import com.example.TeamProject.model.Producer;   // 입점 업체 데이터를 담을 모델
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.BestProduct; // 베스트 상품 데이터를 담을 모델

@Service
public class MainService {
	
	@Autowired
	MainMapper mainMapper; // DB 연결을 위한 Mapper

	// 1. 메인 배너 데이터 조회 (fnGetMainBanners용)
	public HashMap<String, Object> selectMainBanners() {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// Mapper에서 List<Main>을 가져옵니다.
			List<Main> list = mainMapper.selectMainBanners();			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	// 2. 메인 추천 데이터 조회
	public HashMap<String, Object> selectRecommendList() {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectRecommendList();
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	// 3. 메인 신상품 데이터 조회
	public HashMap<String, Object> selectNewList() {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectNewList();
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	// 4. 메인 농부 데이터 조회
	public HashMap<String, Object> selectSellerList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Producer> list = mainMapper.selectSellerList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	// 5. 농부 상세 데이터 조회
	public HashMap<String, Object> getSellerDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Producer seller = mainMapper.selectSellerDetail(map);
			List<Product> products = mainMapper.selectSellerProducts(map);
			
			resultMap.put("seller", seller);
			resultMap.put("products", products);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	// 6. 검색 데이터 조회
	public HashMap<String, Object> getSearchList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = mainMapper.selectSearchList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("MainService.selectMainBanners 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
}