package com.example.TeamProject.mapper;

import org.apache.ibatis.annotations.Mapper; 
import com.example.TeamProject.model.SellerVO;


public interface SellerMapper {
    
	// 판매자 정보 
	SellerVO getSellerInfo(String userId);
}
