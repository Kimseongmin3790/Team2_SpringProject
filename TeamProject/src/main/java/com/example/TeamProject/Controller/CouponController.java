package com.example.TeamProject.Controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.TeamProject.dao.CouponService;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;

@Controller
public class CouponController {

    @Autowired
    private CouponService couponService;

    // 내 보유 쿠폰 목록 요청 
    @RequestMapping(value = "/coupon/myList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getMyCoupons(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");
        return new Gson().toJson(couponService.getMyCoupons(userId));
    }

    // 관리자용: 전체 회원 쿠폰 일괄 발급
    @RequestMapping(value = "/admin/coupon/issueAll.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String issueCouponToAll(@RequestParam("couponNo") int couponNo) throws Exception {
        return new Gson().toJson(couponService.issueCouponToAll(couponNo));
    }
}