package com.example.TeamProject.Controller;

import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.PaymentService;
import com.example.TeamProject.dao.SubscriptionService;
import com.example.TeamProject.dao.NotificationService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService;
	
	@Autowired
	SubscriptionService subscriptionService;

	@Autowired
	NotificationService notificationService;
	
	@RequestMapping("/product/payment.do")
	public String payment(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("productNo", map.get("productNo"));
		request.setAttribute("userId", map.get("userId"));
		request.setAttribute("qty", map.get("qty"));
		
		request.setAttribute("optionNo", map.get("optionNo"));
	    request.setAttribute("optionUnit", map.get("optionUnit"));
	    request.setAttribute("optionAddPrice", map.get("optionAddPrice"));
	    request.setAttribute("unitPrice", map.get("unitPrice"));
	    request.setAttribute("fulfillment", map.get("fulfillment"));
	    request.setAttribute("shippingFee", map.get("shippingFee"));
		
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
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/payment/verify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifyPayment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String impUid = (String) map.get("impUid");
	        Object isTestObj = map.get("isTest");
	        String isTest = (isTestObj != null) ? String.valueOf(isTestObj) : "N";

	        String paymentMethod = "UNKNOWN";
	        String status = "failed";
	        int amount = 0;
	        String transactionNo = "";

	        if ("Y".equalsIgnoreCase(isTest) || impUid == null || "null".equals(impUid)) {
	            paymentMethod = "TEST_PAY";
	            status = "paid";
	            amount = toInt(map.get("amount"), 0);
	            transactionNo = "TEST_" + System.currentTimeMillis();
	        } else {
	            String accessToken = paymentService.getPortOneAccessToken();
	            HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);
	            
	            paymentMethod = (String) paymentData.get("pay_method");
	            if (paymentMethod == null || paymentMethod.isEmpty()) {
	                paymentMethod = "UNKNOWN";
	            }
	            status = (String) paymentData.get("status");
	            amount = ((Double) paymentData.get("amount")).intValue();
	            transactionNo = impUid;
	        }
	        
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", amount);
	        orderMap.put("status", "결제완료");
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", map.get("buyerId"));
	        
	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");
	        
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", "paid".equals(status) ? "SUCCESS" : "FAILED");
	        payMap.put("transactionNo", transactionNo);
	        payMap.put("amount", amount);
	        paymentService.insertPayment(payMap);
	        
	        Integer optionNo  = toInt(map.get("optionNo"), null);
	        Integer productNo = toInt(map.get("productNo"), null);
	        Integer quantity  = toInt(map.get("quantity"), 1);
	        
	        if (optionNo != null) {
	            paymentService.decreaseOptionStock(optionNo, quantity);
	        }
	        if (productNo != null) {
	            paymentService.refreshProductStatusByProductNo(productNo);
	        }
	        
	        HashMap<String, Object> orderItemMap = new HashMap<>();
	        orderItemMap.put("orderNo", orderNo);
	        orderItemMap.put("quantity", quantity);
	        orderItemMap.put("price", toInt(map.get("unitPrice"), 0));
	        orderItemMap.put("productNo", productNo);
	        orderItemMap.put("optionNo", optionNo);
	        paymentService.insertOrderItem(orderItemMap);

	        // 알림 발송 
	        try {
	            String buyerId = (String) map.get("buyerId");
	            String msg = "[주문완료] 결제가 완료되었습니다. (주문번호: " + orderNo + ")";
	            notificationService.sendNotification(buyerId, "ORDER", msg, "/buyerMyPage.do?tab=orders");
	            
	         // 2. 판매자 알림 추가
	            String sId = paymentService.getSellerIdByProductNo(productNo);
	            if (sId != null && !sId.isEmpty()) {
	                String sellerMsg = "[신규주문] 등록하신 상품에 새로운 주문이 접수되었습니다.";
	                notificationService.sendNotification(sId, "ORDER", sellerMsg, "/order/sellerList.do");
	            }
	        } catch (Exception ne) {}
	        
	        
	        
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
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/payment/subscriptionVerify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifySubscriptionPayment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        String impUid = (String) map.get("impUid");
	        String accessToken = paymentService.getPortOneAccessToken();
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        String status = (String) paymentData.get("status"); 
	        int amount = ((Double) paymentData.get("amount")).intValue();

	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", amount);
	        orderMap.put("status", "결제완료");
	        orderMap.put("buyerId", map.get("buyerId"));
	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", "CARD");
	        payMap.put("paymentStatus", "paid".equals(status) ? "SUCCESS" : "FAILED");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", amount);
	        paymentService.insertPayment(payMap);

	        HashMap<String, Object> subMap = new HashMap<>();
	        subMap.put("userId", map.get("buyerId"));
	        subMap.put("planId", toInt(map.get("planId"), 0));
	        subMap.put("orderNo", orderNo);
	        subMap.put("status", "ACTIVE");
	        subMap.put("periodType", String.valueOf(map.get("periodType")));
	        subscriptionService.insertSubscription(subMap);

	        resultMap.put("result", "success");
	        resultMap.put("orderNo", orderNo);
	        resultMap.put("message", "정기배송 신청 완료");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return new Gson().toJson(resultMap);
	}
	
	private Integer toInt(Object v, Integer def) {
		if (v == null) return def;
	    if (v instanceof Number) return ((Number) v).intValue();
	    try {
	        String s = v.toString().trim().replaceAll(",", "");
	        return new java.math.BigDecimal(s).intValue();
	    } catch (Exception e) { return def; }
	}
}