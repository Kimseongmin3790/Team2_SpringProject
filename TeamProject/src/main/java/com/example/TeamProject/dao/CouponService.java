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
            // DB 일괄 발급 
            int count = couponMapper.insertBulkCoupons(couponNo);

            // 발급 대상 유저 목록 조회
            List<String> userIds = couponMapper.selectAllActiveUserIds();

            // 각 유저에게 알림 발송
            String msg = "[선물] 모든 회원님께 특별 쿠폰이 도착했습니다! 지금 확인해보세요.";
            for (String userId : userIds) {
                notificationService.sendNotification(userId, "NOTICE", msg, "/buyerMyPage.do?tab=coupons");
            }

            resultMap.put("result", "success");
            resultMap.put("count", count);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
}