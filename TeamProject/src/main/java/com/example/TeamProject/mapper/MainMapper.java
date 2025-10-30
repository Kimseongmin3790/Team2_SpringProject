package com.example.TeamProject.mapper; 

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.TeamProject.model.Banner; // Banner 모델 임포트
import com.example.TeamProject.model.Producer; // Producer 모델 임포트
import com.example.TeamProject.model.BestProduct; // BestProduct 모델 임포트

@Mapper 
public interface MainMapper {
    
    // 반환 타입을 List<Banner>로 변경
    List<Banner> selectMainBanners();

    // 반환 타입을 List<Producer>로 변경
    List<Producer> selectProducers();

    // 반환 타입을 List<BestProduct>로 변경
    List<BestProduct> selectBestProducts();
}