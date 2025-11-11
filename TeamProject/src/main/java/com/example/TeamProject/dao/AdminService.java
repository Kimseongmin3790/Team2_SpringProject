package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.AdminMapper;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	public HashMap<String, Object> getUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> list = adminMapper.selectUserList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> approveSeller(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			adminMapper.approveSeller(map);				
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> rejectSeller(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			adminMapper.rejectSeller(map);				
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> dashboardCount(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int allProductCount = adminMapper.allProductCount();
			int allUserCount = adminMapper.allUserCount();
			int todayOrders = adminMapper.todayOrders();
			int allOrdersCount = adminMapper.allOrdersCount();
						
			resultMap.put("allOrderCount", allOrdersCount);
			resultMap.put("pCount", allProductCount);
			resultMap.put("uCount", allUserCount);
			resultMap.put("oCount", todayOrders);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = adminMapper.selectProductList(map);
			List<ProductCategory> categories = adminMapper.selectCategoryList(map);
			
			resultMap.put("list", list);
			resultMap.put("categories", categories);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> getCategoryList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<ProductCategory> list = adminMapper.selectCategoryList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> findNearestSellers(double userLat, double userLng) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("lat", userLat);
		map.put("lng", userLng);
		
		List<SellerVO> list = adminMapper.selectNearestSellers(map);		
		resultMap.put("list", list);
		return resultMap;
	}
	
	public HashMap<String, Object> getTopList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			
		
		try {
			List<ProductCategory> list = adminMapper.selectTopList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getMidList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			

		try {
			List<ProductCategory> list = adminMapper.selectMidList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getLeafList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			

		try {
			List<ProductCategory> list = adminMapper.selectLeafList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> updateRecommend(int productNo, String recommend) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			

		try {
			adminMapper.updateRecommend(productNo, recommend);			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> updateProductStatus(int productNo, String productStatus) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			

		try {
			adminMapper.updateProductStatus(productNo, productStatus);			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
}
