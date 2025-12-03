package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.RegionService;
import com.google.gson.Gson;

@Controller
public class RegionController {
	@Autowired
	RegionService regionService;
	
	@RequestMapping("/region/specialList.do")
	public String goRegionSpecialListPage(Model model) {
		return "region/specialList";
	}
	
	@RequestMapping(value = "/region/specialDetail.do", method = RequestMethod.GET)
    public String goRegionSpecialDetailPage(@RequestParam("regionId") int regionId, Model model) {
        model.addAttribute("regionId", regionId);
        return "region/specialDetail";
    }
	
	@RequestMapping(value = "/main/data/regionalSpecials.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRegionSpecialList(@RequestParam HashMap<String, Object> map) throws Exception { 
                
        HashMap<String, Object> resultMap = regionService.getRegionSpecialList(map);

        return new Gson().toJson(resultMap);
    }
	
	@RequestMapping(value = "/data/regionDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRegionSpecialDetail(@RequestParam HashMap<String, Object> map) throws Exception {
		// map 안에는 regionId가 들어옴
		HashMap<String, Object> resultMap = regionService.getRegionSpecialById(map);
		return new Gson().toJson(resultMap);
	}
}
