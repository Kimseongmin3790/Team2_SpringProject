package com.example.TeamProject.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.User;

@Mapper
public interface UserMapper {
	// 일반 회원가입 등록
	int insertUser(HashMap<String, Object> map);
	// 아이디 중복체크
	User idCheck(HashMap<String, Object> map);
}
