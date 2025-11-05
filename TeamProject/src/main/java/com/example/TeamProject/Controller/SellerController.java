package com.example.TeamProject.Controller;

import java.util.HashMap; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.ResponseBody;  
import jakarta.servlet.http.HttpSession;

import com.example.TeamProject.dao.SellerService; // SellerService의 패키지 경로
import com.google.gson.Gson; 

@Controller
public class SellerController {

    @Autowired
    private SellerService sellerService;

 
    @RequestMapping(value = "seller/info.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSellerInfo(HttpSession session) throws Exception { 
        String sellerId = (String) session.getAttribute("sessionId");
        
        HashMap<String, Object> resultMap = sellerService.getSellerInfoForMyPage(sellerId);

        return new Gson().toJson(resultMap);
    }
}