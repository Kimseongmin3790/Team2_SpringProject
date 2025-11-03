package com.example.TeamProject.model;

import lombok.Data; 

@Data // @Getter, @Setter, @ToString 등을 자동으로 생성합니다.
public class Main {
    
    // =========================================================
    // 1. 배너 관련 필드 (Main Banners)
    // =========================================================
    private int id;                 // Mybatis 매핑을 위한 기본 ID (PRODUCT_IMAGE.IMAGE_ID)
    private String title;           // 배너 제목 (PRODUCT.PNAME)
    private String imageUrl;        // 배너 이미지 경로 (PRODUCT_IMAGE.IMAGE_URL)
    private String linkUrl;         // 클릭 시 이동할 링크 URL (임시 값: '#')
    private String description;     // 배너 설명 (PRODUCT.DESCRIPTION)
    
    // =========================================================
    // 2. 입점 업체 관련 필드 (Producers)
    // ---------------------------------------------------------
    // 참고: Producer 데이터는 MainMapper.xml에서 SELECT DISTINCT SELLER_ID ...를 통해
    // 별도의 Producer 모델을 사용하지 않고 Mapper에서 처리하는 경우를 고려하여
    // 이 파일에는 포함하지 않습니다. (별도 Producer.java가 없다면 MainMapper.xml과 충돌 방지)
    // 단, 베스트 상품 필드와의 중복 때문에 이 파일에는 통합하지 않겠습니다.
    // =========================================================
    
    // =========================================================
    // 3. 베스트 상품 관련 필드 (Best Products)
    // =========================================================
    private int productNo;          // 상품 번호 (Product 테이블의 기본키)
    private String category;        // 상품 카테고리
    private long price;             // 상품 가격
    // private String name;         // 상품 이름 (title 필드와 중복되므로 재사용 가능)

}