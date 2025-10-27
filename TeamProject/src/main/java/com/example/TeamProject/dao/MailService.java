package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class MailService {
	
	private final Map<String, String> authCodes = new HashMap<>();
	
	public void saveAuthCode(String email, String code) {
        authCodes.put(email, code);
    }
	
	public boolean verifyAuthCode(String email, String inputCode) {
        return authCodes.containsKey(email) && authCodes.get(email).equals(inputCode);
    }
}
