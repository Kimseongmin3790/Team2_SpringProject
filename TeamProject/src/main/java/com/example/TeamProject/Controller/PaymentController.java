package com.example.TeamProject.Controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService;
	
	@Autowired
	SubscriptionService subscriptionService;
	
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

	        // 6) ORDER_ITEM 여러 건 INSERT + 재고 차감
	        for (com.example.TeamProject.model.Cart l : lines) {
	            Integer productNo = toInt(l.getProductNo(), null);
	            Integer optionNo  = toInt(l.getOptionNo(), null);
	            Integer qty       = Math.max(1, toInt(l.getQuantity(), 1));
	            Integer unitPrice = toInt(l.getUnitPrice(), 0);

	            if (productNo == null) throw new IllegalStateException("상품 번호 누락");

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
	public String verifySubscriptionPayment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String impUid = (String) map.get("impUid");
	        String merchantUid = (String) map.get("merchantUid");

	        // 1) PortOne Access Token
	        String accessToken = paymentService.getPortOneAccessToken();

	        // 2) 결제 정보 조회
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        String paymentMethod = (String) paymentData.get("pay_method");
	        if (paymentMethod == null || paymentMethod.isEmpty()) {
	            paymentMethod = "UNKNOWN";
	        }
	        String status = (String) paymentData.get("status"); // paid, failed
	        int amount = ((Double) paymentData.get("amount")).intValue();
	        String transactionNo = impUid;

	        // 3) ORDER INSERT (구독 타입 표시용 컬럼이 있다면 orderType='SUBSCRIPTION')
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("totalPrice", amount);
	        orderMap.put("status", "결제완료");
	        orderMap.put("receivName", map.get("receivName"));
	        orderMap.put("receivPhone", map.get("receivPhone"));
	        orderMap.put("deliverAddr", map.get("deliverAddr"));
	        orderMap.put("memo", map.get("memo"));
	        orderMap.put("buyerId", map.get("buyerId"));
	        // orderMap.put("orderType", "SUBSCRIPTION");  // ORDER 테이블에 컬럼 있다면

	        paymentService.insertOrder(orderMap);
	        int orderNo = (int) orderMap.get("orderNo");

	        // 4) PAYMENT INSERT
	        HashMap<String, Object> payMap = new HashMap<>();
	        payMap.put("orderNo", orderNo);
	        payMap.put("paymentMethod", paymentMethod.toUpperCase());
	        payMap.put("paymentStatus", status.equals("paid") ? "SUCCESS" : "FAILED");
	        payMap.put("transactionNo", transactionNo);
	        payMap.put("amount", amount);
	        paymentService.insertPayment(payMap);

	        // 5) SUBSCRIPTION INSERT
	        HashMap<String, Object> subMap = new HashMap<>();
	        subMap.put("userId", map.get("buyerId"));
	        subMap.put("planId", Integer.parseInt(String.valueOf(map.get("planId"))));
	        subMap.put("orderNo", orderNo);
	        subMap.put("status", "ACTIVE");
	        subMap.put("periodType", String.valueOf(map.get("periodType")));
	        subMap.put("memo", map.get("memo"));

	        subscriptionService.insertSubscription(subMap);

	        resultMap.put("result", "success");
	        resultMap.put("orderNo", orderNo);
	        resultMap.put("subscriptionId", subMap.get("subscriptionId"));
	        resultMap.put("message", "정기배송 신청 및 결제 완료");

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
	        String s = v.toString().trim();
	        if (s.isEmpty() || "null".equalsIgnoreCase(s)) return def;
	        // 1,000 같은 포맷 혹시 대비
	        s = s.replaceAll(",", "");
	        return new java.math.BigDecimal(s).intValue();
	    } catch (Exception e) {
	        return def;
	    }
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

}
