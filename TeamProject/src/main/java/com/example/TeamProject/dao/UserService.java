package com.example.TeamProject.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	
	@Autowired
	UserMapper userMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			userMapper.insertUser(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> idCheck(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.idCheck(map);
			if (user != null) {
				resultMap.put("result", "N");
			} else {
				resultMap.put("result", "Y");
			}			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
}
