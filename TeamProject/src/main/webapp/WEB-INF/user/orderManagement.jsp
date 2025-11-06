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
            max-width: 700px;
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
            gap: 1rem;
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

                <!-- Orders Table -->
                <div class="table-section">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
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
                                <tr v-for="order in filteredOrders" :key="order.orderNo">
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
                                        <span :class="getStatusBadgeClass(order.status)">
                                            {{ order.status }}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-controls">
                                            <select 
                                                class="status-select" 
                                                :value="order.status"
                                                @change="handleStatusChange(order.orderNo, $event.target.value)"
                                            >
                                                <option value="신규 주문">신규 주문</option>
                                                <option value="배송 준비중">배송 준비중</option>
                                                <option value="배송중">배송중</option>
                                                <option value="배송 완료">배송 완료</option>
                                                <option value="취소/반품">취소/반품</option>
                                            </select>
                                            <button 
                                                v-if="order.status === '배송 준비중'" 
                                                class="btn"
                                                @click="openDeliveryModal(order)"
                                            >
                                                🚚 배송등록
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Empty State -->
                    <div v-if="filteredOrders.length === 0" class="empty-state">
                        <div class="empty-icon">📦</div>
                        <p>주문 내역이 없습니다.</p>
                    </div>
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
                <div class="modal-header">
                    <h2 class="modal-title">주문 상세 정보</h2>
                    <p class="modal-description">주문번호: {{ selectedOrder.orderNo }}</p>
                </div>
                <div class="modal-body">
                    <!-- Order Info -->
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

                    <!-- Product Info -->
                    <div class="detail-section">
                        <h3>주문 상품</h3>
                        <div class="product-card">
                            <div class="product-image">📦</div>
                            <div class="product-info">
                                <div class="product-info-name">{{ selectedOrder.productName }}</div>
                                <div class="product-info-quantity">수량: 1개</div>
                                <div class="product-info-price">{{ selectedOrder.totalAmount.toLocaleString() }}원</div>
                            </div>
                        </div>
                    </div>

                    <!-- Delivery Address -->
                    <div class="detail-section">
                        <h3>배송지 정보</h3>
                        <div class="detail-box">
                            <div class="detail-row">
                                <span class="detail-label">수령인</span>
                                <span class="detail-value">{{ selectedOrder.buyerName }}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">연락처</span>
                                <span class="detail-value">010-1234-5678</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">주소</span>
                                <span class="detail-value">서울시 강남구 테헤란로 123</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">배송메모</span>
                                <span class="detail-value">문 앞에 놓아주세요</span>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Info -->
                    <div class="detail-section">
                        <h3>결제 정보</h3>
                        <div class="detail-box">
                            <div class="detail-row">
                                <span class="detail-label">상품금액</span>
                                <span class="detail-value">{{ (selectedOrder.totalAmount - 3000).toLocaleString() }}원</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">배송비</span>
                                <span class="detail-value">3,000원</span>
                            </div>
                            <div class="detail-row total">
                                <span class="detail-label">최종 결제금액</span>
                                <span class="detail-value">{{ selectedOrder.totalAmount.toLocaleString() }}원</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">결제수단</span>
                                <span class="detail-value">신용카드</span>
                            </div>
                        </div>
                    </div>

                    <!-- Delivery Info -->
                    <div v-if="selectedOrder.deliveryCompany" class="detail-section">
                        <h3>🚚 배송 정보</h3>
                        <div class="detail-box">
                            <div class="detail-row">
                                <span class="detail-label">택배사</span>
                                <span class="detail-value">{{ selectedOrder.deliveryCompany }}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">송장번호</span>
                                <span class="detail-value" style="font-family: monospace;">{{ selectedOrder.trackingNumber }}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" @click="closeDetailModal">닫기</button>
                </div>
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
                selectedStatus: "전체",
                searchQuery: "",
                startDate: "",
                endDate: "",
                deliveryModalOpen: false,
                detailModalOpen: false,
                selectedOrder: null,
                deliveryCompany: "",
                trackingNumber: "",
                orders: []
            };
        },
        computed: {
            filteredOrders() {
                let self = this;
                const filteredByDate = self.orders.filter(order => {
                const orderDate = new Date(order.orderDate);
                const start = self.startDate ? new Date(self.startDate) : null;
                const end = self.endDate ? new Date(self.endDate) : null;

                if (start && orderDate < start) return false;
                if (end && orderDate > end) return false;
                return true;
                });

                return filteredByDate.filter(order => {
                    const matchesStatus = self.selectedStatus === "전체" || order.status === self.selectedStatus;
                    const matchesSearch =
                        String(order.orderNo).toLowerCase().includes(self.searchQuery.toLowerCase()) ||
                        order.buyerName.toLowerCase().includes(self.searchQuery.toLowerCase()) ||
                        order.productName.toLowerCase().includes(self.searchQuery.toLowerCase());
                    return matchesStatus && matchesSearch;
                });
            }
        },
        methods: {
            getStatusBadgeClass(status) {
                const classes = {
                    "신규 주문": "badge badge-new",
                    "배송 준비중": "badge badge-preparing",
                    "배송중": "badge badge-shipping",
                    "배송 완료": "badge badge-completed",
                    "취소/반품": "badge badge-cancelled"
                };
                return classes[status] || "badge";
            },
            handleStatusChange(orderNo, newStatus) {
                if (newStatus === "배송중") {
                    const order = this.orders.find(o => o.orderNo === orderNo);
                    if (order) {
                        this.selectedOrder = order;
                        this.deliveryModalOpen = true;
                    }
                } else {
                    this.orders = this.orders.map(o => 
                        o.orderNo === orderNo ? { ...o, status: newStatus } : o
                    );
                }
            },
            openDeliveryModal(order) {
                this.selectedOrder = order;
                this.deliveryModalOpen = true;
            },
            closeDeliveryModal() {
                this.deliveryModalOpen = false;
                this.deliveryCompany = "";
                this.trackingNumber = "";
                this.selectedOrder = null;
            },
            submitDelivery() {
                if (this.selectedOrder && this.deliveryCompany && this.trackingNumber) {
                    this.orders = this.orders.map(o =>
                        o.orderNo === this.selectedOrder.orderNo
                            ? { ...o, status: "배송중", deliveryCompany: this.deliveryCompany, trackingNumber: this.trackingNumber }
                            : o
                    );
                    this.closeDeliveryModal();
                    alert("배송 정보가 등록되었습니다.");
                } else {
                    alert("택배사와 송장번호를 모두 입력해주세요.");
                }
            },
            openDetailModal(order) {
                this.selectedOrder = order;
                this.detailModalOpen = true;
            },
            closeDetailModal() {
                this.detailModalOpen = false;
                this.selectedOrder = null;
            },
            fnLoadOrders() {
                console.log("fnLoadOrders 함수 호출됨. API 요청 시작.");
                let self = this;
                    
                let param = {};
                $.ajax({
                    url: "${pageContext.request.contextPath}/order/sellerList.dox",
                    dataType: "json",
                    type: "POST", 
                    data: param, 
                        success: function (data) {
                            if (data.result === "success") {
                                console.log("성공적으로 조회했으나, 주문 목록이 비어있습니다.");
                                self.orders = data.list; 
                            } else {
                                alert(data.message || '주문 목록을 불러오는데 실패했습니다.');
                            }
                        },
                        error: function(xhr, status, error) {
                            alert('서버와 통신 중 오류가 발생했습니다. ' + error);
                            console.error("AJAX Error: ", status, error, xhr);
                        }
                });
            }
        },
        mounted() {
            console.log("Vue app mounted! 스크립트 시작됨.");
            let self = this;
            self.fnLoadOrders();
        }
    });

    app.mount('#app');
</script>