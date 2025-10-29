package com.example.TeamProject.mapper; 

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.TeamProject.model.Main; // 단일 Model 파일 import

@Mapper 
public interface MainMapper {
    
    // Main.java 내의 중첩 클래스를 반환 타입으로 지정
    List<Main.MainBannerVO> selectMainBanners();

    List<Main.ProducerVO> selectProducers();

    List<Main.BestProductVO> selectBestProducts();
}