package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.AdminMapper;
import com.example.TeamProject.mapper.ProductMapper;
import com.example.TeamProject.mapper.WishListMapper;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.ProductCategory;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	@Autowired
	WishListMapper wishListMapper;

	@Autowired
	NotificationService notificationService;

	@Autowired
	ProductMapper productMapper; 
		
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
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        adminMapper.updateProductStatus(productNo, productStatus);

	        if ("SELLING".equalsIgnoreCase(productStatus)) {
	            try {
	                // 해당 상품을 찜한 유저 목록 조회 (List<String>)
	                List<String> userIds = wishListMapper.selectWishUserIds(productNo);

	                if (userIds != null && !userIds.isEmpty()) {
	                    // 상품 정보(이름) 조회
	                    HashMap<String, Object> pMap = new HashMap<>();
	                    pMap.put("productNo", productNo);
	                    Product product = productMapper.selectProduct(pMap);

	                    String msg = "[재입고] 찜하신 '" + product.getPName() + "' 상품이 다시 판매를 시작했습니다!";

	                    for (String userId : userIds) {
	                        notificationService.sendNotification(userId, "NOTICE", msg, "/productInfo.do?productNo=" + productNo);
	                    }
	                    System.out.println("재입고 알림 발송 완료: " + userIds.size() + "명");
	                }
	            } catch (Exception ne) {
	                System.err.println("재입고 알림 발송 실패: " + ne.getMessage());
	            }
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        System.out.println(e.getMessage());
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> updateUserStatus(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();			

		try {
			adminMapper.updateUserStatus(map);	
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
}
