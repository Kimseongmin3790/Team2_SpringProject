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
import com.google.gson.Gson;

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
	
	@RequestMapping("/userjoin.do") 
    public String join(Model model) throws Exception{

        return "user/join"; 
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
	
	@RequestMapping("/buyer.do") 
    public String buyer(Model model) throws Exception{

        return "user/buyerMypage";
    }
	
	@RequestMapping("/seller.do") 
    public String seller(Model model) throws Exception{

        return "user/sellerMypage";
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
}
