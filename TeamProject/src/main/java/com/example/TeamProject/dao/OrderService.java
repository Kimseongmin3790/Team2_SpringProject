package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.TeamProject.mapper.OrderMapper;
import com.example.TeamProject.model.Order;

@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    public HashMap<String, Object> getOrderHistory(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            if (userId == null || userId.isEmpty()) {
                throw new Exception("로그인이 필요합니다.");
            }

            List<Order> orderList = orderMapper.selectOrderHistoryByUserId(userId);

            resultMap.put("list", orderList);
            resultMap.put("result", "success");

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
            e.printStackTrace();
        }
        return resultMap;
    }

    // 판매자 ID로 주문목록 조회
    public HashMap<String, Object> getOrderListBySeller(String sellerId, int currentPage, int itemsPerPage,
        String status, String startDate, String endDate, String searchKeyword) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
		if (sellerId == null || sellerId.isEmpty()) {
		resultMap.put("result", "fail");
		resultMap.put("message", "로그인이 필요합니다.");
		return resultMap;
		}
		
		// Mapper에 전달할 파라미터들을 HashMap에 담기
		HashMap<String, Object> paramMap = new HashMap<>();
		paramMap.put("sellerId", sellerId);
		paramMap.put("status", status);
		paramMap.put("startDate", startDate);
		paramMap.put("endDate", endDate);
		paramMap.put("searchKeyword", searchKeyword);
		
		// 1. 필터 조건이 적용된 전체 주문 건수 조회
		int totalCount = orderMapper.selectOrderListCountBySeller(paramMap);
		
		// 2. 페이징 계산
		int startRow = (currentPage - 1) * itemsPerPage + 1;
		int endRow = currentPage * itemsPerPage;
		paramMap.put("startRow", startRow);
		paramMap.put("endRow", endRow);
		
		System.out.println("DB 쿼리 파라미터 (selectOrderListBySeller): " + paramMap.toString());
		
		// 3. 페이징 및 필터 적용된 목록 조회
		List<Order> orderList = orderMapper.selectOrderListBySeller(paramMap);
		
		resultMap.put("list", orderList);
		resultMap.put("totalCount", totalCount);
		resultMap.put("result", "success");
		
		} catch (Exception e) {
		System.out.println("판매자 주문 목록 조회 중 에러 발생: " + e.getMessage());
		e.printStackTrace();
		resultMap.put("result", "fail");
		resultMap.put("message", "데이터베이스 조회 중 오류가 발생했습니다.");
		}
	
		return resultMap;
	}
    
    // 주문 상태 변경
    public HashMap<String, Object> updateOrderStatus(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String sellerId = (String) map.get("sellerId");
            String newStatus = (String) map.get("status");
            String orderNoStr = String.valueOf(map.get("orderNo")); 

            if (sellerId == null || sellerId.isEmpty()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            // 1. 현재 주문 상태 조회
            HashMap<String, Object> currentOrderParam = new HashMap<>();
            currentOrderParam.put("orderNo", orderNoStr);
            currentOrderParam.put("sellerId", sellerId);
            Order currentOrder = orderMapper.selectOrderForUpdate(currentOrderParam);

            if (currentOrder == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문을 찾을 수 없거나 해당 주문에 대한 권한이 없습니다.");
                return resultMap;
            }

            String currentStatus = currentOrder.getStatus();

            // 2. 상태 변경 유효성 검사
            boolean isValidTransition = false;
            switch (currentStatus) {
                case "결제완료": 
                case "신규 주문": 
                    if (newStatus.equals("배송 준비중") || newStatus.equals("취소/반품")) {
                        isValidTransition = true;
                    }
                    break;
                case "배송 준비중":
                    if (newStatus.equals("배송중") || newStatus.equals("취소/반품")) {
                        isValidTransition = true;
                    }
                    break;
                case "배송중":
                    if (newStatus.equals("배송 완료")) {
                        isValidTransition = true;
                    }
                    break;
                case "배송 완료": 
                    if (newStatus.equals("배송중")) {
                        isValidTransition = true;
                    }
                    break;
                case "취소/반품": 
                    if (newStatus.equals("배송 준비중")) {
                        isValidTransition = true;
                    }
                    break;
        
                default:
                    isValidTransition = false;
                    break;
            }

            if (!isValidTransition) {
                resultMap.put("result", "fail");
                resultMap.put("message", "현재 상태(" + currentStatus + ")에서 " + newStatus + "(으)로의 변경은 허용되지 않습니다.");
                return resultMap;
            }

            // 3. 유효한 경우에만 상태 업데이트 진행
            int updatedRows = orderMapper.updateOrderStatus(map);

            if (updatedRows > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문 상태 업데이트에 실패했습니다. 데이터베이스 오류일 수 있습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
        }
        return resultMap;
    }

    // --- 배송 정보 등록 ---
    @Transactional
    public HashMap<String, Object> registerDelivery(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String sellerId = (String) map.get("sellerId");
            String orderNoStr = String.valueOf(map.get("orderNo"));

            if (sellerId == null || sellerId.isEmpty()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            // 배송 등록 전 현재 상태 확인 (선택 사항: '배송 준비중'에서만 등록 가능하도록)
            HashMap<String, Object> currentOrderParam = new HashMap<>();
            currentOrderParam.put("orderNo", orderNoStr);
            currentOrderParam.put("sellerId", sellerId);
            Order currentOrder = orderMapper.selectOrderForUpdate(currentOrderParam);

            if (currentOrder == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문을 찾을 수 없거나 해당 주문에 대한 권한이 없습니다.");
                return resultMap;
            }

            if (!currentOrder.getStatus().equals("배송 준비중")) {
                resultMap.put("result", "fail");
                resultMap.put("message", "현재 상태(" + currentOrder.getStatus() + ")에서는 배송 등록을 할 수 없습니다. '배송 준비중' 상태에서만 가능합니다.");
                return resultMap;
            }


           
            int deliveryInserted = orderMapper.insertDelivery(map);

            if (deliveryInserted > 0) {
                map.put("status", "배송중");
                int statusUpdated = orderMapper.updateOrderStatus(map);

                if (statusUpdated > 0) {
                    resultMap.put("result", "success");
                } else {
                    throw new Exception("주문 상태를 '배송중'으로 변경하는데 실패했습니다.");
                }
            } else {
                throw new Exception("배송 정보 등록에 실패했습니다. 해당 주문에 대한 권한이 없거나 주문 번호가 잘못되었습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        return resultMap;
    }
    
    // --- 주문 상태 일괄 변경  ---
    @Transactional
    public HashMap<String, Object> bulkUpdateOrderStatus(String sellerId, List<String> orderNoList, String newStatus) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            if (sellerId == null || sellerId.isEmpty()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }
            if (orderNoList == null || orderNoList.isEmpty()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "선택된 주문이 없습니다.");
                return resultMap;
            }

            // 1. 모든 주문에 대해 유효성 검사를 먼저 수행
            for (String orderNo : orderNoList) {
                HashMap<String, Object> param = new HashMap<>();
                param.put("orderNo", orderNo);
                param.put("sellerId", sellerId);
                Order currentOrder = orderMapper.selectOrderForUpdate(param);

                if (currentOrder == null) {
                    throw new Exception("주문 번호 " + orderNo + "에 대한 권한이 없거나 존재하지 않는 주문입니다.");
                }

                String currentStatus = currentOrder.getStatus();
                boolean isValidTransition = false;

                switch (currentStatus) {
                    case "결제완료": case "신규 주문":
                        if (newStatus.equals("배송 준비중") || newStatus.equals("취소/반품")) isValidTransition = true;
                        break;
                    case "배송 준비중":
                        if (newStatus.equals("배송중") || newStatus.equals("취소/반품")) isValidTransition = true
;
                        break;
                    case "배송중":
                        if (newStatus.equals("배송 완료")) isValidTransition = true;
                        break;
                    case "배송 완료":
                        if (newStatus.equals("배송중")) isValidTransition = true; 
                        break;
                    case "취소/반품":
                        if (newStatus.equals("배송 준비중")) isValidTransition = true;
                        break;
                }

                if (!isValidTransition) {
                    throw new Exception("주문 번호 " + orderNo + "는 현재 상태(" + currentStatus + ")에서 '" + newStatus + "'(으)로 변경할 수 없습니다.");
                }
            }

            // 2. 모든 검사가 통과되면 일괄 업데이트 실행
            HashMap<String, Object> updateParam = new HashMap<>();
            updateParam.put("orderNoList", orderNoList);
            updateParam.put("status", newStatus);

            int updatedRows = orderMapper.bulkUpdateOrderStatus(updateParam);

            if (updatedRows > 0) {
                resultMap.put("result", "success");
                resultMap.put("message", updatedRows + "건의 주문 상태가 변경되었습니다.");
            } else {
                throw new Exception("주문 상태 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage()); 
        }
        return resultMap;
    }
    
    // --- 주문 상세 정보 조회 ---
    public Order getOrderDetail(HashMap<String, Object> paramMap) {
        try {
            String sellerId = (String) paramMap.get("sellerId");
            Integer orderNo = (Integer) paramMap.get("orderNo");

            if (sellerId == null || sellerId.isEmpty()) {
                System.err.println("Error: sellerId is null or empty in getOrderDetail.");
                return null;
            }
            if (orderNo == null) {
                System.err.println("Error: orderNo is null in getOrderDetail.");
                return null;
            }

            Order orderDetail = orderMapper.selectOrderDetail(paramMap);

            return orderDetail;

        } catch (Exception e) {
            System.err.println("주문 상세 정보 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    // 환불 요청 등록 및 결과 반환
 	public HashMap<String, Object> requestRefund(HashMap<String, Object> paramMap) {
 		 HashMap<String, Object> resultMap = new HashMap<>();
 	     try {
 	    	 int result = orderMapper.insertRefundRequest(paramMap);
 	         if (result > 0) {
 	        	 resultMap.put("result", "success");
 	         } else {
 	             resultMap.put("result", "fail");
 	             resultMap.put("message", "환불 요청 처리에 실패했습니다.");
 	         }
 	     } catch (Exception e) {
 	    	 e.printStackTrace(); 
 	         resultMap.put("result", "fail");
 	         resultMap.put("message", "환불 요청 중 오류가 발생했습니다.");
 	     }
 	     	return resultMap;
 	 }
 	
 	// 환불 요청 취소
 	public HashMap<String, Object> cancelRefund(HashMap<String, Object> paramMap) {
 	    HashMap<String, Object> resultMap = new HashMap<>();
 	    try {
 	        int result = orderMapper.deleteRefundRequest(paramMap);
 	        if (result > 0) {
 	            resultMap.put("result", "success");
 	        } else {
 	            resultMap.put("result", "fail");
 	            resultMap.put("message", "취소할 환불 요청이 없습니다.");
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	        resultMap.put("result", "fail");
 	        resultMap.put("message", "환불 요청 취소 중 오류가 발생했습니다.");
 	    }
 	    return resultMap;
 	}
 	
 	// 환불 요청 처리 (승인/거절)
 	public HashMap<String, Object> processRefund(HashMap<String, Object> paramMap) {
 	    HashMap<String, Object> resultMap = new HashMap<>();
 	    try {
 	        int result = orderMapper.updateRefundStatus(paramMap);
 	        if (result > 0) {
 	            resultMap.put("result", "success");
 	           
 	        } else {
 	            resultMap.put("result", "fail");
 	            resultMap.put("message", "이미 처리되었거나 존재하지 않는 환불 요청입니다.");
 	        }
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	        resultMap.put("result", "fail");
 	        resultMap.put("message", "환불 처리 중 오류가 발생했습니다.");
 	    }
 	    return resultMap;
 	}
    
}