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
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
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

                .order-actions {
                    display: flex;
                    flex-direction: column;
                    gap: 0.5rem;
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
                                <div class="user-avatar">홍</div>
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

                            <!-- 카트 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'cart' }">
                                <div class="card" v-for="item in cartItems" :key="item.id">
                                    <div class="cart-item">
                                        <div class="cart-item-image"></div>
                                        <div class="cart-item-info">
                                            <h3>{{ item.name }}</h3>
                                            <p>{{ item.description }}</p>
                                            <p class="cart-item-price">{{ item.price.toLocaleString() }}원</p>
                                        </div>
                                        <div class="quantity-control">
                                            <button class="quantity-btn" @click="decreaseQuantity(item)">-</button>
                                            <span class="quantity-value">{{ item.quantity }}</span>
                                            <button class="quantity-btn" @click="increaseQuantity(item)">+</button>
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
                                        <button class="btn btn-primary btn-lg"
                                            style="width: 100%; margin-top: 1rem;">주문하기</button>
                                    </div>
                                </div>
                            </div>

                            <!-- 주문 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'orders' }">
                                <div class="card" v-for="order in orders" :key="order.id">
                                    <div class="order-header">
                                        <div>
                                            <p class="order-date">{{ order.date }}</p>
                                            <p class="order-number">주문번호: {{ order.orderNumber }}</p>
                                        </div>
                                        <span class="badge">{{ order.status }}</span>
                                    </div>
                                    <div class="cart-item">
                                        <div class="cart-item-image"></div>
                                        <div class="cart-item-info">
                                            <h3>{{ order.productName }}</h3>
                                            <p>수량: {{ order.quantity }}개</p>
                                            <p class="cart-item-price">{{ order.price.toLocaleString() }}원</p>
                                        </div>
                                        <div class="order-actions">
                                            <button class="btn btn-outline btn-sm">배송조회</button>
                                            <button class="btn btn-outline btn-sm">리뷰작성</button>
                                            <button class="btn btn-outline btn-sm" style="color: #ef4444;">환불신청</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 리뷰 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'reviews' }">
                                <div class="card" v-for="review in reviews" :key="review.id">
                                    <div class="review-item">
                                        <div class="cart-item-image"></div>
                                        <div class="review-content">
                                            <div class="review-header">
                                                <h3>{{ review.productName }}</h3>
                                                <div class="stars">★★★★★</div>
                                            </div>
                                            <p class="review-date">{{ review.date }}</p>
                                            <p class="review-text">{{ review.content }}</p>
                                        </div>
                                        <div class="order-actions">
                                            <button class="btn btn-outline btn-sm">수정</button>
                                            <button class="btn btn-outline btn-sm" style="color: #ef4444;">삭제</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 정보 탭 -->
                            <div class="tab-content" :class="{ active: activeTab === 'profile' }">
                                <div class="card profile-form">
                                    <div class="form-group">
                                        <label class="form-label">이름</label>
                                        <input type="text" class="form-input readonly-input" v-model="profile.name" disabled>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">이메일</label>
                                        <input type="email" class="form-input" v-model="profile.email">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">전화번호 ('-' 없이 숫자만 입력)</label>
                                        <input type="tel" class="form-input" v-model="profile.phone" placeholder="'-' 없이 숫자만 입력">
                                        <div v-if="errors.phone" class="error-message">{{ errors.phone }}</div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">주소 : <button @click="fnAddr">주소검색</button></label>
                                        <input type="text" class="form-input" v-model="profile.address" placeholder="주소 검색 버튼으로 입력해주세요" disabled>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">비밀번호 변경</label>
                                        <input type="password" class="form-input" placeholder="새 비밀번호" v-model="profile.newPassword">
                                        <div v-if="errors.newPassword" class="error-message">{{ errors.newPassword }}</div>
                                    </div>
                                    <div class="form-group" v-if="loginType === 'NORMAL'">
                                        <label class="form-label">비밀번호 확인</label>
                                        <input type="password" class="form-input" placeholder="새 비밀번호 확인" v-model="profile.confirmPassword">
                                        <div v-if="errors.confirmPassword" class="error-message">{{ errors.confirmPassword }}</div>
                                    </div>
                                    <div class="form-actions">
                                        <button class="btn btn-primary" @click="saveProfile">저장하기</button>
                                        <button class="btn btn-outline">취소</button>
                                    </div>
                                </div>
                                <!-- 탈퇴 기능 -->
                                <div class="danger-zone">
                                    <div class="danger-zone-header">
                                        <span style="font-size: 1.5rem;">⚠️</span>
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

            const app = Vue.createApp({
                data() {
                    return {
                        userId: "${sessionId}",
                        activeTab: 'cart',
                        userName: "",
                        userEmail: "",
                        cartItems: [
                            { id: 1, name: '제주 감귤 5kg', description: '신선한 제주 감귤', price: 25000, quantity: 1 },
                            { id: 2, name: '유기농 사과 3kg', description: '무농약 유기농 사과', price: 30000, quantity: 1 },
                            { id: 3, name: '제철 딸기 2kg', description: '달콤한 제철 딸기', price: 20000, quantity: 1 }
                        ],
                        shippingFee: 3000,
                        orders: [
                            { id: 1, date: '2024.01.15', orderNumber: '20240115-001', status: '배송완료', productName: '제주 감귤 5kg', quantity: 1, price: 25000 },
                            { id: 2, date: '2024.01.10', orderNumber: '20240110-001', status: '배송중', productName: '유기농 사과 3kg', quantity: 1, price: 30000 },
                            { id: 3, date: '2024.01.05', orderNumber: '20240105-001', status: '배송완료', productName: '제철 딸기 2kg', quantity: 1, price: 20000 }
                        ],
                        reviews: [
                            { id: 1, productName: '제주 감귤 5kg', date: '2024.01.20', content: '정말 신선하고 맛있어요! 다음에도 구매할게요.' },
                            { id: 2, productName: '유기농 사과 3kg', date: '2024.01.18', content: '아이들이 너무 좋아해요. 무농약이라 안심하고 먹을 수 있어요.' }
                        ],
                        profile: {
                            name: '',
                            email: '',
                            phone: '',
                            address: '',
                            newPassword: '',
                            confirmPassword: ''
                        },
                        loginType: '',
                        
                        errors: { 
                            phone: '',
                            newPassword: '',
                            confirmPassword: ''
                        },
                    };
                },
                computed: {
                    totalPrice() {
                        return this.cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
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
                            success: function(response) {
                                if (response.result === 'success') {
                                    alert('회원정보가 성공적으로 수정되었습니다.');
                                } else {
                                    alert('정보 수정에 실패했습니다.');
                                }
                            },
                            error: function() {
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
                            
                            if (self.loginType === 'NORMAL') { // 일반 로그인 사용자
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

                            } else if (self.loginType === 'SOCIAL') { // 소셜 로그인 사용자
                                let finalConfirm = prompt('소셜 로그인 계정입니다. 탈퇴를 진행하려면 "탈퇴"를 입력하세요:');
                                if (finalConfirm === '탈퇴') {
                                    proceedWithdrawal = true;
                                } else if (finalConfirm === null) {
                                    alert('탈퇴가 취소되었습니다.');
                                    return; // 사용자가 취소
                                } else {
                                    alert('정확히 "탈퇴"를 입력해야 합니다.');
                                    return; // 잘못 입력
                                }
                            } else { // 로그인 유형을 알 수 없는 경우 (예외 처리)
                                alert('로그인 유형을 알 수 없어 탈퇴를 진행할 수 없습니다.');
                                return;
                            }

                            if (proceedWithdrawal) {
                                $.ajax({
                                    url: "${pageContext.request.contextPath}/user/withdrawal.dox", // 일반 사용자 탈퇴 URL
                                    dataType: "json",
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(withdrawalData), 
                                    success: function (response) {
                                        if (response.result === 'success') {
                                            alert('회원 계정이 성공적으로 탈퇴되었습니다.');
                                            location.href = '${pageContext.request.contextPath}/'; // 메인 페이지로 이동
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
                    // 초기 데이터 로드 등
                    self.fnUserInfo();
                   
                }
            })
            window.vueObj = app.mount('#app');
            
        </script>