package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.example.TeamProject.model.Order;
import com.example.TeamProject.model.OrderItem;

public interface OrderMapper {

    // userId로 주문목록 조회
    List<Order> selectOrderHistoryByUserId(@Param("userId") String userId);
    // 특정주문번호 조회
    List<OrderItem> selectOrderItemsByOrderNo(@Param("orderNo") int orderNo);
    // 판매자 ID로 주문목록 조회
    List<Order> selectOrderListBySeller(HashMap<String, Object> map);
}