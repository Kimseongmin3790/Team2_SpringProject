package com.example.TeamProject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.example.TeamProject.model.Main;       // 배너 모델
import com.example.TeamProject.model.Producer;   // 입점 업체 모델
import com.example.TeamProject.model.BestProduct; // 베스트 상품 모델

@Mapper // MyBatis 매퍼임을 나타냅니다.
public interface MainMapper {

    // 1. 메인 배너 리스트 조회
    // MainMapper.xml의 <select id="selectMainBanners"> 쿼리와 연결됩니다.
    public List<Main> selectMainBanners() throws Exception;

}