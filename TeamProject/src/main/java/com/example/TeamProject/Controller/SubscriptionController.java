package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.SubscriptionService;
import com.google.gson.Gson;

@Controller
public class SubscriptionController {
	@Autowired
    SubscriptionService subscriptionService;
	
    // 리스트 페이지 이동
    @RequestMapping(value = "/subscription/list.do", method = RequestMethod.GET)
    public String goSubscriptionListPage() {
        return "subscription/subscriptionList";  // /WEB-INF/views/subscription/subscriptionList.jsp
    }

    // 상세 페이지 이동
    @RequestMapping(value = "/subscription/detail.do", method = RequestMethod.GET)
    public String goSubscriptionDetailPage(@RequestParam("planId") int planId, Model model) {
        model.addAttribute("planId", planId);
        return "subscription/subscriptionDetail"; // /WEB-INF/views/subscription/subscriptionDetail.jsp
    }
    
    // 메인 페이지용 데이터
    @RequestMapping(value = "/main/data/subscriptionPlans.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSubscriptionPlanMainList(@RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = subscriptionService.getSubscriptionPlanMainList(map);
        return new Gson().toJson(resultMap);
    }

    // 리스트 페이지용 데이터
    @RequestMapping(value = "/data/subscriptionList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSubscriptionPlanList(@RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = subscriptionService.getSubscriptionPlanList(map);
        return new Gson().toJson(resultMap);
    }

    // 상세 페이지용 데이터
    @RequestMapping(value = "/data/subscriptionDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSubscriptionPlanDetail(@RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = subscriptionService.getSubscriptionPlanDetail(map);
        return new Gson().toJson(resultMap);
    }
    
    @RequestMapping( value = "/payment/subscriptionPrepare.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String subscriptionPrepare(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = subscriptionService.getSubscriptionPlanForPayment(map);
	    return new Gson().toJson(resultMap);
	}
    
    
}
