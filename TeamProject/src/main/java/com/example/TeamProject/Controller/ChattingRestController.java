package com.example.TeamProject.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.ChattingService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ChattingRestController {

	@Autowired
	ChattingService chattingService;

	/*
	 * ========================= 채팅 페이지 진입 (.do) — POST =========================
	 */
	@RequestMapping("/chatting.do")
	public String chatting(HttpServletRequest req) {
		  // 넘어온 param을 attribute로 승격(있을 때만)
		  String sid = req.getParameter("sessionId");
		  String sname = req.getParameter("sessionName");
		  if (sid != null)   req.setAttribute("sessionId", sid);
		  if (sname != null) req.setAttribute("sessionName", sname);
		  String roomNo = req.getParameter("roomNo");
		  if (roomNo != null) req.setAttribute("roomNo", roomNo);
		  return "chatMessage";
	}

	/*
	 * ========================= 채팅 API (.dox) — 모두 POST =========================
	 */

	// 1) 방 만들기
	@RequestMapping(value = "/chat/room/create.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String createRoom(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: title, productNo(opt), ownerId, isPrivate(opt)
			resultMap = chattingService.createRoom(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// 2) 내 방 목록
	@RequestMapping(value = "/chat/myRooms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myRooms(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: userId
			resultMap = chattingService.myRooms(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// 3) 방 입장(참가 업서트)
	@RequestMapping(value = "/chat/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: roomNo, userId, role(opt)
			resultMap = chattingService.join(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// 4) 방 퇴장
	@RequestMapping(value = "/chat/leave.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String leave(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: roomNo, userId
			resultMap = chattingService.leave(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// 5) 메시지 저장 (JOIN/LEAVE/CHAT 모두 공용)
	@RequestMapping(value = "/chat/save.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String save(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: roomNo, userId, contents, type(CHAT/JOIN/LEAVE), senderName(opt)
			resultMap = chattingService.saveMessage(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// 6) 히스토리 조회 (무한스크롤/페이지)
	@RequestMapping(value = "/chat/history.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String history(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 기대 파라미터: roomNo, page(opt, 기본0), pageSize(opt, 기본50)
			resultMap = chattingService.history(map);
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}
}
