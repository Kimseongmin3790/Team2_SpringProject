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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
    html,
    body {
        height: 100%;
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        background-color: #f9fafb; 
    }

    #app {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .content {
        flex: 1;
    }

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
        color: #166534; 
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.875rem;
        font-weight: 600;
    }

    .quick-actions {
        max-width: 1200px;
        margin: 2rem auto;
        padding: 0 1rem;
    }

    .quick-actions-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem; 
    }

    .action-card {
        background-color: white;
        border: 1px solid #e5e7eb;
        border-radius: 0.75rem; 
        padding: 1.5rem;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05); 
    }

    .action-card:hover {
        transform: translateY(-4px); 
        box-shadow: 0 4px 12px 0 rgba(0, 0, 0, 0.1);
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
        border-bottom: 3px solid transparent; 
        color: #6b7280;
        font-weight: 500;
        font-size: 1rem; 
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
        font-weight: 600; 
        border-bottom-color: #16a34a;
    }

    .tab-content {
        background-color: white;
        border: 1px solid #e5e7eb;
        border-radius: 0.75rem;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background-color: #f9fafb;
        border: 1px solid #e5e7eb;
        border-radius: 0.75rem;
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

    .orders-table {
        width: 100%;
        border-collapse: collapse;
    }

    .orders-table th {
        background-color: #f9fafb;
        padding: 0.75rem 1rem; 
        text-align: left;
        font-size: 0.875rem; 
        font-weight: 600;
        color: #374151;
        border-bottom: 2px solid #e5e7eb;
    }

    .orders-table td {
        padding: 1rem; 
        border-bottom: 1px solid #e5e7eb;
        color: #374151;
    }

    .orders-table tbody tr:last-child td {
        border-bottom: none; 
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
    .info-item:last-child {
        border-bottom: none;
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

    .review-card {
        border: 1px solid #e5e7eb;
        border-radius: 0.75rem;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
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
        line-height: 1.6; 
    }

    .review-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 0.875rem;
        color: #9ca3af;
        margin-top: 1rem;
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-label {
        display: block;
        font-weight: 500;
        color: #374151;
        margin-bottom: 0.5rem;
    }

    .form-input, .form-select, .form-textarea {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #d1d5db;
        border-radius: 0.5rem; 
        font-size: 1rem;
        box-sizing: border-box; 
    }

    .form-input:focus, .form-select:focus, .form-textarea:focus {
        outline: none;
        border-color: #16a34a;
        box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
    }

    .form-textarea {
        min-height: 120px;
        resize: vertical;
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 0.5rem; 
        font-weight: 600; 
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
        border: 1px solid #e5e7eb; 
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
        border-radius: 0.75rem; 
        padding: 1.5rem;
    }

    .danger-zone-desc {
        color: #991b1b;
        margin-bottom: 1rem;
    }

    .non-editable-field {
        padding: 0.75rem;
        border: 1px solid #d1d5db;
        border-radius: 0.5rem;
        background-color: #f3f4f6; 
        color: #6b7280;
    }

    .non-editable-text {
        font-size: 0.875rem;
        color: #6b7280;
        margin-top: 0.5rem;
    }

    .review-images-container {
        margin-top: 1rem;
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .review-image-thumbnail {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 0.5rem; 
        border: 1px solid #e5e7eb;
    }

    .review-section-title {
        margin-bottom: 1.5rem;
        color: #111827;
        font-size: 1.5rem; 
        font-weight: 600;
    }

    .seller-reply-container {
        margin-top: 1.5rem; 
        background-color: #f9fafb;
        border-radius: 0.75rem;
        padding: 1.5rem;
    }

    .seller-reply-item {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 1rem 0;
        border-bottom: 1px solid #e5e7eb;
    }
    .seller-reply-item:first-child {
        padding-top: 0;
    }
    .seller-reply-item:last-child {
        padding-bottom: 0;
        border-bottom: none;
    }

    .seller-reply-author {
        font-weight: 600;
        color: #16a34a;
    }

    .seller-reply-content {
        color: #374151;
        margin: 0.5rem 0;
        line-height: 1.6;
    }

    .seller-reply-date {
        font-size: 0.875rem;
        color: #9ca3af;
        margin-top: 0.5rem;
    }

    .btn-sm {
        padding: 0.25rem 0.75rem; 
        font-size: 0.875rem;
    }

    .seller-reply-actions {
        display: flex;
        gap: 0.5rem;
        margin-left: 1rem;
        flex-shrink: 0; 
    }

    .seller-reply-edit-input {
        width: 100%;
        min-height: 60px;
        margin: 0.5rem 0;
    }

    .sales-filter-container {
        display: flex;
        align-items: flex-end;
        gap: 1rem;
        padding: 1.5rem;
        background-color: #f9fafb;
        border-radius: 0.75rem;
        margin-bottom: 2rem;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
    }

    .filter-label {
        font-size: 0.9rem;
        font-weight: 500;
        margin-bottom: 0.5rem;
        color: #374151;
    }

    .sales-summary-card {
        display: grid;
        grid-template-columns: repeat(3, 1fr); 
        justify-content: space-around;
        background-color: #f9fafb;
        border: 1px solid #e5e7eb;
        border-radius: 0.75rem;
        padding: 1.5rem;
        margin-bottom: 2rem;
        gap: 1rem;
    }

    .summary-item {
        text-align: center;
    }

    .summary-label {
        font-size: 0.9rem;
        color: #6b7280;
        margin-bottom: 0.5rem;
    }

    .summary-value {
        font-size: 1.8rem;
        font-weight: bold;
        color: #111827;
    }

    .summary-unit {
        font-size: 1rem;
        font-weight: normal;
        margin-left: 0.25rem;
        color: #6b7280;
    }

    .empty-state {
        text-align: center;
        padding: 3rem 0;
    }
    .empty-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: #9ca3af;
    }

    @media (max-width: 768px) {
        .seller-header-container {
            flex-direction: column;
            gap: 1rem;
        }

        .tab-nav {
            flex-wrap: nowrap;
        }

        .tab-content {
            padding: 1.5rem; 
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

        .stats-grid, .quick-actions-grid {
            grid-template-columns: 1fr;
        }

        .sales-filter-container {
            flex-direction: column;
            align-items: stretch;
        }

        .sales-summary-card {
            grid-template-columns: 1fr;
        }
        
    }
    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 2rem;
        gap: 0.5rem;
    }
    .page-btn {
        padding: 0.5rem 1rem;
        border: 1px solid #d1d5db;
        background-color: white;
        border-radius: 0.5rem;
        cursor: pointer;
        transition: all 0.2s;
    }
    .page-btn:hover {
        background-color: #f3f4f6;
    }
    .page-btn:disabled {
        cursor: not-allowed;
        opacity: 0.5;
    }
    .page-btn.active {
        background-color: #16a34a;
        color: white;
        border-color: #16a34a;
        font-weight: 600;
    }
    .badge-refund-request {
        background-color: #fef3c7; 
        color: #92400e;
    }

    .badge-success {
        background-color: #dcfce7; 
        color: #166534;
    }

    .badge-danger {
        background-color: #fee2e2; 
        color: #991b1b;
    }
    .orders-table td.text-center > div {
        justify-content: center;
        display: flex;
    }
    .date-range {
        display: flex;
        align-items: center;
        gap: 0.5rem; 
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
                    <div class="action-card" @click="goToPage('product-manage')">
                        <div class="action-icon">🚚</div>
                        <div class="action-title">내 상품 관리</div>
                        <div class="action-desc">내 상품을 관리하세요</div>
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
                        매출 관리
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
                            <tr v-for="order in recentOrders" :key="order.orderNo">
                                <td>{{ order.orderNo }}</td>
                                <td>{{ order.productName }}</td>
                                <td>{{ order.productCount }}개</td>
                                <td>{{ formatPrice(order.totalPrice) }}원</td>
                                 <td>
                                    <!-- 환불 관련 상태가 있을 경우 우선 표시 -->
                                    <span v-if="order.primaryRefundStatus"
                                        class="status-badge" :class="getRefundStatusBadgeClass(order.primaryRefundStatus)">
                                        환불 {{ order.primaryRefundStatus }}
                                    </span>
                                    <!-- 환불 관련 상태가 없을 경우에만 기존 주문 상태 표시 -->
                                    <span v-else class="status-badge" :class="getStatusClass(order.status)">
                                        {{ order.status }}
                                    </span>
                                </td>
                                <td>{{ order.orderDate }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 매출 관리 -->
                <div v-show="activeTab === 'settlement'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">매출 관리</h2>

                    <!-- 기간 조회 UI -->
                    <div class="sales-filter-container">
                        <div class="filter-group">
                            <label class="filter-label">조회 기간</label>
                            <select v-model="salesPeriod.type" class="form-select">
                                <option value="daily">일별</option>
                                <option value="monthly">월별</option>
                                <option value="yearly">연도별</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">조회 날짜</label>
                            <!-- 일별 조회 -->
                            <div v-if="salesPeriod.type === 'daily'" class="date-range">
                                <select v-model.number="salesPeriod.year" class="form-select">
                                    <option v-for="y in yearOptions" :key="y" :value="y">{{ y }}년</option>
                                </select>
                                <select v-model.number="salesPeriod.month" class="form-select">
                                    <option v-for="m in monthOptions" :key="m" :value="m">{{ m }}월</option>
                                </select>
                            </div>
                            <!-- 월별 조회 -->
                            <div v-if="salesPeriod.type === 'monthly'" class="date-range">
                                <select v-model.number="salesPeriod.year" class="form-select">
                                    <option v-for="y in yearOptions" :key="y" :value="y">{{ y }}년</option>
                                </select>
                            </div>
                            <!-- 연별 조회 -->
                            <div v-if="salesPeriod.type === 'yearly'" class="date-range">
                                <select v-model.number="salesPeriod.startYear" class="form-select">
                                    <option v-for="y in yearOptions" :key="y" :value="y">{{ y }}년</option>
                                </select>
                                <span>~</span>
                                <select v-model.number="salesPeriod.endYear" class="form-select">
                                    <option v-for="y in yearOptions" :key="y" :value="y">{{ y }}년</option>
                                </select>
                            </div>
                        </div>
                        <button @click="loadSalesHistory" class="btn btn-primary">조회</button>
                    </div>

                    <!-- 기간 내 총계 요약 -->
                    <div class="sales-summary-card">
                        <div class="summary-item">
                            <div class="summary-label">총 주문건수</div>
                            <div class="summary-value">{{ salesSummary.totalOrderCountSum }}<span class="summary-unit">건</span></div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">총 매출</div>
                            <div class="summary-value">{{ formatPrice(salesSummary.totalSalesSum) }}<span class="summary-unit">원</span></div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">총 플랫폼 수수료</div>
                            <div class="summary-value">{{ formatPrice(salesSummary.totalPlatformFeeSum) }}<span class="summary-unit">원</span>
                    </div>
                        </div>
                    </div>

                    <!-- 매출 내역 테이블 -->
                    <div class="sales-history-table">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>기간</th>
                                    <th>주문 건수</th>
                                    <th>매출액</th>
                                    <th>플랫폼 수수료</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="record in paginatedSalesHistory" :key="record.period">
                                    <td>{{ record.period }}</td>
                                    <td>{{ record.orderCount }}건</td>
                                    <td>{{ formatPrice(record.totalSales) }}원</td>
                                    <td>{{ formatPrice(record.platformFee) }}원</td>
                                </tr>
                            </tbody>
                        </table>
                        <div v-if="salesHistory.length === 0" class="empty-state">
                            <div class="empty-icon">📊</div>
                            <p>매출 내역이 없습니다.</p>
                        </div>
                    </div>
                    <!-- 페이징 -->
                    <div v-if="salesPeriod.type === 'monthly' && totalPages > 1" class="pagination">
                        <button @click="changePage(salesPagination.currentPage - 1)" :disabled="salesPagination.currentPage <= 1" class="page-btn"> 이전 </button>
                        <span v-for="page in totalPages" :key="page">
                            <button @click="changePage(page)" :class="{ 'page-btn': true, 'active': salesPagination.currentPage === page }"> {{ page }} </button>
                        </span>
                        <button @click="changePage(salesPagination.currentPage + 1)" :disabled="salesPagination.currentPage >= totalPages" class= "page-btn"> 다음 </button>
                    </div>
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
                        </div>
                        <button type="submit" class="btn btn-primary" style="margin-top: 2rem;">농가 정보 저장</button>
                    </form>
                </div>

                <!-- 리뷰 -->
                <div v-show="activeTab === 'reviews'" class="tab-content">
                    <h2 class="review-section-title">리뷰 관리</h2> 

                    <div v-for="review in reviews" :key="review.id" class="review-card">
                        <div class="review-header">
                            <div class="review-product">{{ review.productName }}</div>
                            <div class="review-rating">{{ '⭐'.repeat(review.rating) }}</div>
                        </div>
                        <div class="review-content">{{ review.content }}</div>
                        <div v-if="review.reviewImages && review.reviewImages.length > 0" class="review-images-container">
                            <img v-for="(imageUrl, index) in review.reviewImages" :key="index" :src="imageUrl" alt="리뷰 이미지" class="review-image-thumbnail">
                        </div>
                        <div v-if="review.comments && review.comments.length > 0" class="seller-reply-container">
                            <div v-for="comment in review.comments" :key="comment.commentNo" class="seller-reply-item">
                                <div class="seller-reply-body">
                                    <p class="seller-reply-author">{{ comment.userId }} (판매자)님의 답글:</p>
                                    <p v-if="editingCommentNo !== comment.commentNo" class="seller-reply-content">{{ comment.contents}}</p>
                                    <textarea v-else v-model="comment.contents" class="form-textarea seller-reply-edit-input"></textarea>
                                    <p class="seller-reply-date">작성일: {{ comment.cDatetime }}</p>
                                </div>
                                <div class="seller-reply-actions">
                                    
                                    <template v-if="editingCommentNo !== comment.commentNo">
                                        <button class="btn btn-secondary btn-sm" @click="editComment(comment.commentNo)">수정</button>
                                        <button class="btn btn-secondary btn-sm" @click="deleteComment(comment.commentNo)">삭제</button>
                                    </template>
                                    <template v-else>
                                        <button class="btn btn-primary btn-sm" @click="saveEditedComment(comment)">저장</button>
                                        <button class="btn btn-secondary btn-sm" @click="cancelEdit()">취소</button>
                                    </template>
                                </div>
                            </div>
                        </div>
                        <div class="review-meta">
                            <span>작성자:  {{ review.userId }}  <br> 리뷰 날짜:  {{ review.cdate }}</span>
                            <button class="btn btn-secondary" @click="replyToReview(review.reviewNo)">답글 작성</button>
                        </div>
                    </div>
                </div>

                <!-- 정보 -->
                <div v-show="activeTab === 'profile'" class="tab-content">
                    <h2 style="margin-bottom: 1.5rem; color: #111827;">회원정보 수정</h2>
                    
                    <form @submit.prevent="updateProfile">
                        <div class="form-group">
                            <label class="form-label">이메일</label>
                            <div class="info-value non-editable-field">
                                {{ profile.email }}
                            </div>
                            <p class="non-editable-text">
                                이메일은 변경할 수 없습니다.
                            </p>
                        </div>
                        <div class="form-group">
                            <label class="form-label">연락처</label>
                            <input type="tel" class="form-input" v-model="profile.phone">
                        </div>
                        <div class="form-group">
                            <label class="form-label">사업자등록번호</label>
                            <div class="info-value non-editable-field">
                                {{ profile.businessNumber }}
                            </div>
                            <p class="non-editable-text">
                                사업자등록번호 변경은 관리자에게 문의해주세요.
                            </p>
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
                loginType: '${loginType}',

                stats: {
                    todayOrders: 0,
                    todaySales: 0,
                    totalProducts: 0,
                    avgRating: 0.0
                },
                recentOrders: [],
                salesHistory: [],
                salesPeriod: {
                    type: 'daily',
                    month: new Date().getMonth() + 1, 
                    year: new Date().getFullYear(),
                    startYear: new Date().getFullYear() - 3,
                    endYear: new Date().getFullYear()
                },
                monthOptions: Array.from({ length: 12 }, (_, i) => i + 1), 
                salesPagination: { 
                    currentPage: 1,
                    rowsPerPage: 10 
                },
                farmInfo: {
                    name: '',
                    owner: '',
                    location: '',
                },
                reviews: [],
                profile: {
                    email: '',
                    phone: '',
                    businessNumber: '',
                    accountNumber: '',
                    bankName: ''
                },
                
                editingCommentNo: null
            };
        },
        computed: {
            yearOptions() {
                const currentYear = new Date().getFullYear();
                const startYear = 2024; 
                const years = [];
                for (let i = currentYear; i >= startYear; i--) {
                    years.push(i);
                }
                return years;
            },
            salesSummary: function() {
                let self = this;
                let totalSalesSum = 0;
                let totalPlatformFeeSum = 0;
                let totalOrderCountSum = 0; 
                self.salesHistory.forEach(record => {
                    totalSalesSum += record.totalSales || 0;
                    totalPlatformFeeSum += record.platformFee || 0;
                    totalOrderCountSum += record.orderCount || 0; 
                });
                return {
                    totalSalesSum: totalSalesSum,
                    totalPlatformFeeSum: totalPlatformFeeSum,
                    totalOrderCountSum: totalOrderCountSum 
                };
            },
            totalPages: function() {
                return Math.ceil(this.salesHistory.length / this.salesPagination.rowsPerPage);
            },

            paginatedSalesHistory: function() {
                if (this.salesPeriod.type !== 'monthly' || this.totalPages <= 1) {
                    return this.salesHistory; 
                }
                const start = (this.salesPagination.currentPage - 1) * this.salesPagination.rowsPerPage;
                const end = start + this.salesPagination.rowsPerPage;
                return this.salesHistory.slice(start, end);
            }
        },
        methods: {
            formatPrice: function(price) {
                if (price === undefined || price === null) {
                    return '0'; 
                }
                const numericPrice = Number(price);
                if (isNaN(numericPrice)) {
                    return String(price); 
                }
                return numericPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
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
                    path = '${pageContext.request.contextPath}/order/sellerList.do';
                } else if (page === 'product-manage') {
                    path = '${pageContext.request.contextPath}/sellerProductList.do';   
                }

                if (path) {
                    window.location.href = path;
                } else {
                    alert(page + ' 페이지는 아직 경로가 정의되지 않았습니다.');
                }
            },
            updateFarmInfo: function() {
                if (confirm('농가 정보를 수정하시겠습니까?')) {
                    let self = this;
                    let param = {
                        businessName: self.farmInfo.name,
                        "user.name": self.farmInfo.owner, 
                        "user.address": self.farmInfo.location
                    };

                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/farm/update.dox", 
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
                        }
                    });
                }
            },
            replyToReview: function(reviewNo) {
                let reply = prompt('답글을 입력하세요:');
                if (reply && reply.trim() !== '') {
                    let self = this;
                    let param = {
                        reviewNo: reviewNo,
                        contents: reply
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/review/addComment.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(response) {
                            if(response.result === 'success') {
                                alert('답글이 등록되었습니다.');      
                                self.loadReviews();                
                            } else {
                                alert('답글 등록에 실패했습니다: ' + response.message);
                            }
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
                        "user.phone": self.profile.phone,  
                        account: self.profile.accountNumber,
                        bankName: self.profile.bankName
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/profile/update.dox", 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function(data) {
                            if (data.result === 'success') {
                                alert('회원정보가 수정되었습니다.');
                            } else {
                                alert('회원정보 수정 중 오류가 발생했습니다: ' + data.message);
                            }
                        },
                        error: function() {
                            alert('회원정보 수정 중 오류가 발생했습니다.');
                        }
                    });
                }
            },
            confirmWithdrawal: function () {
                let self = this;
                if (confirm('정말로 판매자 계정을 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 상품이 숨김 처리되고, 계정 상태가 변경됩니다.')) {

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
                    } else { 
                        alert('로그인 유형을 알 수 없어 탈퇴를 진행할 수 없습니다.');
                        return;
                    }

                    if (proceedWithdrawal) {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/seller/withdrawal.dox", 
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8", 
                            data: JSON.stringify(withdrawalData), 
                            success: function (response) {
                                if (response.result === 'success') {
                                    alert('판매자 계정이 성공적으로 탈퇴되었습니다.');
                                    location.href = '${pageContext.request.contextPath}/login.do';
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
                            
                        } else {
                            alert('판매자 정보를 불러오는데 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('판매자 정보를 불러오는 중 오류가 발생했습니다.');
                    }
                });
            },
            loadProfileData: function() {
                let self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/info.dox",
                    dataType: "json",
                    type: "GET",
                    success: function(response) {
                        if (response.result === 'success') {
                            let sellerData = response.sellerInfo;
                            self.profile.businessNumber = sellerData.businessNumber;
                            self.profile.accountNumber = sellerData.account;
                            self.profile.bankName = sellerData.bankName;

                            if (sellerData.user) {
                                self.profile.email = sellerData.user.email;
                                self.profile.phone = sellerData.user.phone;
                            }
                        } else {
                            alert("회원정보를 불러오는데 실패했습니다");
                        }
                    },
                    error: function(xhr, status, error) {      
                        alert("회원정보를 불러오는 중 오류가 발생했습니다.")
                    }
                });
            },
            loadReviews: function() {
                let self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/reviews.dox", 
                    dataType: "json",
                    type: "GET",
                    success: function(response) {
                        self.reviews = response;
                    },
                    error: function(xhr, status, error) {
                        alert('리뷰를 불러오는 중 오류가 발생했습니다.');
                    }
                });
            },
            deleteComment: function(commentNo) {
                if (confirm('정말로 이 답글을 삭제하시겠습니까?')) {
                    let self = this;
                    $.ajax({
                        url: "${pageContext.request.contextPath}/seller/review/deleteComment.dox", 
                        dataType: "json",
                        type: "POST",
                        data: {
                            commentNo: commentNo 
                        },
                        success: function(response) {
                            if (response.result === 'success') {
                                alert('답글이 삭제되었습니다.');
                                self.loadReviews(); 
                            } else {
                                alert('답글 삭제에 실패했습니다: ' + response.message);
                            }
                        },
                        error: function() {
                            alert('답글 삭제 중 오류가 발생했습니다.');
                        }
                    });
                }
            },
            editComment: function(commentNo) {
                let self = this;
                self.editingCommentNo = commentNo; 
            },

            cancelEdit: function() {
                let self = this;
                self.editingCommentNo = null; 
                self.loadReviews(); 
            },

            saveEditedComment: function(comment) {
                let self = this;

                if (comment.contents.trim() === '') {
                    alert('답글 내용을 입력해주세요.');
                    return;
                }
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/review/updateComment.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        commentNo: comment.commentNo,
                        contents: comment.contents
                    },
                    success: function(response) {
                        if (response.result === 'success') {
                            alert('답글이 수정되었습니다.');
                            self.editingCommentNo = null; 
                            self.loadReviews(); 
                        } else {
                            alert('답글 수정에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function() {
                        alert('답글 수정 중 오류가 발생했습니다.');
                    }
                });
            },
            loadDashboardData: function() {
                let self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/dashboard.dox",
                    dataType: "json",
                    type: "GET",
                    success: function(response) {
                        if (response.result === 'success') {
                            self.stats.todayOrders = response.todayOrders;
                            self.stats.todaySales = response.todaySales;
                            self.stats.totalProducts = response.totalProducts;
                            self.stats.avgRating = response.avgRating;
                            self.recentOrders = response.recentOrders;
                        } else {
                            alert('대시보드 데이터를 불러오는데 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('대시보드 데이터를 불러오는 중 오류가 발생했습니다.');
                    }
                });
            },
            loadSalesHistory: function() {
                let self = this;

                self.salesPagination.currentPage = 1;

                let params = {
                    type: self.salesPeriod.type
                };

               if (self.salesPeriod.type === 'daily') {
                    if (self.salesPeriod.year && self.salesPeriod.month) {
                        params.month = self.salesPeriod.year + '-' + String(self.salesPeriod.month).padStart(2, '0');
                    }
                } else if (self.salesPeriod.type === 'monthly') {
                    if (self.salesPeriod.year) {
                        params.year = self.salesPeriod.year;
                    }
                } else if (self.salesPeriod.type === 'yearly') {
                    if (self.salesPeriod.startYear && self.salesPeriod.endYear) {
                        params.startYear = self.salesPeriod.startYear;
                        params.endYear = self.salesPeriod.endYear;
                    }
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/seller/salesHistory.dox",
                    dataType: "json",
                    type: "GET",
                    data: params,
                    success: function(response) {
                        if (response.result === 'success') {
                            self.salesHistory = response.history;
                        } else {
                            alert('매출 내역을 불러오는데 실패했습니다: ' + response.message);
                            self.salesHistory = [];
                        }
                    },
                    error: function() {
                        alert('매출 내역을 불러오는 중 오류가 발생했습니다.');
                        self.salesHistory = [];
                    }
                });
            },
            changePage: function(page) {
                let self = this;
                if (page > 0 && page <= self.totalPages) {
                    self.salesPagination.currentPage = page;
                }
            },
            getRefundStatusBadgeClass(status) {
                const classes = {
                    '대기': 'badge badge-refund-request', 
                    '승인': 'badge badge-success', 
                    '거절': 'badge badge-danger' 
                };
                return classes[status] || 'badge';
            }

        },
        mounted() {
            let self = this;
            self.loadDashboardData(); 
            self.loadFarmInfo();
            self.loadReviews();
            self.loadSalesHistory();
            self.loadProfileData();
        }
    });

    app.mount('#app');
</script>