package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.ChattingMapper;
import com.example.TeamProject.model.ChatMessage;

@Service
public class ChattingService {

    @Autowired
    ChattingMapper chattingMapper;

    public HashMap<String, Object> saveChat(HashMap<String, Object> map) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            if (map.get("roomId") == null) map.put("roomId", 1);
            if (map.get("userId") == null && map.get("sender") != null) {
                map.put("userId", map.get("sender"));
            }
            chattingMapper.insertChat(map);
            res.put("result", "success");
        } catch (Exception e) {
            res.put("result", "fail");
            res.put("message", e.getMessage());
        }
        return res;
    }

    public HashMap<String, Object> history(HashMap<String, Object> map) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            int page = parseInt(map.get("page"), 0);
            int pageSize = parseInt(map.get("pageSize"), 50);
            map.put("offset", page * pageSize);
            map.put("pageSize", pageSize);

            List<ChatMessage> list = chattingMapper.selectHistory(map);
            int cnt = chattingMapper.selectHistoryCnt(map);
            res.put("list", list);
            res.put("cnt", cnt);
            res.put("result", "success");
        } catch (Exception e) {
            res.put("result", "fail");
            res.put("message", e.getMessage());
        }
        return res;
    }

    private int parseInt(Object v, int def) {
        if (v == null) return def;
        try { return Integer.parseInt(String.valueOf(v)); }
        catch (Exception e) { return def; }
    }
}
