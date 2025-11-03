package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.CategoryService;
import com.google.gson.Gson;

@Controller
public class CategoryController {
	
	@Autowired
    private CategoryService categoryService;
   
	
	@RequestMapping("/productCategory.do") 
    public String productCategory(Model model) throws Exception{

        return "category/categoryMain"; 
    }		
	
	@GetMapping("/category/{categoryNo}") // header dropdwon에서 보내온 categoryNo 받기
	public String categoryMain(@PathVariable("categoryNo") int categoryNo, Model model) {
	    model.addAttribute("categoryNo", categoryNo);
	    return "category/categoryMain";  // categoryMain.jsp 경로 (변경 시 맞게 수정)
	}
	
    @RequestMapping(value = "/categoryProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String categoryProductList() {
        HashMap<String, Object> resultMap = categoryService.getProductAndCategoryList();
        return new Gson().toJson(resultMap);
    }

}
