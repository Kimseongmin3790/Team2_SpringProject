package com.example.TeamProject.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.AdminDashboardMapper;

@Service
public class AdminDashboardService {
	
	@Autowired
	AdminDashboardMapper adminDashboardMapper;
	
	public HashMap<String, Object> getStats(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			resultMap.put("userCount", adminDashboardMapper.selectUserCountByRole());
			resultMap.put("ageGenderDistribution", adminDashboardMapper.selectAgeGenderDistribution());
			resultMap.put("regionRatio", adminDashboardMapper.selectRegionRatio());                   
			resultMap.put("salesByMonth", adminDashboardMapper.selectSalesByMonth(map)); 
			resultMap.put("newUserTrend", adminDashboardMapper.selectNewUserTrend(map));
			resultMap.put("genderCount", adminDashboardMapper.selectGenderRatio());
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
}
