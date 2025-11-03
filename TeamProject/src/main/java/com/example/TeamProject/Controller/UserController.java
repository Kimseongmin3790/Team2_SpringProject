package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.OrderService;
import com.example.TeamProject.dao.UserService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	OrderService orderService;
	
	@RequestMapping("/login.do") 
    public String login(Model model) throws Exception{

        return "user/login"; 
    }
	
	@RequestMapping("/chooseJoin.do") 
    public String chooseJoin(Model model) throws Exception{

        return "user/chooseJoin"; 
    }
	
	@RequestMapping("/userJoin.do") 
    public String join(Model model) throws Exception{

        return "user/userJoin"; 
    }
	
	@RequestMapping("/sellerJoin.do") 
    public String sellerJoin(Model model) throws Exception{

        return "user/sellerJoin"; 
    }
	
	@RequestMapping("/findId.do") 
    public String findId(Model model) throws Exception{

        return "user/findId"; 
    }
	
	@RequestMapping("/findPwd.do") 
    public String findPwd(Model model) throws Exception{

        return "user/findPwd"; 
    }
	
	@RequestMapping("/addr.do") 
    public String addr(Model model) throws Exception{

        return "jusoPopup";
    }
	
	@RequestMapping("/buyerMyPage.do") 
    public String buyerMyPage(Model model) throws Exception{

        return "user/buyerMypage";
    }
	
	@RequestMapping("/sellerMyPage.do") 
    public String sellerMyPage(Model model) throws Exception{

        return "user/sellerMyPage";
    }
	
	@RequestMapping("/cart.do") 
    public String cart(Model model) throws Exception{

        return "user/cart";
    }
	
	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		// 주소 → 좌표 변환
	    String addr = (String) map.get("userAddr");
	    double[] coords = userService.getCoordinatesFromAddress(addr);
	    double lat = coords[0];
	    double lng = coords[1];

	    map.put("lat", lat);
	    map.put("lng", lng);
		
		resultMap = userService.addUser(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/sellerJoin.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerJoin(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.addSeller(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.idCheck(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.login(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = userService.logout(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.findId(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/findPwdSendCode.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findPwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
		resultMap = userService.findPwd(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/findPwdReset.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findPwdReset(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
		resultMap = userService.resetPwd(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 로그인 유저 정보 가져오기
	@RequestMapping(value = "/userInfo.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
		public String getUserProfile(HttpSession session) throws Exception {
			String userId = (String) session.getAttribute("sessionId");
			HashMap<String, Object> resultMap = userService.getUserProfile(userId);
			
			return new Gson().toJson(resultMap);
			}
	
	// 회원 정보 수정
	@RequestMapping(value = "/updateProfile.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProfile(@RequestBody HashMap<String, Object> map, HttpSession session) throws Exception {
		String userId = (String) session.getAttribute("sessionId");
		map.put("userId", userId);
		HashMap<String, Object> resultMap = userService.updateProfile(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 회원 탈퇴 로직
	@RequestMapping(value = "/user/withdrawal.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String withdrawUser(@RequestBody HashMap<String, Object> map, HttpSession session) throws Exception {
		
		HashMap<String, Object> resultMap = userService.withdrawUser(map, session); 
		
		return new Gson().toJson(resultMap);
	}
	
	// 계정 복구
	@RequestMapping(value = "/user/recover.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recoverUser(@RequestBody HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.recoverUser(map);
		return new Gson().toJson(resultMap);
	}
	
	// 주문목록 가져오기
    @RequestMapping(value = "/myPage/orders.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String getOrderHistory(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");

        HashMap<String, Object> resultMap = orderService.getOrderHistory(userId);

        return new Gson().toJson(resultMap);
    }
	
}