package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.TeamProject.mapper.CouponMapper;

@Service
public class CouponService {

    @Autowired
    private CouponMapper couponMapper;

    @Autowired
    private NotificationService notificationService;

    // 내 쿠폰 목록 가져오기
    public HashMap<String, Object> getMyCoupons(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = couponMapper.selectMyCoupons(userId);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 전체 회원에게 쿠폰 일괄 발급 및 알림 전송
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> issueCouponToAll(int couponNo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 1. 쿠폰 상세 정보 조회 (알림 메시지 포함)
            HashMap<String, Object> couponInfo = couponMapper.selectCouponDetail(couponNo);
            if (couponInfo == null) {
                throw new Exception("쿠폰 정보가 존재하지 않습니다.");
            }

            // 2. 알림 메시지 설정
            String msg = (String) couponInfo.get("NOTI_MESSAGE");
            if (msg == null || msg.trim().isEmpty()) {
                msg = "[선물] 모든 회원님께 특별 쿠폰이 도착했습니다! 지금 확인해보세요.";
            }

            // 3. 미수령 활성 유저 조회 (중복 발급 방지용)
            List<String> targetUserIds = couponMapper.selectUnissuedActiveUserIds(couponNo);
            
            // 발급 대상이 없는 경우 처리
            if (targetUserIds == null || targetUserIds.isEmpty()) {
                resultMap.put("result", "success");
                resultMap.put("count", 0);
                resultMap.put("message", "이미 모든 회원이 쿠폰을 보유 중입니다.");
                return resultMap;
            }

            // 4. DB 일괄 발급 실행
            int count = couponMapper.insertBulkCoupons(couponNo);

            // 5. 대상 유저에게 알림 발송
            for (String userId : targetUserIds) {
                notificationService.sendNotification(userId, "NOTICE", msg, "/buyerMyPage.do?tab=coupons");
            }

            resultMap.put("result", "success");
            resultMap.put("count", count);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
    
    // 쿠폰 생성 (관리자)
    public HashMap<String, Object> createCoupon(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            couponMapper.insertCoupon(map);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 관리자 쿠폰 목록 조회
    public HashMap<String, Object> getAdminCouponList() {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = couponMapper.selectAdminCouponList();
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 쿠폰 삭제
    public HashMap<String, Object> deleteCoupon(int couponNo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            couponMapper.deleteCoupon(couponNo);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "이미 발급된 쿠폰은 삭제할 수 없거나 오류가 발생했습니다.");
        }
        return resultMap;
    }
}