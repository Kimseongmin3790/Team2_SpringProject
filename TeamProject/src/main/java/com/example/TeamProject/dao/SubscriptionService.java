package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.SubscriptionMapper;

@Service
public class SubscriptionService {
	
	@Autowired
    SubscriptionMapper subscriptionMapper;
	
	// 메인용
    public HashMap<String, Object> getSubscriptionPlanMainList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = subscriptionMapper.selectSubscriptionPlanMainList(map);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println("selectSubscriptionPlanMainList 오류: " + e.getMessage());
        }
        return resultMap;
    }

    // 리스트 페이지용
    public HashMap<String, Object> getSubscriptionPlanList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = subscriptionMapper.selectSubscriptionPlanList(map);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println("selectSubscriptionPlanList 오류: " + e.getMessage());
        }
        return resultMap;
    }

    // 상세용
    public HashMap<String, Object> getSubscriptionPlanDetail(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            HashMap<String, Object> detail = subscriptionMapper.selectSubscriptionPlanDetail(map);
            resultMap.put("detail", detail);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println("getSubscriptionPlanDetail 오류: " + e.getMessage());
        }
        return resultMap;
    }
    
    public HashMap<String, Object> getSubscriptionPlanForPayment(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            HashMap<String, Object> detail = subscriptionMapper.selectSubscriptionPlanDetail(map);
            resultMap.put("plan", detail);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            System.out.println("getSubscriptionPlanForPayment 오류: " + e.getMessage());
        }
        return resultMap;
    }
    
    public void insertSubscription(HashMap<String, Object> map) {
        subscriptionMapper.insertSubscription(map);
    }
}
