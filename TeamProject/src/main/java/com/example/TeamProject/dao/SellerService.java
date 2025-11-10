package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.TeamProject.mapper.ProductMapper;
import com.example.TeamProject.mapper.SellerMapper;
import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.Order;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;

import jakarta.servlet.http.HttpSession; 

@Service
public class SellerService {

    @Autowired
    private SellerMapper sellerMapper;
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private ProductMapper productMapper;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    

    public HashMap<String, Object> getSellerInfoForMyPage(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            SellerVO sellerInfo = sellerMapper.getSellerInfo(userId);
            if (sellerInfo != null) {
                if ("N".equals(sellerInfo.getVerified())) {
                    resultMap.put("result", "fail");
                    resultMap.put("message", "판매자 승인이 완료되지 않았습니다.");
                } else {
                    resultMap.put("sellerInfo", sellerInfo);
                    resultMap.put("result", "success");
                }
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "판매자 정보를 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            System.out.println("판매자 정보 조회 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "데이터 조회 중 오류가 발생했습니다.");
        }
        return resultMap;
    }

    @Transactional
    public HashMap<String, Object> updateFarmInfo(SellerVO sellerVO, String loggedInUserId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // SellerVO에 userId 설정 (SELLER_INFO 업데이트용)
            sellerVO.setUserId(loggedInUserId);

            

            // 1. SELLER_INFO 테이블 업데이트
            sellerMapper.updateSellerInfo(sellerVO);

            // 2. USERS 테이블 업데이트
            if (sellerVO.getUser() != null) {
                User userToUpdate = sellerVO.getUser();

                // NAME 필드 유효성 검사 및 설정
                if (userToUpdate.getName() == null || userToUpdate.getName().trim().isEmpty()) {
                    throw new IllegalArgumentException("대표자명은 필수 입력 항목입니다.");
                }
                userToUpdate.setUserId(loggedInUserId); 

                sellerMapper.updateUserInfo(userToUpdate);
            } else {
                throw new IllegalArgumentException("사용자 정보가 올바르지 않습니다.");
            }

            resultMap.put("result", "success");
            resultMap.put("message", "농가 정보가 성공적으로 업데이트되었습니다.");

        } catch (IllegalArgumentException e) { // 유효성 검사 실패 시
            System.out.println("농가 정보 업데이트 유효성 검사 실패: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage()); // 유효성 검사 메시지를 클라이언트에 직접 전달
        } catch (Exception e) { // 그 외 데이터베이스 또는 시스템 오류 시
            System.out.println("농가 정보 업데이트 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "농가 정보 업데이트 중 치명적인 오류가 발생했습니다.");
        }
        return resultMap;
    }
    
    @Transactional // 두 개 이상의 DB 작업이 하나의 논리적인 단위로 처리되도록 트랜잭션 적용
    public HashMap<String, Object> updateSellerProfile(SellerVO sellerVO) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 1. USERS 테이블 업데이트 (phone)
            // User 객체가 존재하고 userId가 설정되어 있을 경우
            if (sellerVO.getUser() != null) {
                User userToUpdate = sellerVO.getUser();

                // phone 필드 유효성 검사 (필요시 추가)
                if (userToUpdate.getPhone() == null || userToUpdate.getPhone().trim().isEmpty()) {
                    throw new IllegalArgumentException("연락처는 필수 입력 항목입니다.");
                }
                // userId는 컨트롤러에서 이미 설정되어 넘어옴

                System.out.println("SellerService: Updating User Phone for userId: " + userToUpdate.getUserId());
                System.out.println("SellerService: User Phone: " + userToUpdate.getPhone());

                sellerMapper.updateUserPhone(userToUpdate); 
            } else {
                throw new IllegalArgumentException("사용자 정보가 올바르지 않습니다.");
            }

            // 2. SELLER_INFO 테이블 업데이트 (account, bankName)
            // userId는 컨트롤러에서 이미 설정되어 넘어옴
            System.out.println("SellerService: Updating Seller Account Info for userId: " + sellerVO.getUserId());
            System.out.println("SellerService: Account: " + sellerVO.getAccount());
            System.out.println("SellerService: BankName: " + sellerVO.getBankName());

            sellerMapper.updateSellerAccountInfo(sellerVO); 

            resultMap.put("result", "success");
            resultMap.put("message", "회원정보가 성공적으로 업데이트되었습니다.");

        } catch (IllegalArgumentException e) {
            System.out.println("회원정보 업데이트 유효성 검사 실패: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        } catch (Exception e) {
            System.out.println("회원정보 업데이트 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "회원정보 업데이트 중 치명적인 오류가 발생했습니다.");
        }
        return resultMap;
    }
    
    public HashMap<String, Object> getDashboardData(String sellerId) {
        HashMap<String, Object> dashboardData = new HashMap<>();
        try {
            // 1. 오늘 주문 건수
            int todayOrders = sellerMapper.getTodayOrdersCount(sellerId);
            dashboardData.put("todayOrders", todayOrders);

            // 2. 오늘 매출
            Long todayGrossSales = sellerMapper.getTodaySalesAmount(sellerId); 
            Long todayRefunds = sellerMapper.getTodayRefundAmount(sellerId); 
            long todayNetSales = (todayGrossSales != null ? todayGrossSales : 0L) - (todayRefunds != null ? todayRefunds : 0L);
            dashboardData.put("todaySales", todayNetSales); 

            // 3. 등록 상품 수
            int totalProducts = sellerMapper.getTotalProductsCount(sellerId);
            dashboardData.put("totalProducts", totalProducts);

            // 4. 평균 평점
            Double avgRating = sellerMapper.getAverageRating(sellerId);
            dashboardData.put("avgRating", avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0);

            // 5. 최근 주문 목록
            List<Order> recentOrders = sellerMapper.getRecentOrders(sellerId);
            dashboardData.put("recentOrders", recentOrders);

            dashboardData.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            dashboardData.put("result", "fail");
            dashboardData.put("message", "대시보드 데이터 조회 중 오류가 발생했습니다.");
        }
        return dashboardData;
    }
    
    public HashMap<String, Object> getSalesHistory(HashMap<String, Object> paramMap) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> salesHistory = sellerMapper.getSalesHistory(paramMap);

            resultMap.put("result", "success");
            resultMap.put("history", salesHistory); // 프론트엔드에서 salesHistory로 받도록 설정
        } catch (Exception e) {
            System.out.println("매출 내역 조회 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "매출 내역 조회 중 오류가 발생했습니다.");
        }
        return resultMap;
    }
    
    // 판매자 탈퇴
    public HashMap<String, Object> withdrawSeller(HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            if (userId == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }
            map.put("userId", userId);

            // 1. 사용자 정보 조회 (구매자 탈퇴 로직과 동일)
            HashMap<String, Object> paramMap = new HashMap<>();
            paramMap.put("userId", userId);
            User userProfile = userMapper.loginUser(paramMap);

            if (userProfile == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "사용자 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            String loginType = (userProfile.getPassword() == null) ? "SOCIAL" : "NORMAL";

            // 2. 본인 확인 (구매자 탈퇴 로직과 동일)
            if (loginType.equals("NORMAL")) {
                String inputPassword = (String) map.get("password");
                if (inputPassword == null || !passwordEncoder.matches(inputPassword, userProfile.getPassword())) {
                    resultMap.put("result", "fail");
                    resultMap.put("message", "비밀번호가 일치하지 않습니다.");
                    return resultMap;
                }
            }

            // 판매자 탈퇴 ---

            // 3. USERS 테이블 상태 변경
            userMapper.updateUserStatus(userId, "WITHDRAWN");

            // 4. SELLER_INFO 테이블 상태 변경 (판매 자격 박탈)
            sellerMapper.updateSellerVerification(userId, "N");

            // 5. PRODUCT 테이블 상태 변경 (판매 중인 모든 상품을 'hidden'으로)
            productMapper.hideAllProductsBySeller(userId);

            // 6. 세션 무효화
            session.invalidate();

            resultMap.put("result", "success");
            resultMap.put("message", "판매자 계정 탈퇴가 성공적으로 처리되었습니다.");

        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "판매자 탈퇴 처리 중 오류가 발생했습니다.");
            e.printStackTrace();
            // @Transactional에 의해 오류 발생 시 모든 DB 변경이 롤백됩니다.
        }

        return resultMap;
    }
    
    // 판매자 계정 정보 복구
    @Transactional
    public void recoverSellerAccount(String userId) {
        sellerMapper.updateSellerVerification(userId, "Y");
     
    }
}