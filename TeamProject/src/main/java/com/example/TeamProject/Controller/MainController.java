package com.example.TeamProject.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/main/do")
	public String login(Model model) throws Exception{
			
		return "/main/home";
	}
}
