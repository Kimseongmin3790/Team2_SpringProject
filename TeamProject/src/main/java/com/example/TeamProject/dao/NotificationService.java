package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;

import com.example.TeamProject.mapper.NotificationMapper;

@Service
public class NotificationService {

    @Autowired
    NotificationMapper notificationMapper;
    
    @Autowired
    SimpMessagingTemplate messagingTemplate;

    // 서버 시작 시 오래된 알림 자동 삭제 
    @PostConstruct
    public void init() {
        System.out.println("=== [알림 서비스] 서버 시작: 30일 경과 알림 정리 수행 ===");
        try {
            int count = notificationMapper.deleteOldNotifications();
            System.out.println("=== [알림 서비스] 정리 완료: " + count + "건 삭제됨 ===");
        } catch (Exception e) {
            System.err.println("!!! [알림 서비스] 초기화 중 에러: " + e.getMessage());
        }
    }

    // 매일 자정마다 오래된 알림 자동 삭제
    @Scheduled(cron = "0 0 0 * * *")
    public void autoDeleteOldNotifications() {
        System.out.println("=== [스케줄러] 자정: 30일 경과 알림 자동 삭제 시작 ===");
        try {
            int count = notificationMapper.deleteOldNotifications();
            System.out.println("=== [스케줄러] 삭제 완료: " + count + "건 ===");
        } catch (Exception e) {
            System.err.println("!!! [스케줄러] 에러: " + e.getMessage());
        }
    }

    // 알림 전송 (DB 저장 + 실시간 전송)
    public void sendNotification(String userId, String type, String message, String linkUrl) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("type", type);
        map.put("message", message);
        map.put("linkUrl", linkUrl);
        notificationMapper.insertNotification(map);
        // 웹소켓 실시간 전송
        try {
            messagingTemplate.convertAndSend("/topic/notifications/" + userId, map);
            System.out.println("실시간 알림 전송 성공: " + userId);
        } catch (Exception e) {
            System.err.println("실시간 알림 전송 실패: " + e.getMessage());
        }
    }

    // 내 알림 목록 조회
    public HashMap<String, Object> getNotificationList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 페이징 변수 설정
            int currentPage = Integer.parseInt(String.valueOf(map.getOrDefault("currentPage", 1)));
            int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", 10)));
            int offset = (currentPage - 1) * pageSize;

            map.put("offset", offset);
            map.put("pageSize", pageSize);

            // 데이터 조회
            List<HashMap<String, Object>> list = notificationMapper.selectNotificationList(map);
            int totalCount = notificationMapper.countNotification(map);

            // 결과 반환
            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount); 
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    // 알림 읽음 처리
    public HashMap<String, Object> markAsRead(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            notificationMapper.updateReadStatus(map);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
        }
        return resultMap;
    }

    // 읽지 않은 알림 개수 (헤더 배지용)
    public int getUnreadCount(String userId) {
        try {
            return notificationMapper.selectUnreadCount(userId);
        } catch (Exception e) {
            return 0;
        }
    }
    
    // 알림 삭제 (개별)
    public HashMap<String, Object> removeNotification(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            notificationMapper.deleteNotification(map);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
        }
        return resultMap;
    }

    // 읽은 알림 전체 삭제
    public HashMap<String, Object> removeReadNotifications(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            notificationMapper.deleteReadNotifications(userId);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
        }
        return resultMap;
    }
    
    
    
}