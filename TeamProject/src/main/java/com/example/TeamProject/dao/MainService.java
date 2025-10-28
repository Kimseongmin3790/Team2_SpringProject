package com.example.TeamProject.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.MainMapper;

@Service
public class MainService {

	@Autowired
    private MainMapper mainMapper;

    public List<Map<String, Object>> getBestProducts() {
        // Map 리스트를 반환
        return mainMapper.selectBestProducts();
    }

    public List<Map<String, Object>> getMainBanners() {
        // Map 리스트를 반환
        return mainMapper.selectMainBanners();
    }

    public List<Map<String, Object>> getProducers() {
        // Map 리스트를 반환
        return mainMapper.selectProducers();
    }
}
