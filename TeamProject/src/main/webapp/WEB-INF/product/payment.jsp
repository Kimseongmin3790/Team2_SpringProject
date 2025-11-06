<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>결제하기 | AGRICOLA</title>

            <!-- ✅ jQuery + Vue -->
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

            <!-- ✅ 공통 CSS -->
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

                /* 좌측 */
                .left-section {
                    flex: 2;
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                }

                /* 우측 */
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
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
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
                                        <div class="product-price">{{ Number(p.price).toLocaleString() }}원</div>
                                    </div>
                                </div>
                                <div class="total-box">배송비 3,000원 포함</div>
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
                                    <input type="text" v-model="shipping.recipient" placeholder="수령인">
                                    <input type="text" v-model="shipping.phone" placeholder="연락처">
                                </div>
                                <div class="input-row">
                                    <input type="text" v-model="shipping.zip" placeholder="우편번호">
                                    <button class="btn" @click="searchAddress">주소찾기</button>
                                </div>
                                <input type="text" v-model="shipping.address" placeholder="주소"
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
                                <div class="price-summary">
                                    상품금액 <span>{{ totalPrice.toLocaleString() }}원</span><br>
                                    배송비 <span>3,000원</span><br>
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
                        </section>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </body>

        </html>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        userId: "${userId}",
                        productNo: "${productNo}",
                        quantity: "${qty}",
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

                    };
                },
                computed: {
                    totalPrice() { return this.products.reduce((sum, p) => sum + (p.price) * (p.quantity), 0); },
                    finalPrice() { return this.totalPrice + 3000 - this.usedPoint; }
                },
                methods: {
                    fnProduct: function () {
                        let self = this;
                        let param = {
                            userId: self.userId,
                            productNo: self.productNo,
                            quantity: self.quantity
                        };
                        $.ajax({
                            url: "/payment/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                console.log(data.list);
                                if (data.result == 'success') {
                                    self.products = data.list || [];
                                } else {
                                    alert('불러오기 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
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
                                console.log(data.info);
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

                        // PortOne 객체 생성
                        const IMP = window.IMP;
                        IMP.init("impxxxxxx"); // ⚠️ 여기에 본인 가맹점 식별코드 넣기 (예: imp12345678)

                        const paymentData = {
                            pg: "html5_inicis", // 결제 PG사: inicis, kakaopay, toss 등
                            pay_method: "card", // 결제수단
                            merchant_uid: "ORD" + new Date().getTime(), // 고유 주문번호
                            name: this.products[0].pName, // 결제명
                            amount: 1, // ⚠️ 일단 테스트로 100원 하드코딩
                            buyer_email: this.buyer.email,
                            buyer_name: this.buyer.name,
                            buyer_tel: this.buyer.phone,
                            buyer_addr: this.shipping.address,
                            buyer_postcode: this.shipping.zip
                        };

                        IMP.request_pay(paymentData, (rsp) => {
                            let self = this;
                            if (rsp.success) {
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
                                        memo: memo
                                    },
                                    success: function (data) {
                                        if (data.result == "success") {
                                            alert("주문번호 " + data.orderNo + " 결제가 완료되었습니다!");
                                            location.href = "${path}/product/payment.do";
                                        } else {
                                            alert("결제 저장 실패:" + data.message);
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