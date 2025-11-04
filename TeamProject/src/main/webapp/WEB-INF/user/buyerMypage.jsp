<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>마이페이지 - 농수산물 직거래 장터</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/resources/js/page-change.js"></script>
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
            <style>
                .w-100 {
                    width: 100%;
                }

                .mt-1 {
                    margin-top: 1rem;
                }

                .btn.text-danger {
                    color: #ef4444;
                }

                .text-center {
                    text-align: center;
                }

                .text-muted {
                    color: #6b7280;
                }

                .order-item-divider {
                    margin-top: 1rem;
                    border-top: 1px solid #f3f4f6;
                    padding-top: 1rem;
                }

                .icon-warning {
                    font-size: 1.5rem;
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                html,
                body {
                    height: 100%;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                    color: #333;
                    background-color: #f9fafb;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                    padding: 2rem 1rem;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                }

                /* 사용자 정보 배너 */
                .user-banner {
                    background: linear-gradient(to right, #f0fdf4, #d1fae5);
                    border-radius: 8px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                .user-avatar {
                    width: 64px;
                    height: 64px;
                    background-color: #22c55e;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 1.5rem;
                    font-weight: bold;
                }

                .user-info h2 {
                    font-size: 1.25rem;
                    font-weight: bold;
                    margin-bottom: 0.25rem;
                }

                .user-info p {
                    font-size: 0.875rem;
                    color: #6b7280;
                }

                /* 탭 */
                .tabs-list {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 0.5rem;
                    margin-bottom: 2rem;
                    background-color: #f3f4f6;
                    padding: 0.25rem;
                    border-radius: 8px;
                }

                .tab-trigger {
                    padding: 0.75rem 1rem;
                    background-color: transparent;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 0.875rem;
                    font-weight: 500;
                    color: #6b7280;
                    transition: all 0.2s;
                }

                .tab-trigger:hover {
                    background-color: #e5e7eb;
                }

                .tab-trigger.active {
                    background-color: white;
                    color: #22c55e;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                .tab-content {
                    display: none;
                }

                .tab-content.active {
                    display: block;
                }

                /* 카드 */
                .card {
                    background-color: white;
                    border-radius: 8px;
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                /* 카드 정보 */
                .cart-item {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .cart-item-image {
                    width: 80px;
                    height: 80px;
                    background-color: #f3f4f6;
                    border-radius: 8px;
                    flex-shrink: 0;
                }

                .cart-item-info {
                    flex: 1;
                }

                .cart-item-info h3 {
                    font-weight: 600;
                    margin-bottom: 0.25rem;
                }

                .cart-item-info p {
                    font-size: 0.875rem;
                    color: #6b7280;
                    margin-bottom: 0.5rem;
                }

                .cart-item-price {
                    font-weight: bold;
                    color: #22c55e;
                }

                .quantity-control {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .quantity-btn {
                    width: 32px;
                    height: 32px;
                    border: 1px solid #e5e7eb;
                    background-color: white;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 1rem;
                }

                .quantity-btn:hover {
                    background-color: #f9fafb;
                }

                .quantity-value {
                    width: 32px;
                    text-align: center;
                }

                /* 버튼 */
                .btn {
                    padding: 0.5rem 1rem;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 0.875rem;
                    font-weight: 500;
                    transition: all 0.2s;
                }

                .btn-primary {
                    background-color: #22c55e;
                    color: white;
                }

                .btn-primary:hover {
                    background-color: #16a34a;
                }

                .btn-outline {
                    background-color: white;
                    color: #6b7280;
                    border: 1px solid #e5e7eb;
                }

                .btn-outline:hover {
                    background-color: #f9fafb;
                }

                .btn-danger {
                    background-color: #ef4444;
                    color: white;
                }

                .btn-danger:hover {
                    background-color: #dc2626;
                }

                .btn-sm {
                    padding: 0.375rem 0.75rem;
                    font-size: 0.8125rem;
                }

                .btn-lg {
                    padding: 0.75rem 1.5rem;
                    font-size: 1rem;
                }

                /* 주문 요약 */
                .order-summary {
                    max-width: 320px;
                    margin-left: auto;
                }

                .summary-row {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 0.5rem;
                    font-size: 0.875rem;
                }

                .summary-total {
                    border-top: 1px solid #e5e7eb;
                    padding-top: 0.5rem;
                    margin-top: 0.5rem;
                    display: flex;
                    justify-content: space-between;
                    font-weight: bold;
                    font-size: 1.125rem;
                }

                .summary-total .price {
                    color: #22c55e;
                }

                /* 배지 */
                .badge {
                    display: inline-block;
                    padding: 0.25rem 0.75rem;
                    background-color: #22c55e;
                    color: white;
                    border-radius: 9999px;
                    font-size: 0.75rem;
                    font-weight: 500;
                }

                /* 주문 정보 */
                .order-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 1rem;
                }

                .order-date {
                    font-size: 0.875rem;
                    color: #6b7280;
                }

                .order-number {
                    font-weight: 600;
                }

                /* 리뷰 */
                .review-item {
                    display: flex;
                    gap: 1rem;
                }

                .review-content {
                    flex: 1;
                }

                .review-header {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    margin-bottom: 0.5rem;
                }

                .review-header h3 {
                    font-weight: 600;
                }

                .stars {
                    color: #fbbf24;
                }

                .review-date {
                    font-size: 0.875rem;
                    color: #6b7280;
                    margin-bottom: 0.5rem;
                }

                .review-text {
                    font-size: 0.875rem;
                }

                /* 양식 */
                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-label {
                    display: block;
                    font-size: 0.875rem;
                    font-weight: 500;
                    margin-bottom: 0.5rem;
                }

                .form-input {
                    width: 100%;
                    padding: 0.5rem 0.75rem;
                    border: 1px solid #e5e7eb;
                    border-radius: 6px;
                    font-size: 0.875rem;
                }

                .form-input:focus {
                    outline: none;
                    border-color: #22c55e;
                    box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
                }

                .form-actions {
                    display: flex;
                    gap: 0.5rem;
                }

                .form-actions .btn {
                    flex: 1;
                }

                .form-input.readonly-input {
                    background-color: #f2f2f2;
                    cursor: not-allowed;
                }

                /* 프로필 양식 */
                .profile-form {
                    max-width: 672px;
                    margin: 0 auto;
                }

                /* 탈퇴 영역 */
                .danger-zone {
                    margin-top: 3rem;
                    padding-top: 2rem;
                    border-top: 2px solid #fee2e2;
                }

                .danger-zone-header {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    margin-bottom: 1rem;
                }

                .danger-zone-title {
                    color: #dc2626;
                    font-weight: 600;
                    font-size: 1.125rem;
                }

                .danger-zone-content {
                    background-color: #fef2f2;
                    border: 1px solid #fecaca;
                    border-radius: 0.5rem;
                    padding: 1.5rem;
                }

                .danger-zone-desc {
                    color: #991b1b;
                    margin-bottom: 1rem;
                }

                /* 반응형 */
                @media (max-width: 768px) {
                    .tabs-list {
                        grid-template-columns: repeat(2, 1fr);
                    }

                    .cart-item {
                        flex-wrap: wrap;
                    }

                    .order-summary {
                        max-width: 100%;
                    }
                }

                /* 에러 메시지 */
                .error-message {
                    color: #dc2626;
                    font-size: 0.8rem;
                    font-weight: 500;
                    margin-top: 0.25rem;
                }

                .btn-outline-success {
                    background-color: white;
                    color: #22c55e;
                    border: 1px solid #22c55e;
                }

                .btn-outline-success:hover {
                    background-color: #22c55e;
                    color: white;
                }

                .btn-outline-info {
                    background-color: white;
                    color: #3b82f6;
                    border: 1px solid #3b82f6;
                }

                .btn-outline-info:hover {
                    background-color: #3b82f6;
                    color: white;
                }

                .order-header-actions {
                    display: flex;
                    flex-direction: row;
                    align-items: center;
                    gap: 0.75rem;
                }

                .cart-item {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                /* 이미지는 고정 폭/높이 + 줄어들지 않게 */
                .cart-item-image {
                    width: 80px;
                    height: 80px;
                    background-color: #f3f4f6;
                    border-radius: 8px;
                    flex-shrink: 0;
                }

                /* 이미지+텍스트만 클릭되도록 하되, 우측 버튼을 오른쪽으로 밀어냄 */
                .cart-link {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    flex: 1;
                    /* ← 이게 포인트! */
                    min-width: 0;
                    text-decoration: none;
                    color: inherit;
                }

                .cart-link:hover,
                .cart-link:visited {
                    text-decoration: none;
                    color: inherit;
                }

                .cart-link:focus {
                    outline: none;
                }

                /* 우측 액션들 약간 간격 */
                .quantity-control {
                    margin-left: 1rem;
                }

                .cart-item .btn-danger {
                    margin-left: .5rem;
                }

                /* 반응형에서 줄바꿈 방지 (선택) */
                @media (max-width: 480px) {
                    .cart-item {
                        flex-wrap: wrap;
                    }

                    .quantity-control,
                    .cart-item .btn-danger {
                        margin-top: .5rem;
                    }
                }
            </style>
        </head>

        <body>
            <div id="app">
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="container">
                            <!-- 유저 정보 -->
                            <div class="user-banner">
                                <div class="user-avatar"></div>
                                <div class="user-info">
                                    <h2>{{ userName }}님</h2>
                                    <p>{{ userEmail }}</p>
                                </div>
                            </div>

                            <!-- 탭 -->
                            <div class="tabs-list">
                                <button class="tab-trigger" :class="{ active: activeTab === 'cart' }"
                                    @click="activeTab = 'cart'">
                                    장바구니
                                </button>
                                <button class="tab-trigger" :class="{ active: activeTab === 'orders' }"
                                    @click="activeTab = 'orders'">
                                    주문내역
                                </button>
                                <button class="tab-trigger" :class="{ active: activeTab === 'reviews' }"
                                    @click="activeTab = 'reviews'">
                                    리뷰 관리
                                </button>
                                <button class="tab-trigger" :class="{ active: activeTab === 'profile' }"
                                    @click="activeTab = 'profile'">
                                    회원정보
                                </button>
                            </div>

                            <!-- 장바구니 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'cart' }">
                                <div class="card" v-for="item in cartItems" :key="item.cartNo">
                                    <div class="cart-item">
                                        <a href="javascript:;" @click="fnBack(item.productNo)" class="cart-link">
                                            <div class="cart-item-image">
                                                <img :src="item.thumbPath" alt=""
                                                    style="width:100%;height:100%;object-fit:cover;border-radius:8px;">
                                            </div>
                                            <div class="cart-item-info">
                                                <h3>{{ item.pName }}</h3>
                                                <p class="cart-item-price">{{ Number(item.price||0).toLocaleString() }}원
                                                </p>
                                            </div>
                                        </a>
                                        <div class="quantity-control">
                                            <button class="quantity-btn" @click="changeQty(item, -1)">-</button>
                                            <span class="quantity-value">{{ item.quantity }}</span>
                                            <button class="quantity-btn" @click="changeQty(item, +1)">+</button>
                                        </div>
                                        <button class="btn btn-danger btn-sm" @click="removeFromCart(item)">삭제</button>
                                    </div>
                                </div>

                                <div class="order-summary">
                                    <div class="card">
                                        <div class="summary-row">
                                            <span>상품금액</span>
                                            <span>{{ totalPrice.toLocaleString() }}원</span>
                                        </div>
                                        <div class="summary-row">
                                            <span>배송비</span>
                                            <span>{{ shippingFee.toLocaleString() }}원</span>
                                        </div>
                                        <div class="summary-total">
                                            <span>총 결제금액</span>
                                            <span class="price">{{ (totalPrice + shippingFee).toLocaleString()
                                                }}원</span>
                                        </div>
                                        <button class="btn btn-primary btn-lg w-100 mt-1">주문하기</button>
                                    </div>
                                </div>
                            </div>

                            <!-- 주문 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'orders' }">
                                <div class="card" v-for="order in orders" :key="order.orderNo">
                                    <div class="order-header">
                                        <div>
                                            <p class="order-date">{{ order.orderdate }}</p>
                                            <p class="order-number">주문번호: {{ order.orderNo }}</p>
                                        </div>
                                        <div class="order-header-actions">
                                            <span class="badge">{{ order.status }}</span>
                                            <button class="btn btn-outline-info btn-sm">배송조회</button>
                                        </div>
                                    </div>
                                    <div class="cart-item order-item-divider" v-for="item in order.items" :key="item.orderItemNo">
                                        <div class="cart-item-image"></div>
                                        <div class="cart-item-info">
                                            <h3>{{ item.productName }}</h3>
                                            <p>수량: {{ item.quantity }}개</p>
                                            <p class="cart-item-price">{{ item.price.toLocaleString() }}원</p>
                                        </div>
                                        <button class="btn btn-outline-success btn-sm"
                                            @click="fnWriteReview(item.productNo, item.orderItemNo)">리뷰작성</button>
                                        <button class="btn btn-outline btn-sm text-danger">환불신청</button>
                                    </div>
                                </div>

                                <div v-if="orders.length === 0" class="card">
                                    <p class="text-center text-muted">주문 내역이 없습니다.</p>
                                </div>
                            </div>

                            <!-- 리뷰 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'reviews' }">
                                <div v-if="reviews.length > 0">
                                    <div class="card" v-for="review in reviews" :key="review.reviewNo"> 
                                        <div class="review-item">
                                            <!-- 리뷰 상품 이미지 -->
                                            <img :src="review.imageUrl" alt="상품 이미지" class="cart-item-image" v-if="review.imageUrl">
                                            <div class="cart-item-image" v-else></div>

                                            <div class="review-content">
                                                <div class="review-header">
                                                    <h3>{{ review.productName }}</h3>
                                                    <div class="stars">
                                                        <span v-for="n in 5" :key="n">{{ n <= review.rating ? '★' : '☆' }}</span>
                                                    </div>
                                                </div>
                                                <p class="review-date">{{ review.cdate }}</p>
                                                <p class="review-text">{{ review.content }}</p>
                                            </div>
                                            <div class="order-actions">
                                                <button class="btn btn-outline btn-sm" @click="fnUpdateReview(review.reviewNo)">수정</button>
                                                <button class="btn btn-outline btn-sm text-danger" @click="fnDeleteReview(review.reviewNo)">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- 리뷰가 없을 경우 -->
                                <div v-else class="card">
                                    <p class="text-center text-muted">작성한 리뷰가 없습니다.</p>
                                </div>
                            </div>

                            <!-- 정보 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'profile' }">
                                <div class="card profile-form">
                                    <div class="form-group">
                                        <label class="form-label">이름</label>
                                        <input type="text" class="form-input readonly-input" v-model="profile.name"
                                            disabled>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">이메일</label>
                                        <input type="email" class="form-input" v-model="profile.email">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">전화번호 ('-' 없이 숫자만 입력)</label>
                                        <input type="tel" class="form-input" v-model="profile.phone"
                                            placeholder="'-' 없이 숫자만 입력">
                                        <div v-if="errors.phone" class="error-message">{{ errors.phone }}</div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">주소 : <button @click="fnAddr">주소검색</button></label>
                                        <input type="text" class="form-input" v-model="profile.address"
                                            placeholder="주소 검색 버튼으로 입력해주세요" disabled>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">비밀번호 변경</label>
                                        <input type="password" class="form-input" placeholder="새 비밀번호"
                                            v-model="profile.newPassword">
                                        <div v-if="errors.newPassword" class="error-message">{{ errors.newPassword }}
                                        </div>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">비밀번호 확인</label>
                                        <input type="password" class="form-input" placeholder="새 비밀번호 확인"
                                            v-model="profile.confirmPassword">
                                        <div v-if="errors.confirmPassword" class="error-message">{{
                                            errors.confirmPassword }}</div>
                                    </div>
                                    <div class="form-actions">
                                        <button class="btn btn-primary" @click="saveProfile">저장하기</button>
                                        <button class="btn btn-outline">취소</button>
                                    </div>
                                </div>
                                <!-- 탈퇴 기능 -->
                                <div class="danger-zone">
                                    <div class="danger-zone-header">
                                        <span class="icon-warning">⚠️</span>
                                        <h3 class="danger-zone-title">탈퇴 기능</h3>
                                    </div>
                                    <div class="danger-zone-content">
                                        <p class="danger-zone-desc">
                                            계정을 탈퇴하면 모든 계정 정보가 삭제됩니다.
                                            이 작업은 되돌릴 수 없습니다.
                                        </p>
                                        <button class="btn btn-danger" @click="confirmWithdrawal">계정 탈퇴</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <!-- 공통 푸터 -->
                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>
        </body>

        </html>

        <script>
            function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
            }

            const contextPath = "<%= request.getContextPath() %>";

            const app = Vue.createApp({
                data() {
                    return {
                        userId: "${sessionId}",
                        activeTab: '${activeTab}',
                        userName: "",
                        userEmail: "",
                        cartItems: [],           // ← 서버 데이터로 채움
                        shippingFee: 3000,
                        orders: [],
                        reviews: [],
                        profile: {},
                        loginType: '',
                        errors: {}
                    };
                },
                computed: {
                    totalPrice() {
                        return (this.cartItems || []).reduce((sum, it) => {
                            const price = Number(it.price || 0);
                            const qty = Number(it.quantity || 0);
                            return sum + (price * qty);
                        }, 0);
                    }
                },

                watch: {
                    activeTab(newTab, oldTab) {
                        if (newTab === 'orders') {
                            this.fnLoadOrders();
                        } else if (newTab === 'reviews') {
                            this.fnLoadReviews();
                        }
                    }
                },

                methods: {
                    increaseQuantity(item) {
                        item.quantity++;
                    },
                    decreaseQuantity(item) {
                        if (item.quantity > 1) {
                            item.quantity--;
                        }
                    },
                    removeFromCart(item) {
                        const index = this.cartItems.indexOf(item);
                        if (index > -1) {
                            this.cartItems.splice(index, 1);
                        }
                    },
                    // 로그인한 사용자 정보 불러오는 로직
                    fnUserInfo() {
                        let self = this;
                        $.ajax({
                            url: "${pageContext.request.contextPath}/userInfo.dox",
                            dataType: "json",
                            type: "GET",
                            success: function (data) {
                                if (data.status === 'error') {
                                    alert(data.message);
                                    location.href = '${pageContext.request.contextPath}/login.do';
                                    return;
                                }

                                self.profile = data;
                                self.loginType = data.loginType;
                                self.profile.newPassword = ''; // 비밀번호 필드는 비워둠
                                self.profile.confirmPassword = ''; // 비밀번호 필드는 비워둠

                                self.userName = data.name;
                                self.userEmail = data.email;
                            },
                            error: function (xhr, status, error) {
                                alert("사용자 정보를 불러오는 중 오류가 발생했습니다.");
                                console.error("Error:", error);
                            }
                        });
                    },

                    fnBack: function (productNo) {
                        pageChange('/productInfo.do', { productNo });
                    },

                    // 프로필 저장 로직
                    saveProfile() {
                        let self = this;
                        let isValid = true;

                        self.errors = { phone: '', newPassword: '', confirmPassword: '' };

                        if (self.profile.phone) {
                            const phoneRegex = /^\d{10,11}$/;
                            const rawPhone = self.profile.phone.replaceAll('-', '');
                            if (!phoneRegex.test(rawPhone)) {
                                self.errors.phone = "올바른 전화번호 형식이 아닙니다. (10~11자리 숫자)";
                                isValid = false;
                            }
                        }

                        if (self.profile.newPassword) {
                            const pwdRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+\[\]{};:'",.<>\/?\\|`~])(?!.*\s).{8,16}$/;
                            if (!pwdRegex.test(self.profile.newPassword)) {
                                self.errors.newPassword = "비밀번호는 소문자, 숫자, 특수문자를 포함하여 8~16자 이내여야 합니다.";
                                isValid = false;
                            }
                            if (self.profile.newPassword !== self.profile.confirmPassword) {
                                self.errors.confirmPassword = "새 비밀번호가 일치하지 않습니다.";
                                isValid = false;
                            }
                        }

                        if (!isValid) {
                            return;
                        }

                        const profileData = {
                            phone: self.profile.phone.replaceAll('-', ''),
                            address: self.profile.address,
                            email: self.profile.email
                        };

                        if (self.profile.newPassword) {
                            profileData.password = self.profile.newPassword;
                        }

                        $.ajax({
                            url: "${pageContext.request.contextPath}/updateProfile.dox",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            data: JSON.stringify(profileData),
                            success: function (response) {
                                if (response.result === 'success') {
                                    alert('회원정보가 성공적으로 수정되었습니다.');
                                } else {
                                    alert('정보 수정에 실패했습니다.');
                                }
                            },
                            error: function () {
                                alert('회원정보 수정 중 오류가 발생했습니다.');
                            }
                        });
                    },
                    fnAddr() {
                        window.open("/addr.do", "addr", "width=500, height=500");
                    },
                    fnResult(roadFullAddr, addrDetail, zipNo) {
                        let self = this;
                        self.profile.address = roadFullAddr;
                    },

                    // 계정 탈퇴 로직
                    confirmWithdrawal: function () {
                        let self = this;
                        if (confirm('정말로 계정을 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 상품과 주문 정보가 삭제됩니다.')) {

                            let withdrawalData = {};
                            let proceedWithdrawal = false;

                            if (self.loginType === 'NORMAL') {
                                let passwordConfirm = prompt('탈퇴를 진행하려면 현재 비밀번호를 입력하세요:');
                                if (passwordConfirm) {
                                    withdrawalData.password = passwordConfirm;
                                    proceedWithdrawal = true;
                                } else if (passwordConfirm === null) {
                                    alert('탈퇴가 취소되었습니다.');
                                    return;
                                } else {
                                    alert('비밀번호를 입력해야 탈퇴할 수 있습니다.');
                                    return;
                                }

                            } else if (self.loginType === 'SOCIAL') {
                                let finalConfirm = prompt('소셜 로그인 계정입니다. 탈퇴를 진행하려면 "탈퇴"를 입력하세요:');
                                if (finalConfirm === '탈퇴') {
                                    proceedWithdrawal = true;
                                } else if (finalConfirm === null) {
                                    alert('탈퇴가 취소되었습니다.');
                                    return;
                                } else {
                                    alert('정확히 "탈퇴"를 입력해야 합니다.');
                                    return;
                                }
                            } else { // 로그인 유형을 알 수 없는 경우 (예외 처리)
                                alert('로그인 유형을 알 수 없어 탈퇴를 진행할 수 없습니다.');
                                return;
                            }

                            if (proceedWithdrawal) {
                                $.ajax({
                                    url: "${pageContext.request.contextPath}/user/withdrawal.dox",
                                    dataType: "json",
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(withdrawalData),
                                    success: function (response) {
                                        if (response.result === 'success') {
                                            alert('회원 계정이 성공적으로 탈퇴되었습니다.');
                                            location.href = '${pageContext.request.contextPath}/';
                                        } else {
                                            alert(response.message || '계정 탈퇴 중 오류가 발생했습니다.');
                                        }
                                    },
                                    error: function () {
                                        alert('서버와 통신 중 오류가 발생했습니다.');
                                    }
                                });
                            }
                        }
                    },

                    /* 장바구니 목록 불러오기 */
                    fnLoadCart: function () {
                        let self = this;
                        let param = {
                            userId: self.userId
                        };
                        $.ajax({
                            url: "/cart/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                if (data.result == 'success') {
                                    self.cartItems = data.list || [];
                                } else {
                                    alert('장바구니 불러오기 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
                    },

                    /* 수량 변경(+/-1) */
                    changeQty: function (item, diff) {
                        const next = Number(item.quantity || 0) + diff;
                        if (next < 1) {
                            return;
                        }
                        let self = this;
                        $.ajax({
                            url: "/cart/qty.dox",
                            type: "POST",
                            dataType: "json",
                            data: { cartNo: item.cartNo, userId: self.userId, quantity: next },
                            success: function (res) {
                                if (res.result === 'success') {
                                    item.quantity = next; // 화면 즉시 반영
                                } else {
                                    alert('수량 변경 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
                    },

                    /* 항목 삭제 */
                    removeFromCart(item) {
                        if (!confirm('삭제하시겠습니까?')) {
                            return;
                        }
                        let self = this;
                        let param = {
                            cartNo: item.cartNo,
                            userId: self.userId
                        };
                        $.ajax({
                            url: "/cart/remove.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                if (data.result == 'success') {
                                    self.cartItems = self.cartItems.filter(x => x.cartNo !== item.cartNo);
                                } else {
                                    alert('삭제 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
                    },

                    fnLoadOrders() {
                        let self = this;
                        $.ajax({
                            url: "<%= request.getContextPath() %>/myPage/orders.dox",
                            dataType: "json",
                            type: "GET",
                            success: function (data) {
                                if (data.result === "success") {
                                    self.orders = data.list;
                                    self.orders.forEach(order => {
                                        console.log("주문번호:", order.orderNo);
                                        console.log("items:", order.items);
                                    });
                                } else {
                                    alert("주문 내역을 불러오는 데 실패했습니다: " + data.message);
                                    console.error("Error:", data.message);
                                }
                            },
                            error: function (xhr, status, error) {
                                alert("서버와의 통신 중 오류가 발생했습니다. 주문 내역을 불러올 수 없습니다.");
                                console.error("Ajax Error:", error);
                            }
                        });
                    },
                    fnWriteReview(productNo, orderItemNo) {
                        console.log("productNo:", productNo, "orderItemNo:", orderItemNo);

                        const url = contextPath + "/reviewWrite.do?productNo=" + encodeURIComponent(productNo)
                            + "&orderItemNo=" + encodeURIComponent(orderItemNo);

                        console.log("생성된 URL:", url);
                        location.href = url;
                    },
                    fnLoadReviews() {
                        let self = this;
                        $.ajax({
                            url: "${pageContext.request.contextPath}/review/list.dox",
                            type: "GET",
                            dataType: "json",
                            success: function(response) {
                                if (response.result === "success") {
                                    self.reviews = response.list;
                                    console.log("Loaded Reviews:", self.reviews);
                                } else {
                                    alert("리뷰 목록을 불러오는 데 실패했습니다.");
                                }
                            },
                            error: function() {
                                alert("리뷰 목록 조회 중 오류가 발생했습니다.");
                            }
                        });
                    },
                    fnUpdateReview(reviewNo) {
                        window.location.href = '${pageContext.request.contextPath}/reviewUpdate.do?reviewNo=' + reviewNo;
                    },
                    fnDeleteReview(reviewNo) {
                        if (confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
                            const self = this;
                            $.ajax({
                                url: "${pageContext.request.contextPath}/review/delete.dox",
                                type: "POST", 
                                data: { reviewNo: reviewNo },
                                dataType: "json",
                                success: function(response) {
                                    if (response.result === "success") {
                                        alert('리뷰가 삭제되었습니다.');
                                        self.fnLoadReviews();
                                    } else {
                                        alert('리뷰 삭제에 실패했습니다: ' + response.message);
                                    }
                                },
                                error: function() {
                                    alert('리뷰 삭제 중 오류가 발생했습니다.');
                                }
                            });
                        }
                    },

                    // ✅ 판매자 마커 표시
                    fnDrawMarkers() {
                        const self = this;
                        self.markers.forEach(m => m.setMap(null));
                        self.markers = [];

                        self.sellers.forEach((s, idx) => {
                            const pos = new kakao.maps.LatLng(s.lat, s.lng);
                            const marker = new kakao.maps.Marker({
                                position: pos,
                                map: self.map
                            });
                        })
                    }
                },
                mounted() {
                    let self = this;
                    self.fnUserInfo();
                    self.fnLoadOrders();
                    self.fnLoadCart();
                }
            })
            window.vueObj = app.mount('#app');
        </script>