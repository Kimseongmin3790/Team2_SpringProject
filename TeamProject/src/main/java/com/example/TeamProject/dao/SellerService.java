package com.example.TeamProject.dao;

import java.util.HashMap; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.TeamProject.mapper.SellerMapper;
import com.example.TeamProject.model.SellerVO;

@Service
public class SellerService {

    @Autowired
    private SellerMapper sellerMapper;

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
}