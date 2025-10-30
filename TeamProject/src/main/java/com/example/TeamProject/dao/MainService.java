package com.example.TeamProject.dao;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.MainMapper;
import com.example.TeamProject.model.Banner; 
import com.example.TeamProject.model.Producer;
import com.example.TeamProject.model.BestProduct;


@Service 
public class MainService { 
    
    @Autowired
    private MainMapper mainMapper;
    
    // 1. 메인 배너 데이터 조회 (List<Banner> 반환)
    public List<Banner> selectMainBanners() {
        return mainMapper.selectMainBanners();
    }

    // 2. 입점 업체 데이터 조회 (List<Producer> 반환)
    public List<Producer> selectProducers() {
        return mainMapper.selectProducers();
    }

    // 3. 베스트 상품 데이터 조회 (List<BestProduct> 반환)
    public List<BestProduct> selectBestProducts() {
        return mainMapper.selectBestProducts();
    }
}