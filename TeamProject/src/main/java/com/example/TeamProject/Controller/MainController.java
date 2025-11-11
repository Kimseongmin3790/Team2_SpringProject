package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 뷰 반환과 데이터 응답을 모두 처리하기 위해 @Controller 유지
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.MainService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession; 

@Controller
@RequestMapping("/")
public class MainController {

	@Autowired
	private MainService mainService;

	// 1. 메인 페이지 JSP 반환 메서드
	@GetMapping("/main.do")
	public String main() throws Exception {
		return "main/main";
	}
	
	// 2. 판매자 페이지 JSP 반환 메서드
	@GetMapping("/seller/detail.do")
	public String sellerDetail() throws Exception {
		return "main/sellerDetail";
	}
	
	@GetMapping("/map/nearby.do")
	public String nearby() throws Exception {
		return "map/nearby-map";
	}
	

	// 3. 메인 배너 데이터 응답
	@RequestMapping(value = "/main/data/banners", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMainBannersData() throws Exception {
		HashMap<String, Object> resultMap = mainService.selectMainBanners();
        
		@SuppressWarnings("unchecked")
		List<?> list = (List<?>) resultMap.get("list");
		
		return new Gson().toJson(list); 
	}
	
	// 4. 메인 추천 데이터 응답
	@RequestMapping(value = "/main/data/recommend.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRecommendProducts() throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
        resultMap = mainService.selectRecommendList();
        return new Gson().toJson(resultMap);
    }
	
	// 5. 메인 신상품 데이터 응답
	@RequestMapping(value = "/main/data/newList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String newList() throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
        resultMap = mainService.selectNewList();
        return new Gson().toJson(resultMap);
    }
	
	// 6. 메인 입점 농가 데이터 응답
	@RequestMapping(value = "/main/data/sellerList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sellerList(@RequestParam(required = false) Double lat, @RequestParam(required = false) Double lng) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		HashMap<String, Object> map = new HashMap<>();
		if (lat == null || lng == null) {
			lat = 37.5665;
			lng = 126.9780;
		}
		
		map.put("lat", lat);
		map.put("lng", lng);
		
        resultMap = mainService.selectSellerList(map);
        return new Gson().toJson(resultMap);
    }
	
	// 7. 판매자 상세 데이터 응답
	@RequestMapping(value = "/seller/detailData.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sellerInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
        resultMap = mainService.getSellerDetail(map);
        return new Gson().toJson(resultMap);
    }
	
	// 8. 검색 데이터 응답
	@RequestMapping(value = "/search", method = RequestMethod.GET)
    public String search(@RequestParam("keyword") String keyword, Model model) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        
        HashMap<String, Object> resultMap = mainService.getSearchList(map);
        
        model.addAttribute("keyword", keyword);
        model.addAttribute("list", new Gson().toJson(resultMap.get("list")));
        return "main/search"; // => /WEB-INF/views/product/search.jsp
    }
	
	// 9. 로그인 유저 좌표 데이터 응답
	@RequestMapping(value = "/main/data/userLocation.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getUserLocation(HttpSession session) {
	    HashMap<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId"); // 세션에 저장된 로그인 아이디

	    try {
	        if (userId != null) {
	            // ✅ DB에서 사용자 좌표 조회
	            HashMap<String, Object> userLoc = mainService.selectUserLocation(userId);

	            if (userLoc != null) {
	                result.put("login", true);
	                result.put("lat", userLoc.get("LAT"));
	                result.put("lng", userLoc.get("LNG"));
	            } else {
	                // 사용자 위치 정보가 DB에 없는 경우
	                result.put("login", true);
	                result.put("lat", null);
	                result.put("lng", null);
	            }
	        } else {
	            // 로그인 안 한 경우
	            result.put("login", false);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("login", false);
	        result.put("error", "DB 조회 중 오류 발생: " + e.getMessage());
	    }

	    return result;
	}

}
