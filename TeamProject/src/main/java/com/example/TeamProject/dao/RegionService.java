package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.RegionMapper;

@Service
public class RegionService {
	@Autowired
	RegionMapper regionMapper;
	
	public HashMap<String, Object> getRegionSpecialList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> list = regionMapper.selectRegionSpecialList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("regionMapper.selectRegionSpecialList 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getRegionSpecialById(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			HashMap<String, Object> header = regionMapper.selectRegionSpecialById(map);
			List<HashMap<String, Object>> products = regionMapper.selectRegionSpecialProducts(map);
			
			for (HashMap<String, Object> p : products) {
				Integer productNo = (p.get("productNo") == null) ? null : Integer.parseInt(String.valueOf(p.get("productNo")));
	            if (productNo != null) {
	                List<HashMap<String, Object>> options = regionMapper.selectProductOptionList(productNo);
	                p.put("options", options);
	            }
			}
			
			resultMap.put("header", header);
			resultMap.put("products", products);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println("regionMapper.selectRegionSpecialById 오류: " + e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getAllRegionSpecialList() {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        List<HashMap<String, Object>> list = regionMapper.selectAllRegionSpecialList();
	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	        System.out.println("regionMapper.selectRegionSpecialList 오류: " + e.getMessage());
	    }
	    return resultMap;
	}
	
//	public HashMap<String,Object> addBundleToCart(HashMap<String,Object> map, HttpSession session) {
//	    HashMap<String,Object> res = new HashMap<>();
//	    try {
//	        String userId = (String) session.getAttribute("sessionId");
//	        if (userId == null || userId.isBlank()) {
//	            res.put("result", "fail");
//	            res.put("code", "LOGIN_REQUIRED");
//	            res.put("message", "로그인이 필요합니다.");
//	            return res;
//	        }
//
//	        String itemsJson = String.valueOf(map.get("itemsJson"));
//	        if (itemsJson == null || itemsJson.isBlank()) {
//	            res.put("result", "fail");
//	            res.put("message", "itemsJson이 없습니다.");
//	            return res;
//	        }
//
//	        // itemsJson 파싱
//	        List<HashMap<String,Object>> items =
//	            new Gson().fromJson(itemsJson, new com.google.gson.reflect.TypeToken<List<HashMap<String,Object>>>(){}.getType());
//
//	        List<Long> cartNos = new ArrayList<>();
//
//	        for (HashMap<String,Object> it : items) {
//	            Integer productNo = toInt(it.get("productNo"), null);
//	            Integer optionNo  = toInt(it.get("optionNo"), null);
//	            Integer quantity  = Math.max(1, toInt(it.get("quantity"), 1));
//
//	            if (productNo == null || optionNo == null) {
//	                throw new IllegalStateException("상품/옵션 정보가 올바르지 않습니다.");
//	            }
//
//	            // ✅ 기존 cart/add.dox의 로직을 재사용하는 방식으로 userService.addCart 호출
//	            HashMap<String,Object> clean = new HashMap<>();
//	            clean.put("userId", userId);
//	            clean.put("productNo", productNo);
//	            clean.put("optionNo", optionNo);
//	            clean.put("quantity", quantity);
//	            clean.put("fulfillment", "delivery");
//	            clean.put("shippingFee", 3000);
//
//	            HashMap<String,Object> r = userService.addCart(clean);
//
//	            Long cartNo = (r.get("cartNo") == null) ? null : Long.parseLong(String.valueOf(r.get("cartNo")));
//	            if (cartNo != null) cartNos.add(cartNo);
//	        }
//
//	        res.put("result", "success");
//	        res.put("cartNos", cartNos.stream().map(String::valueOf).reduce((a,b)->a+","+b).orElse(""));
//	        return res;
//
//	    } catch (Exception e) {
//	        res.put("result", "fail");
//	        res.put("message", e.getMessage());
//	        return res;
//	    }
//	}
	
}
