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
}