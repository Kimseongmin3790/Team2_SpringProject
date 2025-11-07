package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.SellerService;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession; 

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
    
    @RequestMapping(value = "seller/farm/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateFarmInfo(SellerVO sellerVO, HttpSession session) {
        HashMap<String, Object> response = new HashMap<>();
        String loggedInUserId = (String) session.getAttribute("sessionId");

        if (loggedInUserId == null || loggedInUserId.isEmpty()) {
            response.put("result", "fail");
            response.put("message", "로그인 정보가 없습니다.");
            return new Gson().toJson(response);
        }

        response = sellerService.updateFarmInfo(sellerVO, loggedInUserId);

        return new Gson().toJson(response);
    }
    
    @RequestMapping(value = "seller/profile/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateSellerProfile(SellerVO sellerVO, HttpSession session) {
        HashMap<String, Object> response = new HashMap<>();
        String loggedInUserId = (String) session.getAttribute("sessionId");

        if (loggedInUserId == null || loggedInUserId.isEmpty()) {
            response.put("result", "fail");
            response.put("message", "로그인 정보가 없습니다.");
            return new Gson().toJson(response);
        }

        sellerVO.setUserId(loggedInUserId);

        if (sellerVO.getUser() == null) {
            sellerVO.setUser(new User());
        }
        sellerVO.getUser().setUserId(loggedInUserId);
        
        response = sellerService.updateSellerProfile(sellerVO);

        return new Gson().toJson(response);
    }
    
    @RequestMapping(value = "/seller/dashboard.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    		@ResponseBody
    		public String getDashboardData(HttpSession session) {
    		    String sellerId = (String) session.getAttribute("sessionId");
    		    HashMap<String, Object> resultMap = new HashMap<>();

    		    if (sellerId == null || sellerId.isEmpty()) {
    		        resultMap.put("result", "fail");
    		        resultMap.put("message", "로그인이 필요합니다.");
    		        return new Gson().toJson(resultMap);
    		    }

    		    resultMap = sellerService.getDashboardData(sellerId);

    		    resultMap.put("result", "success");
    		    resultMap.put("message", "컨트롤러 연결 성공");

    		    return new Gson().toJson(resultMap);
    		}
    
    
       
}