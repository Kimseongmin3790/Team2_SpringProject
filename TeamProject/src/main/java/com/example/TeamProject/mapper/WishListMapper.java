package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.example.TeamProject.model.WishList;
import com.example.TeamProject.model.Product;

@Mapper
public interface WishListMapper {
    // 찜 여부 확인 (중복 체크)
    int checkWishList(HashMap<String, Object> map);
    // 찜 등록
    int insertWishList(HashMap<String, Object> map);
    // 찜 해제 (삭제)
    int deleteWishList(HashMap<String, Object> map);
    // 찜 선택 삭제
    int deleteWishListMulti(HashMap<String, Object> map);
    // 내가 찜한 상품 리스트 조회
    List<Product> selectWishList(HashMap<String, Object> map);
}
