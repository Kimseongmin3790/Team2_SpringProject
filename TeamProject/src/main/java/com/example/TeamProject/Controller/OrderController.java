package com.example.TeamProject.Controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.TeamProject.dao.OrderService;
import com.example.TeamProject.model.Order;
import com.google.gson.Gson;

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
    @RequestMapping(value = "/order/sellerList.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String sellerOrderList(
            // 페이징 파라미터
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "10") int itemsPerPage,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String searchKeyword,
            HttpSession session) throws Exception {

        String sellerId = (String) session.getAttribute("sessionId");

        // 서비스 호출 시 모든 파라미터 전달
        HashMap<String, Object> resultMap = orderService.getOrderListBySeller(
            sellerId, currentPage, itemsPerPage, status, startDate, endDate, searchKeyword
        );

        return new Gson().toJson(resultMap);
    }
    
    // --- 주문 상태 업데이트 ---
    @RequestMapping(value = "/order/updateStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateOrderStatus(@RequestParam HashMap<String, Object> paramMap, HttpSession session) throws Exception {
        String sellerId = (String) session.getAttribute("sessionId");
        paramMap.put("sellerId", sellerId); 
        HashMap<String, Object> resultMap = orderService.updateOrderStatus(paramMap);
        return new Gson().toJson(resultMap);
    }

    // --- 배송 정보 등록 ---
    @RequestMapping(value = "/order/registerDelivery.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String registerDelivery(@RequestParam HashMap<String, Object> paramMap, HttpSession session) throws Exception {
        String sellerId = (String) session.getAttribute("sessionId");
        paramMap.put("sellerId", sellerId); 
        HashMap<String, Object> resultMap = orderService.registerDelivery(paramMap);
        return new Gson().toJson(resultMap);
    }
    
    // 주문 일괄 변경
    @RequestMapping(value = "/order/bulkUpdateStatus.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String bulkUpdateStatus(@RequestParam("orderNoList[]") List<String> orderNoList, 
    @RequestParam("status") String status, HttpSession session) throws Exception {
        String sellerId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> resultMap = orderService.bulkUpdateOrderStatus(sellerId, orderNoList, status);
        return new Gson().toJson(resultMap);
    }
    
    // --- 주문 상세 정보 조회 ---
    @RequestMapping(value = "/order/detail.dox", method = RequestMethod.POST, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String orderDetail(@RequestParam("orderNo") int orderNo, HttpSession session) throws Exception {
        String sellerId = (String) session.getAttribute("sessionId");

        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("orderNo", orderNo);
        paramMap.put("sellerId", sellerId);

        
        Order orderDetail = orderService.getOrderDetail(paramMap);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", orderDetail != null ? "success" : "fail");
        resultMap.put("order", orderDetail);

        return new Gson().toJson(resultMap);
    }    
    
}