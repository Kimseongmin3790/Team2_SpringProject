package com.example.TeamProject.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.PaymentMapper;

@Service
public class PaymentService {
	
	@Autowired
	PaymentMapper paymentMapper;

	@Value("${portone.rest-key}")
    private String REST_KEY;
	
	@Value("${portone.rest-secret}")
	private String REST_SECRET;
	
    // ✅ Access Token 발급
    public String getPortOneAccessToken() throws Exception {
        URL url = new URL("https://api.iamport.kr/users/getToken");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        JSONObject json = new JSONObject();
        json.put("imp_key", REST_KEY);
        json.put("imp_secret", REST_SECRET);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.toString().getBytes());
            os.flush();
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();

        JSONObject response = new JSONObject(sb.toString());
        return response.getJSONObject("response").getString("access_token");
    }

    // ✅ 결제정보 조회
    public HashMap<String, Object> getPaymentData(String impUid, String accessToken) throws Exception {
        URL url = new URL("https://api.iamport.kr/payments/" + impUid);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", accessToken);

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();

        JSONObject response = new JSONObject(sb.toString());
        
        if (!response.has("response") || response.isNull("response")) {
            throw new Exception("PortOne 응답이 비정상입니다: " + response);
        }
        
        JSONObject res = response.getJSONObject("response");

        HashMap<String, Object> map = new HashMap<>();
        map.put("amount", res.optDouble("amount", 0));
        map.put("status", res.optString("status", "unknown"));
        map.put("pay_method", res.optString("pay_method", "unknown")); // ✅ 안전하게
        map.put("merchant_uid", res.optString("merchant_uid", "unknown"));
        map.put("pg_provider", res.optString("pg_provider", "none"));
        return map;
    }
    
    public void insertPayment(HashMap<String, Object> map) throws Exception {
        paymentMapper.insertPayment(map);
    }
    
    public void insertOrder(HashMap<String, Object> map) throws Exception {
        paymentMapper.insertOrder(map);
    }
}
