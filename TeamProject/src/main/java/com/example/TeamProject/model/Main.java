package com.example.TeamProject.model;

import lombok.Data; // Lombok 사용 가정
@Data
// 메인 페이지 관련 모든 VO(Value Object)를 담는 컨테이너 클래스
public class Main {
    
   
        private int id; 
        private String title;
        private String imageUrl; // DB 컬럼: IMAGE_URL
        private String linkUrl;  // DB 컬럼: LINK_URL        
    
         
        private String name;
        private String description;
        private String logoUrl; // DB 컬럼: LOGO_URL
    
        
        private String category;
        private long price;
    

}