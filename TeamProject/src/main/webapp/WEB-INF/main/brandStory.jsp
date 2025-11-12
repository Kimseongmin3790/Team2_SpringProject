<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>브랜드 스토리 - AGRICOLA</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html,
        body {
            height: 100%;
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: #1f2937;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #ffffff;
        }

        .content {
            flex: 1;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .hero-section {
            padding: 5rem 1rem;
        }

        .hero-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 3rem;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        @media (min-width: 768px) {
            .hero-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        .brand-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: #d1fae5;
            color: #047857;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        @media (min-width: 768px) {
            .hero-title {
                font-size: 3rem;
            }
        }

        .hero-subtitle {
            font-size: 1.5rem;
            font-weight: 600;
            color: #059669;
            margin-bottom: 1.5rem;
        }

        .hero-description {
            font-size: 1.125rem;
            line-height: 1.75;
            color: #374151;
        }

        .hero-image {
            position: relative;
            height: 400px;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .values-section {
            background-color: #f0fdf4;
            padding: 5rem 1rem;
        }

        .section-title {
            font-size: 1.875rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 3rem;
        }

        .values-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        @media (min-width: 768px) {
            .values-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        .value-card {
            background: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .value-icon {
            width: 4rem;
            height: 4rem;
            background-color: #d1fae5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2rem;
        }

        .value-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }

        .value-description {
            color: #4b5563;
        }

        .promise-section {
            padding: 5rem 1rem;
        }

        .promise-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .promise-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: #059669;
            color: white;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .promise-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        @media (min-width: 768px) {
            .promise-title {
                font-size: 2.25rem;
            }
        }

        .promise-subtitle {
            font-size: 1.25rem;
            color: #4b5563;
            max-width: 48rem;
            margin: 0 auto;
        }

        .promise-images {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        @media (min-width: 768px) {
            .promise-images {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .promise-image {
            position: relative;
            height: 300px;
            border-radius: 0.75rem;
            overflow: hidden;
        }

        .promise-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .promise-content {
            background-color: #f9fafb;
            border-radius: 1rem;
            padding: 2rem;
        }

        @media (min-width: 768px) {
            .promise-content {
                padding: 3rem;
            }
        }

        .promise-text {
            font-size: 1.125rem;
            line-height: 1.75;
            color: #374151;
            margin-bottom: 2rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
        }

        @media (min-width: 768px) {
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .feature-item {
            display: flex;
            gap: 1rem;
        }

        .feature-icon {
            flex-shrink: 0;
            width: 3rem;
            height: 3rem;
            background-color: #d1fae5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .feature-title {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .feature-description {
            color: #4b5563;
        }

        .promise2-section {
            padding: 5rem 1rem;
            background: linear-gradient(to bottom right, #f0fdf4, #d1fae5);
        }

        .promise2-images {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        @media (min-width: 768px) {
            .promise2-images {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        .promise2-image {
            position: relative;
            height: 250px;
            border-radius: 0.75rem;
            overflow: hidden;
        }

        .promise2-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .promise2-card {
            background: white;
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        @media (min-width: 768px) {
            .promise2-card {
                padding: 3rem;
            }
        }

        .delivery-feature {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem;
            background-color: #f0fdf4;
            border-radius: 0.75rem;
            margin-top: 2rem;
        }

        .delivery-icon {
            font-size: 3rem;
            color: #059669;
            flex-shrink: 0;
        }

        .delivery-title {
            font-weight: 700;
            font-size: 1.125rem;
            margin-bottom: 0.5rem;
        }

        .delivery-description {
            color: #4b5563;
        }

        .cta-section {
            padding: 5rem 1rem;
            background-color: #059669;
            color: white;
            text-align: center;
        }

        .cta-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        @media (min-width: 768px) {
            .cta-title {
                font-size: 2.25rem;
            }
        }

        .cta-subtitle {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            max-width: 42rem;
            margin-left: auto;
            margin-right: auto;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 2rem;
            font-size: 1.125rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: white;
            color: #059669;
        }

        .btn-primary:hover {
            background-color: #f3f4f6;
        }

        .btn-outline {
            background-color: transparent;
            color: white;
            border: 2px solid white;
        }

        .btn-outline:hover {
            background-color: white;
            color: #059669;
        }
    </style>
</head>

<body>
    <div id="app">
        <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <div class="content">
            <section class="hero-section">
                <div class="container">
                    <div class="hero-grid">
                        <div>
                            <div class="brand-badge">BRAND STORY</div>
                            <h2 class="hero-title">AGRICOLA의 약속</h2>
                            <p class="hero-subtitle">가장 정직한 연결</p>
                            <p class="hero-description">
                                AGRICOLA는 그 잃어버린 연결을 되찾고 싶은 마음에서 시작되었습니다. 복잡한 유통의 거품을 걷어내고, 땀 흘려
                                결실을 맺은 생산자와 건강한 먹거리를 찾는 소비자를 가장 정직하게 잇기로 약속했습니다.
                            </p>
                        </div>
                        <div class="hero-image">
                            <img src="${path}/resources/img/brand/farm-field.jpg" alt="농장 풍경">
                        </div>
                    </div>
                </div>
            </section>

            <section class="values-section">
                <div class="container">
                    <h3 class="section-title">우리의 가치</h3>
                    <div class="values-grid">
                        <div class="value-card">
                            <div class="value-icon">❤️</div>
                            <h4 class="value-title">정직함</h4>
                            <p class="value-description">생산자와 소비자를 투명하게 연결하여 신뢰를 만듭니다</p>
                        </div>
                        <div class="value-card">
                            <div class="value-icon">🌿</div>
                            <h4 class="value-title">신선함</h4>
                            <p class="value-description">산지 직송으로 가장 신선한 상태를 유지합니다</p>
                        </div>
                        <div class="value-card">
                            <div class="value-icon">🛡️</div>
                            <h4 class="value-title">품질</h4>
                            <p class="value-description">엄격한 기준으로 최고의 품질만을 제공합니다</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="promise-section">
                <div class="container">
                    <div class="promise-header">
                        <div class="promise-badge">약속 1</div>
                        <h3 class="promise-title">얼굴 있는 먹거리</h3>
                        <p class="promise-subtitle">저희에게 생산자는 단순한 공급업체가 아닙니다</p>
                    </div>

                    <div class="promise-images">
                        <div class="promise-image">
                            <img src="${path}/resources/img/brand/farmer-hands.jpg" alt="생산자의 손">
                        </div>
                        <div class="promise-image">
                            <img src="${path}/resources/img/brand/farm-location.jpg" alt="농장 위치">
                        </div>
                    </div>

                    <div class="promise-content">
                        <p class="promise-text">
                            AGRICOLA에서는 모든 생산자가 자신의 이름을 걸고, 자부심으로 키운 작물의 성장 과정을 공유합니다. 당신이
                            먹는 음식이 누구의 손에서 왔는지 알게 되는 순간, 식탁은 더욱 풍성해집니다.
                        </p>
                        <div class="features-grid">
                            <div class="feature-item">
                                <div class="feature-icon">📍</div>
                                <div>
                                    <h4 class="feature-title">농장 위치 확인</h4>
                                    <p class="feature-description">
                                        지도로 농장의 위치를 직접 확인하고, 어디서 재배되는지 알 수 있습니다.
                                    </p>
                                </div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">💬</div>
                                <div>
                                    <h4 class="feature-title">실시간 소통(예정)</h4>
                                    <p class="feature-description">실시간 채팅으로 궁금한 것을 물어보세요. 생산자가 직접 답변합니다.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="promise2-section">
                <div class="container">
                    <div class="promise-header">
                        <div class="promise-badge">약속 2</div>
                        <h3 class="promise-title">어제 밭, 오늘 식탁</h3>
                        <p class="promise-subtitle">
                            가장 신선한 음식은 가장 짧은 길을 달려온 음식입니다
                        </p>
                    </div>

                    <div class="promise2-images">
                        <div class="promise2-image">
                            <img src="${path}/resources/img/brand/fresh-produce.jpg" alt="신선한 농산물">
                        </div>
                        <div class="promise2-image">
                            <img src="${path}/resources/img/brand/delivery-box.jpg" alt="배송">
                        </div>
                        <div class="promise2-image">
                            <img src="${path}/resources/img/brand/family-dinner.jpg" alt="식탁">
                        </div>
                    </div>

                    <div class="promise2-card">
                        <p class="promise-text">
                            AGRICOLA는 산지 직송을 통해 어제 밭에서 수확한 신선함을 오늘 당신의 식탁에 그대로 전합니다. 불필요한
                            중간 과정이 없기에 가격은 합리적이고, 품질은 타협하지 않습니다.
                        </p>
                        <div class="delivery-feature">
                            <div class="delivery-icon">🚚</div>
                            <div>
                                <h4 class="delivery-title">산지 직송 시스템</h4>
                                <p class="delivery-description">생산자와 소비자 사이의 거리를 최소화하여 최상의 품질을 보장합니다</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="cta-section">
                <div class="container">
                    <h3 class="cta-title">AGRICOLA와 함께 시작하세요</h3>
                    <p class="cta-subtitle">가장 정직한 연결로 신선한 농수산물을 만나보세요</p>
                    <div class="cta-buttons">
                        <a href="${pageContext.request.contextPath}/productCategory.do#v=parent" class="btn btn-primary">쇼핑 시작하기</a>
                        <a href="${path}/partnership.do" class="btn btn-outline">입점 / 제휴 문의</a>
                    </div>
                </div>
            </section>
        </div>

        <!-- 공통 푸터 -->
        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {

            };
        },
        methods: {
            // 필요한 메소드 추가
        },
        mounted() {
            // 페이지 로드 시 실행
        }
    });

    app.mount('#app');
</script>