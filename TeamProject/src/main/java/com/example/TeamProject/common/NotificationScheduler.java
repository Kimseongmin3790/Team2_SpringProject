package com.example.TeamProject.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.TeamProject.mapper.NotificationMapper;

@Component
public class NotificationScheduler {

    @Autowired
    private NotificationMapper notificationMapper;

    // 초 분 시 일 월 요일
    @Scheduled(cron = "0 0 3 * * *") // 매일 새벽 3시에 실행
    public void cleanupOldNotifications() {
        int deletedCount = notificationMapper.deleteOldNotifications();
        System.out.println(">>> [자동 알림 정리] 30일 지난 알림 " + deletedCount + "건을 삭제했습니다.");
    }
}