package com.example.TeamProject.Controller;

import java.util.ArrayList;
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

import com.example.TeamProject.dao.NotificationService;
import com.example.TeamProject.dao.PaymentService;
import com.example.TeamProject.dao.SubscriptionService;
import com.example.TeamProject.model.Cart;
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
	        // 로그인 방어 
	        String sessionUser = (String) session.getAttribute("sessionId");
	        if (sessionUser == null || sessionUser.isBlank()) {
	            resultMap.put("result", "fail");
	            resultMap.put("code", "LOGIN_REQUIRED");
	            resultMap.put("message", "로그인이 필요합니다.");
	            return new Gson().toJson(resultMap);
	        }

	        String impUid = String.valueOf(map.get("impUid"));
	        String merchantUid = String.valueOf(map.get("merchantUid"));

	        // PortOne 결제 검증
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

	        // 모드 분기: cartNos 있으면 다건(특산물 박스/장바구니)
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

	        // 서버 기준 금액 계산(변조 방지) + PG 금액 비교
	        int goodsTotal = 0;
	        boolean hasDelivery = false;

	        for (com.example.TeamProject.model.Cart l : lines) {
	            int unit = toInt(l.getUnitPrice(), 0);
	            int qty  = Math.max(1, toInt(l.getQuantity(), 1));
	            goodsTotal += unit * qty;

	            String f = String.valueOf(l.getFulfillment());
	            if ("delivery".equalsIgnoreCase(f)) hasDelivery = true;
	        }
	        
	        String testPay = String.valueOf(map.getOrDefault("testPay", "")).trim();
	        boolean isTestPay = "Y".equalsIgnoreCase(testPay) || "true".equalsIgnoreCase(testPay);
	        int shippingFee = 0;

	        for (Cart l : lines) {
	            String f = String.valueOf(l.getFulfillment());
	            if ("delivery".equalsIgnoreCase(f)) {
	                shippingFee = Math.max(shippingFee, toInt(l.getShippingFee(), 0)); // 배송 상품 중 최대 배송비
	            }
	        }

	        int usedPoint = Math.max(0, toInt(map.get("usedPoint"), 0));
	        int expectedAmount = Math.max(0, goodsTotal + shippingFee - usedPoint);
	        if (!isTestPay) {
	            if (paidAmount != expectedAmount) {
	                throw new IllegalStateException("결제금액 불일치(서버=" + expectedAmount + ", PG=" + paidAmount + ")");
	            }
	        } else {	
	            if (paidAmount != 1) {
	                throw new IllegalStateException("테스트 결제는 1원만 허용됩니다. paidAmount=" + paidAmount);
	            }
	        }	       

	        // ORDERS INSERT
	        HashMap<String, Object> orderMap = new HashMap<>();
	        int orderTotalToSave = isTestPay ? expectedAmount : paidAmount;

	        orderMap.put("totalPrice", orderTotalToSave);
	        orderMap.put("status", isTestPay ? "테스트결제" : "결제완료");	      
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", sessionUser);
	        
	        if (map.get("ucId") != null && !String.valueOf(map.get("ucId")).isBlank()) {
	            orderMap.put("issueNo", map.get("ucId"));
	        }

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        // PAYMENT INSERT
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", "SUCCESS");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", paidAmount);
	        paymentService.insertPayment(payMap);
	        
	        Set<String> sellerIds = new HashSet<>();

	        // ORDER_ITEM 여러 건 INSERT + 재고 차감
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

	        // cart 모드면 결제된 cart 삭제
	        if (isCartMode) {
	            HashMap<String, Object> del = new HashMap<>();
	            del.put("userId", sessionUser);
	            del.put("cartNoList", parseCsvToLongList(cartNosCsv));
	            paymentService.deleteCartByNos(del);
	                 
	        }
	        // 쿠폰 사용 처리
	        Integer ucId = toInt(map.get("ucId"), null);
            if (ucId != null) {
                paymentService.useCoupon(ucId);
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
	@RequestMapping(
	    value = "/payment/subscriptionVerify.dox",
	    method = RequestMethod.POST,
	    produces = "application/json;charset=UTF-8"
	)
	@ResponseBody
	public String verifySubscriptionPayment(
	    @RequestParam HashMap<String, Object> map,
	    HttpSession session
	) throws Exception {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 로그인 방어
	        String sessionUser = (String) session.getAttribute("sessionId");
	        if (sessionUser == null || sessionUser.isBlank()) {
	            resultMap.put("result", "fail");
	            resultMap.put("code", "LOGIN_REQUIRED");
	            resultMap.put("message", "로그인이 필요합니다.");
	            return new Gson().toJson(resultMap);
	        }

	        // 테스트 결제 여부 
	        boolean isTest = "Y".equalsIgnoreCase(String.valueOf(map.getOrDefault("testPay", "N")));

	        // 필수값
	        String impUid = String.valueOf(map.get("impUid"));
	        Integer planId = toInt(map.get("planId"), null);
	        if (planId == null) throw new IllegalArgumentException("planId가 없습니다.");

	        // 서버 기준 플랜 조회
	        HashMap<String, Object> plan = subscriptionService.getPlanById(planId);
	        if (plan == null || plan.isEmpty()) throw new IllegalStateException("플랜 정보를 찾을 수 없습니다.");

	        String periodType = String.valueOf(plan.get("periodType")); 
	        int planPrice = toInt(plan.get("price"), 0);
	        if (planPrice <= 0) throw new IllegalStateException("플랜 가격이 올바르지 않습니다.");

	        int expectedAmount = planPrice;     
	        int amountToSave  = expectedAmount;

	        // PortOne 검증
	        String accessToken = paymentService.getPortOneAccessToken();
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        String status = String.valueOf(paymentData.get("status"));
	        int paidAmount = toInt(paymentData.get("amount"), 0);

	        if (!"paid".equalsIgnoreCase(status)) {
	            throw new IllegalStateException("결제가 완료되지 않았습니다. status=" + status);
	        }

	        if (isTest) {
	            if (paidAmount != 1) {
	                throw new IllegalStateException("테스트 결제는 1원만 허용됩니다. paid=" + paidAmount);
	            }
	        } else {
	            if (paidAmount != expectedAmount) {
	                throw new IllegalStateException("결제금액 불일치(서버=" + expectedAmount + ", PG=" + paidAmount + ")");
	            }
	        }

	        String paymentMethod = String.valueOf(paymentData.get("pay_method"));
	        if (paymentMethod == null || paymentMethod.isBlank() || "null".equalsIgnoreCase(paymentMethod)) {
	            paymentMethod = "UNKNOWN";
	        }

	        // ORDERS 저장 
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", amountToSave);
	        orderMap.put("status", "결제완료");
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", sessionUser);

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        // PAYMENT 저장
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", "SUCCESS");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", amountToSave);
	        paymentService.insertPayment(payMap);

	        // SUBSCRIPTION 생성
	        HashMap<String, Object> subMap = new HashMap<>();
	        subMap.put("planId", planId);
	        subMap.put("userId", sessionUser);
	        subMap.put("status", "ACTIVE");
	        subMap.put("orderNo", orderNo);
	        subscriptionService.insertSubscription(subMap);
	        
	        // 정기구독 신청 완료 알림 발송
	        try {
	            String buyerId = (String) map.get("buyerId");
	            String msg = "[정기구독] 신청이 완료되었습니다. 첫 배송부터 꼼꼼히 챙겨드릴게요!";
	            notificationService.sendNotification(buyerId, "NOTICE", msg, "/buyerMyPage.do?tab=subscriptions");
	        } catch (Exception ne) {
	            System.err.println("정기구독 알림 발송 실패: " + ne.getMessage());
	        }
	        Integer subscriptionId = toInt(subMap.get("subscriptionId"), null);
	        if (subscriptionId == null) throw new IllegalStateException("subscriptionId 생성 실패");

	        // 8) SUBSCRIPTION_ORDER 기록(회차 결제 내역)
	        HashMap<String, Object> subOrderMap = new HashMap<>();
	        subOrderMap.put("subscriptionId", subscriptionId);
	        subOrderMap.put("orderNo", orderNo);
	        subOrderMap.put("amount", amountToSave);
	        subOrderMap.put("status", "PAID");
	        subscriptionService.insertSubscriptionOrder(subOrderMap);

	        // SUBSCRIPTION 업데이트
	        HashMap<String, Object> upd = new HashMap<>();
	        upd.put("subscriptionId", subscriptionId);
	        upd.put("lastOrderNo", orderNo);
	        upd.put("periodType", periodType);
	        subscriptionService.updateSubscriptionAfterPaid(upd);

	        resultMap.put("result", "success");
	        resultMap.put("orderNo", orderNo);
	        resultMap.put("subscriptionId", subscriptionId);
	        resultMap.put("message", "정기배송 신청 완료");

	    } catch (Exception e) {
	        e.printStackTrace();
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

	        // 모드 분기 
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
	        
	        // ORDERS INSERT
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", paidAmount);
	        orderMap.put("status", "결제완료"); 
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", sessionUser);

	        // 쿠폰 번호가 있으면 주문 정보에 포함 (저장 순서 개선)
	        if (map.get("ucId") != null && !String.valueOf(map.get("ucId")).isBlank()) {
	            orderMap.put("issueNo", map.get("ucId"));
	        }

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");
	        
	        // PAYMENT INSERT
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", "TEST_CARD");
	        payMap.put("paymentStatus", "SUCCESS");
	        payMap.put("transactionNo", impUid);
	        payMap.put("amount", paidAmount);
	        paymentService.insertPayment(payMap);
	        
	        Set<String> sellerIds = new HashSet<>();

	        // ORDER_ITEM + 재고 차감
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

	        // 장바구니 삭제
	        if (isCartMode) {
	            HashMap<String, Object> del = new HashMap<>();
	            del.put("userId", sessionUser);
	            del.put("cartNoList", parseCsvToLongList(cartNosCsv));
	            paymentService.deleteCartByNos(del);
	            
	        }
	        // 쿠폰 사용 처리
	        Integer ucId = toInt(map.get("ucId"), null);
            if (ucId != null) {
                paymentService.useCoupon(ucId);
            }

	        // 알림 발송 
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
