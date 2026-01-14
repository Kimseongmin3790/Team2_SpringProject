package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NotificationMapper {
    // 알림 생성 (주문, 채팅 등 발생 시 호출)
    int insertNotification(HashMap<String, Object> map);
    // 내 알림 목록 조회 (최신순)
    List<HashMap<String, Object>> selectNotificationList(HashMap<String, Object> map);
    // 알림 읽음 처리 (개별 또는 전체)
    int updateReadStatus(HashMap<String, Object> map);
    // 읽지 않은 알림 개수 조회 (헤더 배지용)
    int selectUnreadCount(String userId);
    // 전체 알림 개수 조회 (페이징용)
    int countNotification(HashMap<String, Object> map);
}
