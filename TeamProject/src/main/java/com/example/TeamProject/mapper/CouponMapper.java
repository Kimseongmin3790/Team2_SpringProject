package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CouponMapper {
    // 내 쿠폰 목록 조회
    List<HashMap<String, Object>> selectMyCoupons(String userId);

    // 쿠폰 사용 처리 
    int useCoupon(int issueNo);

    // 쿠폰 일괄 발급
    int insertBulkCoupons(int couponNo);

    // 알림 발송을 위한 전체 활성 회원 ID 조회
    @Select("SELECT USER_ID FROM USERS WHERE STATUS = 'ACTIVE'")
    List<String> selectAllActiveUserIds();
}