package com.example.TeamProject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class sampleController {
	 
	@RequestMapping("/default.do") 
    public String home(Model model) throws Exception{

        return "default"; 
    }
	
	@RequestMapping("/login.do") 
    public String login(Model model) throws Exception{

        return "/login/login"; 
    }
	
	
	// Product Category
	@RequestMapping("/category/agriculture.do") 
    public String aProduct(Model model) throws Exception{

        return "/category/agriculture"; 
    }	
	
	@RequestMapping("/category/animal.do") 
    public String a1Product(Model model) throws Exception{

        return "/category/animal"; 
    }
		
	@RequestMapping("/category/forestry.do") 
    public String fProduct(Model model) throws Exception{

        return "/category/forestry"; 
    }
		
	@RequestMapping("/category/marine.do") 
    public String mProduct(Model model) throws Exception{

        return "/category/marine"; 
    }
	
	
}
