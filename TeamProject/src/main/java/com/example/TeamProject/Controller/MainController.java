package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 뷰 반환과 데이터 응답을 모두 처리하기 위해 @Controller 유지
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.MainService;
import com.google.gson.Gson; 

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

	// 2. 메인 배너 데이터 응답
	@RequestMapping(value = "/main/data/banners", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMainBannersData() throws Exception {
		HashMap<String, Object> resultMap = mainService.selectMainBanners();
        
		@SuppressWarnings("unchecked")
		List<?> list = (List<?>) resultMap.get("list");
		
		return new Gson().toJson(list); 
	}
	
	// 3. 메인 추천 데이터 응답
	@RequestMapping(value = "/main/data/recommend.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRecommendProducts() throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
        resultMap = mainService.selectRecommendList();
        return new Gson().toJson(resultMap);
    }
	
	// 4. 메인 신상품 데이터 응답
	@RequestMapping(value = "/main/data/newList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String newList() throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
        resultMap = mainService.selectNewList();
        return new Gson().toJson(resultMap);
    }
	
	// 5. 메인 입점 농가 데이터 응답
		@RequestMapping(value = "/main/data/sellerList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String sellerList() throws Exception {
			HashMap<String, Object> resultMap = new HashMap<>();
			
	        resultMap = mainService.selectSellerList();
	        return new Gson().toJson(resultMap);
	    }

}
