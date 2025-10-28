package com.example.TeamProject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class productInfoController {

	@RequestMapping("/productInfo.do")
    public String home(Model model) throws Exception{

        return "productInfo";
    }
	
}
