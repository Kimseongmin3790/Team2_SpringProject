<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>판매자 마이페이지 - AGRICOLA</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            flex: 1;
            background-color: #f9fafb;
        }

        /* 판매자 헤더 스타일 */
        .seller-header {
            background-color: white;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 0;
        }

        .seller-header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .seller-logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #16a34a;
        }

        .seller-badge {
            display: inline-block;
            background-color: #dcfce7;
            color: #16a34a;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
        }

        /* 퀵 액션 */
        .quick-actions {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .action-card {
            background-color: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .action-card:hover {
            border-color: #16a34a;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .action-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .action-title {
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.25rem;
        }

        .action-desc {
            font-size: 0.875rem;
            color: #6b7280;
        }

        /* 탭 네비 */
        .tab-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .tab-nav {
            display: flex;
            gap: 0.5rem;
            border-bottom: 2px solid #e5e7eb;
            margin-bottom: 2rem;
            overflow-x: auto;
        }

        .tab-button {
            padding: 1rem 1.5rem;
            background: none;
            border: none;
            border-bottom: 2px solid transparent;
            color: #6b7280;
            font-weight: 500;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.2s;
            margin-bottom: -2px;
        }

        .tab-button:hover {
            color: #16a34a;
        }

        .tab-button.active {
            color: #16a34a;
            border-bottom-color: #16a34a;
        }

        /* 캡 내용 */
        .tab-content {
            background-color: white;
            border-radius: 0.5rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }

        /* 통계창 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1.5rem;
        }

        .stat-label {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.875rem;
            font-weight: bold;
            color: #111827;
        }

        .stat-unit {
            font-size: 1rem;
            color: #6b7280;
            margin-left: 0.25rem;
        }

        /* 주문 */
        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }

        .orders-table th {
            background-color: #f9fafb;
            padding: 0.75rem;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 2px solid #e5e7eb;
        }

        .orders-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status-shipping {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .status-completed {
            background-color: #dcfce7;
            color: #166534;
        }

        /* 통계 자료 */
        .settlement-summary {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            border-radius: 0.5rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .settlement-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .settlement-item h4 {
            font-size: 0.875rem;
            color: #166534;
            margin-bottom: 0.5rem;
        }

        .settlement-item p {
            font-size: 1.5rem;
            font-weight: bold;
            color: #111827;
        }

        /* 농가 정보 */
        .info-grid {
            display: grid;
            gap: 1.5rem;
        }

        .info-item {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .info-label {
            font-weight: 600;
            color: #374151;
        }

        .info-value {
            color: #6b7280;
        }

        .cert-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .cert-badge {
            background-color: #dcfce7;
            color: #166534;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* 리뷰 */
        .review-card {
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-product {
            font-weight: 600;
            color: #111827;
        }

        .review-rating {
            color: #fbbf24;
        }

        .review-content {
            color: #6b7280;
            margin-bottom: 1rem;
        }

        .review-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
            color: #9ca3af;
        }

        /* 폼 양식 */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 1rem;
        }

        .form-input:focus {
            outline: none;
            border-color: #16a34a;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
        }

        .form-textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 1rem;
            min-height: 120px;
            resize: vertical;
        }

        /* 버튼 */
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #16a34a;
            color: white;
        }

        .btn-primary:hover {
            background-color: #15803d;
        }

        .btn-secondary {
            background-color: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background-color: #e5e7eb;
        }

        .btn-danger {
            background-color: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background-color: #b91c1c;
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
            .seller-header-container {
                flex-direction: column;
                gap: 1rem;
            }

            .tab-nav {
                flex-wrap: nowrap;
            }

            .tab-content {
                padding: 1rem;
            }

            .info-item {
                grid-template-columns: 1fr;
            }

            .orders-table {
                font-size: 0.875rem;
            }

            .orders-table th,
            .orders-table td {
                padding: 0.5rem;
            }
        }
    </style>
</head>

<body>
    <div id="app">
        <!-- 공통 헤더 -->
        <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <main class="content">
            <!-- 판매자 헤더 -->
            <div class="seller-header">
                <div class="seller-header-container">
                    <div class="seller-logo">AGRICOLA 판매자센터</div>
                    <span class="seller-badge">판매자</span>
                </div>
            </div>

            <!-- 빠른 이동 -->
            <div class="quick-actions">
                <div class="quick-actions-grid">
                    <div class="action-card" @click="goToPage('product-register')">
                        <div class="action-icon">📦</div>
                        <div class="action-title">상품 등록</div>
                        <div class="action-desc">새로운 상품을 등록하세요</div>
                    </div>
                    <div class="action-card" @click="goToPage('order-manage')">
                        <div class="action-icon">📋</div>
                        <div class="action-title">주문 관리</div>
                        <div class="action-desc">주문 내역을 확인하세요</div>
                    </div>
                    <div class="action-card" @click="goToPage('delivery-manage')">
                        <div class="action-icon">🚚</div>
                        <div class="action-title">배송 상태 변경</div>
                        <div class="action-desc">배송 상태를 업데이트하세요</div>
                    </div>
                </div>
            </div>

            <!-- 탭 네비 -->
            <div class="tab-container">
                <div class="tab-nav">
                    <button 
                        class="tab-button" 
                        :class="{ active: activeTab === 'dashboard' }"
                        @click="activeTab = 'dashboard'">
                        대시보드
                    </button>
                    <button 
                        class="tab-button" 
                        :class="{ active: activeTab === 'settlement' }"
                        @click="activeTab = 'settlement'">
                        정산 관리
                    </button>
                    <button 
                        class="tab-button" 
                        :class="{ active: activeTab === 'farm' }"
                        @click="activeTab = 'farm'">
                        농가 정보
                    </button>
                    <button 
                        class="tab-button" 
                        :class="{ active: activeTab === 'reviews' }"
                        @click="activeTab = 'reviews'">
                        리뷰 관리
                    </button>
                    <button 
                        class="tab-button" 
                        :class="{ active: activeTab === 'profile' }"
                        @click="activeTab = 'profile'">
                        회원정보
                    </button>
                </div>

                <!-- 통계 창 -->
                <div v-show="activeTab === 'dashboard'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">판매 현황</h2>
                    
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-label">오늘 주문</div>
                            <div class="stat-value">{{ stats.todayOrders }}<span class="stat-unit">건</span></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">오늘 매출</div>
                            <div class="stat-value">{{ formatPrice(stats.todaySales) }}<span class="stat-unit">원</span></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">등록 상품</div>
                            <div class="stat-value">{{ stats.totalProducts }}<span class="stat-unit">개</span></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">평균 평점</div>
                            <div class="stat-value">{{ stats.avgRating }}<span class="stat-unit">/ 5.0</span></div>
                        </div>
                    </div>

                    <h3 style="margin-bottom: 1rem; color: #111827;">최근 주문</h3>
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>상품명</th>
                                <th>수량</th>
                                <th>금액</th>
                                <th>상태</th>
                                <th>주문일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="order in recentOrders" :key="order.id">
                                <td>{{ order.orderNo }}</td>
                                <td>{{ order.productName }}</td>
                                <td>{{ order.quantity }}개</td>
                                <td>{{ formatPrice(order.amount) }}원</td>
                                <td>
                                    <span class="status-badge" :class="getStatusClass(order.status)">
                                        {{ order.status }}
                                    </span>
                                </td>
                                <td>{{ order.orderDate }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 통계 자료 -->
                <div v-show="activeTab === 'settlement'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">정산 관리</h2>
                    
                    <div class="settlement-summary">
                        <div class="settlement-grid">
                            <div class="settlement-item">
                                <h4>총 매출</h4>
                                <p>{{ formatPrice(settlement.totalSales) }}원</p>
                            </div>
                            <div class="settlement-item">
                                <h4>플랫폼 수수료 (5%)</h4>
                                <p>{{ formatPrice(settlement.platformFee) }}원</p>
                            </div>
                            <div class="settlement-item">
                                <h4>정산 예정 금액</h4>
                                <p>{{ formatPrice(settlement.expectedAmount) }}원</p>
                            </div>
                        </div>
                    </div>

                    <div style="margin-bottom: 1.5rem;">
                        <h3 style="margin-bottom: 0.5rem; color: #111827;">정산 계좌 정보</h3>
                        <p style="color: #6b7280;">{{ settlement.bankName }} {{ settlement.accountNumber }}</p>
                    </div>

                    <button class="btn btn-primary" @click="requestSettlement">정산 신청</button>
                </div>

                <!-- 농가 정보 -->
                <div v-show="activeTab === 'farm'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">농가 정보</h2>

                    <form @submit.prevent="updateFarmInfo">
                        <div class="info-grid">
                            <div class="form-group">
                                <label class="form-label">농가명</label>
                                <input type="text" class="form-input" v-model="farmInfo.name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">대표자명</label>
                                <input type="text" class="form-input" v-model="farmInfo.owner">
                            </div>
                            <div class="form-group">
                                <label class="form-label">농가 위치</label>
                                <input type="text" class="form-input" v-model="farmInfo.location">
                            </div>
                            <div class="info-item">
                                <div class="info-label">농가 소개</div>
                                <div class="info-value">{{ farmInfo.description }}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">인증 현황</div>
                                <div class="cert-badges">
                                    <span v-for="cert in farmInfo.certifications" :key="cert" class="cert-badge">
                                        {{ cert }}
                                    </span>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary" style="margin-top: 2rem;">농가 정보 저장</button>
                    </form>
                </div>

                <!-- 리뷰 -->
                <div v-show="activeTab === 'reviews'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">리뷰 관리</h2>
                    
                    <div v-for="review in reviews" :key="review.id" class="review-card">
                        <div class="review-header">
                            <div class="review-product">{{ review.productName }}</div>
                            <div class="review-rating">{{ '⭐'.repeat(review.rating) }}</div>
                        </div>
                        <div class="review-content">{{ review.content }}</div>
                        <div class="review-meta">
                            <span>{{ review.userName }} · {{ review.date }}</span>
                            <button class="btn btn-secondary" @click="replyToReview(review.id)">답글 작성</button>
                        </div>
                    </div>
                </div>

                <!-- 정보 -->
                <div v-show="activeTab === 'profile'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">회원정보 수정</h2>
                    
                    <form @submit.prevent="updateProfile">
                        <div class="form-group">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-input" v-model="profile.email" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">연락처</label>
                            <input type="tel" class="form-input" v-model="profile.phone">
                        </div>
                        <div class="form-group">
                            <label class="form-label">사업자등록번호</label>
                            <input type="text" class="form-input" v-model="profile.businessNumber" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">계좌번호</label>
                            <input type="text" class="form-input" v-model="profile.accountNumber">
                        </div>
                        <div class="form-group">
                            <label class="form-label">은행명</label>
                            <input type="text" class="form-input" v-model="profile.bankName">
                        </div>
                        
                        <button type="submit" class="btn btn-primary">정보 수정</button>
                    </form>

                    <!-- 탈퇴 기능 -->
                    <div class="danger-zone">
                        <div class="danger-zone-header">
                            <span style="font-size: 1.5rem;">⚠️</span>
                            <h3 class="danger-zone-title">탈퇴 기능</h3>
                        </div>
                        <div class="danger-zone-content">
                            <p class="danger-zone-desc">
                                판매자 계정을 탈퇴하면 모든 상품이 삭제되고, 진행 중인 주문이 취소됩니다. 
                                이 작업은 되돌릴 수 없습니다.
                            </p>
                            <button class="btn btn-danger" @click="confirmWithdrawal">판매자 계정 탈퇴</button>
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
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                activeTab: 'dashboard',
                stats: {
                    todayOrders: 12,
                    todaySales: 850000,
                    totalProducts: 24,
                    avgRating: 4.8
                },
                recentOrders: [
                    { id: 1, orderNo: 'ORD-2024-001', productName: '유기농 토마토', quantity: 3, amount: 45000, status: '배송중', orderDate: '2024-01-15' },
                    { id: 2, orderNo: 'ORD-2024-002', productName: '친환경 쌀', quantity: 1, amount: 50000, status: '배송완료', orderDate: '2024-01-14' },
                    { id: 3, orderNo: 'ORD-2024-003', productName: '제주 감귤', quantity: 5, amount: 75000, status: '주문확인', orderDate: '2024-01-14' }
                ],
                settlement: {
                    totalSales: 5420000,
                    platformFee: 271000,
                    expectedAmount: 5149000,
                    bankName: '농협은행',
                    accountNumber: '123-456-789012'
                },
                farmInfo: {
                    name: '',
                    owner: '',
                    location: '',
                    description: '3대째 이어온 친환경 농법으로 건강한 농산물을 재배하고 있습니다.', // db 추가 ?
                    certifications: ['GAP 인증', '유기농 인증', '친환경 인증']
                },
                reviews: [
                    { id: 1, productName: '유기농 토마토', rating: 5, content: '정말 신선하고 맛있어요! 다음에도 주문할게요.', userName: '김**', date: '2024-01-10' },
                    { id: 2, productName: '친환경 쌀', rating: 4, content: '품질이 좋네요. 포장도 깔끔했습니다.', userName: '이**', date: '2024-01-08' },
                    { id: 3, productName: '제주 감귤', rating: 5, content: '달고 맛있어요. 가족 모두 만족합니다.', userName: '박**', date: '2024-01-05' }
                ],
                profile: {
                    email: 'farmer@example.com',
                    phone: '010-1234-5678',
                    businessNumber: '123-45-67890',
                    accountNumber: '123-456-789012',
                    bankName: '농협은행'
                }
            };
        },
        methods: {
            formatPrice: function(price) {
                return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            },
            getStatusClass: function(status) {
                if (status === '주문확인') return 'status-pending';
                if (status === '배송중') return 'status-shipping';
                if (status === '배송완료') return 'status-completed';
                return '';
            },
            goToPage: function(page) {
                let path = '';
                if (page === 'product-register') {
                    path = '${pageContext.request.contextPath}/product/add.do';
                } else if (page === 'order-manage') {
                    // 주문 관리 페이지 경로를 여기에 지정하세요. (예: /seller/orders.do)
                } else if (page === 'delivery-manage') {
                    // 배송 상태 변경 페이지 경로를 여기에 지정하세요. (예: /seller/delivery.do)      
                }

                if (path) {
                    window.location.href = path;
                } else {
                    // 정의되지 않은 페이지에 대한 처리 (선택 사항)
                    alert(page + ' 페이지는 아직 경로가 정의되지 않았습니다.');
                }
            },
            requestSettlement: function() {
                if (confirm('정산을 신청하시겠습니까?')) {
                    let self = this;
                    let param = {
                        amount: self.settlement.expectedAmount
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/settlement/request",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(data) {
                            alert('정산 신청이 완료되었습니다.');
                        },
                        error: function() {
                            alert('정산 신청 중 오류가 발생했습니다.');
                        }
                    });
                }
            },
            updateFarmInfo: function() {
                if (confirm('농가 정보를 수정하시겠습니까?')) {
                    let self = this;
                    let param = {
                        businessName: self.farmInfo.name,
                        ownerName: self.farmInfo.owner, 
                        address: self.farmInfo.location
                    };

                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/farm/update", 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(response) {
                            if (response.result === 'success') {
                                alert('농가 정보가 성공적으로 수정되었습니다.');
                            } else {
                                alert('농가 정보 수정에 실패했습니다: ' + response.message);
                            }
                        },
                        error: function(xhr, status, error) {
                            alert('농가 정보 수정 중 오류가 발생했습니다.');
                            console.error("AJAX Error: ", status, error);
                        }
                    });
                }
            },
            replyToReview: function(reviewId) {
                let reply = prompt('답글을 입력하세요:');
                if (reply) {
                    let self = this;
                    let param = {
                        reviewId: reviewId,
                        reply: reply
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/review/reply",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(data) {
                            alert('답글이 등록되었습니다.');
                        },
                        error: function() {
                            alert('답글 등록 중 오류가 발생했습니다.');
                        }
                    });
                }
            },
            updateProfile: function() {
                if (confirm('회원정보를 수정하시겠습니까?')) {
                    let self = this;
                    let param = {
                        phone: self.profile.phone,
                        accountNumber: self.profile.accountNumber,
                        bankName: self.profile.bankName
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/profile/update",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(data) {
                            alert('회원정보가 수정되었습니다.');
                        },
                        error: function() {
                            alert('회원정보 수정 중 오류가 발생했습니다.');
                        }
                    });
                }
            },
            confirmWithdrawal: function() {
                if (confirm('정말로 판매자 계정을 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 상품과 주문 정보가 삭제됩니다.')) {
                    let finalConfirm = prompt('탈퇴를 진행하려면 "탈퇴"를 입력하세요:');
                    if (finalConfirm === '탈퇴') {
                        let self = this;
                        $.ajax({
                            url: "${pageContext.request.contextPath}/seller/withdrawal",
                            dataType: "json",
                            type: "POST",
                            data: {},
                            success: function(data) {
                                alert('판매자 계정이 탈퇴되었습니다.');
                                location.href = '${pageContext.request.contextPath}/';
                            },
                            error: function() {
                                alert('계정 탈퇴 중 오류가 발생했습니다.');
                            }
                        });
                    }
                }
            },
            loadFarmInfo: function() {
                let self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/info.dox",
                    dataType: "json",
                    type: "GET",
                    success: function(response) {
                        if (response.result === 'success') {
                            let sellerData = response.sellerInfo;
                            self.farmInfo.name = sellerData.businessName;
                            
                            if (sellerData.user) { 
                                self.farmInfo.owner = sellerData.user.name;
                                self.farmInfo.location = sellerData.user.address;
                            }
                            // description과 certifications는 DB에 없으므로 기존 값을 유지하거나 다른 방식으로 처리해야 합니다.
                        } else {
                            alert('판매자 정보를 불러오는데 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('판매자 정보를 불러오는 중 오류가 발생했습니다.');
                        console.error("AJAX Error: ", status, error);
                    }
                });
            },


        },
        mounted() {
            let self = this;
            // self.loadDashboardData(); 대시보드 추후 
            self.loadFarmInfo();
        }
    });

    app.mount('#app');
</script>

