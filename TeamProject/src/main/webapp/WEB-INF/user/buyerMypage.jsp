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

                .card {
                    background-color: white;
                    border-radius: 8px;
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

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
                .cart-item-image img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    border-radius: 8px;
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

                .badge {
                    display: inline-block;
                    padding: 0.25rem 0.75rem;
                    background-color: #22c55e;
                    color: white;
                    border-radius: 9999px;
                    font-size: 0.75rem;
                    font-weight: 500;
                }

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

                .profile-form {
                    max-width: 672px;
                    margin: 0 auto;
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
                    border-radius: 0.5rem;
                    padding: 1.5rem;
                }

                .danger-zone-desc {
                    color: #991b1b;
                    margin-bottom: 1rem;
                }

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

             
                .cart-item-image {
                    width: 80px;
                    height: 80px;
                    background-color: #f3f4f6;
                    border-radius: 8px;
                    flex-shrink: 0;
                }
   
                .cart-link {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    flex: 1;
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

                .quantity-control {
                    margin-left: 1rem;
                }

                .cart-item .btn-danger {
                    margin-left: .5rem;
                }

                .bulk-actions {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin: .75rem 0 1rem;
                }

                .bulk-actions .toggle-all {
                    display: flex;
                    align-items: center;
                    gap: .5rem;
                    font-size: .9rem;
                    color: #374151;
                }

                .bulk-actions-right {
                    display: flex;
                    gap: .5rem;
                }

                .btn[disabled] {
                    opacity: .5;
                    cursor: not-allowed;
                }

                @media (max-width: 480px) {
                    .cart-item {
                        flex-wrap: wrap;
                    }

                    .quantity-control,
                    .cart-item .btn-danger {
                        margin-top: .5rem;
                    }
                }
                .order-details-section {
                    padding: 15px;
                    background-color: #f9f9f9;
                    border-top: 1px solid #eee;
                    margin-top: 10px;
                    border-radius: 0 0 8px 8px;
                }

                .order-details-section .detail-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 5px 0;
                    font-size: 0.9em;
                }

                .order-details-section .detail-row span:first-child {
                    font-weight: bold;
                    color: #555;
                }

                .order-details-section .total-price {
                    font-size: 1.1em;
                    font-weight: bold;
                    color: #333;
                    border-top: 1px dashed #ddd;
                    padding-top: 10px;
                    margin-top: 10px;
                }
                .modal-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5); 
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    z-index: 1000; 
                }

                .modal-content {
                    background-color: #fff;
                    padding: 25px;
                    border-radius: 10px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    width: 90%;
                    max-width: 500px;
                    position: relative;
                    box-sizing: border-box; 
                }

                .modal-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 15px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 10px;
                }

                .modal-header h3 {
                    margin: 0;
                    font-size: 1.4em;
                    color: #333;
                }

                .modal-header .close-button {
                    background: none;
                    border: none;
                    font-size: 2em;
                    cursor: pointer;
                    color: #999;
                }

                .modal-body {
                    margin-bottom: 20px;
                }

                .modal-body p {
                    font-size: 1em;
                    margin-bottom: 15px;
                    color: #333;
                }

                .modal-body label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: bold;
                    color: #555;
                }

                .modal-body textarea.form-input {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                    font-size: 1em;
                    resize: vertical;
                    box-sizing: border-box; 
                }
                .form-group {
                    margin-bottom: 15px;
                }
                .modal-footer {
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px; 
                    border-top: 1px solid #eee;
                    padding-top: 15px;
                }

                .modal-footer .btn {
                    padding: 8px 18px; 
                    font-size: 0.95em;
                }
                .item-option-info {
                    font-size: 0.9em;
                    color: #666;
                    background-color: #f5f5f5;
                    padding: 3px 8px;
                    border-radius: 4px;
                    display: inline-block;
                    margin-top: 5px;
                    margin-bottom: 5px;
                }
                .quantity-control {
                    display: flex;
                    align-items: center;
                    gap: 5px;
                }

                .quantity-control .quantity-btn {
                    width: 30px;
                    height: 30px;
                    border: 1px solid #ccc;
                    background-color: #f0f0f0;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 1.2em;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    padding: 0;
                }

                .quantity-control .quantity-btn:disabled {
                    background-color: #e0e0e0;
                    cursor: not-allowed;
                    color: #aaa;
                }

                .quantity-control .quantity-input {
                    width: 60px; 
                    text-align: center;
                    -moz-appearance: textfield; /
                }

                .quantity-control .quantity-input::-webkit-outer-spin-button,
                .quantity-control .quantity-input::-webkit-inner-spin-button {
                    -webkit-appearance: none;
                    margin: 0;
                }
                .refund-status-badge {
                    display: inline-block;
                    padding: 4px 8px;
                    margin-left: 10px;
                    border-radius: 5px;
                    font-size: 0.8em;
                    font-weight: bold;
                    color: #fff;
                    background-color: #ffc107; 
                    vertical-align: middle;
                }
                .refund-status-badge.approved { background-color: #28a745; } 
                .refund-status-badge.rejected { background-color: #dc3545; }
                .refund-action-group {
                    display: flex; 
                    align-items: center; 
                    gap: 8px; 
                }
                .refund-action-group .btn-secondary {
                    background-color: #6c757d; 
                    color: #fff;
                    border-color: #6c757d;
                }
                .badge-info {
                    background-color: #e0f7fa; 
                    color: #006064; 
                }
                .badge-shipping { 
                    background-color: #e9d5ff;
                    color: #6b21a8;
                }
                .badge-completed { 
                    background-color: #d1fae5;
                    color: #065f46;
                }
                
                .form-input:disabled {
                    background-color: #f3f4f6; 
                    cursor: not-allowed;
                    color: #6b7280;
                }

                .non-editable-text {
                    font-size: 0.8rem;
                    color: #6b7280; 
                    margin-top: 0.5rem;
                }
            </style>
        </head>

        <body>
            <div id="app" data-ctx="<c:out value='${pageContext.request.contextPath}'/>"
                data-user-id="<c:out value='${sessionId}'/>" data-active-tab="<c:out value='${param.activeTab}'/>">
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
                                <div class="bulk-actions" v-if="activeTab === 'cart' && cartItems.length">
                                    <label class="toggle-all">
                                        <input type="checkbox" v-model="allSelected" />
                                        전체선택
                                    </label>
                                </div>

                                <div class="card" v-for="item in cartItems" :key="item.cartNo">
                                    <div class="cart-item">
                                        <input type="checkbox" :value="item.cartNo" v-model="selectedIds">
                                        <a href="javascript:;" @click="fnBack(item.productNo)" class="cart-link">
                                            <div class="cart-item-image">
                                                <img :src="item.thumbPath" alt=""
                                                    style="width:100%;height:100%;object-fit:cover;border-radius:8px;">
                                            </div>
                                            <div class="cart-item-info">
                                                <h3>{{ item.pName }} {{ item.unit }}</h3>
                                                <p>수량: {{ item.quantity }}개</p>
                                                <p class="cart-item-price">
                                                    {{ Number(item.unitPrice || 0).toLocaleString() }}원
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
                                            <span>{{ shippingFeeC.toLocaleString() }}원</span>
                                        </div>
                                        <div class="summary-total">
                                            <span>총 결제금액</span>
                                            <span class="price">{{ finalPriceC.toLocaleString()}}원</span>
                                        </div>
                                        <button class="btn btn-primary btn-lg w-100 mt-1"
                                            @click="fnPurchase">구매하기</button>
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
                                            <span v-if="getOrderOverallRefundStatus(order) === '대기'"
                                                class="badge badge-warning">
                                                환불 요청
                                            </span>
                                            <span v-else-if="getOrderOverallRefundStatus(order) === '전체 환불 완료'"
                                                class="badge badge-danger">
                                                전체 환불 완료
                                            </span>
                                            <span v-else-if="getOrderOverallRefundStatus(order) === '부분 환불 완료'"
                                                class="badge badge-info">
                                                부분 환불 완료
                                            </span>
                                            <!-- 환불 관련 상태가 없을 경우에만 기존 주문 상태 표시 -->
                                            <span v-else :class="getStatusClass(order.status)">
                                                {{ order.status }}
                                            </span>
                                            <!-- 배송조회 버튼은 별도로 유지 -->
                                            <button class="btn btn-outline-info btn-sm" @click="trackDelivery(order)" v-if="order.courier && order.trackingNo &&
                                        getOrderOverallRefundStatus(order) !== '전체 환불 완료'">배송조회</button>
                                            <button class="btn btn-outline-secondary btn-sm" @click="toggleDetails(order)">
                                                {{ order.isDetailsVisible ? '상세보기 닫기' : '상세보기' }}
                                            </button>
                                        </div>
                                    </div>
                                    <div class="cart-item order-item-divider" v-for="item in order.items"
                                        :key="item.orderItemNo">
                                         <div class="cart-item-image">
                                            <img :src="item.imageUrl" alt="상품 이미지">
                                        </div>         

                                         <div class="cart-item-info">
                                            <h3>{{ item.productName }}</h3>
                                            <p class="item-option-info" v-if="item.optionUnit">
                                                옵션: {{ item.optionUnit }}
                                                <span v-if="item.optionAddPrice > 0">
                                                    (+{{ Number(item.optionAddPrice).toLocaleString() }}원)
                                                </span>
                                            </p>
                                            <!-- 수량 표시 조정 -->
                                            <p v-if="item.refundStatus === '승인'">
                                                수량: {{ item.quantity - item.refundQuantity }}개
                                                <span class="text-muted">(원래 {{ item.quantity }}개, {{ item.refundQuantity }}개 환불)</span>
                                            </p>
                                            <p v-else>수량: {{ item.quantity }}개</p>

                                            <!-- 가격 표시 조정 -->
                                            <p v-if="item.refundStatus === '승인'" class="cart-item-price">
                                                {{ (Number(item.price || 0) - (item.price / item.quantity * item.refundQuantity)).toLocaleString() }}원
                                                <span class="text-muted">(원래 {{ Number(item.price || 0).toLocaleString() }}원)</span>
                                            </p>
                                            <p v-else class="cart-item-price">
                                                {{ Number(item.price || 0).toLocaleString() }}원
                                            </p>
                                        </div>
                                        <!-- 버튼 영역: v-if/v-else로 상태에 따라 분기 -->
                                        <div class="order-actions">
                                            <!-- 환불 요청이 있을 경우 -->
                                            <div v-if="item.refundStatus" class="refund-action-group">
                                                <span class="refund-status-badge">
                                                    {{ item.refundStatus === '대기' ? '환불 요청됨' : item.refundStatus }}
                                                </span>
                                                <!-- '대기' 상태일 때만 환불 취소 버튼 표시 -->
                                                <button class="btn btn-secondary btn-sm"
                                                        @click="cancelRefund(item)"
                                                        v-if="item.refundStatus === '대기'">환불 취소</button>
                                            </div>
                                            <!-- 환불 요청이 없을 경우 -->
                                            <div v-else>
                                                <button class="btn btn-outline-success btn-sm"
                                                    @click="fnWriteReview(item.productNo, item.orderItemNo)"
                                                    v-if="order.status === '배송 완료' && item.hasReview === 0">리뷰작성</button>
                                                <button class="btn btn-outline btn-sm text-danger"
                                                    @click="openRefundModal(item)"
                                                    v-if="order.status === '결제완료' || order.status === '배송준비중'">환불신청</button>
                                            </div>
                                        </div>                              
                                    </div>
                                    <div class="order-details-section" v-if="order.isDetailsVisible">
                                        <hr>
                                        <div class="detail-row">
                                            <span>받는 사람:</span>
                                            <span>{{ order.receivName }}</span>
                                        </div>
                                        <div class="detail-row">
                                            <span>연락처:</span>
                                            <span>{{ order.receivPhone }}</span>
                                        </div>
                                        <div class="detail-row">
                                            <span>배송지:</span>
                                            <span>{{ order.deliverAddr }}</span>
                                        </div>
                                        <div class="detail-row" v-if="order.memo">
                                            <span>배송 요청사항:</span>
                                            <span>{{ order.memo }}</span>
                                        </div>
                                        <div class="detail-row">
                                            <span>총 주문 금액</span>
                                            <span>{{ Number(order.totalPrice || 0).toLocaleString() }}원</span>
                                        </div>
                                        <div v-if="getRefundedAmount(order) > 0" class="detail-row text-danger">
                                            <span>- 환불된 금액</span>
                                            <span>{{ getRefundedAmount(order).toLocaleString() }}원</span>
                                        </div>
                                        <div class="detail-row total-price">
                                            <span>최종 결제 금액</span>
                                            <span>{{ (Number(order.totalPrice || 0) - getRefundedAmount(order)).toLocaleString() }}원</span>
                                        </div>
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
                                            <img :src="review.imageUrl" alt="상품 이미지" class="cart-item-image"
                                                v-if="review.imageUrl">
                                            <div class="cart-item-image" v-else></div>

                                            <div class="review-content">
                                                <div class="review-header">
                                                    <h3>{{ review.productName }}</h3>
                                                    <div class="stars">
                                                        <span v-for="n in 5" :key="n">{{ n <= review.rating ? '★' : '☆'
                                                                }}</span>
                                                    </div>
                                                </div>
                                                <p class="review-date">{{ review.cdate }}</p>
                                                <p class="review-text">{{ review.content }}</p>
                                            </div>
                                            <div class="order-actions">
                                                <button class="btn btn-outline btn-sm"
                                                    @click="fnUpdateReview(review.reviewNo)">수정</button>
                                                <button class="btn btn-outline btn-sm text-danger"
                                                    @click="fnDeleteReview(review.reviewNo)">삭제</button>
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
                                        <input type="text" class="form-input readonly-input" v-model="profile.name" disabled>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">이메일</label>
                                        <input type="email" class="form-input" v-model="profile.email" :disabled="userRole === 'SELLER'">
                                        <p v-if="userRole === 'SELLER'" class="non-editable-text">
                                            판매자 계정은 이메일을 변경할 수 없습니다.
                                        </p>
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
                    <div class="modal-overlay" v-if="isRefundModalVisible" @click.self="closeRefundModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>환불 신청</h3>
                                <button class="close-button" @click="closeRefundModal">&times;</button>
                            </div>
                            <div class="modal-body">
                                <p><strong>상품명:</strong> {{ refundRequest.productName }}</p>

                                <div class="form-group">
                                    <label for="refundQuantity">환불 수량:</label>
                                    <div class="quantity-control">
                                        <button class="quantity-btn" @click="changeRefundQuantity(-1)" :disabled= "refundRequest.quantity <= 1">-</button>
                                        <input type="number" id="refundQuantity" class="form-input quantity-input"
                                            v-model.number="refundRequest.quantity"
                                            min="1" :max="refundRequest.maxQuantity"
                                            @change="validateRefundQuantity">
                                        <button class="quantity-btn" @click="changeRefundQuantity(1)" :disabled= "refundRequest.quantity >= refundRequest.maxQuantity">+</button>
                                    </div>
                                    <small class="text-muted">최대 {{ refundRequest.maxQuantity }}개까지 환불 가능합니다.</small>
                                </div>
                                <div class="form-group">
                                    <label for="refundReason">환불 사유:</label>
                                    <textarea id="refundReason" class="form-input" v-model="refundRequest.reason"
                                            placeholder="환불 사유를 상세히 입력해 주세요." rows="5"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-primary" @click="submitRefundRequest">요청 제출</button>
                                <button class="btn btn-outline" @click="closeRefundModal">취소</button>
                            </div>
                        </div>
                    </div>

                    <!-- 공통 푸터 -->
                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>

        </body>

        </html>

        <script>
            function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
            }

            const root = document.getElementById('app');
            const zap = s => (s || '').replace(/[\u200B-\u200D\uFEFF]/g, '');

            const CTX = zap(root?.dataset?.ctx);
            const USER = zap(root?.dataset?.userId);
            const TAB = zap(root?.dataset?.activeTab) || 'cart';

            const app = Vue.createApp({
                data() {
                    return {
                        userId: root?.dataset?.userId || '',
                        activeTab: root?.dataset?.activeTab || 'cart',
                        userName: "",
                        userEmail: "",
                        cartItems: [],
                        orders: [],
                        reviews: [],
                        profile: {},
                        loginType: '',
                        userRole: '',
                        errors: {},
                        selectedIds: [],   
                        isRefundModalVisible: false,
                        refundRequest: {
                            orderItemNo: null,
                            productName: '',
                            reason: '',
                            quantity: 1,  
                            maxQuantity: 1

                        }

                    };
                },
                computed: {
                    pickedItems() {
                        return this.selectedIds.length
                            ? this.cartItems.filter(i => this.selectedIds.includes(i.cartNo))
                            : this.cartItems;
                    },
                    totalPrice() {
                        return this.pickedItems
                            .reduce((s, i) => s + Number(i.unitPrice || 0) * Number(i.quantity || 1), 0);
                    },
                    shippingFeeC() {
                        // 선택된 항목 기준으로 배송비 결정
                        const items = this.pickedItems;
                        if (!items.length) return 0;

                        // fulfillment 필드가 없다면 기본값 'delivery'
                        const hasDelivery = items.some(i => {
                            const f = String(i.fulfillment || i.FULFILLMENT || 'delivery').toLowerCase();
                            return f === 'delivery';
                        });

                        return hasDelivery ? 3000 : 0;
                    },
                    finalPriceC() {
                        return this.totalPrice + this.shippingFeeC;
                    },
                    allSelected: {
                        get() {
                            return this.cartItems.length > 0 && this.selectedIds.length === this.cartItems.length;
                        },
                        set(v) {
                            this.selectedIds = v ? this.cartItems.map(i => i.cartNo) : [];
                        }
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
                    cancelRefund(item) {
                        if (!confirm('"' + item.productName + '" 상품에 대한 환불 요청을 취소하시겠습니까?')) {
                            return;
                        }

                        const self = this;
                        $.ajax({
                            url: "${pageContext.request.contextPath}/refund/cancel.dox", 
                            type: "POST",
                            dataType: "json",
                            data: {
                                orderItemNo: item.orderItemNo
                            },
                            success: function(response) {
                                if (response.result === 'success') {
                                    alert('환불 요청이 취소되었습니다.');
                                    self.fnLoadOrders();
                                } else {
                                    alert(response.message || '환불 요청 취소에 실패했습니다.');
                                }
                            },
                            error: function() {
                                alert('서버와 통신 중 오류가 발생했습니다.');
                            }
                        });
                    },
                    changeRefundQuantity(diff) {
                        let self = this;
                        const current = self.refundRequest.quantity;
                        const next = current + diff;
                        if (next >= 1 && next <= self.refundRequest.maxQuantity) {
                            self.refundRequest.quantity = next;
                        }
                    },
                    validateRefundQuantity() {
                        let self = this;
                        let qty = self.refundRequest.quantity;
                        if (qty < 1) {
                            self.refundRequest.quantity = 1;
                        } else if (qty > self.refundRequest.maxQuantity) {
                            self.refundRequest.quantity = self.refundRequest.maxQuantity;
                        }
                        // Ensure it's an integer
                        self.refundRequest.quantity = Math.floor(self.refundRequest.quantity);
                    },
                    trackDelivery(order) {
                        if (!order.courier || !order.trackingNo) {
                            alert('배송 정보가 없습니다.');
                            return;
                        }

                        // 택배사별 조회 URL 맵
                        const courierUrls = {
                            'CJ대한통운': 'https://www.cjlogistics.com/ko/tool/parcel/tracking?gnbInvcNo=',
                            '우체국택배': 'https://service.epost.go.kr/trace.RetrieveDomRmgTrace.comm?sid1=',
                            '로젠택배': 'https://www.ilogen.com/web/personal/trace/',
                            '한진택배': 'https://www.hanjin.co.kr/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&wblnum=',
                            '롯데택배': 'https://www.lotteglogis.com/home/reservation/tracking/linkView?InvNo='
                        };

                        const baseUrl = courierUrls[order.courier];

                        if (!baseUrl) {
                            alert('지원하지 않는 택배사입니다: ' + order.courier);
                            return;
                        }

                        // 운송장 번호에서 숫자 외 문자 제거 (필요시)
                        const trackingNumber = order.trackingNo.replace(/[^0-9]/g, '');
                        const trackingUrl = baseUrl + trackingNumber;

                        // 새 창에서 배송조회 페이지 열기
                        window.open(trackingUrl, '_blank', 'noopener,noreferrer');
                    },
                    openRefundModal(item) {
                        let self = this;
                        self.refundRequest = {
                            orderItemNo: item.orderItemNo,
                            productName: item.productName,
                            reason: '',
                            quantity: 1, 
                            maxQuantity: item.quantity 
                        };
                        self.isRefundModalVisible = true;
                    },
                    closeRefundModal() {
                        const self = this;
                        self.isRefundModalVisible = false;
                    },
                    submitRefundRequest() {
                        const self = this;

                        if (!self.refundRequest.reason.trim()) {
                            alert('환불 사유를 입력해주세요.');
                            return;
                        }
                     
                        $.ajax({
                            url: "${pageContext.request.contextPath}/refund/request.dox", 
                            type: "POST",
                            dataType: "json",
                            data: {
                                orderItemNo: self.refundRequest.orderItemNo,
                                reason: self.refundRequest.reason,
                                refundAmount: self.refundRequest.quantity
                            },
                            success: function(response) {
                                if (response.result === 'success') {
                                    alert('환불 요청이 정상적으로 접수되었습니다.');
                                    self.closeRefundModal();
                                    self.fnLoadOrders();
                                } else {
                                    alert(response.message || '환불 요청 접수에 실패했습니다.');
                                }
                            },
                            error: function() {
                                alert('서버와 통신 중 오류가 발생했습니다.');
                            }
                        });
                    },
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

                    fnUserInfo() {
                        let self = this;
                        $.ajax({
                            url: CTX + "/userInfo.dox",
                            dataType: "json",
                            type: "GET",
                            success: function (data) {
                                if (data.status === 'error') {
                                    location.href = CTX + '/login.do';
                                    return;
                                }

                                self.profile = data;
                                self.loginType = data.loginType;
                                self.userRole = data.userRole;
                                self.profile.newPassword = ''; 
                                self.profile.confirmPassword = ''; 

                                self.userName = data.name;
                                self.userEmail = data.email;
                            },
                            error: function (xhr, status, error) {
                                alert("사용자 정보를 불러오는 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    fnPurchase() {
                        const cartNos = this.selectedIds.length
                            ? this.selectedIds
                            : this.cartItems.map(i => i.cartNo);

                        if (cartNos.length === 0) {
                            alert('구매할 상품을 선택하세요.');
                            return;
                        }

                        // 결제 페이지로 이동 (장바구니 다건 결제)
                        pageChange(CTX + '/product/payment.do', {
                            userId: this.userId,
                            cartNos: cartNos.join(',')   // payment.jsp에서 분해해서 /payment/list.dox 호출
                        });
                    },

                    fnBack: function (productNo) {
                        pageChange(CTX + '/productInfo.do', { productNo });
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
                        };

                        if (self.userRole !== 'SELLER') {
                            profileData.email = self.profile.email;
                        }

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
                        window.open(CTX + "/addr.do", "addr", "width=500, height=500");
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
                            url: CTX + "/cart/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                //console.log(data);
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
                            url: CTX + "/cart/qty.dox",
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
                            url: CTX + "/cart/remove.dox",
                            type: "POST",
                            dataType: "json",
                            data: { cartNo: item.cartNo, userId: this.userId },
                            success: (data) => {
                                if (data.result == 'success') {
                                    this.cartItems = this.cartItems.filter(x => x.cartNo !== item.cartNo);
                                    this.selectedIds = this.selectedIds.filter(id => id !== item.cartNo); // ✅ 선택에서도 제거
                                } else {
                                    alert('삭제 실패');
                                }
                            },
                            error: (xhr) => alert('서버오류: ' + xhr.status)
                        });
                    },

                    fnLoadOrders() {
                        let self = this;
                        $.ajax({
                            url: CTX + '/myPage/orders.dox',
                            dataType: "json",
                            type: "GET",
                            success: function (data) {
                                 if (data.result === "success") {
                                    self.orders = data.list.map(order => ({
                                        ...order,
                                        isDetailsVisible: false
                                    }));
                                } else {
                                    alert("주문 내역을 불러오는 데 실패했습니다: " + data.message);
                                }
                            },
                            error: function (xhr, status, error) {
                                alert("서버와의 통신 중 오류가 발생했습니다. 주문 내역을 불러올 수 없습니다.");
                                
                            }
                        });
                    },
                     toggleDetails(order) {
                        order.isDetailsVisible = !order.isDetailsVisible;
                    },
                    fnWriteReview(productNo, orderItemNo) {
                        //console.log("productNo:", productNo, "orderItemNo:", orderItemNo);

                        const url = CTX + "/reviewWrite.do?productNo=" + encodeURIComponent(productNo)
                            + "&orderItemNo=" + encodeURIComponent(orderItemNo);

                        //console.log("생성된 URL:", url);
                        location.href = url;
                    },
                    fnLoadReviews() {
                        let self = this;
                        $.ajax({
                            url: CTX + '/review/list.dox',
                            type: "GET",
                            dataType: "json",
                            success: function (response) {
                                if (response.result === "success") {
                                    self.reviews = response.list;
                                    //console.log("Loaded Reviews:", self.reviews);
                                } else {
                                    alert("리뷰 목록을 불러오는 데 실패했습니다.");
                                }
                            },
                            error: function () {
                                alert("리뷰 목록 조회 중 오류가 발생했습니다.");
                            }
                        });
                    },
                    fnUpdateReview(reviewNo) {
                        window.location.href = CTX + '/reviewUpdate.do?reviewNo=' + reviewNo;
                    },
                    fnDeleteReview(reviewNo) {
                        if (confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
                            const self = this;
                            $.ajax({
                                url: "${pageContext.request.contextPath}/review/delete.dox",
                                type: "POST",
                                data: { reviewNo: reviewNo },
                                dataType: "json",
                                success: function (response) {
                                    if (response.result === "success") {
                                        alert('리뷰가 삭제되었습니다.');
                                        self.fnLoadReviews();
                                    } else {
                                        alert('리뷰 삭제에 실패했습니다: ' + response.message);
                                    }
                                },
                                error: function () {
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
                    },

                    unitPrice(i) {
                        const hasUnit = i.unitPrice !== null && i.unitPrice !== undefined && !Number.isNaN(Number(i.unitPrice));
                        if (hasUnit) return Number(i.unitPrice);

                        const base = Number(i.basePrice || 0);
                        const add = Number(i.addPrice || 0);
                        const combo = base + add;
                        return combo > 0 ? combo : Number(i.price || 0);
                    },
                    getRefundedAmount(order) {
                        if (!order || !order.items) {
                            return 0;
                        }

                        return order.items.reduce((total, item) => {
                            if (item.refundStatus === '승인') {
                                const unitPrice = item.price / item.quantity;
                                const refundValue = unitPrice * item.refundQuantity;
                                return total + refundValue;
                            }
                            return total;
                        }, 0);
                    },
                    getOrderOverallRefundStatus(order) {
                        if (!order || order.totalItemCount === undefined) {
                            return null;
                        }

                        const totalItems = order.totalItemCount;
                        const pendingRefundItems = order.pendingRefundItemCount;
                        const processedRefundItems = order.processedRefundItemCount;

                        if (pendingRefundItems > 0) {
                            return '대기'; // 하나라도 대기 중인 환불이 있으면 '대기'
                        } else if (processedRefundItems > 0 && processedRefundItems === totalItems) {
                            return '전체 환불 완료'; // 모든 상품이 환불 처리됨 (승인 또는 거절)
                        } else if (processedRefundItems > 0 && processedRefundItems < totalItems) {
                            return '부분 환불 완료'; // 일부 상품만 환불 처리됨 (승인 또는 거절)
                        } else {
                            return null; // 환불 관련 없음
                        }
                    },
                    getStatusClass(status) {
                        const classes = {
                            "결제완료": "badge badge-new",
                            "배송 준비중": "badge badge-preparing",
                            "배송중": "badge badge-shipping",
                            "배송 완료": "badge badge-completed",
                            "취소/반품": "badge badge-cancelled"
                        };
                        return classes[status] || "badge";
                    },
    
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