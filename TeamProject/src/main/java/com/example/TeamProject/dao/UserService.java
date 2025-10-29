package com.example.TeamProject.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	
	@Autowired
	UserMapper userMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	MailService mailService;
	
	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String hashPwd = passwordEncoder.encode((String)map.get("userPwd"));
			map.put("hashPwd", hashPwd);
			userMapper.insertUser(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addSeller(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			userMapper.insertSeller(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> idCheck(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.idCheck(map);
			if (user != null) {
				resultMap.put("result", "N");
			} else {
				resultMap.put("result", "Y");
			}			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> login(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.loginUser(map);
			String message = "";
			String result = "";
			
			if (user != null) {
				boolean loginFlg = passwordEncoder.matches((String)map.get("userPwd"), user.getPassword());
				if (loginFlg) {
					message = "로그인 성공";
					result = "success";
					session.setAttribute("sessionId", user.getUserId());
					session.setAttribute("sessionStatus", user.getUserRole());
					session.setAttribute("sessionName", user.getName());
				} else {
					message = "비밀번호가 일치하지 않습니다";
					result = "fail";
				}
			} else {
				message = "아이디가 존재하지 않습니다.";
				result = "fail";
			}
			resultMap.put("msg", message);
			resultMap.put("result", result);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> logout(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		session.invalidate();
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> findId(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.findId(map);
			if (user != null) {
				resultMap.put("user", user);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> findPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.findPwd(map);
			if (user != null) {
				String autoCode = String.valueOf((int)(Math.random() * 900000) + 100000);
				mailService.saveAuthCode(user.getEmail(), autoCode);
				sendAuthCode(user.getEmail(), autoCode);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public void sendAuthCode(String toEmail, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[AGRICOLA] 비밀번호 재설정 인증코드 안내");
        message.setText(
                "안녕하세요 AGRICOLA입니다.\n\n" +
                "요청하신 인증코드는 아래와 같습니다.\n\n" +
                "인증코드: " + code + "\n\n" +
                "본인이 요청하지 않았다면 본 메일을 무시해주세요.\n\n감사합니다."
        );
        message.setFrom("sungmin3790@gmail.com"); // Gmail 계정과 동일하게
        mailSender.send(message);
    }
	
	public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String email = (String) map.get("userEmail");	    
	    String authCode = (String) map.get("authCode");
	    
		try {
			boolean isValid = mailService.verifyAuthCode(email, authCode);
			if (isValid) {		
				String hashPwd = passwordEncoder.encode((String)map.get("newPwd"));
				map.put("hashPwd", hashPwd);
				userMapper.resetPwd(map);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "invalid"); // 인증 실패
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
}
