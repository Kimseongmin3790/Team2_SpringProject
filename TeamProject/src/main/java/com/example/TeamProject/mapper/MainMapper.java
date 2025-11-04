package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.TeamProject.model.Main;       // 배너 모델
import com.example.TeamProject.model.Producer;   // 입점 업체 모델
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.BestProduct; // 베스트 상품 모델

@Mapper // MyBatis 매퍼임을 나타냅니다.
public interface MainMapper {

    // 메인 배너 리스트 조회    
    public List<Main> selectMainBanners() throws Exception;
    
    // 메인 추천 리스트 조회
    List<Main> selectRecommendList();
    
    // 메인 신상품 리스트 조회
    List<Main> selectNewList();
    
    // 메인 농부 리스트 조회
    List<Producer> selectSellerList(HashMap<String, Object> map);
    
    // 농부 상세 정보 조회
    Producer selectSellerDetail(HashMap<String, Object> map);
    
    // 농부가 판매하는 상품 조회
    List<Product> selectSellerProducts(HashMap<String, Object> map);
    
    // 검색 결과 조회(제목, 내용)
    List<Product> selectSearchList(HashMap<String, Object> map);
    
    // 유저 좌표 조회
    HashMap<String, Object> selectUserLocation(@Param("userId") String userId);
}