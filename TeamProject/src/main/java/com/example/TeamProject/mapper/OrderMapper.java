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
    // 주문 상태 수정
    int updateOrderStatus(HashMap<String, Object> map);
    // 배송정보 입력
    int insertDelivery(HashMap<String, Object> map);
    // 현재 주문 정보를 조회
    Order selectOrderForUpdate(HashMap<String, Object> map);
    // 주문 상태 일괄 변경
    int bulkUpdateOrderStatus(HashMap<String, Object> map);
    // 주문 상세 정보 조회
    Order selectOrderDetail(HashMap<String, Object> map);
    // 총 주문 건수 조회 메소드
    int selectOrderListCountBySeller(HashMap<String, Object> map);
    // 환불 
    int insertRefundRequest(HashMap<String, Object> paramMap);
    // 환불 요청 취소
    int deleteRefundRequest(HashMap<String, Object> paramMap);
    // 환불 요청 상태 변경 (승인/거절)
    int updateRefundStatus(HashMap<String, Object> paramMap);

 

    
    
}