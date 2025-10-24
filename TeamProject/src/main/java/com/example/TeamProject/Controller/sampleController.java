package com.example.TeamProject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class sampleController {
	 
	@RequestMapping("/index.do") 
    public String home(Model model) throws Exception{

        return "index"; 
    }
	
	@RequestMapping("/login.do") 
    public String login(Model model) throws Exception{

        return "/login/login"; 
    }
	
	@RequestMapping("/customerService.do") 
    public String customerService(Model model) throws Exception{

        return "/views/common/customerService"; 
    }
}
