package com.example.TeamProject.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.TeamProject.mapper.RegionMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Service
public class RegionService {
	@Autowired
	RegionMapper regionMapper;
	@Autowired
	UserService userService;
	
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
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addBundleToCart(HashMap<String, Object> map, HttpSession session) {

	    HashMap<String, Object> res = new HashMap<>();

	    try {
	        String userId = (String) session.getAttribute("sessionId");
	        if (userId == null || userId.isBlank()) {
	            res.put("result", "fail");
	            res.put("code", "LOGIN_REQUIRED");
	            res.put("message", "로그인이 필요합니다.");
	            return res;
	        }

	        Object raw = map.get("itemsJson");
	        if (raw == null) {
	            res.put("result", "fail");
	            res.put("message", "itemsJson이 없습니다.");
	            return res;
	        }

	        String itemsJson = String.valueOf(raw).trim();
	        if (itemsJson.isBlank() || "null".equalsIgnoreCase(itemsJson)) {
	            res.put("result", "fail");
	            res.put("message", "itemsJson이 비어있습니다.");
	            return res;
	        }

	        // itemsJson 파싱
	        List<HashMap<String, Object>> items =
	            new Gson().fromJson(itemsJson,
	                new com.google.gson.reflect.TypeToken<List<HashMap<String, Object>>>(){}.getType());

	        if (items == null || items.isEmpty()) {
	            res.put("result", "fail");
	            res.put("message", "구성 상품이 없습니다.");
	            return res;
	        }

	        // ✅ cartNos 중복 방지
	        java.util.LinkedHashSet<Long> cartNoSet = new java.util.LinkedHashSet<>();

	        for (HashMap<String, Object> it : items) {
	            Integer productNo = toInt(it.get("productNo"), null);
	            Integer optionNo  = toInt(it.get("optionNo"), null);
	            Integer quantity  = Math.max(1, toInt(it.get("quantity"), 1));

	            if (productNo == null || optionNo == null) {
	                throw new IllegalStateException("상품/옵션 정보가 올바르지 않습니다.");
	            }

	            // ✅ (추천) 옵션 유효성 + 재고 체크 (Mapper 하나 만들면 됨)
	            // HashMap<String,Object> opt = regionMapper.selectOptionForBundle(productNo, optionNo);
	            // if (opt == null) throw new IllegalStateException("옵션이 존재하지 않거나 비활성 상태입니다.");
	            // int stock = toInt(opt.get("stockQty"), 0);
	            // if (stock < quantity) throw new IllegalStateException("재고가 부족합니다.");

	            HashMap<String, Object> clean = new HashMap<>();
	            clean.put("userId", userId);
	            clean.put("productNo", productNo);
	            clean.put("optionNo", optionNo);
	            clean.put("quantity", quantity);
	            clean.put("fulfillment", "delivery");

	            // ✅ 번들에서는 라인별 shippingFee 저장하지 말고 0 권장
	            clean.put("shippingFee", 0);

	            HashMap<String, Object> r = userService.addCart(clean);

	            Long cartNo = (r.get("cartNo") == null) ? null : Long.parseLong(String.valueOf(r.get("cartNo")));
	            if (cartNo != null) cartNoSet.add(cartNo);
	        }

	        res.put("result", "success");
	        res.put("cartNos", cartNoSet.stream().map(String::valueOf).reduce((a, b) -> a + "," + b).orElse(""));
	        return res;

	    } catch (Exception e) {
	        res.put("result", "fail");
	        res.put("message", e.getMessage());
	        return res;
	    }
	}
	
	
	private Integer toInt(Object v, Integer def) {
		if (v == null) return def;
	    if (v instanceof Number) return ((Number) v).intValue();
	    try {
	        String s = v.toString().trim();
	        if (s.isEmpty() || "null".equalsIgnoreCase(s)) return def;
	        // 1,000 같은 포맷 혹시 대비
	        s = s.replaceAll(",", "");
	        return new java.math.BigDecimal(s).intValue();
	    } catch (Exception e) {
	        return def;
	    }
	}
	
}
