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
        body { 
            font-family: sans-serif; 
            color: #1f2937; 
            background-color: #f9fafb; 
        }
        .container { 
            width: 100%; 
            max-width: 1024px; 
            margin: auto; 
            padding: 0 1rem; 
        }
        .main-content { 
            padding: 2rem 0; 
        }
        .main-title { 
            font-size: 1.5rem; 
            font-weight: 700; 
            margin-bottom: 1rem; 
            text-align: center; 
        }
        /* 검색창 섹션 */
        .search-wrapper { 
            margin-bottom: 3rem; 
            max-width: 640px; 
            margin-left: auto; 
            margin-right: auto; 
        }
        .search-form { 
            display: flex; 
            border: 1px solid #d1d5db; 
            border-radius: 0.5rem; 
            overflow: hidden; 
            background-color: #fff; 
            transition: all 0.2s 
            ease-in-out; 
        }
        .search-form:focus-within { 
            border-color: #059669; 
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
        }
        .search-input { 
            flex-grow: 1; 
            border: none; 
            padding: 0.875rem 1rem; 
            font-size: 1rem; 
            outline:none; 
            background: transparent; 
        }
        .search-button { 
            border: none; 
            background-color: #059669; 
            color: white; 
            padding: 0.75rem 1.25rem;
            cursor: pointer; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 1.25rem; 
        }
        .search-button:hover { 
            background-color: #047857; 
        }
        /* 서비스 카드 섹션 */
        .service-card-grid { 
            display: grid; 
            gap: 1.5rem; 
            margin-bottom: 3rem; 
        }
        @media (min-width: 768px) { 
            .service-card-grid { 
                grid-template-columns: repeat(3, 1fr); 
            } 
        }
        .service-card { 
            border: 1px solid #e5e7eb; 
            background-color: #ffffff; 
            border-radius: 0.5rem;
            padding: 1.5rem; 
            cursor: pointer; 
            transition: all 0.2s ease-in-out; 
        }
        .service-card:hover { 
            box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 /0.1); 
        }
        /* 활성화된 탭 카드 스타일 추가 */
        .service-card.active {
            border-color: #059669;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
            transform: translateY(-2px);
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
            border:none; 
            padding: 0; 
            cursor: pointer; 
        }
        /* 콘텐츠 공통 스타일 */
        .content-section { 
            background-color: #f3f4f6; 
            border-radius: 0.5rem; 
            padding: 1.5rem; 
        }
        .content-title { 
            font-weight: 700; 
            font-size: 1.125rem; 
            margin-bottom: 1rem; 
        }
        /* FAQ 섹션 */
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
        /* 1대1 문의 폼 스타일 */
        .inquiry-form .form-group { 
            margin-bottom: 1rem; 
        }
        .inquiry-form label { 
            display: block; 
            font-weight: 500; 
            margin-bottom: 0.5rem; 
            font-size:0.875rem; 
        }
        .inquiry-form .form-input, .inquiry-form .form-select, .inquiry-form .form-textarea {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            padding: 0.5rem 0.75rem;
            font-size: 1rem;
        }
        .inquiry-form .form-textarea { 
            min-height: 120px; 
        }
        .inquiry-form .submit-button {
            width: 100%;
            padding: 0.75rem;
            border: none;
            border-radius: 0.375rem;
            background-color: #059669;
            color: white;
            font-weight: 700;
            cursor: pointer;
        }
        .inquiry-form .submit-button:hover { 
            background-color: #047857; 
        }
        /* 공지사항 리스트 스타일 */
        .notice-list { 
            display: flex; 
            flex-direction: column; 
        }
        .notice-item { 
            display: flex; 
            justify-content: space-between; 
            padding: 0.75rem; 
            border-bottom:1px solid #e5e7eb; 
        }
        .notice-item:last-child { 
            border-bottom: none; 
        }
        .notice-item:hover { 
            background-color: #e5e7eb; 
        }
        .notice-title { 
            font-weight: 500; 
        }
        .notice-date { 
            color: #6b7280; 
            font-size: 0.875rem; 
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %> <!-- 헤더 -->
    <div id="app">
        <main class="container main-content">
            <div class="max-w-5xl mx-auto">
                <h2 class="main-title">무엇을 도와드릴까요?</h2>
                <div class="search-wrapper">
                    <div class="search-form">
                        <input type="text" placeholder="궁금한 점을 검색해보세요" class="search-input">
                        <button class="search-button" aria-label="검색" @click="fnSearch"><span>🔍</span></button>
                    </div>
                </div>

                <div class="service-card-grid">
                    <div class="service-card" @click="activeTab = 'faq'" :class="{ 'active': activeTab=== 'faq' }">
                        <div class="card-icon-wrapper"><span class="card-icon">❓</span></div>
                        <h3 class="card-title">자주 묻는 질문</h3>
                        <p class="card-description">고객님들이 자주 묻는 질문과 답변을 확인하세요</p>
                    </div>
                    <div class="service-card" @click="activeTab = 'inquiry'" :class="{ 'active':activeTab === 'inquiry' }">
                        <div class="card-icon-wrapper"><span class="card-icon">💬</span></div>
                        <h3 class="card-title">1대1 문의</h3>
                        <p class="card-description">궁금한 사항을 직접 문의해주세요</p>
                    </div>
                    <div class="service-card" @click="activeTab = 'notice'" :class="{ 'active': activeTab=== 'notice' }">
                        <div class="card-icon-wrapper"><span class="card-icon">📢</span></div>
                        <h3 class="card-title">공지사항</h3>
                        <p class="card-description">사이트의 중요 소식과 업데이트를 확인하세요</p>
                    </div>
                </div>

                <!-- 자주 묻는 질문 (기본) -->
                <div v-if="activeTab === 'faq'" class="content-section">
                    <h3 class="content-title">빠른 답변</h3>
                    <div class="faq-list">
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">배송은 얼마나걸리나요?</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">주문 후 2-3일 이내에 배송됩니다. 신선 상품의 경우당일 또는 익일 배송이 가능합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">결제 방법은어떤 것이 있나요?</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">신용카드, 계좌이체, 무통장입금, 간편결제(카카오페이,네이버페이) 등을 지원합니다.</div>
                        </details>
                        <!-- 다른 질문들... -->
                    </div>
                </div>

                <!-- 1대1 문의 -->
                <div v-if="activeTab === 'inquiry'" class="content-section inquiry-form">
                    <h3 class="content-title">1대1 문의하기</h3>
                    <div class="form-group">
                        <label for="inquiry-category">문의 유형</label>
                        <select id="inquiry-category" class="form-select">
                            <option>주문/결제</option>
                            <option>배송</option>
                            <option>취소/환불</option>
                            <option>상품</option>
                            <option>기타</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inquiry-title">제목</label>
                        <input type="text" id="inquiry-title" class="form-input" placeholder="제목을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="inquiry-content">내용</label>
                        <textarea id="inquiry-content" class="form-textarea" placeholder="문의하실 내용을 입력하세요"></textarea>
                    </div>
                    <button class="submit-button">문의 등록</button>
                </div>

                <!-- 공지사항 -->
                <div v-if="activeTab === 'notice'" class="content-section">
                    <h3 class="content-title">공지사항</h3>
                    <div class="notice-list">
                        <div class="notice-item">
                            <span class="notice-title">[안내] 추석 연휴 배송 일정 안내</span>
                            <span class="notice-date">2025-10-20</span>
                        </div>
                        <div class="notice-item">
                            <span class="notice-title">[점검] 10월 25일(토) 서비스 정기 점검 안내</span>
                            <span class="notice-date">2025-10-18</span>
                        </div>
                        <div class="notice-item">
                            <span class="notice-title">[이벤트] 가을 제철 농산물 할인 이벤트 당첨자 발표</span>
                            <span class="notice-date">2025-10-15</span>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %> <!-- 푸터 -->
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                activeTab: 'faq', // 기본으로 보여줄 탭
                list : [],
                id : 'buyer01'
            };
        },
        methods: {
            // 필요 시 함수 추가
            fnOrderInfo (){
                let self = this;
                let param = {
                    buyerId : self.id
                };
                $.ajax({
                    url: "orderList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.list = data.list;
                    }
                });    
            }

        },
        mounted() {
            let self = this;
            self.fnOrderInfo();
        }
    });
    app.mount('#app');
</script>