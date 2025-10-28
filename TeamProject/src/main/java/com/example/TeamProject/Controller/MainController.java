package com.example.TeamProject.Controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 🌟 @Controller 사용
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody; // 🌟 JSON 응답 메서드에만 추가

import com.example.TeamProject.dao.MainService;

@Controller // 뷰(JSP)를 반환하는 기본 컨트롤러로 설정
@RequestMapping("/") 
public class MainController {

    @Autowired
    private MainService mainService; 

    // ----------------------------------------------------
    // 1. 메인 페이지 JSP 반환 메서드 (기존 MainController 역할)
    // ----------------------------------------------------
    @GetMapping("/main")
    public String main() throws Exception {
        return "main"; // /WEB-INF/views/main.jsp 파일을 찾아 반환
    }
    
    // ----------------------------------------------------
    // 2. REST API 메서드들 (기존 MainApiController 역할)
    // ----------------------------------------------------
    
    // 요청 주소: /api/main/best
    @GetMapping("/api/main/best")
    @ResponseBody // 🌟 이 메서드의 반환 값(List<Map>)을 JSON으로 변환하여 응답하도록 명시
    public List<Map<String, Object>> getBestProducts() {
        return mainService.getBestProducts();
    }

    // 요청 주소: /api/main/banners
    @GetMapping("/api/main/banners")
    @ResponseBody // 🌟 JSON 응답 명시
    public List<Map<String, Object>> getMainBanners() {
        return mainService.getMainBanners();
    }

    // 요청 주소: /api/main/producers
    @GetMapping("/api/main/producers")
    @ResponseBody // 🌟 JSON 응답 명시
    public List<Map<String, Object>> getProducers() {
        return mainService.getProducers();
    }
}