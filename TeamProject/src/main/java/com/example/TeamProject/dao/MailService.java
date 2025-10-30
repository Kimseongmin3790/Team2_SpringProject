package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;

import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;


@Service
public class MailService {
	
	@Autowired
	private JavaMailSender mailSender;
	
	private final Map<String, String> authCodes = new HashMap<>();
	
	public void saveAuthCode(String email, String code) {
        authCodes.put(email, code);
    }
	
	public boolean verifyAuthCode(String email, String inputCode) {
        return authCodes.containsKey(email) && authCodes.get(email).equals(inputCode);
    }
	
	// 제휴 신청
    public void sendPartnershipInquiryEmail(Map<String, String> inquiryData) throws Exception {

        String adminEmail = "sinso5281532@gmail.com"; // 임시 이메일 주소 
        String subject = "[제휴 문의] " + inquiryData.get("inquirerName") + "으로부터 문의가 도착했습니다.";

        // HTML 본문 생성
        String htmlBody = "<h2>제휴 문의 내용</h2>"
                        + "<hr>"
                        + "<p><strong>업체명:</strong> " + inquiryData.get("inquirerName") + "</p>"
                        + "<p><strong>담당자 이름:</strong> " + inquiryData.get("managerName") + "</p>"
                        + "<p><strong>회신 이메일:</strong> " + inquiryData.get("email") + "</p>"
                        + "<p><strong>연락처:</strong> " + (inquiryData.get("phone") != null ? inquiryData.get("phone") : "없음") + "</p>"
                        + "<hr>"
                        + "<h3>제안 내용:</h3>"
                        + "<div style='white-space: pre-wrap; border: 1px solid #eee; padding: 10px;'>"
                        + inquiryData.get("proposal")
                        + "</div>";

        // MimeMessage를 사용하여 HTML 이메일 발송
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "UTF-8");

        helper.setTo(adminEmail);
        helper.setSubject(subject);
        helper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

}
