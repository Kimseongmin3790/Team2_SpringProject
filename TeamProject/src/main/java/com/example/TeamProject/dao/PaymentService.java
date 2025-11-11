package com.example.TeamProject.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.PaymentMapper;
import com.example.TeamProject.model.Cart;
import com.example.TeamProject.model.User;

@Service
public class PaymentService {
	
	@Autowired
	PaymentMapper paymentMapper;

	@Value("${portone.rest-key}")
    private String REST_KEY;
	
	@Value("${portone.rest-secret}")
	private String REST_SECRET;
	
    // Access Token 발급
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

    // 결제정보 조회
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
        map.put("pay_method", res.optString("pay_method", "unknown"));
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
    
    public void insertOrderItem(HashMap<String, Object> map) throws Exception {
        paymentMapper.insertOrderItem(map);
    }

    public HashMap<String, Object> getPaymentList(HashMap<String, Object> in) {
        HashMap<String, Object> out = new HashMap<>();
        try {
            // 입력 정규화
            Map<String, Object> p = new HashMap<>();
            String userId = safeStr(in.get("userId"));
            if (userId != null) p.put("userId", userId);

            String cartNosCsv = safeStr(in.get("cartNos"));
            if (cartNosCsv != null && !cartNosCsv.isBlank()) {
                List<Long> cartNoList = Arrays.stream(cartNosCsv.split(","))
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .map(Long::valueOf)
                        .collect(java.util.stream.Collectors.toList());
                p.put("cartNoList", cartNoList);
            } else {
                // 단건 모드
                Long productNo = toLong(in.get("productNo"));
                Integer quantity = toIntOrDefault(in.get("quantity"), 1);
                Long optionNo = toLongNullable(in.get("optionNo"));
                String fulfillment = normalizeFulfillment(safeStr(in.get("fulfillment")));
                Integer shippingFee = toIntNullable(in.get("shippingFee"));

                if (productNo != null) p.put("productNo", productNo);
                p.put("quantity", quantity);
                if (optionNo != null) p.put("optionNo", optionNo);
                if (fulfillment != null) p.put("fulfillment", fulfillment);
                if (shippingFee != null) p.put("shippingFee", shippingFee);
            }

            // 조회
            List<Cart> list = paymentMapper.selectPaymentLines(p);

            out.put("result", "success");
            out.put("list", list);
            return out;
        } catch (Exception e) {
            e.printStackTrace();
            out.put("result", "fail");
            out.put("message", e.getMessage());
            return out;
        }
    }

	public HashMap<String, Object> getUserInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			User info = paymentMapper.selectUserInfo(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	// ===== helper =====
    private static String safeStr(Object o) { return (o == null) ? null : String.valueOf(o); }
    private static Long toLong(Object o) {
        try { return (o == null || String.valueOf(o).isBlank()) ? null : Long.valueOf(String.valueOf(o)); }
        catch (Exception e) { return null; }
    }
    private static Long toLongNullable(Object o) { return toLong(o); }
    private static Integer toIntOrDefault(Object o, int def) {
        try { return (o == null || String.valueOf(o).isBlank()) ? def : Integer.valueOf(String.valueOf(o)); }
        catch (Exception e) { return def; }
    }
    private static Integer toIntNullable(Object o) {
        try { return (o == null || String.valueOf(o).isBlank()) ? null : Integer.valueOf(String.valueOf(o)); }
        catch (Exception e) { return null; }
    }
    private static String normalizeFulfillment(String f) {
        if (f == null) return "delivery";
        String s = f.trim().toLowerCase();
        if (s.equals("delivery") || s.equals("visit") || s.equals("pickup")) return s;
        return "delivery";
    }
}
