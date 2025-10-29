package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 뷰 반환과 데이터 응답을 모두 처리하기 위해 @Controller 유지
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody; // JSON 응답을 위해 @ResponseBody 사용

import com.example.TeamProject.dao.MainService;
import com.google.gson.Gson; // JSON 변환 라이브러리

@Controller // 뷰(JSP) 반환 역할과 데이터 응답 역할을 모두 수행
@RequestMapping("/") 
public class MainController {
    
    // Service 주입
    @Autowired
    private MainService mainService; 

    // ----------------------------------------------------
    // 1. 메인 페이지 JSP 반환 메서드 (기존 역할)
    // ----------------------------------------------------
    // 브라우저 접속 주소: http://[도메인]/main/do
    @GetMapping("/main.do")
    public String main() throws Exception {
        return "main/home"; // /WEB-INF/views/main/home.jsp 파일을 찾아 반환
    }
    
    // ----------------------------------------------------
    // 2. 메인 배너 데이터 응답 처리 (새로운 역할)
    // AJAX 요청 주소: /main/data/banners
    // ----------------------------------------------------
    @RequestMapping(value = "/main/data/banners", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody // 이 메서드가 반환하는 데이터를 HTTP 응답 본문에 직접 기록하도록 지시
    public String getMainBannersData() throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        resultMap = mainService.selectMainBanners();
        
        return new Gson().toJson(resultMap);
    }

    // 3. 입점 업체 데이터 응답 처리 (새로운 역할)
    // AJAX 요청 주소: /main/data/producers
    @RequestMapping(value = "/main/data/producers", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getProducersData() throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        resultMap = mainService.selectProducers();
        
        return new Gson().toJson(resultMap);
    }

    // 4. 베스트 상품 데이터 응답 처리 (새로운 역할)
    // AJAX 요청 주소: /main/data/best
    @RequestMapping(value = "/main/data/best", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBestProductsData() throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        resultMap = mainService.selectBestProducts();
        
        return new Gson().toJson(resultMap);
    }
}