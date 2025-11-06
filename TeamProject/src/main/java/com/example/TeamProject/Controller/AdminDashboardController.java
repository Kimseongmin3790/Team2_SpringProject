package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.AdminDashboardService;
import com.google.gson.Gson;

@Controller
public class AdminDashboardController {
	
	@Autowired
	AdminDashboardService adminDashboardService;
	
	@RequestMapping("/admin/stats.do") 
    public String stats(Model model) throws Exception{

        return "admin/stats"; 
    }
	
	@RequestMapping(value = "/admin/statsData.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String statsData(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = adminDashboardService.getStats(map);
		
		return new Gson().toJson(resultMap);
	}
}
