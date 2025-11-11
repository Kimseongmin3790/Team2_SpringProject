# 프로젝트명 (예: AGRICOLA)

<!-- 간단한 한 줄 소개 -->

> **한 줄 소개:** 농수산물 직거래 플랫폼, 생산자와 소비자를 연결합니다.

---

## 📌 대표 이미지

<!-- 프로젝트 대표 스크린샷 또는 배너 (예: /docs/images/cover.png) -->

<p align="center"><img src="docs/images/cover.png" width="100%" alt="프로젝트 대표 이미지" /></p>


## 🧭 프로젝트 소개

* **배경/문제 인식:** 산지-소비자 간 정보 비대칭, 유통 마진 문제
* **목표/핵심 가치:** 신선도/공정가격/투명한 이력 관리
* **타깃 사용자:** 중소 농가, 신선식품 구매자

## 🗓 개발 기간 & 일정

> 전체 기간: `2025.10.23 ~ 2023.11.10`

## 👥 팀원 구성

| 이름    | 역할     | 깃허브                     
| ----- | ------ | -------------------------- |
| 김성민 | 팀장/프론트엔드/백엔드 | [@id](https://github.com/) | 
| 권혁준 | 프론트엔드/백엔드    | [@id](https://github.com/) |  
| 이민형 | 프론트엔드/백엔드  | [@id](https://github.com/) | 
| 문병서 | 인프라    | [@id](https://github.com/) |

## 🧰 사용 스킬

### 🎨 프론트엔드
![Vue.js](https://img.shields.io/badge/Vue.js-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white)
![AJAX](https://img.shields.io/badge/AJAX-00599C?style=for-the-badge&logo=jquery&logoColor=white)

---

### 💻 백엔드
![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring MVC](https://img.shields.io/badge/Spring%20MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)

---

### 🗄️ 데이터베이스
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)

---

### ⚙️ 기타
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

## 🗂 프로젝트 구조
```
Team2_SpringProject/
├── pom.xml                # Maven 빌드 설정 파일
├── README.md              # 프로젝트 설명 파일
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/
    │   │       └── example/
    │   │           └── TeamProject/
    │   │               ├── TeamProjectApplication.java  # 스프링 부트 시작점
    │   │               │
    │   │               ├── common/              # 공통 기능 (보안 설정, 예외 처리 등)
    │   │               │   ├── SecurityConfig.java
    │   │               │   └── GlobalExceptionHandler.java
    │   │               │
    │   │               ├── config/              # 설정 관련 클래스 (OAuth 등)
    │   │               │   └── auth/
    │   │               │
    │   │               ├── controller/          # 웹 요청을 처리하는 컨트롤러
    │   │               │   ├── UserController.java
    │   │               │   ├── ProductController.java
    │   │               │   ├── OrderController.java
    │   │               │   └── ... (기타 컨트롤러)
    │   │               │
    │   │               ├── dao/                 # 비즈니스 로직을 처리하는 서비스
    │   │               │   ├── UserService.java
    │   │               │   ├── ProductService.java
    │   │               │   └── ... (기타 서비스)
    │   │               │
    │   │               ├── mapper/              # MyBatis 매퍼 인터페이스
    │   │               │   ├── UserMapper.java
    │   │               │   ├── ProductMapper.java
    │   │               │   └── ... (기타 매퍼)
    │   │               │
    │   │               └── model/               # 데이터 모델 (VO, DTO)
    │   │                   ├── User.java
    │   │                   ├── Product.java
    │   │                   └── ... (기타 모델)
    │   │
    │   ├── resources/
    │   │   ├── application.properties   # 애플리케이션 설정 파일
    │   │   │
    │   │   └── mybatis-mapper/          # MyBatis SQL 쿼리 XML 파일
    │   │          ├── sql-user.xml
    │   │          ├── sql-product.xml
    │   │          └── ... (기타 SQL 파일)
    │   │   
    │   │  
    │   │      
    │   │
    │   └── webapp/
    │       ├── resources/               # 정적 리소스 
    │       │   ├── css/
    │       │   ├── js/
    │       │   └── img/
    │       │
    │       └── WEB-INF/                 # JSP 뷰 파일 위치
    │           ├── default.jsp          # 기본 템플릿 JSP
    │           ├── index.jsp
    │           ├── admin/
    │           ├── board/
    │           ├── user/
    │           ├── product/
    │           └── views/
    │               └── common/          # 공통 뷰 (헤더, 푸터)
    │                   ├── header.jsp
    │                   └── footer.jsp
    │
    └──
```

## ✨ 주요 기능

* [ ] 회원가입/로그인, 소셜 로그인(옵션)
* [ ] 권한/역할(관리자/판매자/구매자)
* [ ] 상품 업로드(멀티 이미지, 옵션 SKU), 목록/필터/검색
* [ ] 장바구니/주문/결제(PortOne 등)
* [ ] 배송 조회(택배 API 연동)
* [ ] 상품문의/리뷰, 공지/이벤트
* [ ] 관리자 대시보드(통계/관리)


## 👥 팀원별 역할 분담(예시)

- **김성민** 🎨 Frontend
  - Vue 3, HTML, CSS, jQuery, AJAX(예시)
  - UI/UX 구현 및 화면 단 테스트

- **권혁준** 💻 Backend
  - Java(Spring MVC/Boot), MyBatis(예시)
  - REST API 개발, 서비스 로직 구현

- **이민형** 🗄 Database
  - Oracle DB 설계 및 관리(예시)
  - SQL 쿼리 작성, MyBatis 매퍼 관리

- **문병서** ⚙️ DevOps/Integration
  - Git/GitHub 관리(예시)
  - 빌드/배포, 테스트 환경 설정





## ☁️ 배포 정보

* **도메인**: [https://your-domain.com](https://your-domain.com)
* **아키텍처**: Nginx → Spring Boot → Oracle
* **CI/CD**: GitHub Actions (build/test/deploy)
* **로그/모니터링**: (예) Spring Actuator, CloudWatch, Grafana

## 🗄 ERD & DB 설계

* ERD 이미지: `docs/db/erd.png`
* 스키마/DDL: `docs/db/schema.sql`

## 📖 API 명세

* 문서: Swagger UI / Notion 링크
* 인증: JWT (Authorization: Bearer {token})
* 예시

```http
GET /api/products?category=grain&page=1
Authorization: Bearer {token}
```

## 🖥 발표 자료 & 시연 영상

* 발표 PPT: [링크]()
* 시연 영상: [링크]()
* 데모 계정/시나리오: [문서]()

## 🗃 기타 산출물

* 회의록: [Notion]()
* 요구사항 정의서/WBS: [링크]()
* 화면 설계서(Figma): [링크]()
* 테스트 케이스/리포트: [링크]()
* 회고/느낀점: [링크]()

## 📏 개발 컨벤션

* **Git 브랜치 전략**: `main` / `develop` / `feature/*`
* **커밋 컨벤션**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
* **코드 스타일**: Checkstyle/Spotless (옵션)
* **이슈/PR 템플릿**: `.github/ISSUE_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE.md`

<details>
<summary>커밋 메시지 예시</summary>

```
feat(product): 옵션 SKU 생성 로직 추가
- 옵션 조합 빌더 적용
- 재고 검증 로직 및 유효성 보강
```

</details>


