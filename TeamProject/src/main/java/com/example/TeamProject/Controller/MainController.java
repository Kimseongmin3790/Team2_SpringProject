package com.example.TeamProject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

	@RequestMapping("/main.do") 
    public String login(Model model) throws Exception{

        return "main/home"; 
    }
	
	@RequestMapping("/default.do")
    public String defaultPage() {
        return "index";  // → /WEB-INF/views/index.jsp
    }
}
