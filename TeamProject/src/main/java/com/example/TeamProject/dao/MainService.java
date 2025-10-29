package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.MainMapper;
import com.example.TeamProject.model.Main; 

@Service // Service 단일 클래스 구현 (예시 코드 패턴)
public class MainService { 
    
    @Autowired
    private MainMapper mainMapper;
    
    // 1. 메인 배너 데이터 조회 및 포장
    public HashMap<String, Object> selectMainBanners() {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // DAO(Mapper) 호출
        List<Main.MainBannerVO> list = mainMapper.selectMainBanners();
        
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return resultMap;
    }

    // 2. 입점 업체 데이터 조회 및 포장
    public HashMap<String, Object> selectProducers() {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        List<Main.ProducerVO> list = mainMapper.selectProducers();
        
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return resultMap;
    }

    // 3. 베스트 상품 데이터 조회 및 포장
    public HashMap<String, Object> selectBestProducts() {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        List<Main.BestProductVO> list = mainMapper.selectBestProducts();
        
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return resultMap;
    }
}