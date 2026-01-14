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
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

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
	public String verifyPayment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // imp_uid, merchant_uid, 결제수단 등 프론트에서 전달
	        String impUid = (String) map.get("impUid");
	        String merchantUid = (String) map.get("merchantUid");

	        // PortOne Access Token 발급
	        String accessToken = paymentService.getPortOneAccessToken();

	        // imp_uid로 결제 정보 조회
	        HashMap<String, Object> paymentData = paymentService.getPaymentData(impUid, accessToken);

	        // PortOne 결제 정보 파싱
	        String paymentMethod = (String) paymentData.get("pay_method");  // card, kakaopay 등
	        if (paymentMethod == null || paymentMethod.isEmpty()) {
	            paymentMethod = "UNKNOWN";
	        }
	        String status = (String) paymentData.get("status");             // paid, failed
	        int amount = ((Double) paymentData.get("amount")).intValue();
	        String transactionNo = impUid; // PortOne 고유 결제번호
	        
	        // 주문 정보 생성 (ORDER 테이블에 insert)
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

	        // DB Insert 실행
	        paymentService.insertPayment(payMap);
	        
	        Integer optionNo  = toInt(map.get("optionNo"), null);
	        Integer productNo = toInt(map.get("productNo"), null);
	        Integer quantity  = toInt(map.get("quantity"), 1);
	        if (optionNo == null) throw new IllegalStateException("옵션 번호가 없습니다.");
	        
	        // 옵션 재고 차감 (음수 방지)
	        int updated = paymentService.decreaseOptionStock(optionNo, quantity);
	        if (updated == 0) throw new IllegalStateException("옵션 재고 부족 또는 옵션 없음");
	        
	        // 해당 상품의 상태 재계산 → SELLING / SOLDOUT (HIDDEN은 그대로 유지)
	        paymentService.refreshProductStatusByProductNo(productNo);
	        
	        // 주문 정보 생성(ORDER_ITEM 테이블에 INSERT) 
	        HashMap<String, Object> orderItemMap = new HashMap<>();
	        orderItemMap.put("orderNo", orderNo);  // FK (주문번호)
	        orderItemMap.put("quantity", toInt(map.get("quantity"), null));
	        orderItemMap.put("price", toInt(map.get("unitPrice"), null));
	        orderItemMap.put("productNo", toInt(map.get("productNo"), null));
	        orderItemMap.put("optionNo", toInt(map.get("optionNo"), null));
	        
	        // DB Insert 실행
	        paymentService.insertOrderItem(orderItemMap);
	        
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

}
