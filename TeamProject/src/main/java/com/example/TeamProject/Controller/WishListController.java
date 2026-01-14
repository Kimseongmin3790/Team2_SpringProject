package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.WishListService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class WishListController {

    @Autowired
    WishListService wishListService;

    // 찜 목록 페이지 이동
    @RequestMapping("/wishlist/list.do")
    public String wishList(HttpSession session, Model model) {
        return "user/wishList";
    }

    // 찜 목록 데이터 조회 
    @RequestMapping(value = "/wishlist/list.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String wishListDox(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));
        return new Gson().toJson(wishListService.getWishList(map));
    }

    // 찜 토글 (추가/삭제)
    @RequestMapping(value = "/wishlist/toggle.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String toggleWishList(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));
        return new Gson().toJson(wishListService.toggleWishList(map));
    }
    
    // 찜 선택 삭제 (다중 삭제)
    @RequestMapping(value = "/wishlist/deleteMulti.dox", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
    @ResponseBody
    public String deleteWishListMulti(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));
        String json = (String) map.get("selectItem");
        ObjectMapper mapper = new ObjectMapper();
        List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {});
        map.put("list", list); 
        return new Gson().toJson(wishListService.deleteWishListMulti(map));
    }

    
    // 찜 목록 확인
    @RequestMapping(value = "/wishlist/check.dox", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
    @ResponseBody
    public String checkWishList(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
    	map.put("userId", session.getAttribute("sessionId"));
    	return new Gson().toJson(wishListService.getWishListStatus(map));
    }
}