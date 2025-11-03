package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.MainMapper; // MainMapper를 사용합니다.
import com.example.TeamProject.model.Main;       // 배너 데이터를 담을 모델
import com.example.TeamProject.model.Producer;   // 입점 업체 데이터를 담을 모델
import com.example.TeamProject.model.BestProduct; // 베스트 상품 데이터를 담을 모델

@Service
public class MainService {
	
	@Autowired
	MainMapper mainMapper; // DB 연결을 위한 Mapper

	// ----------------------------------------------------
	// 1. 메인 배너 데이터 조회 (fnGetMainBanners용)
	// ----------------------------------------------------
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
}