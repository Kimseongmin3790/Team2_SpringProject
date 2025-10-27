package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.CommonService;
import com.google.gson.Gson;

@Controller
public class CommonController {
	 
	@Autowired
	CommonService commonService;
	
	
	@RequestMapping("/index.do") 
    public String home(Model model) throws Exception{

        return "index"; 
    }
	
	@RequestMapping("/customerService.do") 
    public String customerService(Model model) throws Exception{

        return "/views/common/customerService"; 
    }
	
	@RequestMapping(value = "orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tblList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = commonService.getOrdersByBuyerId(map);
		
		return new Gson().toJson(resultMap);
	}
}
