package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RegionMapper {
	// 지역별 특산물 전체 리스트 (리스트 페이지용)
    List<HashMap<String, Object>> selectRegionSpecialList(HashMap<String, Object> map);

    // 지역별 특산물 상세 (헤더 정보)
    HashMap<String, Object> selectRegionSpecialById(HashMap<String, Object> map);

    // 해당 지역 특산 박스에 포함된 상품 목록
    List<HashMap<String, Object>> selectRegionSpecialProducts(HashMap<String, Object> map);
}
