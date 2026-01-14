package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SubscriptionMapper {
	
	// 메인 페이지용 (최대 4개)
    List<HashMap<String, Object>> selectSubscriptionPlanMainList(HashMap<String, Object> map);
    
	// 플랜 전체 리스트
    List<HashMap<String, Object>> selectSubscriptionPlanList(HashMap<String, Object> map);

    // 플랜 상세
    HashMap<String, Object> selectSubscriptionPlanDetail(HashMap<String, Object> map);
    
    void insertSubscription(HashMap<String, Object> map);
}
