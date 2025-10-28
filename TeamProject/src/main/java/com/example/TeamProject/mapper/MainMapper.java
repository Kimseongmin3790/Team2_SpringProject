package com.example.TeamProject.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainMapper {
	
	// 베스트 상품 목록 반환 타입: List<Map>
    List<Map<String, Object>> selectBestProducts();

    // 메인 슬라이드 배너 목록 반환 타입: List<Map>
    List<Map<String, Object>> selectMainBanners();

    // 입점 업체 목록 반환 타입: List<Map>
    List<Map<String, Object>> selectProducers();

}
