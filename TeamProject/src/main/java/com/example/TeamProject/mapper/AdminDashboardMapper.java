package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.AdminDashboard;

@Mapper
public interface AdminDashboardMapper {
	// 소비자 판매자 카운트
	List<AdminDashboard> selectUserCountByRole();
	// 나이대별 성별 카운트
    List<AdminDashboard> selectAgeGenderDistribution();
    // 지역별 카운트
    List<AdminDashboard> selectRegionRatio();
    // 월별 판매금액 카운트
    List<AdminDashboard> selectSalesByMonth(HashMap<String, Object> params);
    // 월별 신규 유저 카운트
    List<AdminDashboard> selectNewUserTrend(HashMap<String, Object> params);
    // 남녀 성별 카운트
    List<AdminDashboard> selectGenderRatio();
}
