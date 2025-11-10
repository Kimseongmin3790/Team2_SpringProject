<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
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
            margin-bottom: 4rem; 
            text-align: center; 
        }
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
        .inquiry-form .form-check {
            display: flex;
            align-items: center;
            gap: 0.5rem; 
            margin-bottom: 1.5rem; 
        }
        .inquiry-form .form-check-input {
            width: auto;
            margin: 0;
        }
        .inquiry-form .form-check-label {
            margin-bottom: 0; 
        }
        /* 공지사항 리스트 스타일 */
        .notice-list {
            display: flex;
            flex-direction: column;
            border-top: 1px solid #e5e7eb; 
        }
        .notice-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem; 
            border-bottom:1px solid #e5e7eb;
            transition: background-color 0.2s ease-in-out; 
        }
        .notice-item:hover {
            background-color: #f9fafb; 
        }
        .notice-item .notice-title { 
            font-weight: 500;
            color: #1f2937; 
            text-decoration: none; 
            flex-grow: 1; 
            text-align: left;
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis; 
            max-width: calc(100% - 100px); 
            font-size: 0.9rem; 
        }
        .notice-item .notice-title:hover {
            color: #059669; 
        }
        .notice-date {
            color: #6b7280;
            font-size: 0.875rem;
            flex-shrink: 0; 
            margin-left: 1rem;
        }
        .comment-count-badge {
            color: #5dbb63;
            font-size: 0.8rem; 
            font-weight: 600;
            margin-left: 5px; 
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %> <div id="app">
        <main class="container main-content">
            <div class="max-w-5xl mx-auto">
                <h2 class="main-title">고객센터</h2>
                <div class="service-card-grid">
                    <div class="service-card" @click="activeTab = 'faq'" :class="{ 'active': activeTab === 'faq' }">
                        <div class="card-icon-wrapper"><span class="card-icon">❓</span></div>
                        <h3 class="card-title">자주 묻는 질문</h3>
                        <p class="card-description">고객님들이 자주 묻는 질문과 답변을 확인하세요</p>
                    </div>
                    <div class="service-card" @click="fnShowInquiryTab" :class="{ 'active': activeTab === 'inquiry' }">
                        <div class="card-icon-wrapper"><span class="card-icon">💬</span></div>
                        <h3 class="card-title">1대1 문의</h3>
                        <p class="card-description">궁금한 사항을 직접 문의해주세요</p>
                    </div>
                    <div class="service-card" @click="activeTab = 'notice'" :class="{ 'active': activeTab === 'notice' }">
                        <div class="card-icon-wrapper"><span class="card-icon">📢</span></div>
                        <h3 class="card-title">공지사항</h3>
                        <p class="card-description">사이트의 중요 소식과 업데이트를 확인하세요</p>
                    </div>
                </div>

                <div v-if="activeTab === 'faq'" class="content-section">
                    <h3 class="content-title">빠른 답변</h3>
                    <div class="faq-list">
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">[배송관련]배송은 얼마나걸리나요?</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">주문 후 2-3일 이내에 배송됩니다. 신선 상품의 경우당일 또는 익일 배송이 가능합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">[주문결제]결제 방법은어떤 것이 있나요?</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">신용카드, 계좌이체, 무통장입금, 간편결제(카카오페이,네이버페이) 등을 지원합니다.</div>
                        </details>
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">[상품관련] 사진하고 달라요.</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">농산물의 경우 공산품처럼 상품이 항상 같을 수가 없습니다.이점 양해 부탁드립니다</div>
                        </details>
                        <details>
                            <summary class="faq-question"><span class="faq-question-text">[계정관련] 탈퇴는 어떻게 하나요?</span><span class="faq-arrow">▼</span></summary>
                            <div class="faq-answer">마이 페이지 - 회원 정보 란에서 탈퇴 가능합니다.</div>
                        </details>
                    </div>
                </div>

                <div v-if="activeTab === 'inquiry'" class="content-section inquiry-form">
                    <h3 class="content-title">1대1 문의하기</h3>
                    <div class="form-group">
                        <label for="inquiry-category">문의 유형</label>
                        <select id="inquiry-category" class="form-select" v-model="inquiryCategory">
                            <option>주문/결제</option>
                            <option>배송</option>
                            <option>취소/환불</option>
                            <option>상품</option>
                            <option>기타</option>
                        </select>
                    </div>
                    <div class="form-group" v-if="isOrderRelatedCategory">
                        <label for="inquiry-order">주문 선택</label>
                        <select id="inquiry-order" class="form-select" v-model="selectedOrderNo">
                            <option :value="null">문의할 주문을 선택하세요</option>

                            <option v-for="order in orderList" :key="order.orderNo" :value="order.orderNo">
                                주문날짜 : [{{ order.orderDate.split(' ')[0] }}] , 주문번호 : [{{ order.orderNo }}]
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inquiry-title">제목</label>
                        <input type="text" id="inquiry-title" class="form-input" placeholder="제목을 입력하세요" v-model="inquiryTitle">
                    </div>
                    <div class="form-group">
                        <label for="inquiry-content">내용</label>
                        <textarea id="inquiry-content" class="form-textarea" placeholder="문의하실 내용을 입력하세요" v-model="inquiryContent"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="inquiry-password">비밀번호</label>
                        <input type="password" id="inquiry-password" class="form-input" placeholder="비밀번호를 입력하세요. (최대 20자)" v-model="inquiryPassword" maxlength="20">
                    </div>

                    <button class="submit-button" @click="fnInquiry">문의 등록</button>
                </div>

                <div v-if="activeTab === 'notice'" class="content-section">
                    <h3 class="content-title">공지사항</h3>
                    <div class="notice-list">
                        <div v-if="latestNotices.length === 0" class="notice-item">
                            <span class="notice-title">최신 공지사항이 없습니다.</span>
                        </div>
                        <div v-for="notice in latestNotices" :key="notice.noticeNo" class="notice-item">
                            <a :href="'/noticeView.do?noticeNo=' + notice.noticeNo" class="notice-title">
                                {{ notice.title }}
                                <span v-if="notice.commentCount > 0" class="comment-count-badge">({{notice.commentCount}})</span>
                            </a>
                            <span class="notice-date">{{ notice.regDate }}</span>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <button class="card-link" @click="fnGoToNoticeList">더보기</button>
                    </div>
                </div>

            </div> </main>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %> 
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                activeTab: 'faq', // 기본으로 보여줄 탭
                id : '${sessionId}', 
                
                // 문의글
                inquiryCategory: "",
                inquiryTitle : "",
                inquiryContent : "",
                orderList: [],
                selectedOrderNo: null,
                inquiryPassword: "",

                noticeList : [],
                filteredFaqList: [],
                filteredNoticeList: [],

                latestNotices: [],



            };
        },
        computed: { 
            isOrderRelatedCategory() {
                const orderCategories = ['주문/결제', '배송', '취소/환불'];
                return orderCategories.includes(this.inquiryCategory);
            }
        },
        methods: {
            fnShowInquiryTab() {
                let self = this;
                if (!self.id) { 
                    alert('로그인이 필요한 서비스입니다.');
                    location.href = '/login.do'; 
                } else {
                    self.activeTab = 'inquiry';
                }
            },
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
                        console.log(data);
                        self.orderList = data.list;
                    }
                });    
            },
            fnInquiry(){ // 문의글 작성 함수
                let self = this;
                let param = {
                    category: self.inquiryCategory,
                    title: self.inquiryTitle,
                    content: self.inquiryContent,
                    password: self.inquiryPassword,
                    isSecret: 'Y',
                    orderNo: self.selectedOrderNo,
                    userId : self.id
                    
                };
                $.ajax({
                    url: "/inquiry-add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            alert("문의가 성공적으로 등록되었습니다.");

                            // 폼 내용 초기화
                            self.inquiryCategory = "";
                            self.inquiryTitle = "";
                            self.inquiryContent = "";
                            self.inquiryPassword = "";
                            self.selectedOrderNo = null;

                                
                            self.activeTab = 'faq';
                        } else {
                            alert("문의 등록에 실패했습니다. 다시 시도해주세요.");
                        }
                    },
                    error: function() {
                        alert("오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                    }
                });    
            },
            fnLoadLatestNotices() {
                let self = this;
                $.ajax({
                    url: "/notice/latest.dox",
                    type: "GET",
                    dataType: "json",
                    data: { limit: 3 }, 
                    success: function (res) {
                        if (res.result === "success") {
                            self.latestNotices = res.list;
                        } else {
                            alert("최신 공지사항을 불러오는 데 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버와의 통신 중 오류가 발생했습니다.");
                    }
                });
            },
            fnGoToNoticeList: function() {
                location.href = '/board.do?tab=notice';
            },

        },
        mounted() {
            let self = this;

            const urlParams = new URLSearchParams(window.location.search);
            const tabFromUrl = urlParams.get('tab');
            const validTabs = ['faq', 'inquiry', 'notice'];

            if (tabFromUrl && validTabs.includes(tabFromUrl)) {
                if (tabFromUrl === 'inquiry' && !self.id) {
                    alert('로그인이 필요한 서비스입니다.');
                    location.href = '/login.do'; 
                    return; 
                }
                self.activeTab = tabFromUrl;
            }

            if (self.id) {
                self.fnOrderInfo();
            }

            self.fnLoadLatestNotices();
        }
    });
    app.mount('#app');
</script>