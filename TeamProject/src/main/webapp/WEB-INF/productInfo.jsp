<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
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
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                    margin: 20px auto;
                }

                #container,
                #img {
                    float: left;
                }

                #container {
                    width: 500px;
                    margin: 10px 30px;
                }

                #title {
                    font-size: 24px;
                    color: #000;
                    font-weight: bold;
                }

                #store {
                    font-size: 12px;
                    color: #000;
                }

                #sub {
                    font-size: 15px;
                    color: #000;
                    margin-bottom: 24px;
                }

                #price {
                    font-size: 24px;
                    color: #000;
                    font-weight: bold;
                }

                #delivery {
                    margin: 10px 0px;
                    border: 2px solid rgba(0, 0, 0, 0.03);
                    background: rgba(0, 0, 0, 0.03);
                }

                #choice select {
                    width: 500px;
                    height: 50px;
                }

                #choice select option {
                    width: 500px;
                    height: 50px;
                }

                /* [추가] 아주 간단한 커스텀 드롭다운 스타일 (select 대체) */
                .dd {
                    position: relative;
                    width: 500px;
                    font-size: 16px;
                }

                .dd-btn {
                    width: 100%;
                    height: 50px;
                    padding: 6px 12px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    background: #fff;
                    text-align: left;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    gap: 2px;
                    cursor: pointer;
                }

                .dd-btn .l1 {
                    font-weight: 600;
                    line-height: 1.1;
                }

                .dd-btn .l2 {
                    font-size: 14px;
                    opacity: .8;
                    line-height: 1.1;
                }

                .dd-list {
                    position: absolute;
                    z-index: 10;
                    width: 488px;
                    margin-top: 6px;
                    padding: 6px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    background: #fff;
                    max-height: 260px;
                    overflow: auto;
                    box-shadow: 0 6px 16px rgba(0, 0, 0, .08);
                }

                .dd-opt {
                    padding: 10px;
                    border-radius: 6px;
                    cursor: pointer;
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .dd-opt:hover {
                    background: #f5f5f5;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div id="img">
                            <!-- [수정] px 단위 보정 -->
                            <img src="/resources/img/snowCrab.png" style="width: 480px; margin: 5px 5px;">
                        </div>
                        <div id="container">
                            <div id="store">윤자네 수산</div>
                            <div id="title">[경북 포항 김지윤] 구룡포 연지홍게 홍게제철 실속 가성비 3kg(10~12미)</div>
                            <img src="/resources/img/sale.png" style="width: 62px;">
                            <div id="price">
                                15,900원
                            </div>
                            <hr>
                            <div id="sub">
                                <p>타 홍게류 보다 크기는 작지만 장맛이 일품인 연지홍게입니다</p>
                                <p>가정에서 실속 가성비로 저렴하게 드셔보세요!</p>
                                <p>모든 홍게는 고압스팀기 자숙 후 배송해드립니다</p>
                            </div>
                            <div v-if="fulfillment == 'delivery'">
                                <div>
                                    <span style="font-weight: bold;">원산지</span> 국산(구룡포)
                                </div>
                                <div>
                                    <span style="font-weight: bold;">구매혜택</span> 318 포인트 적립예정
                                </div>
                                <div>
                                    <span style="font-weight: bold;">배송비</span> 3,000원 | 도서산간 배송비 추가
                                </div>
                                <div>
                                    <span style="font-weight: bold;">배송 안내</span> 배송비 3,000원
                                </div>
                            </div>
                            <div v-else>
                                <div>
                                    <span style="font-weight: bold;">원산지</span> 국산(구룡포)
                                </div>
                                <div>
                                    <span style="font-weight: bold;">구매혜택</span> 318 포인트 적립예정
                                </div>
                            </div>
                            <!-- 수령방법 드롭다운 -->
                            <div class="dd">
                                <button type="button" class="dd-btn" @click.stop="ddOpen1=!ddOpen1">
                                    <span class="l1">{{ fulfillmentSel?.l1 || '수령 방법 선택' }}</span>
                                    <span class="l2" v-if="fulfillmentSel?.l2">{{ fulfillmentSel.l2 }}</span>
                                </button>
                                <div class="dd-list" v-if="ddOpen1" @click.stop>
                                    <div class="dd-opt" v-for="opt in deliveryOptions" :key="opt.value"
                                        @click="pickFulfillment(opt)">
                                        <span class="l1">{{ opt.l1 }}</span>
                                    </div>
                                </div>
                                <input type="hidden" name="fulfillment" :value="fulfillment">
                            </div>

                            <div id="delivery">
                                <p>오늘출발 상품</p>
                                <p>오늘출발 마감되었습니다. (평일 15:00까지)</p>
                            </div>

                            <div>
                                수율 상세페이지 참조 *
                                <!-- [변경] 기존 select → 드롭다운 (상품 옵션) -->
                                <div class="dd" style="margin-top:8px;">
                                    <button type="button" class="dd-btn" @click.stop="ddOpen2=!ddOpen2">
                                        <span class="l1">{{ skuSel?.l1 || '옵션 선택' }}</span>
                                        <span class="l2" v-if="skuSel?.l2">{{ skuSel.l2 }}</span>
                                    </button>
                                    <div class="dd-list" v-if="ddOpen2" @click.stop>
                                        <div class="dd-opt" v-for="opt in skuOptions" :key="opt.value"
                                            @click="pickSku(opt)">
                                            <span class="l1">{{ opt.l1 }}</span>
                                            <span class="l2" v-if="opt.l2">{{ opt.l2 }}</span>
                                        </div>
                                    </div>
                                    <input type="hidden" name="sku" :value="sku">
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
                        ddOpen1: false, ddOpen2: false,
                        fulfillment: 'delivery',
                        sku: 'b3',
                        deliveryOptions: [
                            { value: 'delivery', l1: '택배' },
                            { value: 'pickup', l1: '방문 수령' }
                        ],
                        skuOptions: [
                            { value: 'b3', l1: '가성비 B급 3kg (10~12미)', l2: '15,900원' },
                            { value: 'b6', l1: '가성비 B급 6kg (20~24미)', l2: '29,900원' },
                            { value: 'a3', l1: '가성비 A급 3kg (10~12미)', l2: '27,900원' }
                        ]
                    }
                },
                computed: {
                    fulfillmentSel() { return this.deliveryOptions.find(o => o.value === this.fulfillment) || null; },
                    skuSel() { return this.skuOptions.find(o => o.value === this.sku) || null; }
                },
                methods: {
                    pickFulfillment(opt) { this.fulfillment = opt.value; this.ddOpen1 = false; },
                    pickSku(opt) { this.sku = opt.value; this.ddOpen2 = false; }
                },
                mounted() {
                    // 바깥 클릭 시 닫기
                    document.addEventListener('click', () => {
                        this.ddOpen1 = false;
                        this.ddOpen2 = false;
                    });
                },
                beforeUnmount() {
                    document.removeEventListener('click', this._docHandler);
                }
            });
            app.mount('#app');
        </script>