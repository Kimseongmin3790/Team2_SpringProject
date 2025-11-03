package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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

// ----------------------------------------------------
// 1. 메인 페이지 JSP 반환 메서드 (GET /main.do)
// ----------------------------------------------------
	@GetMapping("/main.do")
	public String main() throws Exception {
		return "main/home";
	}

	// ----------------------------------------------------
	// 2. 메인 배너 데이터 응답 (GET /main/data/banners)
	// ----------------------------------------------------
	@RequestMapping(value = "/main/data/banners", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMainBannersData() throws Exception {
		HashMap<String, Object> resultMap = mainService.selectMainBanners();
        
		@SuppressWarnings("unchecked")
		List<?> list = (List<?>) resultMap.get("list");
		
		return new Gson().toJson(list); 
	}

	// ----------------------------------------------------
	// 3. 입점 업체 데이터 응답 (GET /main/data/producers)
	// ----------------------------------------------------
	@RequestMapping(value = "/main/data/producers", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProducersData() throws Exception {
		HashMap<String, Object> resultMap = mainService.selectProducers();
        
		@SuppressWarnings("unchecked")
        List<?> list = (List<?>) resultMap.get("list");

		return new Gson().toJson(list);
	}

	// ----------------------------------------------------
	// 4. 베스트 상품 데이터 응답 (GET /main/data/best)
	// ----------------------------------------------------
	@RequestMapping(value = "/main/data/best", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBestProductsData() throws Exception {
		HashMap<String, Object> resultMap = mainService.selectBestProducts();
		
        @SuppressWarnings("unchecked")
        List<?> list = (List<?>) resultMap.get("list");
        
        return new Gson().toJson(list);
	}
}