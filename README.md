# 프로젝트명 (예: AGRICOLA)

<!-- 간단한 한 줄 소개 -->

> **한 줄 소개:** 농수산물 직거래 플랫폼, 생산자와 소비자를 연결합니다.

<!-- 깃허브 상단에 보이는 배지들: 필요 시 수정/삭제 -->

<p align="left">
  <img src="https://img.shields.io/badge/Java-17-black" alt="Java" />
  <img src="https://img.shields.io/badge/Spring_Boot-3.x-brightgreen" alt="Spring Boot" />
  <img src="https://img.shields.io/badge/JSP%2FServlet-2.3-lightgrey" alt="JSP" />
  <img src="https://img.shields.io/badge/Vue-3.x-blue" alt="Vue" />
  <img src="https://img.shields.io/badge/Oracle_DB-19c-orange" alt="Oracle" />
  <img src="https://img.shields.io/badge/MyBatis-3.x-yellow" alt="MyBatis" />
  <img src="https://img.shields.io/badge/Build-Gradle-02303A" alt="Gradle" />
</p>

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

| 이름    | 역할     | 깃허브                        | 담당 영역 키워드     |
| ----- | ------ | -------------------------- | ------------- |
| 김성민 | 팀장/프론트엔드/백엔드 | [@id](https://github.com/) |  자신의 담당영역 입력    |
| 권혁준 | 프론트엔드/백엔드    | [@id](https://github.com/) |   자신의 담당영역 입력    |
| 이민형 | 프론트엔드/백엔드  | [@id](https://github.com/) | 판매자,소비자 마이페이지 /  |
| 문병서 | 인프라    | [@id](https://github.com/) | 자신의 담당영역 입력 |

## 🧰 사용 스킬

### 🎨 Frontend
![Vue.js](https://img.shields.io/badge/Vue.js-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white)
![AJAX](https://img.shields.io/badge/AJAX-00599C?style=for-the-badge&logo=jquery&logoColor=white)

---

### 💻 Backend
![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring MVC](https://img.shields.io/badge/Spring%20MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)

---

### 🗄️ Database
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)

---

### ⚙️ Others
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)





## 🏗 시스템 아키텍처

* 아키텍처 다이어그램: `docs/architecture/architecture.png`
* 모듈 구성: Web (JSP/Vue) ↔ API (Spring) ↔ DB (Oracle)

<p align="center"><img src="docs/architecture/architecture.png" width="90%" alt="Architecture" /></p>

## 🗂 프로젝트 구조

```text
project-root/
├─ docs/                   # 문서, 다이어그램, 스크린샷
├─ src/
│  ├─ main/
│  │  ├─ java/...          # Controller, Service, Mapper
│  │  ├─ resources/
│  │  │  ├─ mapper/*.xml   # MyBatis 매퍼
│  │  │  └─ application.yml
│  │  └─ webapp/
│  │     ├─ WEB-INF/views/ # JSP
│  │     └─ resources/     # css/js/img
│  └─ test/java/...        # 테스트 코드
├─ build.gradle
└─ README.md
```

## ✨ 주요 기능

* [ ] 회원가입/로그인, 소셜 로그인(옵션)
* [ ] 권한/역할(관리자/판매자/구매자)
* [ ] 상품 업로드(멀티 이미지, 옵션 SKU), 목록/필터/검색
* [ ] 장바구니/주문/결제(PortOne 등)
* [ ] 배송 조회(택배 API 연동)
* [ ] 상품문의/리뷰, 공지/이벤트
* [ ] 관리자 대시보드(통계/관리)

## 🧩 팀원별 역할 분담

| 기능      | 담당자   | 상세 업무                |
| ------- | ----- | -------------------- |
| 회원/권한   | 홍길동   | JWT, Security, 예외 처리 |
| 상품/카테고리 | 김개발   | 이미지 업로드, 옵션/재고       |
| 주문/결제   | 김개발   | 장바구니, 결제 연동          |
| 프론트/UI  | 이프론트  | 공통 헤더/푸터, 반응형, 접근성   |
| 배송/지도   | 이프론트  | Kakao Maps, 배송 추적    |
| 인프라/배포  | 박데브옵스 | CI/CD, 서버/도메인, 로그    |

## ⚙️ 설치 및 실행 방법

### 1) 필수 요구사항

* JDK 17+, Gradle 8+
* Node 18+ (프론트 빌드 사용 시)
* Oracle DB (로컬/원격), 계정/스키마 준비

### 2) 환경 변수 설정

`.env` 또는 `application-local.yml` 예시:

```yaml
spring:
  datasource:
    url: jdbc:oracle:thin:@localhost:1521/XE
    username: YOUR_ID
    password: YOUR_PW
  servlet:
    multipart:
      max-file-size: 20MB
      max-request-size: 100MB
jwt:
  secret: your-secret
```

### 3) 로컬 실행

```bash
# 1) 의존성 다운로드 & 빌드
./gradlew clean build

# 2) 애플리케이션 실행
./gradlew bootRun

# 3) 접속
http://localhost:8080
```

### 4) 테스트 계정(예시)

* Admin: `admin / admin123!`
* Seller: `seller1 / seller123!`
* Buyer: `user1 / user123!`

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

## 📝 라이선스

이 프로젝트는 [LICENSE](LICENSE) 조항을 따릅니다.

---

> 📎 **Tip:** README 최상단에 대표 이미지와 짧은 소개, 바로 아래에 `배포 링크`와 `시연 영상`을 배치하면 심사/발표 때 가독성이 좋아집니다.
