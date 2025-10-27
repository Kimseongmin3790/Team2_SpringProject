package com.example.TeamProject.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.User;

@Mapper
public interface UserMapper {
	// 일반 회원가입 등록
	int insertUser(HashMap<String, Object> map);
	// 판매자 정보 등록
	int insertSeller(HashMap<String, Object> map);
	// 아이디 중복체크
	User idCheck(HashMap<String, Object> map);
	// 로그인
	User loginUser(HashMap<String, Object> map);
	// 아이디 찾기
	User findId(HashMap<String, Object> map);
	// 비밀번호 찾기
	User findPwd(HashMap<String, Object> map);
	// 새 비밀번호 등록
	int resetPwd(HashMap<String, Object> map);
	
}
