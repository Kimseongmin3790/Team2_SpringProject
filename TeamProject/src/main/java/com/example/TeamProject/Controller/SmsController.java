package com.example.TeamProject.Controller;

import java.io.File;
import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Balance;
import net.nurigo.sdk.message.model.Message;          // ✅ 누락되기 쉬운 import
import net.nurigo.sdk.message.model.StorageType;
import net.nurigo.sdk.message.request.MessageListRequest;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.MessageListResponse;
import net.nurigo.sdk.message.response.MultipleDetailMessageSentResponse;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

@RestController
public class SmsController {

    final DefaultMessageService messageService;

    public SmsController(
            @Value("${coolsms.api.key}") String apiKey,
            @Value("${coolsms.api.secret}") String apiSecret) {
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, "https://api.coolsms.co.kr");
    }
    
    @Value("${coolsms.api.sender}")
    private String senderPhone;
    
    /**
     * 단일 메시지 발송 예제
     */
    @PostMapping("/send-one")
    public HashMap<String, Object> sendOne(@RequestParam("phone") String phone, HttpSession session) {
        Message message = new Message();
        // 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
        String ranStr = randomNumber();
        
        message.setFrom(senderPhone);
        message.setTo(phone);
        message.setText("[AGRICOLA 본인 인증] 인증번호 " + ranStr + "를 화면에 입력해주세요.");
        
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
        try {
        	SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
            System.out.println("문자 전송 결과" + response);
            
            // 세션에 인증번호 저장 (3분간 유효)
            session.setAttribute("authCode", ranStr);
            session.setAttribute("authPhone", phone);
            session.setMaxInactiveInterval(180);
            
            resultMap.put("result", "success");
            resultMap.put("message", "인증번호가 발송되었습니다");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "문자 발송에 실패했습니다.");
		}
        
        return resultMap;
    }
    
    // 인증번호 확인용 API 추가
    @PostMapping("/verify-code")
    public HashMap<String, Object> verifyCode(
            @RequestParam("phone") String phone,
            @RequestParam("code") String code,
            HttpSession session) {

        HashMap<String, Object> resultMap = new HashMap<>();
        String savedCode = (String) session.getAttribute("authCode");
        String savedPhone = (String) session.getAttribute("authPhone");

        if (savedCode != null && savedPhone != null &&
            savedPhone.equals(phone) && savedCode.equals(code)) {
            resultMap.put("result", "success");
            resultMap.put("message", "인증이 완료되었습니다.");
        } else {
            resultMap.put("result", "fail");
            resultMap.put("message", "인증번호가 일치하지 않습니다.");
        }

        return resultMap;
    }

    
    public String randomNumber () {
    	Random ran = new Random();
		String ranStr = "";
		
		for(int i=0; i<6; i++) {
			ran.nextInt(10);
			ranStr += ran.nextInt(10);
		}
		
    	return ranStr;
    }
    
}