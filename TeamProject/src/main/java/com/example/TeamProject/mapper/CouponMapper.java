package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CouponMapper {
    // 내 쿠폰 목록 조회
    List<HashMap<String, Object>> selectMyCoupons(String userId);

    // 쿠폰 사용 처리 
    int useCoupon(int issueNo);

    // 쿠폰 일괄 발급
    int insertBulkCoupons(int couponNo);

    // 알림 발송을 위한 전체 활성 회원 ID 조회
    List<String> selectAllActiveUserIds();

    // 미수령 유저 ID 조회
    List<String> selectUnissuedActiveUserIds(int couponNo);

    // 쿠폰 상세 정보 조회
    HashMap<String, Object> selectCouponDetail(int couponNo);

    // 쿠폰 생성
    int insertCoupon(HashMap<String, Object> map);

    // 관리자 쿠폰 목록 조회
    List<HashMap<String, Object>> selectAdminCouponList();

    // 쿠폰 삭제
    int deleteCoupon(int couponNo);
}
