package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.CommonMapper;
import com.example.TeamProject.model.Order;
import com.example.TeamProject.model.ProductCategory;

@Service
public class CommonService {

    @Autowired
    CommonMapper commonMapper;

    
//      구매자 ID로 주문 목록을 조회하는 서비스
    public HashMap<String, Object> getOrdersByBuyerId(HashMap<String, Object> map) {

        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<Order> orderList = commonMapper.selectOrdersByBuyerId(map);

            resultMap.put("list", orderList);
            resultMap.put("result", "success");

        } catch (Exception e) {
         
            System.out.println("주문 목록 조회 중 에러 발생: " + e.getMessage());

            e.printStackTrace();

            resultMap.put("result", "fail");
            resultMap.put("message", "데이터를 불러오는 중 오류가 발생했습니다.");
        }

        return resultMap;
    }
    // 문의글 등록 서비스
    public HashMap<String, Object> inquiryAdd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = commonMapper.inquiryInsert(map);
		
		resultMap.put("inquiryNo",map.get("inquiryNo"));
		resultMap.put("result","success");
		return resultMap;
	}
    
    // 최상위 카테고리 확인
    
    public HashMap<String, Object> allCategory(HashMap<String, Object> map) {

        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<ProductCategory> categoryList  = commonMapper.getAllCategory(map);

            resultMap.put("list", categoryList );
            resultMap.put("result", "success");

        } catch (Exception e) {
         
            System.out.println("주문 목록 조회 중 에러 발생: " + e.getMessage());

            e.printStackTrace();

            resultMap.put("result", "fail");
            resultMap.put("message", "데이터를 불러오는 중 오류가 발생했습니다.");
        }

        return resultMap;
    }
}
