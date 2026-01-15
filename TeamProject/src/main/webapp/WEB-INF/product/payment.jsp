<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>결제하기 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

            <link rel="stylesheet" href="${path}/resources/css/header.css">
            <link rel="stylesheet" href="${path}/resources/css/footer.css">

            <style>
                html,
                body {
                    background: #f6f6f6;
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main.content {
                    flex: 1;
                    width: 100%;
                    max-width: 1100px;
                    margin: 50px auto;
                    display: flex;
                    gap: 25px;
                }

                .left-section {
                    flex: 2;
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                }

                .right-section {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                }

                .box {
                    background: #fff;
                    border-radius: 8px;
                    padding: 25px 30px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                }

                .box h3 {
                    font-size: 18px;
                    font-weight: 700;
                    margin-bottom: 15px;
                    border-bottom: 2px solid #5dbb63;
                    padding-bottom: 6px;
                }

                .product-item {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 15px;
                }

                .product-item img {
                    width: 90px;
                    height: 90px;
                    object-fit: cover;
                    border-radius: 8px;
                    border: 1px solid #ddd;
                }

                .product-info {
                    flex: 1;
                }

                .product-name {
                    font-weight: 600;
                    margin-bottom: 6px;
                }

                .product-price {
                    color: #1a5d1a;
                    font-weight: 700;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                }

                .input-row {
                    display: flex;
                    gap: 8px;
                    margin-bottom: 10px;
                }

                input[type="text"],
                input[type="number"],
                select {
                    flex: 1;
                    padding: 8px 10px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                }

                .btn {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    border-radius: 6px;
                    padding: 8px 14px;
                    cursor: pointer;
                    font-size: 14px;
                    transition: 0.25s;
                }

                .btn:hover {
                    background: #4caf50;
                }

                .total-box {
                    text-align: right;
                    font-weight: 700;
                    font-size: 16px;
                    margin-top: 10px;
                }

                .btn-pay {
                    width: 100%;
                    background: #ff6a00;
                    border: none;
                    color: white;
                    border-radius: 8px;
                    font-size: 18px;
                    font-weight: 700;
                    padding: 14px 0;
                    cursor: pointer;
                    transition: 0.25s;
                }

                .btn-pay:hover {
                    background: #e75b00;
                }

                .payment-option {
                    margin-bottom: 8px;
                }

                .payment-option input {
                    margin-right: 6px;
                }

                .agree {
                    font-size: 13px;
                    color: #666;
                    margin-top: 10px;
                }

                .point-input {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .point-input input {
                    width: 150px;
                }

                .price-summary {
                    font-size: 16px;
                    line-height: 1.8;
                }

                .price-summary span {
                    float: right;
                    font-weight: 600;
                }
                /* 쿠폰 선택 영역 */
                .coupon-section {
                    margin-top: 10px;
                    padding-top: 10px;
                    border-top: 1px dashed #ddd;
                }

                /* 쿠폰 모달 마스크 */
                .modal-mask {
                    position: fixed;
                    z-index: 9998;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                /* 모달 컨테이너 */
                .modal-container {
                    width: 400px;
                    background: #fff;
                    border-radius: 12px;
                    padding: 20px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                }

                .modal-title {
                    margin-bottom: 20px;
                    border-bottom: 2px solid #5dbb63;
                    padding-bottom: 10px;
                    font-size: 18px;
                    font-weight: 700;
                }

                .modal-body {
                    max-height: 400px;
                    overflow-y: auto;
                }

                .modal-empty {
                    text-align: center;
                    padding: 40px 0;
                    color: #bbb;
                }

                /* 개별 쿠폰 항목 */
                .coupon-item {
                    border: 2px solid #f0f0f0;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 12px;
                    cursor: pointer;
                    transition: 0.2s;
                }

                .coupon-item:hover {
                    border-color: #5dbb63;
                    background: #f9fff9;
                }

                .coupon-name {
                    font-weight: 700;
                    font-size: 15px;
                    color: #333;
                }

                .coupon-benefit {
                    color: #5dbb63;
                    font-size: 18px;
                    font-weight: 800;
                    margin: 5px 0;
                }

                .coupon-condition {
                    font-size: 12px;
                    color: #999;
                }

                /* 유틸리티 */
                .btn-close {
                    background: #666 !important;
                    margin-top: 20px;
                    padding: 10px 0;
                    font-size: 16px;
                }

                .discount-text {
                    color: #ff4444;
                    font-weight: 700;
                    font-size: 14px;
                }

                .btn-cancel {
                    margin-left: 8px;
                    font-size: 12px;
                    color: #999;
                    text-decoration: underline;
                    cursor: pointer;
                }

                .readonly-input {
                    background: #f9f9f9 !important;
                    color: #333 !important;
                }

                .text-right {
                    margin-top: 5px;
                    text-align: right;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app" data-ctx="<c:out value='${pageContext.request.contextPath}'/>"
                    data-user-id="<c:out value='${sessionId}'/>" data-cart-nos="<c:out value='${param.cartNos}'/>"
                    data-product-no="<c:out value='${param.productNo}'/>" data-qty="<c:out value='${param.qty}'/>"
                    data-option-no="<c:out value='${param.optionNo}'/>"
                    data-fulfillment="<c:out value='${param.fulfillment}'/>" data-mode="<c:out value='${param.mode}'/>"
                    data-plan-id="<c:out value='${param.planId}'/>">

                    <main class="content">
                        <!-- 좌측 -->
                        <section class="left-section">
                            <!-- 상품 정보 -->
                            <div class="box">
                                <h3>주문 상품 정보</h3>
                                <div class="product-item" v-for="p in products" :key="p.productNo">
                                    <img :src="p.thumbPath" alt="상품이미지">
                                    <div class="product-info">
                                        <div class="product-name">{{ p.pName }}</div>
                                        <div>수량 : {{p.quantity}}개</div>
                                        <div class="product-price">{{ Number(p.unitPrice).toLocaleString() }}원</div>
                                    </div>
                                </div>
                                <div class="total-box">
                                    배송비 {{ shippingFeeC.toLocaleString() }}원 포함
                                </div>
                            </div>

                            <!-- 주문자 정보 -->
                            <div class="box">
                                <h3>주문자 정보</h3>
                                <div class="info-row"><span>{{ buyer.name }}</span><button class="btn"
                                        @click="editBuyer">수정</button></div>
                                <div>{{ buyer.phone }}</div>
                                <div>{{ buyer.email }}</div>
                            </div>

                            <!-- 배송 정보 -->
                            <div class="box">
                                <h3>배송 정보</h3>
                                <div class="input-row">
                                    <input type="text" v-model="buyer.name" placeholder="수령인">
                                    <input type="text" v-model="buyer.phone" placeholder="연락처">
                                </div>
                                <div class="input-row">
                                    <input type="text" v-model="shipping.zip" placeholder="우편번호">
                                    <button class="btn" @click="searchAddress">주소찾기</button>
                                </div>
                                <input type="text" v-model="buyer.address" placeholder="주소"
                                    style="width:100%; margin-bottom:8px;">
                                <input type="text" v-model="shipping.detail" placeholder="상세주소"
                                    style="width:100%; margin-bottom: 8px;">
                                <select v-model="requestValue" @change="updateRequestLabel"
                                    :class="{ 'select-placeholder': !requestValue }">
                                    <option v-if="!requestValue" hidden value="">배송 요청사항을 선택해주세요</option>
                                    <option v-for="opt in requestOptions" :key="opt.value" :value="opt.value">
                                        {{ opt.label }}
                                    </option>
                                </select>
                                <input v-if="requestValue==='direct'" type="text" v-model="requestDirect"
                                    placeholder="직접입력" />
                            </div>

                        </section>

                        <!-- 우측 -->
                        <section class="right-section">
                            <!-- 주문 요약 -->
                            <div class="box">
                                <h3>주문 요약</h3>
                                <div class="coupon-section">
                                    <label style="font-size:14px; font-weight:600; color:#666;">쿠폰 할인</label>
                                    <div class="input-row">
                                        <input type="text"
                                            :value="selectedCoupon ? selectedCoupon.COUPON_NAME : '적용 가능한 쿠폰을 확인하세요'"
                                            readonly
                                            class="readonly-input">
                                        <button type="button" class="btn" @click="fnShowCoupons">쿠폰조회</button>
                                    </div>
                                    <div v-if="selectedCoupon" class="text-right">
                                        <span class="discount-text">
                                            -{{ couponDiscountAmount.toLocaleString() }}원 할인 적용
                                        </span>
                                        <a class="btn-cancel" @click="fnCancelCoupon">취소</a>
                                    </div>
                                </div>
                                <div class="price-summary">
                                    상품금액 <span>{{ totalPrice.toLocaleString() }}원</span><br>
                                    배송비 <span>{{ shippingFeeC.toLocaleString() }}원</span><br>
                                    포인트 사용 <span>-{{ usedPoint.toLocaleString() }}원</span><br>
                                    <hr>
                                    총 결제금액 <span>{{ finalPrice.toLocaleString() }}원</span>
                                </div>
                            </div>

                            <!-- 약관 -->
                            <div class="box">
                                <h3>이용 및 정보 제공 약관</h3>
                                <label><input type="checkbox" v-model="agree"> 결제 진행 필수 동의</label>
                                <p class="agree">결제 진행을 위해 결제정보 제공 및 결제대행 서비스 약관에 동의합니다.</p>
                            </div>

                            <!-- 결제 버튼 -->
                            <button class="btn-pay" @click="fnPay">결제하기</button>
                            <button class="btn-pay" style="background-color: #666; margin-top: 10px;" @click="fnTestPay">테스트 결제 (알림확인용)</button>
                        </section>
                        <!-- 쿠폰 선택 모달 -->
                        <div v-if="showCouponModal" class="modal-mask" @click.self="showCouponModal = false">
                            <div class="modal-container">
                                <h3 class="modal-title">보유 쿠폰 목록</h3>

                                <div class="modal-body">
                                    <div v-if="couponList.length === 0" class="modal-empty">
                                        사용 가능한 쿠폰이 없습니다.
                                    </div>
                                    <div v-for="c in couponList" :key="c.UC_ID" class="coupon-item" @click="fnSelectCoupon(c)">
                                        <div class="coupon-name">
                                            {{ c.COUPON_NAME }}
                                        </div>
                                        <div class="coupon-benefit">
                                            {{ c.DISCOUNT_TYPE === 'FIXED' ? c.DISCOUNT_VALUE.toLocaleString() + '원' : c.DISCOUNT_VALUE + '%' }} 할인
                                        </div>
                                        <div class="coupon-condition">
                                            {{ Number(c.MIN_ORDER_PRICE).toLocaleString() }}원 이상 구매 시 사용 가능
                                            <br>유효기간: ~ {{ c.END_DATE }}
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn-pay btn-close" @click="showCouponModal = false">
                                    닫기
                                </button>
                            </div>
                        </div>   
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </body>

        </html>
        <script>
            const root = document.getElementById('app');

            const CTX = root?.dataset?.ctx || '';
            const USER = root?.dataset?.userId || '';

            const CART_CSV = (root?.dataset?.cartNos || '').trim();
            const SINGLE = {
                productNo: parseInt(root?.dataset?.productNo, 10) || null,
                qty: parseInt(root?.dataset?.qty, 10) || null,
                optionNo: (root?.dataset?.optionNo || null),
                fulfillment: (root?.dataset?.fulfillment || 'delivery').toLowerCase()
            };
            const IS_CART_MODE = !!CART_CSV;  // true면 장바구니, false면 단건
            const MODE = (root?.dataset?.mode || 'normal').toLowerCase();
            const SUB_PLAN_ID = parseInt(root?.dataset?.planId, 10) || null;
            const IS_SUBSCRIPTION_MODE = MODE === 'subscription';
            const qs = new URLSearchParams(location.search);
            const TEST_PAY = qs.get("test") === "1";  // ✅ test=1이면 1원 결제


            const app = Vue.createApp({
                data() {
                    return {
                        userId: USER,
                        mode: MODE,
                        subscriptionPlanId: SUB_PLAN_ID,

                        products: [],
                        buyer: {},
                        shipping: { recipient: "", phone: "", zip: "", address: "", detail: "" },
                        userPoint: 1000,
                        usedPoint: 0,
                        agree: false,
                        requestOptions: [
                            { value: 'door', label: '문 앞에 놔주세요' },
                            { value: 'guard', label: '경비실에 맡겨주세요' },
                            { value: 'box', label: '택배함에 넣어주세요' },
                            { value: 'call', label: '배송 전에 연락주세요' },
                            { value: 'direct', label: '직접입력' },
                        ],
                        requestValue: '',
                        requestLabel: '',
                        requestDirect: '',
                        // 쿠폰 관련
                        showCouponModal: false,
                        couponList: [],
                        selectedCoupon: null,

                        // 상세 진입 시에만 의미 있음
                        fulfillment: SINGLE.fulfillment,
                        shippingFeeFromDetail: 0
                    };
                },
                computed: {
                    // 쿠폰 할인 금액 계산기
                    couponDiscountAmount() {
                        if (!this.selectedCoupon) return 0;

                        const total = this.totalPrice; // 상품 합계 금액

                        // 최소 주문 금액 미달 시 할인 0원
                        if (total < Number(this.selectedCoupon.MIN_ORDER_PRICE)) return 0;

                        if (this.selectedCoupon.DISCOUNT_TYPE === 'FIXED') {
                            // 정액 할인 (예: 1,000원)
                            return Number(this.selectedCoupon.DISCOUNT_VALUE);
                        } else {
                            // 정률 할인 (예: 10%)
                            return Math.floor(total * (Number(this.selectedCoupon.DISCOUNT_VALUE) / 100));
                        }
                    },
                    totalPrice() {
                        return this.products.reduce((sum, p) => {
                            const unit = Number(p.unitPrice || p.price || 0);
                            const q = Number(p.quantity || 0);
                            return sum + unit * q;
                        }, 0);
                    },
                    // 단건 결제 - 상세에서 수령방법이 '택배'면 3,000, '방문'이면 0.
                    shippingFeeC() {
                        // 단건이면 첫 상품 기준 / 다건이면 some(delivery)
                        if (this.shippingFeeFromDetail > 0) return this.shippingFeeFromDetail;
                        const hasDelivery = this.products.some(p => (p.fulfillment || 'delivery') === 'delivery');
                        return hasDelivery ? 3000 : 0;
                    },
                    finalPrice() {
                        const sum = this.totalPrice + this.shippingFeeC - this.usedPoint - this.couponDiscountAmount;
                        return Math.max(0, sum); 
                    }
                },
                methods: {
                    // 쿠폰 목록 조회
                    fnShowCoupons() {
                        $.ajax({
                            url: "${path}/coupon/myList.dox",
                            type: "POST",
                            dataType: "json",
                            success: (res) => {
                                if (res.result === 'success') {
                                    this.couponList = res.list;
                                    this.showCouponModal = true;
                                } else {
                                    alert("쿠폰 정보를 불러오지 못했습니다.");
                                }
                            },
                            error: () => alert("서버 통신 오류")
                        });
                    },
                    // 쿠폰 선택 시
                    fnSelectCoupon(c) {
                        if (this.totalPrice < Number(c.MIN_ORDER_PRICE)) {
                            alert(Number(c.MIN_ORDER_PRICE).toLocaleString() + "원 이상 구매 시 사용 가능합니다.");
                            return;
                        }
                        this.selectedCoupon = c;
                        this.showCouponModal = false;
                    },

                    // 쿠폰 선택 취소
                    fnCancelCoupon() {
                        this.selectedCoupon = null;
                    },

                    fnTestPay() {
                        if (!confirm("PG 연동 없이 바로 결제 완료 처리하시겠습니까? (알림 테스트용)")) return;

                        const memo = this.requestValue === 'direct'
                            ? (this.requestDirect || '').trim()
                            : (this.requestLabel || '').trim();

                        const line = this.products[0] || {};
                        const amount = Math.max(0, Math.floor(Number(this.finalPrice) || 0));

                        // 테스트용 가짜 데이터
                        const fakeImpUid = "TEST_IMP_" + new Date().getTime();
                        const fakeMerchantUid = "TEST_ORD_" + new Date().getTime();

                        let url = "${path}/payment/testVerify.dox";
                        let data = {
                            impUid: fakeImpUid,
                            merchantUid: fakeMerchantUid,
                            amount: amount,
                            
                            buyerId: this.buyer.userId,
                            receivName: this.buyer.name,
                            receivPhone: this.buyer.phone,
                            deliverAddr: this.buyer.address,
                            memo: memo,
                            usedPoint: this.usedPoint,
                            ucId: this.selectedCoupon ? this.selectedCoupon.UC_ID : null
                        };

                        if (IS_SUBSCRIPTION_MODE) {
                            alert("구독 테스트 결제는 아직 지원하지 않습니다.");
                            return;
                        } else if (IS_CART_MODE) {
                            data.cartNos = CART_CSV;
                        } else {
                            data.productNo = line.productNo;
                            data.optionNo = line.optionNo;
                            data.quantity = line.quantity;
                            data.fulfillment = line.fulfillment || this.fulfillment;
                        }

                        $.ajax({
                            url: url,
                            type: "POST",
                            dataType: "json",
                            data: data,
                            success: (res) => {
                                if (res.result === "success") {
                                    alert("[테스트] 결제 완료! 주문번호: " + res.orderNo + "\n알림이 발송되었습니다.");
                                    location.href = "${path}/buyerMyPage.do?activeTab=orders";
                                } else {
                                    alert("[테스트] 실패: " + res.message);
                                }
                            },
                            error: (xhr) => {
                                alert("서버 오류: " + xhr.status);
                            }
                        });
                    },
                    fnProduct() {
                        if (IS_SUBSCRIPTION_MODE && this.subscriptionPlanId) {
                            // ✅ 정기배송 전용 플로우
                            $.ajax({
                                url: CTX + "/payment/subscriptionPrepare.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    planId: this.subscriptionPlanId,
                                    userId: this.userId
                                },
                                success: (res) => {
                                    if (res.result === 'success' && res.plan) {
                                        const plan = res.plan;
                                        this.products = [{
                                            productNo: plan.planId,      // 그냥 식별용으로만 사용
                                            pName: plan.planName,
                                            quantity: 1,
                                            unitPrice: Number(plan.price || 0),
                                            thumbPath: plan.imageUrl,
                                            fulfillment: 'subscription',
                                            periodType: plan.periodType
                                        }];
                                    } else {
                                        alert(res.message || "정기배송 플랜 정보를 불러오지 못했습니다.");
                                    }
                                },
                                error: () => {
                                    alert("정기배송 플랜 조회 중 오류가 발생했습니다.");
                                }
                            });

                        } else if (IS_CART_MODE) {
                            // ✅ 기존 장바구니 로직 그대로
                            $.ajax({
                                url: CTX + "/payment/list.dox",
                                type: "POST",
                                dataType: "json",
                                data: { userId: USER, cartNos: CART_CSV },
                                success: (res) => {
                                    if (res.result === 'success') {
                                        this.products = (res.list || []).map(p => ({
                                            ...p,
                                            unitPrice: Number(p.unitPrice ?? p.price ?? 0),
                                            quantity: Number(p.quantity ?? 1),
                                            shippingFee: Number(p.shippingFee ?? 0),
                                            fulfillment: (p.fulfillment || 'delivery').toLowerCase()
                                        }));
                                    } else {
                                        alert(res.message || '결제 대상 불러오기 실패');
                                    }
                                }
                            });
                        } else {
                            // ✅ 기존 단건(상품 상세) 로직 그대로
                            if (!SINGLE.productNo || !SINGLE.qty) {
                                alert('결제 대상이 없습니다.'); location.href = CTX + '/'; return;
                            }
                            $.ajax({
                                url: CTX + "/payment/list.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    userId: USER,
                                    productNo: SINGLE.productNo,
                                    quantity: SINGLE.qty,
                                    optionNo: SINGLE.optionNo,
                                    fulfillment: SINGLE.fulfillment
                                },
                                success: (res) => {
                                    if (res.result === 'success') {
                                        this.products = (res.list || []).map(p => ({
                                            ...p,
                                            unitPrice: Number(p.unitPrice ?? p.price ?? 0),
                                            quantity: Number(p.quantity ?? SINGLE.qty ?? 1),
                                            shippingFee: Number(p.shippingFee ?? 0),
                                            fulfillment: (p.fulfillment || SINGLE.fulfillment || 'delivery').toLowerCase()
                                        }));
                                    } else {
                                        alert(res.message || '결제 대상 불러오기 실패');
                                    }
                                }
                            });
                        }
                    },

                    fnUser: function () {
                        let self = this;
                        let param = {
                            userId: self.userId,
                            productNo: self.productNo,
                            quantity: self.quantity
                        };
                        $.ajax({
                            url: "/payment/userInfo.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                if (data.result == 'success') {
                                    self.buyer = data.info || [];
                                } else {
                                    alert('불러오기 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
                    },

                    applyPoint() {
                        this.usedPoint = this.userPoint;
                    },

                    searchAddress() {
                        alert("주소찾기 기능은 추후 연결 예정입니다.");
                    },

                    editBuyer() {
                        alert("주문자 정보 수정 기능은 추후 연결 예정입니다.");
                    },

                    updateRequestLabel() {
                        const opt = this.requestOptions.find(o => o.value === this.requestValue);
                        this.requestLabel = opt ? opt.label : '';
                    },

                    fnPay() {
                        if (!this.agree) {
                            alert("약관에 동의해주세요.");
                            return;
                        }

                        const memo = this.requestValue === 'direct'
                            ? (this.requestDirect || '').trim()
                            : (this.requestLabel || '').trim();

                        // 주문명(다건일 때 "첫상품 외 n건")
                        const line = this.products[0] || {};

                        // 주문명(다건일 때 "첫상품 외 n건")
                        let orderName = '주문';
                        if (this.products.length > 1) {
                            orderName = (line.pName || '상품') + ' 외 ' + (this.products.length - 1) + '건';
                        } else if (line.pName) {
                            orderName = line.pName;
                        }

                        // 총 결제 금액 = finalPrice (정수/0원 이상으로 보정)
                        // const amount = Math.max(0, Math.floor(Number(this.finalPrice) || 0));
                        const expectedAmount = Math.max(0, Math.floor(Number(this.finalPrice) || 0));
                        const payAmount = TEST_PAY ? 1 : expectedAmount;

                        if (payAmount === 0) {
                            alert("결제 금액이 0원입니다.");
                            return;
                        }

                        // 0원 결제는 PG에서 막힐 수 있으니 처리 분기
                        // if (amount === 0) {
                        //     alert("결제 금액이 0원입니다. 포인트 전액 결제 처리 로직으로 분기하세요.");
                        //     return;
                        // }

                        // PortOne 객체 생성
                        const IMP = window.IMP;
                        IMP.init("imp16634661");

                        const paymentData = {
                            pg: "html5_inicis", // 결제 PG사: inicis, kakaopay, toss 등
                            pay_method: "card", // 결제수단
                            merchant_uid: "ORD" + new Date().getTime(), // 고유 주문번호
                            name: orderName, // 결제명
                            amount: payAmount,
                            buyer_email: this.buyer.email,
                            buyer_name: this.buyer.name,
                            buyer_tel: this.buyer.phone,
                            buyer_addr: this.shipping.address,
                            buyer_postcode: this.shipping.zip
                        };

                        IMP.request_pay(paymentData, (rsp) => {
                            if (rsp.success) {

                                if (IS_SUBSCRIPTION_MODE) {
                                    // ✅ 정기배송 전용 검증 dox
                                    $.ajax({
                                        url: "${path}/payment/subscriptionVerify.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            impUid: rsp.imp_uid,
                                            merchantUid: rsp.merchant_uid,

                                            buyerId: this.buyer.userId,
                                            receivName: this.buyer.name,
                                            receivPhone: this.buyer.phone,
                                            deliverAddr: this.buyer.address,
                                            memo: memo,

                                            planId: this.subscriptionPlanId,
                                            periodType: line.periodType,  // WEEKLY / BIWEEKLY / MONTHLY
                                            testPay: "Y"
                                        },
                                        success: function (data) {
                                            if (data.result == "success") {
                                                alert("정기배송 신청이 완료되었습니다. 구독번호 " + data.subscriptionId);
                                                location.href = "${path}/buyerMyPage.do?tab=subscriptions";
                                            } else {
                                                alert("정기배송 저장 실패: " + (data.message || ''));
                                            }
                                        },
                                        error: function () {
                                            alert("서버 통신 오류");
                                        }
                                    });
                                    return;
                                }

                                // ✅ 2) 장바구니/번들(특산물 박스) 결제면 cartNos로 verify
                                if (IS_CART_MODE) {
                                    $.ajax({
                                        url: "${path}/payment/verify.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            impUid: rsp.imp_uid,
                                            merchantUid: rsp.merchant_uid,

                                            // 배송/수령 정보
                                            buyerId: this.buyer.userId,          // (보안상 서버에서 세션으로 다시 검증할 것)
                                            receivName: this.buyer.name,
                                            receivPhone: this.buyer.phone,
                                            deliverAddr: this.buyer.address,
                                            memo: memo,

                                            // ✅ 핵심: 다건결제 표시
                                            cartNos: CART_CSV,

                                            // (선택) 포인트 검증용
                                            usedPoint: this.usedPoint,
                                            testPay: "Y",

                                            ucId: this.selectedCoupon ? this.selectedCoupon.UC_ID : null
                                        },
                                        success: function (data) {
                                            if (data.result == "success") {
                                                alert("주문번호 " + data.orderNo + " 결제가 완료되었습니다!");
                                                location.href = "${path}/buyerMyPage.do?activeTab=orders";
                                            } else {
                                                alert("결제 저장 실패: " + (data.message || ""));
                                            }
                                        },
                                        error: function () {
                                            alert("서버 통신 오류");
                                        }
                                    });
                                    return;
                                }
                            
                                $.ajax({
                                    url: "${path}/payment/verify.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        impUid: rsp.imp_uid,
                                        merchantUid: rsp.merchant_uid,

                                        buyerId: this.buyer.userId,
                                        receivName: this.buyer.name,
                                        receivPhone: this.buyer.phone,
                                        deliverAddr: this.buyer.address,
                                        memo: memo,

                                        productNo: line.productNo,
                                        optionNo: line.optionNo,
                                        quantity: line.quantity,
                                        unitPrice: line.unitPrice || line.price,
                                        fulfillment: line.fulfillment || this.fulfillment,

                                        usedPoint: this.usedPoint,
                                        testPay: "Y"
                                    },
                                    success: function (data) {
                                        if (data.result == "success") {
                                            alert("주문번호 " + data.orderNo + " 결제가 완료되었습니다!");
                                            location.href = "${path}/buyerMyPage.do?activeTab=orders";
                                        } else {
                                            alert("결제 저장 실패:" + (data.message || ""));
                                        }
                                    },
                                    error: function () {
                                        alert("서버 통신 오류");
                                    }
                                });
                            } else {
                                alert("결제 실패: " + rsp.error_msg);
                            }
                        });
                    }
                },
                mounted() {
                    let self = this;
                    self.fnProduct();
                    self.fnUser();
                    this.updateRequestLabel(); // 한번 동기화
                }
            });
            app.mount("#app");
        </script>