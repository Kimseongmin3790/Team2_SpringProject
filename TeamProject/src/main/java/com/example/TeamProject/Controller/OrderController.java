package com.example.TeamProject.Controller; // 패키지명 확인

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.OrderService;

import jakarta.servlet.http.HttpSession;


@Controller
public class OrderController {

    @Autowired
    OrderService orderService;

    @RequestMapping("order/sellerList.do")
    public String sellerList(Model model) {
        return "user/orderManagement";
    }


    // 판매자 주문목록 조회
    @PostMapping("/order/sellerList.dox")
    @ResponseBody

    public Map<String, Object> sellerOrderList(HttpSession session) {
        System.out.println("### 1. /order/sellerList.dox API 호출됨 ###");
        Map<String, Object> result = new HashMap<>();

        try {
            String sellerId = (String) session.getAttribute("sessionId");
            System.out.println("### 2. 세션에서 추출된 sellerId: '" + sellerId + "' ###");

            if (sellerId == null || sellerId.isEmpty()) {
                System.out.println("### 오류: sellerId가 null이거나 비어있습니다. 로그인 필요. ###");
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }

            HashMap<String, Object> paramMap = new HashMap<>();
            paramMap.put("sellerId", sellerId);
            System.out.println("### 3. Service에 전달할 paramMap: " + paramMap + " ###");

            Map<String, Object> serviceResult = orderService.getOrderListBySeller(paramMap);
            System.out.println("### 4. Service로부터 받은 결과: " + serviceResult + " ###");

            if ("success".equals(serviceResult.get("result"))) {
                System.out.println("### 5. 서비스 결과: 성공. ###");
                result.put("result", "success");
                result.put("list", serviceResult.get("list"));
            } else {
                System.out.println("### 5. 서비스 결과: 실패. 메시지: " + serviceResult.get("message") + "###");
                result.put("result", "fail");
                result.put("message", serviceResult.get("message"));
            }
            System.out.println("### 6. 최종 반환될 JSON 데이터: " + result + " ###");
            return result;
        } catch (Exception e) {
            System.err.println("### 컨트롤러 sellerOrderList 메소드에서 예외 발생! ###");
            e.printStackTrace();
            result.put("result", "error");
            result.put("message", "서버 내부 오류: " + e.getMessage());
            return result;
        }
    }
}