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
    
    public HashMap<String, Object> getPlanById(int planId) {
        return subscriptionMapper.selectPlanById(planId);
    }
    
    public int insertSubscriptionOrder(HashMap<String, Object> map) {
    	return subscriptionMapper.insertSubscriptionOrder(map);
    }
    
    public int updateSubscriptionAfterPaid(HashMap<String, Object> map) {
        return subscriptionMapper.updateSubscriptionAfterPaid(map);
    }
    
    public HashMap<String, Object> getSubscriptionHistory(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            if (userId == null || userId.isBlank()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            List<HashMap<String, Object>> list = subscriptionMapper.selectUserSubscriptions(userId);

            // ✅ period/status 라벨 매핑 (서버에서 같이 내려주기)
            for (HashMap<String, Object> row : list) {
                String periodType = String.valueOf(row.get("periodType"));
                String status = String.valueOf(row.get("status"));

                row.put("periodTypeLabel", toPeriodLabel(periodType));
                row.put("statusLabel", toSubStatusLabel(status));
            }

            resultMap.put("result", "success");
            resultMap.put("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }

        return resultMap;
    }

    private String toPeriodLabel(String type) {
        if (type == null) return "정기배송";
        switch (type.toUpperCase()) {
            case "WEEKLY": return "주 1회";
            case "BIWEEKLY": return "격주 1회";
            case "MONTHLY": return "월 1회";
            default: return "정기배송";
        }
    }

    private String toSubStatusLabel(String status) {
        if (status == null) return "진행중";
        switch (status.toUpperCase()) {
            case "ACTIVE": return "진행중";
            case "PAUSED": return "일시중지";
            case "CANCELLED": return "해지";
            case "EXPIRED": return "만료";
            default: return status; // 혹시 다른 값이면 그대로 노출
        }
    }

}
