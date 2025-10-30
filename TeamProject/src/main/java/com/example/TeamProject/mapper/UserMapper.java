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
	// 이메일로 사용자 정보를 가져오는 메서드
	User findByEmail(String email);
	// 소셜 로그인 사용자를 새로 저장하는 메서드
	void insertSocialUser(User user);
	// 기존 사용자의 정보를 업데이트하는 메서드 (이름 등)
	void updateUser(User user);
	
}
