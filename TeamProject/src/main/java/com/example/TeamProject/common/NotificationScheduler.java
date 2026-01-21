package com.example.TeamProject.common;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.TeamProject.dao.NotificationService;
import com.example.TeamProject.mapper.NotificationMapper;
import com.example.TeamProject.mapper.SubscriptionMapper;

@Component
public class NotificationScheduler {
	
	@Autowired
	private SubscriptionMapper subscriptionMapper;

	@Autowired
	private NotificationService notificationService;

    @Autowired
    private NotificationMapper notificationMapper;

    // 초 분 시 일 월 요일
    @Scheduled(cron = "0 0 3 * * *") // 매일 새벽 3시에 실행
    public void cleanupOldNotifications() {
        int deletedCount = notificationMapper.deleteOldNotifications();
        System.out.println(">>> [자동 알림 정리] 30일 지난 알림 " + deletedCount + "건을 삭제했습니다.");
    }
    
    // 매일 오전 10시에 실행
    @Scheduled(cron = "0 0 10 * * *")
    public void notifyUpcomingBilling() {
        try {
            List<HashMap<String, Object>> list = subscriptionMapper.selectUpcomingBillingList();

            for (HashMap<String, Object> item : list) {
                String userId = (String) item.get("USER_ID");
                String planName = (String) item.get("PLAN_NAME");

                String msg = "[결제예정] 3일 뒤 '" + planName + "' 정기 결제가 진행될 예정입니다.";
                notificationService.sendNotification(userId, "NOTICE", msg, "/buyerMyPage.do?tab=subscriptions");
            }
            System.out.println(">>> [정기결제 알림] " + list.size() + "명에게 발송 완료.");

        } catch (Exception e) {
            System.err.println("정기결제 알림 스케줄러 오류: " + e.getMessage());
        }
    }
}