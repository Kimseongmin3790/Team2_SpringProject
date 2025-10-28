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
            <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js" crossorigin="anonymous"></script>
            <script>
                if (window.Kakao && !window.Kakao.isInitialized()) {
                    window.Kakao.init('8e779c5d556d3d49da94596f97d290c4');
                }
            </script>

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

                .badge-row {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .share-naver {
                    height: 32px;
                    padding: 0 10px;
                    border: 0;
                    border-radius: 6px;
                    cursor: pointer;
                    background: #03c75a;
                    color: #fff;
                    font-weight: 600;
                    font-size: 14px;
                }

                .share-naver:hover {
                    filter: brightness(0.95);
                }

                .share-wrap {
                    position: relative
                }

                .share-icon-btn {
                    width: 36px;
                    height: 36px;
                    border: 1px solid #ddd;
                    border-radius: 50%;
                    background: #fff;
                    cursor: pointer;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }

                .share-pop {
                    position: absolute;
                    right: 0;
                    top: 42px;
                    z-index: 20;
                    min-width: 160px;
                    background: #fff;
                    border: 1px solid #e5e5e5;
                    border-radius: 10px;
                    padding: 8px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, .08);
                }

                .share-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    width: 100%;
                    padding: 8px;
                    border: 0;
                    background: #fff;
                    cursor: pointer;
                    border-radius: 8px
                }

                .share-item:hover {
                    background: #f7f7f7
                }

                .share-badge {
                    width: 22px;
                    height: 22px;
                    border-radius: 6px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-weight: 700
                }

                .naver-badge {
                    background: #03c75a
                }

                .kakao-badge {
                    background: #fee500;
                    color: #000
                }

                .link-badge {
                    background: #888
                }

                .selection-summary {
                    margin: 10px 0px;
                    border: 2px solid rgba(0, 0, 0, 0.03);
                    background: rgba(0, 0, 0, 0.03);
                }

                .irq {
                    clear: both;
                }

                #information,
                #review,
                #qeustion {
                    float: left;
                }

                table,
                tr,
                td,
                th {
                    border: 1px solid black;
                    border-collapse: collapse;
                    padding: 5px 10px;
                }

                th {
                    background-color: rgba(0, 0, 0, 0.03);
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
                            <div class="badge-row">
                                <img src="/resources/img/sale.png" style="width: 62px;">

                                <!-- ▼ v-model 바인딩 (숨김) -->
                                <input v-model="shareUrl" type="hidden">
                                <input v-model="shareTitle" type="hidden">

                                <!-- ▼ 공유 아이콘 + 팝오버 -->
                                <div class="share-wrap">
                                    <button type="button" class="share-icon-btn" @click.stop="shareOpen = !shareOpen"
                                        aria-label="공유">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                            <path
                                                d="M15 7a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm0 16a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"
                                                stroke="#333" stroke-width="1.5" />
                                            <path d="M5.5 12.5 12.5 6M5.5 11.5 12.5 17" stroke="#333"
                                                stroke-width="1.5" />
                                        </svg>
                                    </button>

                                    <div class="share-pop" v-if="shareOpen" @click.stop>
                                        <button type="button" class="share-item" @click="shareNaver">
                                            <span class="share-badge naver-badge">N</span><span>네이버로 공유</span>
                                        </button>
                                        <button type="button" class="share-item" @click="shareKakao">
                                            <span class="share-badge kakao-badge">K</span><span>카카오로 공유</span>
                                        </button>
                                        <button type="button" class="share-item" @click="shareCopy">
                                            <span class="share-badge link-badge">⧉</span><span>링크 복사</span>
                                        </button>
                                    </div>
                                </div>
                            </div>

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
                                <p v-if="week && before">오늘 발송됩니다. (평일 15:00까지)</p>
                                <p v-else>오늘출발 마감되었습니다. (평일 15:00까지)</p>
                            </div>

                            <div>
                                수율 상세페이지 참조 *
                                <!-- [변경] 기존 select → 드롭다운 (상품 옵션) -->
                                <div class="dd" style="margin-top:8px;">
                                    <button type="button" class="dd-btn" @click.stop="ddOpen2=!ddOpen2">
                                        <span class="l1">수율 상세페이지 참조 (필수)</span>
                                    </button>
                                    <div class="dd-list" v-if="ddOpen2" @click.stop>
                                        <div class="dd-opt" v-for="opt in skuOptions" :key="opt.value"
                                            @click="pickSku(opt)">
                                            <span class="l1">{{ opt.l1 }}</span>
                                            <span class="l2">{{ (opt.l2).toLocaleString() }}원</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="selection-summary" v-if="selections.length" style="margin-top:12px">
                                    <div v-for="(it, i) in selections" :key="it.sku"
                                        style="padding:8px 0;border-top:1px solid #eee">
                                        <div>{{ it.name }}</div>
                                        <div
                                            style="font-size:18px;font-weight:700; display:flex; align-items:center; gap:8px; margin-top:6px">
                                            <button @click="fnMinus(i)">-</button>
                                            <input v-model.number="it.qty" @input="recomputeTotal">
                                            <button @click="fnPlus(i)">+</button>
                                            <span>{{ (it.price * it.qty).toLocaleString() }}원</span>
                                            <button @click="removeExtra(i)" style="margin-left:auto">삭제</button>
                                        </div>
                                    </div>
                                </div>
                                <div style="margin-top:12px; text-align:right; font-size:20px; font-weight:800;">
                                    합계: {{ totalSum.toLocaleString() }}원
                                </div>
                                <div>
                                    <button @click="fnPurchase">구매하기</button>
                                    <button @click="fnBasket">장바구니</button>
                                    <button @click="fnWish">찜</button>
                                </div>
                            </div>
                        </div>
                        <div class="irq">
                            <div id="information">
                                <a href="javascript:;">상세정보</a>
                            </div>
                            <div id="review">
                                <a href="javascript:;">구매평</a>
                            </div>
                            <div id="question">
                                <a href="javascript:;">Q&A</a>
                            </div>
                        </div>
                        <div>
                            <img src="/resources/img/class.png">
                        </div>
                        <div v-if="!showDetail" style="margin:16px 0; text-align:center;">
                            <button @click="openDetail"
                                style="padding:10px 16px; border:1px solid #ddd; border-radius:8px; background:#fff; cursor:pointer;">
                                ▼ 상세 보기
                            </button>
                        </div>
                        <div v-show="showDetail">
                            <div>
                                아그리콜라는
                                <br>
                                매일매일 최저가예요
                                <br>
                                생산자님의 판매자가 다른 사이트보다 비싸다면
                                <br>
                                책임지고 100% 차액환불을 약속드려요
                            </div>
                            <div>
                                리뷰쓰고 포인트 받고,
                                <br>
                                최대 10만원의 대박 혜택
                                <br>
                                상품 구매하고 후기만 써도 적립금이 펑펑
                                <br>
                                베스트 리뷰어님께는 놀라운 선물을 드려요!
                            </div>
                            <div>
                                아그리콜라 직거래마켓이 새롭게 오픈하였습니다.
                                <br>
                                후기가 없어도 걱정하지 마세요.
                                <br>
                                『아그리콜라는 100만명 이상의 회원보유
                                <br>
                                매일 수만명의 고객님이 방문하는 공식 쇼핑몰입니다.』
                            </div>
                            <div>
                                생산자님이 등록한 상품에 문제가 생겨도
                                <br>
                                아그리콜라가 책임지고 먼저 해결해드릴게요
                            </div>
                            <div>
                                본 상품은 생산자와 소비자 간 유통과정 없이
                                <br>
                                생산자와 직접 거래하는 직거래 상품입니다
                            </div>
                            <div>
                                해상 기상악화 인한
                                <br>
                                배송지연안내
                                <br>
                                10/20 오후부터 기상 악화로 인하여 조업 지연으로
                                <br>
                                10/20 ~ 10/24 주문건 배 입항 일자에 따라
                                <br>
                                입항 일자는 변동될 수 있습니다.
                                <br>
                                조업 성공시 10/27 ~ 10/28 출고 예정입니다.
                                <br>
                                순차적으로 빠르게 배송해드리겠습니다.
                                <br>
                                고객님들의 너른 양해 부탁드리겠습니다.
                            </div>
                            <div>
                                산지직송 연지홍게
                                <br>
                                4차 선별 완료 후
                                <br>
                                당일작업 당일배송!
                                <br>
                                동해안 바다에서 잡은
                                <br>
                                프리미업 A급 연지홍게!
                            </div>
                            <div>
                                홍게가 가장 신선한 상태에서
                                <br>
                                전용 고압 스팀으로 자숙(찜)을 해
                                <br>
                                홍게의 달달하고 고소한 맛을
                                <br>
                                그대로 즐기실 수 있습니다!
                            </div>
                            <div>
                                연지홍게 주문시 필독!
                                <br>
                                생물 상품이므로 배송일자 지정이 불가합니다.
                                <br>
                                바다상황, 조업 물량에 따라 조업 지연시
                                <br>
                                당일배송이 어려우며, 순차적인 배송으로 도와드리겠습니다.
                                <br>
                                공상품과 달리 생물 상품이므로
                                <br>
                                매일 조업량이 다릅니다.
                                <br>
                                배송지연시 개별 문자 전달 됩니다.
                            </div>
                            <div>
                                상품 구매시 픽독
                                <br>
                                자숙 찜 연지홍게
                                <br>
                                B급, A급 차이점은 크기 차이가 아닌 살수율 차이
                            </div>
                            <div>
                                선택01
                                <br>
                                가성비(B급) 3kg
                                <br>
                                -몸통수율 50%
                                <br>
                                -다리수율 70%
                                <br>
                                (10~12미)
                            </div>
                            <div>
                                선택02
                                <br>
                                가성비(A급) 3kg
                                <br>
                                -몸통수율 70%
                                <br>
                                -다리수율 80%
                                <br>
                                (10~12미)
                            </div>
                            <div>
                                생물 상품은 공산품과 달리 동일하지 않습니다.
                                <br>
                                생물 기준 3kg찜(자숙) 후 수분감량 40~50% 있습니다.
                            </div>
                            <div>
                                •연지홍게의 몸통 크기는 성인 여성 손바닥 크기 정도입니다.
                                <br>
                                • 연지홍게는 타게류 보다 크기 몸집이 많이 작은 게 입니다.
                                <br>
                                • 생물을 자숙하여 보내드리므로 살수율 차이가 날 수 있습니다.
                                <br>
                                대게, 일반홍게 처럼 큰 사이즈를 원하실 경우 구매 지양 드립니다.
                                <br>
                                연지홍게는 몸집은 작지만 껍질이 매우 얇고, 붉은 빛이 강한 홍게의 종류입니다.
                                <br>
                                살집의 단맛이 일품이며 녹진한 내장의 풍미 가성비로 즐기실 수 있습니다.
                            </div>
                            <div>
                                안 먹어본 사람은 있어도
                                <br>
                                한번만 먹어본 사람은 없다!
                                <br>
                                윤자네수산
                                <br>
                                연지홍게
                            </div>
                            <div>
                                당일 한정수량
                                <br>
                                저온창고에 보관하는 타사와 달리
                                <br>
                                하루에 조업된 수량만큼 한정판매합니다
                                <br>
                                산지상황에 따라 배송 지연될 수 있으며 지연시 연락 드립니다.
                                <br>
                                최고급 품질, 깐깐한 선별의
                                <br>
                                중요성을 직접 느껴보세요
                            </div>
                            <div>
                                포항 동해안 바다의 신선함
                                <br>
                                산지직송 시스템!
                                <br>
                                01
                                <br>
                                구룡포에서 직접 유통하는 산지배송 시스템
                                <br>
                                02
                                <br>
                                매일 새벽 당일 조업 후 크기 미달/파품 선별
                                <br>
                                03
                                <br>
                                당일 자숙 후 수분감량 체크
                                <br>
                                살수율에 따른 깐깐한 선별
                                <br>
                                04
                                <br>
                                아이스박스 및 아이스팩 기본 배송
                            </div>
                            <div>
                                연지홍게
                                <br>
                                어떻게 먹어야
                                <br>
                                가장 맛있을까요?
                                <hr>
                            </div>
                            <div>
                                이미 자숙된 홍게이므로
                                <br>
                                바로 드시는 게 가장 맛있습니다!
                                <br>
                                *자숙된 홍게를 오랜기간 찌게 되면 수분감량, 홍게 살, 내장이 녹을 수 있어요.
                            </div>
                            <div>
                                따뜻하게 드시고 싶으신 경우
                                <br>
                                찜기에 수증기로 3분만 데워주세요
                            </div>
                            <div>
                                연지홍게를 즐기는
                                <br>
                                다양한 방법
                                <br>
                                수령 후 바로 먹어보세요
                                <br>
                                오리지널 연지홍게
                                <br>
                                고소한 내장과 함께 즐기는
                                <br>
                                연지홍게 게딱지 볶음밥
                                <br>
                                홍게를 통째로 넣어서 즐기는
                                <br>
                                얼큰한 해장 홍게라면
                            </div>
                            <div>
                                살수율 보장!!
                                <br>
                                몸통 50% 다리 70%
                            </div>
                            <div>
                                홍게구매시
                                <br>
                                주의사항
                                <br>
                                01
                                <br>
                                홍게의 다리는 1~2개 절지되어도 정품입니다.
                                <br>
                                배송 도중 떨어지는 현상이 발생할 수 있습니다.
                                <br>
                                02
                                <br>
                                홍게는 대게처럼 크지 않습니다.
                                <br>
                                큰 사이즈를 원하시면 구매를 피해 주세요.
                                <br>
                                03
                                <br>
                                자숙 연지홍게이므로 자숙 과정 수분 감소 40~50%
                                <br>
                                수령 후 바로 드시는 것이 가장 맛있습니다.
                                <br>
                                04
                                <br>
                                냉장보관 할 경우 비닐을 꼭 덮어서 보관해주세요.
                                <br>
                                냉장보관 1일 권장
                                <br>
                                05
                                <br>
                                내장이 들어 있는 중간 부분은 원래 살이 없습니다.
                                <br>
                                06
                                <br>
                                집에서 장시간 찌시는 경우 홍게 살이 녹습니다.
                                <br>
                                07
                                <br>
                                현재지연, 기상악화 등으로 인한 배송지연이
                                <br>
                                있을 수 있습니다. 반품 사유가 되지 않습니다.
                            </div>
                            <div>
                                010-3377-9324
                                <br>
                                평일 09:00~18:00 / 토, 일, 공휴일 휴무
                            </div>
                            <div>
                                기본 배송구성
                                <br>
                                아이스박스에 아이스팩을 넣어 신선하게 배송됩니다
                            </div>
                            <div>
                                교환 • 반품 안내사항
                                <br>
                                ·신선 식품은 재판매가 어려우므로 구매자의 단순 변심과
                                <br>
                                개인 입맛의 차이로 반품 및 교환 불가합니다
                                <br>
                                ·구매자의 실수로 배송지 오기입, 보관 실수로 인한
                                <br>
                                변질 이유에 대해서 반품 및 교환 불가합니다
                            </div>
                            <div>
                                수령하신 상품에 문제 있는 경우
                                <br>
                                ·운송장이 보이게 박스를 찍어 전달해 주세요
                                <br>
                                ·해당 상품 사진의 문제점이 보이는 부분을 찍어주세요
                                <br>
                                ·상품 택배 박스 파손 시 폐기하지 마시고 빠른 시일 내에
                                <br>
                                수령 후 촬영하여 톡톡 및 고객센터 접수 부탁드립니다
                                <br>
                                ·부분 상품 누락 시 해당 상품에 대해서 부분 취소 및
                                <br>
                                부분 환불 처리 해드립니다
                            </div>
                            <div>
                                구매 전 꼭 확인해주세요!
                            </div>
                            <div>
                                <h2>배송안내</h2>
                                <br>
                                ·당일 작업하는 상품들은 주문 폭주 시 배송 지연이 있을 수 있지만
                                <br>
                                최대한 빠른 배송 드릴 수 있도록 노력하겠습니다
                                <br>
                                ·도서산간지역 / 제주도의 경우 택배사 배송일이 2~3일 소요됩니다.
                                <br>
                                신선식품의 경우 제품이 부패할 수 있어 배송이 제한될 수 있습니다
                                <br>
                                ·각 산지에서 가장 신선하게 배송 드리는 산지직송 배송 방식으로
                                <br>
                                택배 박스는 산지에 따라 따로 도착하기에 '합포장'이 불가한 점
                                <br>
                                양해 말씀 드립니다
                                <br>
                                ·배송 도착시간은 배송사에 따라 각각 다를 수 있습니다
                            </div>
                            <div>
                                <h2>교환 • 반품불가능 안내</h2>
                                <br>
                                ·신선식품의 경우 재판매가 불가능한 제품의 특성상 단순 변심과
                                <br>
                                개인적인 입맛 차이로 인한 반품 및 교환은 불가합니다
                                <br>
                                ·상품이 [배송중] 상태인 경우 주문취소가 불가합니다
                                <br>
                                ·고객의 과실로 고객 정보나, 부재 시 보관 장소에 대한 기재 오류로 인해
                                <br>
                                연락 부재로 발생한 배송사고에 대해서는 책임을 지지 않습니다
                            </div>
                            <div>
                                교환 반품 요청시 반드시 준비해주세요!
                                <br>
                                1. 운송장이 보이는 박스사진
                                <br>
                                2. 상품 사진 (문제 부분 집중적으로 찍어주면 처리가 빨라집니다)
                                <br>
                                3. 택배 파손 시 파손 부분 사진
                                <br>
                                (물품은 수령하신 상태 그대로 폐기하지 마시고 보관해주세요)
                                <br>
                                수령일로부터 3일 이내에 고객센터로 접수해주시면 바로 처리를
                                <br>
                                도와드리겠습니다
                            </div>
                            <div>
                                <h2>고객센터 안내</h2>
                                <br>
                                ·문의를 원하시는 고객님께서는 주문해주신 각 상품 산지의 고객센터 번호 및
                                <br>
                                아그리콜라 상품 문의를 이용해주시면 빠르게 처리 도와드리겠습니다
                            </div>
                            <div>
                                상품정보 제공고시
                                <table>
                                    <tr>
                                        <th>품목 또는 명칭</th>
                                        <td>연지홍게</td>
                                    </tr>
                                    <tr>
                                        <th>포장단위별 용량(중량), 수량, 크기</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>생산자</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>원산지</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>제조연월일, 소비기한 또는 유통기한 또는 품질유지기한</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>세부 품목군별 표시사항</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>상품구성</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>보관방법 또는 취급방법</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>소비자안전을 위한 주의사항</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>소비자상담 관련 전화번호</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                </table>
                            </div>
                            <div style="margin:16px 0; text-align:center;">
                                <button @click="closeDetail"
                                    style="padding:10px 16px; border:1px solid #ddd; border-radius:8px; background:#fff; cursor:pointer;">
                                    ▲ 상세 접기
                                </button>
                            </div>
                        </div>
                        <div>
                            리뷰
                            <div>
                                <a href="javascript:;">추천순</a>
                                <a href="javascript:;">최신순</a>
                                <a href="javascript:;">평점 높은순</a>
                                <a href="javascript:;">평점 낮은순</a>
                            </div>
                        </div>
                        <div>
                            Q&A
                            <div>
                                <button>상품문의</button>
                                <button>실시간 문의</button>
                            </div>
                            <div>
                                <table>
                                    <tr>
                                        <th>상태</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>등록일</th>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
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
                        // 기존 필드들...
                        ddOpen1: false, ddOpen2: false,
                        fulfillment: 'delivery',
                        sku: '',
                        deliveryOptions: [
                            { value: 'delivery', l1: '택배' },
                            { value: 'pickup', l1: '방문 수령' }
                        ],
                        skuOptions: [
                            { value: 'b3', l1: '가성비 B급 3kg (10~12미)', l2: 15900 },
                            { value: 'b6', l1: '가성비 B급 6kg (20~24미)', l2: 29900 },
                            { value: 'a3', l1: '가성비 A급 3kg (10~12미)', l2: 27900 }
                        ],

                        // ▼ v-model로 연결될 공유 값
                        shareOpen: false,
                        shareUrl: window.location.href,
                        shareTitle: '',
                        selections: [],
                        totalSum: 0,
                        showDetail: false,
                        week: false,
                        befor: false
                    }
                },
                computed: {
                    fulfillmentSel() {
                        return this.deliveryOptions.find(o => o.value === this.fulfillment) || null;
                    },
                    skuSel() {
                        return this.skuOptions.find(o => o.value === this.sku) || null;
                    }
                },
                methods: {
                    alreadyAdded: function (opt) {
                        for (var i = 0; i < this.selections.length; i++) {
                            if (this.selections[i].sku == opt.value) {
                                return true;
                            }
                        }
                        return false;
                    },

                    pickFulfillment(opt) {
                        let self = this;
                        self.fulfillment = opt.value;
                        self.ddOpen1 = false;
                    },

                    pickSku(opt) {
                        let self = this;
                        if (self.alreadyAdded(opt)) {
                            alert("이미 추가한 옵션입니다.");
                            self.ddOpen2 = false;
                            return;
                        }
                        self.selections.push({
                            sku: opt.value,
                            name: opt.l1,
                            price: opt.l2,
                            qty: 1
                        });
                        self.sku = opt.value;
                        self.ddOpen2 = false;
                        self.recomputeTotal();
                    },

                    // ▼ 네이버 공유: v-model 값 사용
                    shareNaver() {
                        if (!this.shareUrl || !this.shareTitle) {
                            alert('공유할 URL/제목이 비었습니다.');
                            return;
                        }
                        let encUrl = encodeURI(encodeURIComponent(this.shareUrl));
                        let encTitle = encodeURI(this.shareTitle);
                        let shareURL = "https://share.naver.com/web/shareView?url=" + encUrl + "&title=" + encTitle;
                        window.open(shareURL, "_blank");
                        this.shareOpen = false;
                    },

                    // ▼ 카카오 공유(앱키 및 SDK 초기화 필요)
                    shareKakao() {
                        // SDK/도메인 설정 체크
                        if (!(window.Kakao && window.Kakao.isInitialized && window.Kakao.isInitialized())) {
                            alert('카카오 SDK가 초기화되지 않았습니다.');
                            return;
                        }
                        // v2 API 사용: Kakao.Share.sendDefault
                        window.Kakao.Share.sendDefault({
                            objectType: 'feed',
                            content: {
                                title: this.shareTitle || document.title,
                                description: '상품을 공유합니다',
                                imageUrl: location.origin + '/resources/img/snowCrab.png', // 절대URL 권장
                                link: {
                                    webUrl: this.shareUrl || window.location.href,
                                    mobileWebUrl: this.shareUrl || window.location.href
                                }
                            },
                            buttons: [
                                {
                                    title: '바로 보기',
                                    link: {
                                        webUrl: this.shareUrl || window.location.href,
                                        mobileWebUrl: this.shareUrl || window.location.href
                                    }
                                }
                            ]
                        });
                        this.shareOpen = false;
                    }
                    ,

                    // ▼ 링크 복사
                    shareCopy() {
                        let link = this.shareUrl || window.location.href;
                        (navigator.clipboard
                            ? navigator.clipboard.writeText(link)
                            : new Promise((res) => { var ta = document.createElement('textarea'); ta.value = link; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); res(); })
                        ).then(() => alert('링크가 복사되었습니다.'));
                        this.shareOpen = false;
                    },



                    fnMinus(i) {
                        let self = this;
                        let it = self.selections[i];
                        if (!it) {
                            return;
                        }
                        if (it.qty > 1) {
                            it.qty--;
                            this.recomputeTotal();
                        }
                    },

                    fnPlus(i) {
                        let self = this;
                        let it = self.selections[i];
                        if (!it) {
                            return;
                        }
                        it.qty++;
                        this.recomputeTotal();
                    },

                    removeExtra(i) {
                        this.selections.splice(i, 1);
                        this.recomputeTotal();
                    },

                    recomputeTotal() {
                        let sum = 0;
                        for (let i = 0; i < this.selections.length; i++) {
                            sum += this.selections[i].price * this.selections[i].qty;
                        }
                        this.totalSum = sum;
                    },

                    openDetail() {
                        let self = this;
                        self.showDetail = true;
                    },

                    closeDetail() {
                        let self = this;
                        self.showDetail = false;
                    },
                    
                    fnPurchase : function(){

                    },

                    fnBasket : function(){

                    },

                    fnWish : function (){

                    }

                },
                mounted() {
                    let self = this;
                    // 기본 제목을 화면의 #title에서 가져와 v-model에 주입
                    var t = document.getElementById('title');
                    self.shareTitle = t ? t.textContent.trim() : document.title;

                    // 바깥 클릭 시 팝오버/드롭다운 닫기
                    self._docHandler = () => {
                        self.ddOpen1 = false;
                        self.ddOpen2 = false;
                        self.shareOpen = false;
                    };
                    document.addEventListener('click', self._docHandler);
                    const now = new Date();
                    const day = now.getDay(); // 0=일,6=토
                    self.week = day >= 1 && day <= 5;
                    self.before = now.getHours() < 15;
                },
                beforeUnmount() {
                    document.removeEventListener('click', self._docHandler);
                }
            });
            app.mount('#app');
        </script>