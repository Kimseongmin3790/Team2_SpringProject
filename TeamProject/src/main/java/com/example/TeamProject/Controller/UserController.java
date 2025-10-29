package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.UserService;
import com.example.TeamProject.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
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
			// 1. 세션에서 현재 로그인된 사용자 ID를 안전하게 가져옵니다.
			String userId = (String) session.getAttribute("sessionId");

			if (userId == null) {
				// 로그인되어 있지 않은 경우 에러를 반환합니다.
			    HashMap<String, String> errorResult = new HashMap<>();
			    errorResult.put("status", "error");
			    errorResult.put("message", "Not logged in");
			    return new Gson().toJson(errorResult);
			}

			// 2. 서비스에 userId를 전달하기 위해 map을 만듭니다.
			HashMap<String, Object> paramMap = new HashMap<>();
			paramMap.put("userId", userId);

			// 3. 이전에 작성하신 userInfo 서비스 메소드를 호출합니다.
			HashMap<String, Object> serviceResult = userService.userInfo(paramMap);

			// 4. 서비스 결과에서 사용자 정보('info')만 추출합니다.
			User userProfile = (User) serviceResult.get("info");

			// 5. 최종적으로 사용자 정보 객체만 JSON으로 변환하여 반환합니다.
			return new Gson().toJson(userProfile);
		}
	
}
