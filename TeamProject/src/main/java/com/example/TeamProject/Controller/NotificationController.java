package com.example.TeamProject.Controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.TeamProject.dao.NotificationService;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;

@Controller
public class NotificationController {

    @Autowired
    NotificationService notificationService;

    // 알림 목록 페이지 이동
    @RequestMapping("/notification/list.do")
    public String notificationPage() {
        return "user/notificationList";
    }

    // 읽지 않은 알림 개수 조회 (헤더 배지용)
    @RequestMapping(value = "/notification/unreadCount.dox", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
    @ResponseBody
    public String getUnreadCount(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> resultMap = new HashMap<>();

        if (userId != null) {
            int count = notificationService.getUnreadCount(userId);
            resultMap.put("count", count);
            resultMap.put("result", "success");
        } else {
            resultMap.put("result", "fail");
        }
        return new Gson().toJson(resultMap);
    }

    // 알림 데이터 목록 조회
    @RequestMapping(value = "/notification/list.dox", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
    @ResponseBody
    public String getNotificationList(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));

        if(!map.containsKey("currentPage")) map.put("currentPage", 1);
        if(!map.containsKey("pageSize")) map.put("pageSize", 10);

        return new Gson().toJson(notificationService.getNotificationList(map));
    }

    // 알림 읽음 처리
    @RequestMapping(value = "/notification/read.dox", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
    @ResponseBody
    public String markAsRead(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));
        notificationService.markAsRead(map);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "success");
        return new Gson().toJson(resultMap);
    }
    
    // 알림 삭제 (개별)
    @RequestMapping(value = "/notification/remove.dox", method = RequestMethod.POST,produces="application/json;charset=UTF-8")
    @ResponseBody
    public String removeNotification(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        map.put("userId", session.getAttribute("sessionId"));
        return new Gson().toJson(notificationService.removeNotification(map));
    }

    // 읽은 알림 전체 삭제
    @RequestMapping(value = "/notification/removeRead.dox", method = RequestMethod.POST,produces="application/json;charset=UTF-8")
    @ResponseBody
    public String removeReadNotifications(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");
        return new Gson().toJson(notificationService.removeReadNotifications(userId));
    }
    
}