package com.example.TeamProject.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 뷰 반환과 데이터 응답을 모두 처리하기 위해 @Controller 유지
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody; 

import com.example.TeamProject.dao.MainService;
import com.google.gson.Gson; // JSON 변환 라이브러리

@Controller 
@RequestMapping("/") 
public class MainController {
    
    @Autowired
    private MainService mainService; 

    // ----------------------------------------------------
    // 1. 메인 페이지 JSP 반환 메서드
    // ----------------------------------------------------
    @GetMapping("/main.do")
    public String main() throws Exception {
        return "main/home"; // /WEB-INF/views/main/home.jsp 파일을 찾아 반환
    }
    
    // ----------------------------------------------------
    // 2. 메인 배너 데이터 응답 처리 -> List<Banner>를 JSON으로 변환하여 직접 응답
    // ----------------------------------------------------
    @RequestMapping(value = "/main/data/banners", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody 
    public String getMainBannersData() throws Exception {
        // Service에서 List를 직접 받아서 JSON으로 변환 후 응답
        List<?> list = mainService.selectMainBanners();
        return new Gson().toJson(list); // Vue.js에서 기대하는 배열[...] 형태의 JSON 응답
    }

    // 3. 입점 업체 데이터 응답 처리 -> List<Producer>를 JSON으로 변환하여 직접 응답
    @RequestMapping(value = "/main/data/producers", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getProducersData() throws Exception {
        List<?> list = mainService.selectProducers();
        return new Gson().toJson(list); 
    }

    // 4. 베스트 상품 데이터 응답 처리 -> List<BestProduct>를 JSON으로 변환하여 직접 응답
    @RequestMapping(value = "/main/data/best", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBestProductsData() throws Exception {
        List<?> list = mainService.selectBestProducts();
        return new Gson().toJson(list); 
    }

    
}



