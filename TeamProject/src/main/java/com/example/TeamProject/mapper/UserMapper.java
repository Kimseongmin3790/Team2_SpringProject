package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.TeamProject.model.Cart;
import com.example.TeamProject.model.Product;
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
	// 아이디 찾기(이메일주소)
	User findId(HashMap<String, Object> map);
	// 아이디 찾기(핸드폰번호)
	User findIdByPhone(HashMap<String, Object> map);
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
	// 프로필 수정 
	void updateProfile(HashMap<String, Object> map);
	// 사용자 계정 탈퇴
	int updateUserStatus(@Param("userId") String userId, @Param("status") String status);
	// 같은 상품이 이미 있으면 수량만 증가
	int updateCartQty(HashMap<String, Object> map);
	//없으면 새로 추가
	int insertCart(HashMap<String, Object> map);
	// 장바구니 리스트
	List<Cart> selectCartList(HashMap<String, Object> map);
	// 장바구니 합계
	int selectCartTotal(HashMap<String, Object> map);
	// 
	int updateQty(HashMap<String, Object> map);
	// 장바구니 선택 삭제
	int deleteCartItem(HashMap<String, Object> map);
	// 장바구니 전체 삭제
	int allDelete(HashMap<String, Object> map);
	
	// cartNo 조회
	Long selectCartNoByKey(Map<String,Object> key);
	// 장바구니 수량 업데이트
	int updateCartQtyByKey(Map<String, Object> map);
	// 장바구니 추가
	int insertCarts(Map<String, Object> map);
	
	// 판매자 내 상품 목록
	List<Product> getSellerProductList(HashMap<String, Object> map);
	// 판매자 내 상품 삭제(hidden처리)
	int hiddenSellerProduct(HashMap<String, Object> map);
}
