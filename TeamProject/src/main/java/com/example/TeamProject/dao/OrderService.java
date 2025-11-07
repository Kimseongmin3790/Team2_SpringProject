package com.example.TeamProject.dao;

import com.example.TeamProject.mapper.OrderMapper;
import com.example.TeamProject.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.HashMap;

@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    public HashMap<String, Object> getOrderHistory(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            if (userId == null || userId.isEmpty()) {
                throw new Exception("로그인이 필요합니다.");
            }

            List<Order> orderList = orderMapper.selectOrderHistoryByUserId(userId);
        
            resultMap.put("list", orderList);
            resultMap.put("result", "success");

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }
    
    // 판매자 ID로 주문목록 조회
    public HashMap<String, Object> getOrderListBySeller(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String sellerId = (String) map.get("sellerId");
            if (sellerId == null || sellerId.isEmpty()) {
                throw new Exception("판매자 ID가 필요합니다.");
            }

     
            List<Order> orderList = orderMapper.selectOrderListBySeller(map);

            resultMap.put("list", orderList);
            resultMap.put("result", "success");

        } catch (Exception e) {
            System.out.println("판매자 주문 목록 조회 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }

        return resultMap;
    }
}