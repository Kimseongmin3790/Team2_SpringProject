package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	
	
    @RequestMapping(value = "/categoryProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String productList() {
        HashMap<String, Object> resultMap = categoryService.getProductAndCategoryList();
        return new Gson().toJson(resultMap);
    }

}
