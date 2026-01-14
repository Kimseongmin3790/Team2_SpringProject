package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.WishListMapper;
import com.example.TeamProject.model.Product;

@Service
public class WishListService {
	
	@Autowired
	WishListMapper wishListMapper;
	
	// 찜 여부 확인 (0: 안함, 1: 함) DB 확인용
	public int checkWishList(HashMap<String, Object> map) {
	    try {
	        return wishListMapper.checkWishList(map);
	    } catch (Exception e) {
	        return 0;
	    }
	}

	// 찜 등록/해제 토글 기능
	public HashMap<String, Object> toggleWishList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        int count = wishListMapper.checkWishList(map);
	        if (count > 0) {
	            wishListMapper.deleteWishList(map);
	            resultMap.put("status", "removed");
	        } else {
	            wishListMapper.insertWishList(map);
	            resultMap.put("status", "added");
	        }
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}
	
	// 찜 선택 삭제 (다중 삭제)
	public HashMap<String, Object> deleteWishListMulti(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        wishListMapper.deleteWishListMulti(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}


	// 찜한 상품 리스트 조회
	public HashMap<String, Object> getWishList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        List<Product> list = wishListMapper.selectWishList(map);
	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	// 찜 상태 확인 화면 확인용
	public HashMap<String, Object> getWishListStatus(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        int count = wishListMapper.checkWishList(map);
	        resultMap.put("result", "success");
	        resultMap.put("isWish", count > 0); // 찜 여부 true/false
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}

}
