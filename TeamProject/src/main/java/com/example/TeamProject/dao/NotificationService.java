package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.TeamProject.mapper.NotificationMapper;

@Service
public class NotificationService {

    @Autowired
    NotificationMapper notificationMapper;

    // 알림 전송 
    public void sendNotification(String userId, String type, String message, String linkUrl) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("type", type);
        map.put("message", message);
        map.put("linkUrl", linkUrl);
        notificationMapper.insertNotification(map);
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
}