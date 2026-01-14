<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 관리 - AGRICOLA</title>
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
            background-color: #f9fafb;
        }

        .content {
            flex: 1;
        }

        /* Header */
        .page-header {
            background: white;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 0;
        }

        .page-header .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .page-header h1 {
            font-size: 1.5rem;
            font-weight: bold;
            color: #4caf50;
            margin: 0 0 0.25rem 0;
        }

        .page-header p {
            font-size: 0.875rem;
            color: #6b7280;
            margin: 0;
        }

        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.5rem 1rem;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1rem;
        }

        @media (min-width: 768px) {
            .filter-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        .filter-item label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .filter-item select,
        .filter-item input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            box-sizing: border-box;
        }

        .filter-item select:focus,
        .filter-item input:focus {
            outline: none;
            border-color: #4caf50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
        }

        .date-range {
            display: flex;
            gap: 0.5rem;
        }

        .search-wrapper {
            position: relative;
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }

        .search-input {
            padding-left: 2.5rem !important;
        }

        .search-col {
            grid-column: span 2;
        }

        /* Table Section */
        .table-section {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #f9fafb;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
        }

        th.text-right {
            text-align: right;
        }

        th.text-center {
            text-align: center;
        }

        tbody tr {
            border-bottom: 1px solid #e5e7eb;
            transition: background-color 0.2s;
        }

        tbody tr:hover {
            background-color: #f9fafb;
        }

        td {
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
        }

        .order-no-link {
            color: #4caf50;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
        }

        .order-no-link:hover {
            text-decoration: underline;
        }

        .product-name {
            font-weight: 500;
        }

        .product-count {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        /* Badge */
        .badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .badge-new {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .badge-preparing {
            background-color: #fef3c7;
            color: #92400e;
        }

        .badge-shipping {
            background-color: #e9d5ff;
            color: #6b21a8;
        }

        .badge-completed {
            background-color: #d1fae5;
            color: #065f46;
        }

        .badge-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }

        /* Action Controls */
        .action-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .status-select {
            width: 8rem;
            height: 2rem;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }

        .btn {
            padding: 0.375rem 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            cursor: pointer;
            background: white;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            transition: all 0.2s;
        }

        .btn:hover {
            background-color: #f9fafb;
        }

        .btn-primary {
            background-color: #4caf50;
            color: white;
            border-color: #4caf50;
        }

        .btn-primary:hover {
            background-color: #45a049;
        }

        /* Empty State */
        .empty-state {
            padding: 3rem 1rem;
            text-align: center;
            color: #6b7280;
        }

        .empty-icon {
            width: 3rem;
            height: 3rem;
            margin: 0 auto 0.75rem;
            opacity: 0.5;
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            border-radius: 0.5rem;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-content.large {
            max-width: 800px;
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0 0 0.25rem 0;
        }

        .modal-description {
            font-size: 0.875rem;
            color: #6b7280;
            margin: 0;
        }

        .modal-body {
            padding: 1.5rem;
        }

        .modal-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 0.875rem;
        }

        /* Detail Modal Sections */
        .detail-section {
            margin-bottom: 1.5rem;
        }

        .detail-section:last-child {
            margin-bottom: 0;
        }

        .detail-section h3 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 0.75rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-box {
            background-color: #f9fafb;
            border-radius: 0.5rem;
            padding: 1rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .detail-row:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            color: #6b7280;
        }

        .detail-value {
            font-weight: 500;
            text-align: right;
        }

        .detail-row.total {
            border-top: 1px solid #e5e7eb;
            padding-top: 0.5rem;
            margin-top: 0.5rem;
            font-weight: 600;
        }

        .detail-row.total .detail-value {
            color: #4caf50;
        }

        .product-card {
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1rem;
            display: flex;
            flex-direction: column; 
            gap: 1rem; 
        }
        .product-main-info {
            display: flex;
            gap: 1rem;
            width: 100%; 
        }

        .product-image {
            width: 5rem;
            height: 5rem;
            background-color: #f3f4f6;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .product-info {
            flex: 1;
        }

        .product-info-name {
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .product-info-quantity {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .product-info-price {
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* Icons */
        .icon {
            width: 1rem;
            height: 1rem;
            display: inline-block;
        }

        .icon-sm {
            width: 0.75rem;
            height: 0.75rem;
        }

        .icon-lg {
            width: 2rem;
            height: 2rem;
        }
        .bulk-action-container {
            margin-bottom: 1rem;
            padding: 1rem;
            background: #fff;
            border-radius: 0.5rem;
            border: 1px solid #e5e7eb;
            display: flex;
            align-items: center; 
            gap: 0.5rem; 
        }

        .bulk-action-select {
            padding: 0.5rem;
            border-radius: 0.375rem;
            border: 1px solid #d1d5db;
            font-size: 0.875rem; 
        }

        .bulk-action-button {
        }

        th input[type="checkbox"],
        td input[type="checkbox"] {
            width: 1rem;
            height: 1rem;
            vertical-align: middle;
            cursor: pointer;
        }
        .modal-loading {
            padding: 5rem;
            text-align: center;
            color: #6b7280;
        }

        .product-card + .product-card {
            margin-top: 1rem;
        }

        .product-card .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 0.5rem;
        }

        .product-info-option {
            font-size: 0.8rem;
            color: #6b7280;
            margin-bottom: 0.25rem;
        }
        .tracking-number-value {
            font-family: monospace;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1.5rem 0;
        }
        .pagination-button {
            border: 1px solid #d1d5db;
            background-color: #fff;
            color: #374151;
            padding: 0.5rem 0.75rem;
            margin: 0 0.25rem;
            cursor: pointer;
            border-radius: 0.375rem;
            transition: background-color 0.2s;
            font-size: 0.875rem;
        }
        .pagination-button:hover:not(:disabled) {
            background-color: #f9fafb;
        }
        .pagination-button:disabled {
            cursor: not-allowed;
            opacity: 0.5;
        }
        .pagination-button.active {
            background-color: #4caf50;
            color: white;
            border-color: #4caf50;
            font-weight: bold;
        }
        .badge-refund-request {
            display: inline-block;
            padding: 4px 8px;
            margin-left: 5px;
            border-radius: 5px;
            font-size: 0.75em; 
            font-weight: bold;
            color: #fff;
            background-color: #dc3545;
            vertical-align: middle;
        }

        .refund-details {
            width: 100%;
            margin-top: 15px;
            padding: 1rem;
            border-top: 1px dashed #e5e7eb;
            display: flex;
            flex-direction: column; 
            gap: 1rem; 
            background-color: #fffbeb;
            border-radius: 0.375rem;
            border: 1px solid #fcd34d; 
            box-sizing: border-box;
        }

        .refund-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem; 
        }

        .refund-info p {
            margin: 0; 
            font-size: 0.875rem; 
            color: #92400e;
            display: flex; 
            justify-content: space-between; 
        }

        .refund-info p strong {
            color: #b45309;
            font-weight: 600; 
            flex-shrink: 0; 
            margin-right: 0.5rem; 
        }

        .refund-actions {
            display: flex;
            justify-content: flex-end; 
            gap: 0.5rem;
            flex-shrink: 0;
            margin-top: 0.5rem;
        }
        .refund-actions .btn-success {
            background-color: #28a745; 
            border-color: #28a745;
            color: #fff;
        }

        .refund-actions .btn-danger {
            background-color: #dc3545; 
            border-color: #dc3545;
            color: #fff;
        }
        .badge-processed {
        background-color: #e0e0e0; /* 회색 계열 */
        color: #555;
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.75rem;
        font-weight: 500;
    }
    .badge-success {
        background-color: #d1fae5; 
        color: #065f46; 
    }

    .badge-danger {
        background-color: #fee2e2; 
        color: #991b1b; 
    }
    .refund-details .badge {
        font-size: 0.75rem; 
        padding: 0.2em 0.6em;
        font-weight: 600;
    }

    .product-card .refund-details:last-child {
        margin-bottom: 0;
    }
    </style>
</head>
<body>
    <!-- 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div id="app">
        <!-- Page Header -->
        <header class="page-header">
            <div class="container">
                <h1>주문 관리</h1>
                <p>판매자 주문 관리 시스템</p>
            </div>
        </header>

        <main class="content">
            <div class="main-container">
                <!-- Filters -->
                <div class="filter-section">
                    <div class="filter-grid">
                        <!-- Status Filter -->
                        <div class="filter-item">
                            <label>주문 상태</label>
                            <select v-model="selectedStatus">
                                <option value="전체">전체</option>
                                <option value="신규 주문">신규 주문</option>
                                <option value="배송 준비중">배송 준비중</option>
                                <option value="배송중">배송중</option>
                                <option value="배송 완료">배송 완료</option>
                                <option value="취소/반품">취소/반품</option>
                            </select>
                        </div>

                        <!-- Date Range -->
                        <div class="filter-item">
                            <label>조회 기간</label>
                            <div class="date-range">
                                <input type="date" v-model="startDate">
                                <input type="date" v-model="endDate">
                            </div>
                        </div>

                        <!-- Search -->
                        <div class="filter-item search-col">
                            <label>검색</label>
                            <div class="search-wrapper">
                                <span class="search-icon">🔍</span>
                                <input 
                                    type="text" 
                                    class="search-input" 
                                    placeholder="주문번호, 구매자명, 상품명 검색"
                                    v-model="searchQuery"
                                >
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bulk-action-container" v-if="selectedOrders.length > 0">
                    <strong>{{ selectedOrders.length }}</strong>개 항목 선택됨 &nbsp;
                    <select v-model="bulkActionStatus" class="bulk-action-select">
                        <option value="">일괄 변경할 상태 선택</option>
                        <option value="배송 준비중">배송 준비중</option>
                        <option value="취소/반품">취소/반품</option>
                    </select>
                    <button class="btn btn-primary bulk-action-button" @click="applyBulkAction">적용</button>
                </div>

                <!-- Orders Table -->
                <div class="table-section">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 3rem;"><input type="checkbox" @change="toggleSelectAll" :checked="isAllSelected"></th>
                                    <th>주문번호</th>
                                    <th>주문일시</th>
                                    <th>상품명</th>
                                    <th>구매자</th>
                                    <th class="text-right">결제금액</th>
                                    <th class="text-center">주문상태</th>
                                    <th class="text-center">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="order in orders" :key="order.orderNo">
                                    <td><input type="checkbox" :value="order.orderNo" v-model="selectedOrders"></td>
                                    <td>
                                        <a href="#" class="order-no-link" @click.prevent="openDetailModal(order)">
                                            {{ order.orderNo }}
                                        </a>
                                    </td>
                                    <td style="color: #6b7280;">{{ order.orderDate }}</td>
                                    <td>
                                        <div class="product-name">{{ order.productName }}</div>
                                        <div v-if="order.productCount > 1" class="product-count">
                                            외 {{ order.productCount - 1 }}건
                                        </div>
                                    </td>
                                    <td>{{ order.buyerName }}</td>
                                    <td class="text-right" style="font-weight: 500;">
                                        {{ order.totalPrice.toLocaleString() }}원
                                    </td>
                                    <td class="text-center">
                                        <span v-if="getOrderOverallRefundStatus(order) === '대기'"
                                            class="status-badge" :class="getRefundStatusBadgeClass('대기')">
                                            환불 요청
                                        </span>
                                        <span v-else-if="getOrderOverallRefundStatus(order) === '전체 환불 완료'"
                                            class="status-badge" :class="getRefundStatusBadgeClass('승인')">
                                            전체 환불 완료
                                        </span>
                                        <span v-else-if="getOrderOverallRefundStatus(order) === '부분 환불 완료'"
                                            class="status-badge" :class="getRefundStatusBadgeClass('승인')">
                                            부분 환불 완료
                                        </span>
                                        <span v-else :class="getStatusBadgeClass(order.status)">
                                            {{ order.status }}
                                        </span>
                                    </td>
                                    <td class="text-center" style="vertical-align: middle;">
                                        <div v-if="getOrderOverallRefundStatus(order) === '대기'">
                                            <button class="btn btn-danger" @click="openDetailModal(order)">
                                                🚨 환불처리
                                            </button>
                                        </div>
                                        <div v-else-if="getOrderOverallRefundStatus(order) === '전체 환불 완료'">
                                            <span class="text-muted">환불 완료</span>
                                        </div>
                                        <div v-else class="action-controls">
                                            <select
                                                class="status-select"
                                                :value="order.status"
                                                @change="handleStatusChange(order.orderNo, $event.target.value)"
                                                :disabled="getValidStatusOptions(order.status).length === 0">
                                                <option :value="order.status" selected>{{ order.status }}</option>
                                                <option v-for="option in getValidStatusOptions(order.status)" :key="option" :value="option">
                                                    {{ option }}
                                                </option>
                                            </select>
                                            <button
                                                v-if="order.status === '배송 준비중'"
                                                class="btn"
                                                @click="openDeliveryModal(order)">
                                                🚚 배송등록
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Empty State -->
                    <div v-if="orders.length === 0" class="empty-state">
                        <div class="empty-icon">📦</div>
                        <p>주문 내역이 없습니다.</p>
                    </div>
                </div>
                <div class="pagination-container" v-if="totalPages > 0">
                    <button class="pagination-button" @click="goToPage(1)" :disabled="currentPage === 1">
                        &laquo;
                    </button>
                    <button class="pagination-button" @click="prevPage" :disabled="currentPage === 1">
                        &lsaquo;
                    </button>
                    <span v-for="page in pageNumbers" :key="page">
                        <button
                            class="pagination-button"
                            :class="{ 'active': page === currentPage }"
                            @click="goToPage(page)">
                            {{ page }}
                        </button>
                    </span>
                    <button class="pagination-button" @click="nextPage" :disabled="currentPage === totalPages">
                        &rsaquo;
                    </button>
                    <button class="pagination-button" @click="goToPage(totalPages)" :disabled="currentPage === totalPages">
                        &raquo;
                    </button>
                </div>
            </div>
        </main>

        <!-- Delivery Modal -->
        <div v-if="deliveryModalOpen" class="modal-overlay" @click.self="closeDeliveryModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">배송 정보 입력</h2>
                    <p class="modal-description">택배사와 송장번호를 입력해주세요.</p>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="delivery-company">택배사</label>
                        <select id="delivery-company" v-model="deliveryCompany">
                            <option value="">택배사 선택</option>
                            <option value="CJ대한통운">CJ대한통운</option>
                            <option value="우체국택배">우체국택배</option>
                            <option value="로젠택배">로젠택배</option>
                            <option value="한진택배">한진택배</option>
                            <option value="롯데택배">롯데택배</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tracking-number">송장번호</label>
                        <input 
                            type="text" 
                            id="tracking-number" 
                            placeholder="송장번호 입력"
                            v-model="trackingNumber"
                        >
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn" @click="closeDeliveryModal">취소</button>
                    <button class="btn btn-primary" @click="submitDelivery">등록</button>
                </div>
            </div>
        </div>
        <!-- Order Detail Modal -->
        <div v-if="detailModalOpen" class="modal-overlay" @click.self="closeDetailModal">
            <div class="modal-content large">
                <!-- 로딩 표시 -->
                <div v-if="!selectedOrder" class="modal-loading">
                    <p>상세 정보를 불러오는 중입니다...</p>
                </div>
                <!-- 상세 정보 표시 (데이터가 로드된 후) -->
                <template v-else>
                    <div class="modal-header">
                        <h2 class="modal-title">주문 상세 정보</h2>
                        <p class="modal-description">주문번호: {{ selectedOrder.orderNo }}</p>
                    </div>
                    <div class="modal-body">
                        <!-- 주문 정보 -->
                        <div class="detail-section">
                            <h3>📦 주문 정보</h3>
                            <div class="detail-box">
                                <div class="detail-row">
                                    <span class="detail-label">주문번호</span>
                                    <span class="detail-value">{{ selectedOrder.orderNo }}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">주문일시</span>
                                    <span class="detail-value">{{ selectedOrder.orderDate }}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">주문상태</span>
                                    <span :class="getStatusBadgeClass(selectedOrder.status)">
                                        {{ selectedOrder.status }}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- 주문 상품 (v-for로 목록 표시) -->
                        <div class="detail-section">
                            <h3>주문 상품</h3>
                            <div v-for="item in selectedOrder.items" :key="item.orderItemNo" class="product-card">
                                <div class="product-main-info"> 
                                    <div class="product-image">
                                        <img :src="'${pageContext.request.contextPath}' + item.imageUrl" alt="상품 이미지" v-if= "item.imageUrl">
                                        <span v-else>📦</span>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-info-name">{{ item.productName }}</div>
                                        <div v-if="item.optionUnit" class="product-info-option">옵션: {{ item.optionUnit }} </div>
                                        <div class="product-info-quantity">수량: {{ item.quantity }}개</div>
                                        <div class="product-info-price">{{ item.price.toLocaleString() }}원</div>
                                    </div>
                                </div> 

                                <!-- 환불 요청 정보 및 처리 섹션 -->
                                <div v-if="item.refundStatus" class="refund-details">
                                    <div class="refund-info">
                                        <p><strong>환불 상태:</strong> <span class="badge badge-refund-request">{{ item.refundStatus }}</span></p>
                                        <p><strong>환불 요청 수량:</strong> {{ item.refundQuantity }}개</p>
                                        <p><strong>환불 금액:</strong> {{ (item.price / item.quantity * item.refundQuantity).toLocaleString() }}원</p>
                                        <p><strong>환불 사유:</strong> {{ item.refundReason }}</p>
                                    </div>
                                    <!-- '대기' 상태일 때만 승인/거절 버튼 표시 -->
                                    <div v-if="item.refundStatus === '대기'" class="refund-actions">
                                        <button class="btn btn-success btn-sm" @click="processRefund(item, '승인')">승인</button>
                                        <button class="btn btn-danger btn-sm" @click="processRefund(item, '거절')">거절</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 배송지 정보 (동적 데이터로 변경) -->
                        <div class="detail-section">
                            <h3>배송지 정보</h3>
                            <div class="detail-box">
                                <div class="detail-row">
                                    <span class="detail-label">수령인</span>
                                    <span class="detail-value">{{ selectedOrder.receivName }}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">연락처</span>
                                    <span class="detail-value">{{ selectedOrder.receivPhone }}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">주소</span>
                                    <span class="detail-value">{{ selectedOrder.deliverAddr }}</span>
                                </div>
                                <div class="detail-row" v-if="selectedOrder.memo">
                                    <span class="detail-label">배송메모</span>
                                    <span class="detail-value">{{ selectedOrder.memo }}</span>
                                </div>
                            </div>
                        </div>

                        <!-- 결제 정보 (동적 데이터로 변경) -->
                        <div class="detail-section">
                            <h3>결제 정보</h3>
                            <div class="detail-box">
                                <div class="detail-row">
                                    <span class="detail-label">총 주문 금액</span>
                                    <span class="detail-value">{{ (selectedOrder.totalPrice).toLocaleString()}}원</span>
                                </div>
                                <div v-if="getRefundedAmount(selectedOrder) > 0" class="detail-row text-danger">
                                    <span class="detail-label">- 환불된 금액</span>
                                    <span class="detail-value">{{ getRefundedAmount(selectedOrder).toLocaleString() }}원</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">배송비</span>
                                    <span class="detail-value">3,000원</span>
                                </div>
                                <div class="detail-row total">
                                    <span class="detail-label">최종 결제금액</span>
                                    <span class="detail-value">
                                        {{
                                            (selectedOrder.totalPrice - getRefundedAmount(selectedOrder)
                                            + (selectedOrder.totalPrice - getRefundedAmount(selectedOrder) > 0 ? 3000 : 0))
                                            .toLocaleString()
                                        }}원
                                    </span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">결제수단</span>
                                    <span class="detail-value">{{ selectedOrder.paymentMethod || '정보 없음' }}</span>
                                </div>
                            </div>
                        </div>
                        <!-- 배송 정보 섹션 -->
                        <div v-if="selectedOrder.courier" class="detail-section">
                            <h3>🚚 배송 정보</h3>
                            <div class="detail-box">
                                <div class="detail-row">
                                    <span class="detail-label">택배사</span>
                                    <span class="detail-value">{{ selectedOrder.courier }}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">송장번호</span>
                                    <span class="detail-value tracking-number-value">{{ selectedOrder.trackingNo}}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>    
                    <div class="modal-footer">
                        <button class="btn btn-primary" @click="closeDetailModal">닫기</button>
                    </div>
                </template>
            </div>
        </div>
    </div>
    
    <!-- 공통 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                orders: [],
                deliveryModalOpen: false,
                detailModalOpen: false,
                selectedOrder: null,
                deliveryCompany: "",
                trackingNumber: "",

                // 필터 데이터
                selectedStatus: "전체",
                searchQuery: "",
                startDate: "",
                endDate: "",

                // 페이징 데이터
                currentPage: 1,
                itemsPerPage: 10, 
                totalCount: 0,

                // 검색 지연을 위한 변수
                searchTimeout: null,

                // 일괄 처리용 데이터
                selectedOrders: [],
                bulkActionStatus: ""
            };
        },
        computed: {
            totalPages() {
                let self = this;
                return Math.ceil(self.totalCount / self.itemsPerPage);
            },
            pageNumbers() {
                let self = this;
                const maxPagesToShow = 5;
                const half = Math.floor(maxPagesToShow / 2);
                let start = Math.max(1, this.currentPage - half);
                let end = Math.min(self.totalPages, self.currentPage + half);

                if (self.currentPage - half < 1) {
                    end = Math.min(self.totalPages, maxPagesToShow);
                }
                if (self.currentPage + half > self.totalPages) {
                    start = Math.max(1, self.totalPages - maxPagesToShow + 1);
                }

                const pages = [];
                for (let i = start; i <= end; i++) {
                    pages.push(i);
                }
                return pages;
            },
            isAllSelected() {
                let self = this;
                return self.orders.length > 0 && self.selectedOrders.length === self.orders.length;
            },        
        },
        watch: {
            selectedStatus() { this.applyFilter(); },
            startDate() { this.applyFilter(); },
            endDate() { this.applyFilter(); },
            searchQuery() {
                clearTimeout(this.searchTimeout);
                this.searchTimeout = setTimeout(() => {
                    this.applyFilter();
                }, 500); 
            }
        },
        methods: {
            processRefund(item, newStatus) {
                const actionText = newStatus === '승인' ? '승인' : '거절';
                if (!confirm('"' + item.productName + '" 상품의 환불 요청을 ' + actionText + '하시겠습니까?')) {
                    return;
                }

                const self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/refund/process.dox", 
                    type: "POST",
                    dataType: "json",
                    data: {
                        orderItemNo: item.orderItemNo,
                        status: newStatus // '승인' 또는 '거절'
                    },
                    success: function(response) {
                        if (response.result === 'success') {
                            alert('환불 요청이 ' + actionText + ' 처리되었습니다.');
                            self.openDetailModal(self.selectedOrder);
                        } else {
                            alert(response.message || '환불 처리 중 오류가 발생했습니다.');
                        }
                    },
                    error: function() {
                        alert('서버와 통신 중 오류가 발생했습니다.');
                    }
                });
            },
            applyFilter() {
                let self = this;
                self.currentPage = 1;
                self.fnLoadOrders();
            },
            toggleSelectAll(event) {
                let self = this;
                if (event.target.checked) {
                    self.selectedOrders = self.orders.map(order => order.orderNo);
                } else {
                    self.selectedOrders = [];
                }
            },
            applyBulkAction() {
                let self = this;
                if (!self.bulkActionStatus) {
                    alert("일괄 변경할 상태를 선택해주세요.");
                    return;
                }
                if (self.selectedOrders.length === 0) {
                    alert("선택된 주문이 없습니다.");
                    return;
                }

                if (!confirm(self.selectedOrders.length + "개의 주문 상태를 '" + self.bulkActionStatus + "'(으)로 변경하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/order/bulkUpdateStatus.dox",
                    type: "POST",
                    dataType: "json",            
                    data: {
                        "orderNoList[]": self.selectedOrders,
                        "status": self.bulkActionStatus
                    },
                    traditional: true,
                    success: function(data) {
                        if (data.result === "success") {
                            alert(data.message || "주문 상태가 성공적으로 변경되었습니다.");
                            self.selectedOrders = [];
                            self.fnLoadOrders(); 
                        } else {
                            alert("오류: " + data.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("서버와 통신 중 오류가 발생했습니다.");
                    }
                });
            },
             getValidStatusOptions(currentStatus) {
                const statusMap = {
                    "결제완료": ["배송 준비중", "취소/반품"],
                    "신규 주문": ["배송 준비중", "취소/반품"],
                    "배송 준비중": ["배송중", "취소/반품"],
                    "배송중": ["배송 완료"],
                    "배송 완료": ["배송중"],    
                    "취소/반품": ["배송 준비중"]
                };

                return statusMap[currentStatus] || [];
            },
            getStatusBadgeClass(status) {
                const classes = {
                    "신규 주문": "badge badge-new",
                    "결제완료": "badge badge-new", 
                    "배송 준비중": "badge badge-preparing",
                    "배송중": "badge badge-shipping",
                    "배송 완료": "badge badge-completed",
                    "취소/반품": "badge badge-cancelled"
                };
                return classes[status] || "badge";
            },
             handleStatusChange(orderNo, newStatus) {
                let self = this;
                const order = self.orders.find(o => o.orderNo === orderNo);
                const currentStatus = order ? order.status : '';

                if ((currentStatus === '배송 준비중' || currentStatus === '결제완료' || currentStatus === '신규 주문') &&
            newStatus === '배송중') {
                    if (order) {
                        self.selectedOrder = order;
                        self.deliveryModalOpen = true;
                    }
                } else {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/order/updateStatus.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            orderNo: orderNo,
                            status: newStatus
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.fnLoadOrders(); 
                                alert("주문 상태가 업데이트되었습니다.");
                            } else {
                                alert(data.message || '주문 상태 업데이트에 실패했습니다.');
                            }
                        },
                        error: function(xhr, status, error) {
                            alert('서버와 통신 중 오류가 발생했습니다. ' + error);
                        }
                    });
                }
            },
            getRefundStatusBadgeClass(status) {
                const classes = {
                    '대기': 'badge badge-refund-request',
                    '승인': 'badge badge-success', 
                    '거절': 'badge badge-danger' 
                };
                return classes[status] || 'badge';
            },
            openDeliveryModal(order) {
                this.selectedOrder = order;
                this.deliveryModalOpen = true;
            },
            closeDeliveryModal() {
                let self = this;
                self.deliveryModalOpen = false;
                self.deliveryCompany = "";
                self.trackingNumber = "";
                self.selectedOrder = null;
            },
            submitDelivery() {
                let self = this;
                if (self.selectedOrder && self.deliveryCompany && self.trackingNumber) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/order/registerDelivery.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            orderNo: self.selectedOrder.orderNo,
                            deliveryCompany: self.deliveryCompany,
                            trackingNumber: self.trackingNumber
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.closeDeliveryModal();
                                alert("배송 정보가 등록되고 주문 상태가 '배송중'으로 변경되었습니다.");
                                self.fnLoadOrders(); 
                            } else {
                                alert(data.message || '배송 정보 등록에 실패했습니다.');
                            }
                        },
                        error: function(xhr, status, error) {
                            alert('서버와 통신 중 오류가 발생했습니다. ' + error);
                        }
                    });
                } else {
                    alert("택배사와 송장번호를 모두 입력해주세요.");
                }
            },
            openDetailModal(order) { 
                let self = this;
                self.selectedOrder = null; 
                self.detailModalOpen = true; 

                $.ajax({
                    url: "${pageContext.request.contextPath}/order/detail.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        orderNo: order.orderNo
                    },
                    success: function(data) {
                        if (data.result === "success" && data.order) {
                            self.selectedOrder = data.order;
                        } else {
                            alert("주문 상세 정보를 불러오는데 실패했습니다.");
                            self.detailModalOpen = false; 
                        }
                    },
                    error: function() {
                        alert("서버와 통신 중 오류가 발생했습니다.");
                        self.detailModalOpen = false;
                    }
                });
            },
            closeDetailModal() {
                this.detailModalOpen = false;
                this.selectedOrder = null;
            },
            fnLoadOrders() {
                let self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/order/sellerList.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        currentPage: self.currentPage,
                        itemsPerPage: self.itemsPerPage,
                        status: self.selectedStatus,
                        startDate: self.startDate,
                        endDate: self.endDate,
                        searchKeyword: self.searchQuery
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.orders = data.list;
                            self.totalCount = data.totalCount;
                        } else {
                            alert(data.message || '주문 목록을 불러오는데 실패했습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('서버와 통신 중 오류가 발생했습니다. ' + error);
                    }
                });
            },
            goToPage(page) {
                let self = this;
                if (page >= 1 && page <= self.totalPages) {
                    self.currentPage = page;
                    self.fnLoadOrders();
                }
            },
            prevPage() {
                this.goToPage(this.currentPage - 1);
            },
            nextPage() {
                this.goToPage(this.currentPage + 1);
            },
            getRefundedAmount(order) {
                if (!order || !order.items) {
                    return 0;
                }

                return order.items.reduce((total, item) => {
                    if (item.refundStatus === '승인') {
                        // (상품 단가) * (환불 수량)
                        const unitPrice = item.price / item.quantity;
                        const refundValue = unitPrice * item.refundQuantity;
                        return total + refundValue;
                    }
                    return total;
                }, 0);
            },
            getOrderOverallRefundStatus(order) {
                if (!order || order.totalItemCount === undefined) { // totalItemCount가 없으면 아직 데이터가 안 넘어온 것
                    return null;
                }

                const totalItems = order.totalItemCount;
                const pendingRefundItems = order.pendingRefundItemCount;
                const processedRefundItems = order.processedRefundItemCount;

                if (pendingRefundItems > 0) { 
                    return '대기'; 
                } else if (processedRefundItems > 0 && processedRefundItems === totalItems) {          
                    return '전체 환불 완료'; 
                } else if (processedRefundItems > 0 && processedRefundItems < totalItems) {           
                    return '부분 환불 완료'; 
                } else {
                    return null; 
                }
            },
        },
        mounted() {
            let self = this;
            self.fnLoadOrders();
        }
    });

    app.mount('#app');
</script>