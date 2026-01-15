package com.example.TeamProject.Controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
import jakarta.servlet.http.HttpSession;

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
	public String verifyPayment(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // ✅ 로그인 방어 (세션 기준)
	        String sessionUser = (String) session.getAttribute("sessionId");
	        if (sessionUser == null || sessionUser.isBlank()) {
	            resultMap.put("result", "fail");
	            resultMap.put("code", "LOGIN_REQUIRED");
	            resultMap.put("message", "로그인이 필요합니다.");
	            return new Gson().toJson(resultMap);
	        }

	        String impUid = String.valueOf(map.get("impUid"));
	        String merchantUid = String.valueOf(map.get("merchantUid"));

	        // 1) PortOne 결제 검증
	        String accessToken = paymentService.getPortOneAccessToken();
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        String paymentMethod = String.valueOf(paymentData.get("pay_method"));
	        if (paymentMethod == null || paymentMethod.isBlank() || "null".equalsIgnoreCase(paymentMethod)) {
	            paymentMethod = "UNKNOWN";
	        }

	        String status = String.valueOf(paymentData.get("status"));
	        int paidAmount = toInt(paymentData.get("amount"), 0); // ✅ 안전캐스팅

	        if (!"paid".equalsIgnoreCase(status)) {
	            throw new IllegalStateException("결제가 완료되지 않았습니다. status=" + status);
	        }

	        // 2) 모드 분기: cartNos 있으면 다건(특산물 박스/장바구니)
	        String cartNosCsv = String.valueOf(map.getOrDefault("cartNos", "")).trim();
	        boolean isCartMode = (cartNosCsv != null && !cartNosCsv.isBlank() && !"null".equalsIgnoreCase(cartNosCsv));

	        List<com.example.TeamProject.model.Cart> lines;

	        if (isCartMode) {
	            List<Long> cartNoList = parseCsvToLongList(cartNosCsv);
	            if (cartNoList.isEmpty()) throw new IllegalArgumentException("cartNos가 올바르지 않습니다.");

	            HashMap<String, Object> q = new HashMap<>();
	            q.put("userId", sessionUser);
	            q.put("cartNoList", cartNoList);

	            lines = paymentService.selectPaymentLines(q); // ✅ 기존 selectPaymentLines 재사용
	            if (lines == null || lines.isEmpty()) throw new IllegalStateException("결제 대상(cart)이 없습니다.");

	        } else {
	            Integer productNo = toInt(map.get("productNo"), null);
	            Integer optionNo  = toInt(map.get("optionNo"), null);
	            Integer quantity  = Math.max(1, toInt(map.get("quantity"), 1));
	            String fulfillment = String.valueOf(map.getOrDefault("fulfillment", "delivery"));

	            if (productNo == null) throw new IllegalArgumentException("productNo가 없습니다.");

	            HashMap<String, Object> q = new HashMap<>();
	            q.put("productNo", productNo);
	            q.put("optionNo", optionNo);
	            q.put("quantity", quantity);
	            q.put("fulfillment", fulfillment);

	            lines = paymentService.selectPaymentLines(q);
	            if (lines == null || lines.isEmpty()) throw new IllegalStateException("결제 대상(단건)이 없습니다.");
	        }

	        // 3) 서버 기준 금액 계산(변조 방지) + PG 금액 비교
	        int goodsTotal = 0;
	        boolean hasDelivery = false;

	        for (com.example.TeamProject.model.Cart l : lines) {
	            int unit = toInt(l.getUnitPrice(), 0);
	            int qty  = Math.max(1, toInt(l.getQuantity(), 1));
	            goodsTotal += unit * qty;

	            String f = String.valueOf(l.getFulfillment());
	            if ("delivery".equalsIgnoreCase(f)) hasDelivery = true;
	        }

	        int shippingFee = hasDelivery ? 3000 : 0;
	        int usedPoint = Math.max(0, toInt(map.get("usedPoint"), 0));
	        int expectedAmount = Math.max(0, goodsTotal + shippingFee - usedPoint);

	        if (paidAmount != expectedAmount) {
	            throw new IllegalStateException("결제금액 불일치(서버=" + expectedAmount + ", PG=" + paidAmount + ")");
	        }

	        // 4) ORDERS INSERT (네 컬럼에 맞춤)
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", paidAmount);
	        orderMap.put("status", "결제완료");
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", sessionUser);

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        // 5) PAYMENT INSERT
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", "SUCCESS");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", paidAmount);
	        paymentService.insertPayment(payMap);
	        
	        Set<String> sellerIds = new HashSet<>();

	        // 6) ORDER_ITEM 여러 건 INSERT + 재고 차감
	        for (com.example.TeamProject.model.Cart l : lines) {
	            Integer productNo = toInt(l.getProductNo(), null);
	            Integer optionNo  = toInt(l.getOptionNo(), null);
	            Integer qty       = Math.max(1, toInt(l.getQuantity(), 1));
	            Integer unitPrice = toInt(l.getUnitPrice(), 0);

	            if (productNo == null) throw new IllegalStateException("상품 번호 누락");
	            if (l.getSellerId() != null) sellerIds.add(l.getSellerId());

	            // 옵션이 있는 상품만 재고 차감
	            if (optionNo != null) {
	                int updated = paymentService.decreaseOptionStock(optionNo, qty);
	                if (updated == 0) throw new IllegalStateException("옵션 재고 부족 또는 옵션 없음");
	                paymentService.refreshProductStatusByProductNo(productNo);
	            }

	            HashMap<String, Object> itemMap = new HashMap<>();
	            itemMap.put("orderNo", orderNo);
	            itemMap.put("quantity", qty);
	            itemMap.put("price", unitPrice);
	            itemMap.put("productNo", productNo);
	            itemMap.put("optionNo", optionNo);

	            paymentService.insertOrderItem(itemMap);
	        }

	        // 7) cart 모드면 결제된 cart 삭제(선택이지만 보통 필요)
	        if (isCartMode) {
	            HashMap<String, Object> del = new HashMap<>();
	            del.put("userId", sessionUser);
	            del.put("cartNoList", parseCsvToLongList(cartNosCsv));
	            paymentService.deleteCartByNos(del);
	        }
        
        // 알림 발송 
	        try {
	            String buyerId = (String) map.get("buyerId");
	            String msg = "[주문완료] 결제가 완료되었습니다. (주문번호: " + orderNo + ")";
	            notificationService.sendNotification(buyerId, "ORDER", msg, "/buyerMyPage.do?tab=orders");
	            
	         // 2. 판매자 알림 추가
	            for (String sId : sellerIds) {
	                String sellerMsg = "[신규주문] 등록하신 상품에 새로운 주문이 접수되었습니다. (주문번호: " + orderNo + ")";
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
	        
	        // [추가] 정기구독 신청 완료 알림 발송
	        try {
	            String buyerId = (String) map.get("buyerId");
	            String msg = "[정기구독] 신청이 완료되었습니다. 첫 배송부터 꼼꼼히 챙겨드릴게요!";
	            notificationService.sendNotification(buyerId, "NOTICE", msg, "/buyerMyPage.do?tab=subscriptions");
	        } catch (Exception ne) {
	            System.err.println("정기구독 알림 발송 실패: " + ne.getMessage());
	        }

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
	
	private List<Long> parseCsvToLongList(String csv) {
	    List<Long> list = new ArrayList<>();
	    if (csv == null) return list;
	    for (String t : csv.split(",")) {
	        String s = t.trim();
	        if (s.isEmpty()) continue;
	        try { list.add(Long.parseLong(s)); } catch (Exception ignore) {}
	    }
	    return list;
	}
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/payment/testVerify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String testVerifyPayment(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String sessionUser = (String) session.getAttribute("sessionId");
	        if (sessionUser == null || sessionUser.isBlank()) {
	            resultMap.put("result", "fail");
	            resultMap.put("code", "LOGIN_REQUIRED");
	            resultMap.put("message", "로그인이 필요합니다.");
	            return new Gson().toJson(resultMap);
	        }

	        // 테스트 모드이므로 PG 검증 생략
	        String impUid = String.valueOf(map.get("impUid")); // 가짜 ID
	        // String merchantUid = String.valueOf(map.get("merchantUid"));
	        int paidAmount = toInt(map.get("amount"), 0);

	        // 2) 모드 분기 (verifyPayment와 동일 로직)
	        String cartNosCsv = String.valueOf(map.getOrDefault("cartNos", "")).trim();
	        boolean isCartMode = (cartNosCsv != null && !cartNosCsv.isBlank() && !"null".equalsIgnoreCase(cartNosCsv));

	        List<com.example.TeamProject.model.Cart> lines;

	        if (isCartMode) {
	            List<Long> cartNoList = parseCsvToLongList(cartNosCsv);
	            if (cartNoList.isEmpty()) throw new IllegalArgumentException("cartNos가 올바르지 않습니다.");

	            HashMap<String, Object> q = new HashMap<>();
	            q.put("userId", sessionUser);
	            q.put("cartNoList", cartNoList);

	            lines = paymentService.selectPaymentLines(q);
	            if (lines == null || lines.isEmpty()) throw new IllegalStateException("결제 대상(cart)이 없습니다.");
	        } else {
	            Integer productNo = toInt(map.get("productNo"), null);
	            Integer optionNo  = toInt(map.get("optionNo"), null);
	            Integer quantity  = Math.max(1, toInt(map.get("quantity"), 1));
	            String fulfillment = String.valueOf(map.getOrDefault("fulfillment", "delivery"));

	            if (productNo == null) throw new IllegalArgumentException("productNo가 없습니다.");

	            HashMap<String, Object> q = new HashMap<>();
	            q.put("productNo", productNo);
	            q.put("optionNo", optionNo);
	            q.put("quantity", quantity);
	            q.put("fulfillment", fulfillment);

	            lines = paymentService.selectPaymentLines(q);
	            if (lines == null || lines.isEmpty()) throw new IllegalStateException("결제 대상(단건)이 없습니다.");
	        }
	        
	        // 4) ORDERS INSERT
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", paidAmount);
	        orderMap.put("status", "결제완료"); // 바로 결제완료
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", sessionUser);

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        // 5) PAYMENT INSERT
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", "TEST_CARD");
	        payMap.put("paymentStatus", "SUCCESS");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", paidAmount);
	        paymentService.insertPayment(payMap);
	        
	        Set<String> sellerIds = new HashSet<>();

	        // 6) ORDER_ITEM + 재고 차감
	        for (com.example.TeamProject.model.Cart l : lines) {
	            Integer productNo = toInt(l.getProductNo(), null);
	            Integer optionNo  = toInt(l.getOptionNo(), null);
	            Integer qty       = Math.max(1, toInt(l.getQuantity(), 1));
	            Integer unitPrice = toInt(l.getUnitPrice(), 0);

	            if (l.getSellerId() != null) sellerIds.add(l.getSellerId());

	            if (optionNo != null) {
	                paymentService.decreaseOptionStock(optionNo, qty);
	                paymentService.refreshProductStatusByProductNo(productNo);
	            }

	            HashMap<String, Object> itemMap = new HashMap<>();
	            itemMap.put("orderNo", orderNo);
	            itemMap.put("quantity", qty);
	            itemMap.put("price", unitPrice);
	            itemMap.put("productNo", productNo);
	            itemMap.put("optionNo", optionNo);

	            paymentService.insertOrderItem(itemMap);
	        }

	        // 7) 장바구니 삭제
	        if (isCartMode) {
	            HashMap<String, Object> del = new HashMap<>();
	            del.put("userId", sessionUser);
	            del.put("cartNoList", parseCsvToLongList(cartNosCsv));
	            paymentService.deleteCartByNos(del);
	        }

	        // 8) 알림 발송 (테스트의 핵심)
	        try {
	            String buyerId = (String) map.get("buyerId");
	            String msg = "[테스트주문] 결제가 완료되었습니다. (주문번호: " + orderNo + ")";
	            notificationService.sendNotification(buyerId, "ORDER", msg, "/buyerMyPage.do?tab=orders");
	            
	            for (String sId : sellerIds) {
	                String sellerMsg = "[신규주문] 등록하신 상품에 새로운 주문이 접수되었습니다. (주문번호: " + orderNo + ")";
	                notificationService.sendNotification(sId, "ORDER", sellerMsg, "/order/sellerList.do");
	            }	     
	        } catch (Exception ne) {
	        	ne.printStackTrace();
	        }

	        resultMap.put("result", "success");
	        resultMap.put("orderNo", orderNo);
	        resultMap.put("message", "테스트 결제 완료");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return new Gson().toJson(resultMap);
	}

}
