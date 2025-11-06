package com.example.TeamProject.Controller;

import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.PaymentService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService;
	
	@RequestMapping("/product/payment.do")
	public String payment(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map.get("productNo"));
		request.setAttribute("productNo", map.get("productNo"));
		System.out.println(map.get("userId"));
		request.setAttribute("userId", map.get("userId"));
		System.out.println(map.get("qty"));
		request.setAttribute("qty", map.get("qty"));
		return "product/payment";
	}
	
	@RequestMapping(value = "/payment/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getPaymentList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/userInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getUserInfo(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/verify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifyPayment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // imp_uid, merchant_uid, 결제수단 등 프론트에서 전달
	        String impUid = (String) map.get("impUid");
	        String merchantUid = (String) map.get("merchantUid");

	        // 1️⃣ PortOne Access Token 발급
	        String accessToken = paymentService.getPortOneAccessToken();

	        // 2️⃣ imp_uid로 결제 정보 조회
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        // PortOne 결제 정보 파싱
	        String paymentMethod = (String) paymentData.get("pay_method");  // card, kakaopay 등
	        if (paymentMethod == null || paymentMethod.isEmpty()) {
	            paymentMethod = "UNKNOWN";
	        }
	        String status = (String) paymentData.get("status");             // paid, failed
	        int amount = ((Double) paymentData.get("amount")).intValue();
	        String transactionNo = impUid; // PortOne 고유 결제번호
	        
	        // ✅ 3. 주문 정보 생성 (ORDER 테이블에 insert)
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", amount);
	        orderMap.put("status", "결제완료");
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", map.get("buyerId"));
	        
	        // ORDER 테이블에 주문정보 저장
	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo"); // mapper에서 selectKey로 반환받음
	        
	        // 결제 정보 생성(PAYMENT 테이블에 INSERT)
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);  // FK (주문번호)
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", status.equals("paid") ? "SUCCESS" : "FAILED");
	        payMap.put("transactionNo", transactionNo);
	        payMap.put("amount", amount);

	        // 4️⃣ DB Insert 실행
	        paymentService.insertPayment(payMap);

	        resultMap.put("result", "success");
	        resultMap.put("orderNo", orderNo);
	        resultMap.put("message", "결제정보 저장 완료");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }

	    return new Gson().toJson(resultMap);
	}
	
	

}
