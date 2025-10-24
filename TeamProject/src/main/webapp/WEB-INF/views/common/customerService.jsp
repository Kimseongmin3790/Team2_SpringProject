<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 기본 & 레이아웃 */
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: #1f2937; 
            background-color: #f9fafb; 
        }
        .container {
            width: 100%;
            max-width: 1024px; 
            margin-left: auto;
            margin-right: auto;
            padding-left: 1rem; 
            padding-right: 1rem;
        }
        .main-content {
            padding-top: 2rem; 
            padding-bottom: 2rem;
        }
        .main-title {
            font-size: 1.5rem;
            font-weight: 700; 
            margin-bottom: 2rem; 
            text-align: center;
        }

        /* 서비스 카드 섹션 */
        .service-card-grid {
            display: grid;
            gap: 1.5rem; 
            margin-bottom: 3rem;
        }
        @media (min-width: 768px) {
            .service-card-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr)); 
        }
        }
        .service-card {
            border: 1px solid #e5e7eb;
            background-color: #ffffff;
            border-radius: 0.5rem; 
            padding: 1.5rem; 
            cursor: pointer;
            transition: box-shadow 0.2s ease-in-out;
        }
        .service-card:hover {
            box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        }
        .card-icon-wrapper {
            width: 3rem; 
            height: 3rem; 
            background-color: rgba(16, 185, 129, 0.1); 
            border-radius: 9999px; 
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem; 
        }
        .card-icon {
            font-size: 1.5rem; 
        }
        .card-title {
            font-weight: 700; 
            font-size: 1.125rem; 
            margin-bottom: 0.5rem; 
        }
        .card-description {
            color: #6b7280; 
            font-size: 0.875rem; 
            margin-bottom: 1rem; 
        }
        .card-link {
            color: #059669; 
            font-weight: 500; 
            font-size: 0.875rem;
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
        }

        /* 빠른 답변 (FAQ) 섹션 */
        .faq-section {
            background-color: #f3f4f6; 
            border-radius: 0.5rem; 
            padding: 1.5rem; 
        }
        .faq-title {
            font-weight: 700;
            font-size: 1.125rem;
            margin-bottom: 1rem;
        }
        .faq-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem; 
        }
        .faq-question {
            cursor: pointer;
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem; 
            background-color: #ffffff;
            border-radius: 0.5rem;
        }
        .faq-question:hover {
            background-color: #f9fafb;
        }
        .faq-question-text {
            font-weight: 500;
        }
        .faq-arrow {
            color: #9ca3af; 
            transition: transform 0.2s ease-in-out;
        }
        details[open] summary .faq-arrow {
            transform: rotate(180deg);
        }
        .faq-answer {
            margin-top: 0.5rem; 
            padding: 0.75rem; 
            color: #4b5563; 
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <div id="app">
        <main class="container main-content">
            <div class="max-w-5xl mx-auto">
                <h2 class="main-title">무엇을 도와드릴까요?</h2>

                <div class="service-card-grid">
                    <div class="service-card">
                        <div class="card-icon-wrapper"><span class="card-icon">❓</span></div>
                        <h3 class="card-title">자주 묻는 질문</h3>
                        <p class="card-description">고객님들이 자주 묻는 질문과 답변을 확인하세요</p>
                        <button class="card-link">바로가기 →</button>
                    </div>
                    <div class="service-card">
                        <div class="card-icon-wrapper"><span class="card-icon">💬</span></div>
                        <h3 class="card-title">1대1 문의</h3>
                        <p class="card-description">궁금한 사항을 직접 문의해주세요</p>
                        <button class="card-link">문의하기 →</button>
                    </div>
                     <div class="service-card">
                        <div class="card-icon-wrapper"><span class="card-icon">📢</span></div>
                        <h3 class="card-title">공지사항</h3>
                        <p class="card-description">사이트의 중요 소식과 업데이트를 확인하세요</p>
                        <button class="card-link">전체 보기 →</button>
                    </div>
                </div>

                <div class="faq-section">
                    <h3 class="faq-title">빠른 답변</h3>
                    <div class="faq-list">
                        <details>
                            <summary class="faq-question">
                                <span class="faq-question-text">배송은 얼마나 걸리나요?</span>
                                <span class="faq-arrow">▼</span>
                            </summary>
                            <div class="faq-answer">주문 후 2-3일 이내에 배송됩니다. 신선 상품의 경우 당일 또는 익일 배송이 가능합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question">
                                <span class="faq-question-text">결제 방법은 어떤 것이 있나요?</span>
                                <span class="faq-arrow">▼</span>
                            </summary>
                            <div class="faq-answer">신용카드, 계좌이체, 무통장입금, 간편결제(카카오페이,네이버페이) 등을 지원합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question">
                                <span class="faq-question-text">환불은 어떻게 하나요?</span>
                                <span class="faq-arrow">▼</span>
                            </summary>
                            <div class="faq-answer">마이페이지 > 주문내역에서 환불 신청이 가능합니다.상품 수령 후 7일 이내 신청 가능합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question">
                                <span class="faq-question-text">상품 품질에 문제가 있으면 어떻게 하나요?</span>
                                <span class="faq-arrow">▼</span>
                            </summary>
                            <div class="faq-answer">고객센터로 즉시 연락주시면 교환 또는 환불처리해드립니다. 사진 첨부 시 더 빠른 처리가 가능합니다.</div>
                        </details>
                    </div>
                </div>
            </div>
        </main>
    </div>
     <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() { return {}; },
        methods: {},
        mounted() {}
    });
    app.mount('#app');
</script>