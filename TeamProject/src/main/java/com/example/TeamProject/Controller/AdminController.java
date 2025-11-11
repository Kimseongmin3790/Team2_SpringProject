package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.AdminService;
import com.google.gson.Gson;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@RequestMapping("/dashboard.do") 
    public String dashboard(Model model) throws Exception{

        return "admin/adminMain"; 
    }
	
	@RequestMapping("/admin/memberManage.do") 
    public String memberManage(Model model) throws Exception{

        return "admin/memberManage"; 
    }
	
	@RequestMapping("/admin/productManage.do") 
    public String productManage(Model model) throws Exception{

        return "admin/productManage"; 
    }
	
	@RequestMapping("/admin/categoryManage.do") 
    public String categoryManage(Model model) throws Exception{

        return "admin/categoryManage"; 
    }
			
	
	@RequestMapping(value = "/userList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getUserList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/approveSeller.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String approveSeller(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.approveSeller(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/rejectSeller.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rejectSeller(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.rejectSeller(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/dashboardCount.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String dashboardCount(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.dashboardCount(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getProductList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/allCategoryList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String allCategoryList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getCategoryList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/CategoryTopList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String topList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getTopList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/CategoryMidList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String midList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getMidList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/CategoryLeafList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String leafList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getLeafList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/nearestSellers.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String nearestSellers(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		double userLat = Double.parseDouble(map.get("userLat").toString());
	    double userLng = Double.parseDouble(map.get("userLng").toString());
	    
		resultMap = adminService.findNearestSellers(userLat, userLng);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/updateRecommend.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRecommend(@RequestParam("productNo") int productNo, @RequestParam("recommend") String recommend) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
	    resultMap = adminService.updateRecommend(productNo, recommend);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/updateProductStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProductStatus(@RequestParam("productNo") int productNo, @RequestParam("productStatus") String productStatus) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
	    resultMap = adminService.updateProductStatus(productNo, productStatus);
		
		return new Gson().toJson(resultMap);
	}
	
}
