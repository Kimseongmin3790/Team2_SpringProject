package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.TeamProject.dao.ProductCategoryService;
import com.example.TeamProject.model.ProductCategory;
import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/admin/category")
public class ProductCategoryController {

    @Autowired
    private ProductCategoryService categoryService;

    @PostMapping("/list.dox")
    public HashMap<String, Object> list(@RequestParam HashMap<String, Object> param) {
        return categoryService.getCategoryList(param);
    }
    
    @PostMapping("/insert.dox")
    public HashMap<String, Object> insert(@RequestParam HashMap<String, Object> param) {
        return categoryService.insertCategory(param);
    }

    @PostMapping("/update.dox")
    public HashMap<String, Object> update(@RequestParam HashMap<String, Object> param) {
        return categoryService.updateCategory(param);
    }

    @PostMapping("/delete.dox")
    public HashMap<String, Object> delete(@RequestParam HashMap<String, Object> param) {
        return categoryService.deleteCategory(param);
    }
}
