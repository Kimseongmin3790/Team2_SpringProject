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

            <!-- 공통 헤더/푸터 -->
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

                /* 페이지 본문의 최대 폭을 정해 주세요 (원하는 값으로 조절) */
                .content {
                    flex: 1;
                    margin: 20px auto;
                    max-width: 1100px;
                    /* <- 추가 */
                    width: 100%;
                }

                .prod-wrap {
                    display: flex;
                    align-items: flex-start;
                    gap: 32px;
                    /* 칼럼 간격 */
                    max-width: 1200px;
                    /* 페이지 최대폭(원하면 조절) */
                    margin: 20px auto;
                    /* 가운데 정렬 */
                }

                /* 왼쪽 이미지 칼럼: 580px 고정폭(사이트 원본 느낌 유지) */
                .prod-media {
                    flex: 0 0 580px;
                }

                /* 오른쪽 정보 칼럼: 남는 공간 전부 */
                .prod-info {
                    flex: 1;
                    min-width: 0;
                    /* 긴 문자열 줄바꿈 안정화 */
                }

                /* 이미지가 칼럼을 넘지 않도록 */
                .prod-media img {
                    display: block;
                    width: 100%;
                    height: auto;
                    max-width: 100%;
                    /* 필요하면 여백은 여기서 처리 */
                    /* margin: 5px 5px; */
                }

                /* 반응형: 화면 좁아지면 세로로 쌓기 */
                @media (max-width: 900px) {
                    .prod-wrap {
                        flex-direction: column;
                        gap: 16px;
                    }

                    .prod-media {
                        flex-basis: auto;
                    }
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
                    margin: 50px 0px;
                }

                #price {
                    font-size: 24px;
                    color: #000;
                    font-weight: bold;
                }

                #delivery {
                    margin: 10px 0;
                    border: 2px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                }

                /* 커스텀 드롭다운 */
                .dd {
                    position: relative;
                    width: 500px;
                    font-size: 16px;
                }

                .dd-btn {
                    width: 100%;
                    height: 50px;
                    margin: 15px 0px;
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

                .share-wrap {
                    position: relative;
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
                    border-radius: 8px;
                }

                .share-item:hover {
                    background: #f7f7f7;
                }

                .share-badge {
                    width: 22px;
                    height: 22px;
                    border-radius: 6px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-weight: 700;
                }

                .naver-badge {
                    background: #03c75a;
                }

                .kakao-badge {
                    background: #fee500;
                    color: #000;
                }

                .link-badge {
                    background: #888;
                }

                .selection-summary {
                    margin: 10px 0;
                    border: 2px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                }

                /* 탭 바: 스크롤 시 상단 고정 */
                .irq {
                    position: sticky;
                    top: 0;
                    z-index: 50;
                    background: #fff;
                    border-bottom: 1px solid #eee;
                    display: flex;
                    gap: 12px;
                    padding: 6px 0;
                }

                .tab {
                    flex: 1;
                    text-align: center;
                    padding: 5px 10px;
                    box-sizing: border-box;
                }

                .tab a {
                    display: block;
                    text-decoration: none;
                    font-weight: 700;
                    padding: 6px 0;
                    background: #f5f5f5;
                    color: #111;
                    border: 1px solid #e5e5e5;
                    border-radius: 8px;
                }

                /* 섹션 앵커 위치 보정(탭 높이만큼) */
                #in,
                #re,
                #qa {
                    scroll-margin-top: 64px;
                }

                #re {
                    width: 100%;
                }

                /* 활성 색상 토큰 */
                :root {
                    --active-bg: #4caf50;
                    --active-color: #fff;
                }

                /* 해시가 없을 때(초기/새로고침) → 상세정보(#in) 활성 */
                :root:not(:has(:target)) .irq .tab a[href="#in"] {
                    background: var(--active-bg);
                    color: var(--active-color);
                    border-color: var(--active-bg);
                }

                /* 해시가 있을 때 → 해당 탭 활성 */
                :root:has(#in:target) .irq .tab a[href="#in"],
                :root:has(#re:target) .irq .tab a[href="#re"],
                :root:has(#qa:target) .irq .tab a[href="#qa"] {
                    background: var(--active-bg);
                    color: var(--active-color);
                    border-color: var(--active-bg);
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
                    background-color: rgba(0, 0, 0, .03);
                }

                /* 버튼 공통 */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                    min-width: 240px;
                    height: 50px;
                    padding: 0 16px;
                    border-radius: 10px;
                    font-family: "Noto Sans KR", sans-serif;
                    font-size: 15px;
                    font-weight: 700;
                    border: 1px solid transparent;
                    cursor: pointer;
                    transition: transform .06s ease, box-shadow .2s ease, background .2s ease, color .2s ease, border-color .2s ease;
                }

                .btn:active {
                    transform: translateY(1px);
                }

                :root {
                    --green-700: #1a5d1a;
                    --green-500: #5dbb63;
                    --green-500-d: #4ba954;
                    --beige-100: #f5efd8;
                    --beige-150: #f3ebd3;
                    --text-900: #1f1f1f;
                    --text-700: #3a3a3a;
                    --line: #dddddd;
                }

                .btn-primary {
                    background: var(--green-500);
                    color: #fff;
                    box-shadow: 0 6px 14px rgba(26, 93, 26, .18);
                }

                .btn-primary:hover {
                    background: var(--green-500-d);
                }

                .btn-outline {
                    background: #fff;
                    color: var(--green-700);
                    border-color: var(--green-700);
                }

                .btn-outline:hover {
                    background: var(--beige-150);
                }

                .btn-ghost {
                    background: var(--beige-100);
                    color: var(--green-700);
                    border-color: var(--line);
                }

                .btn-ghost:hover {
                    background: #fff;
                    border-color: var(--green-700);
                }

                .btn-like {
                    background: #fff;
                    color: var(--text-900);
                    border-color: var(--line);
                }

                .btn-like:hover {
                    background: var(--beige-100);
                    border-color: var(--green-700);
                    color: var(--green-700);
                }

                #container>div button.btn {
                    margin-right: 8px;
                }

                #container>div+div button.btn {
                    margin-top: 8px;
                }

                /* 배너 쪽만 너무 커지지 않게 별도 제한(선택) */
                #img2 img {
                    width: auto;
                    /* 인라인 width:100%를 쓰셨다면 제거/무시 */
                    max-width: 100%;
                    display: block;
                }

                /* 클릭 가능한 아이콘처럼 보이게 */
                .heart-btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    /* 하트 색 (currentColor) */
                }

                .heart-btn:focus {
                    outline-offset: 2px;
                }

                .heart-btn:hover {
                    filter: brightness(0.95);
                }

                #view {
                    border: 1px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                    border-radius: 5px;
                    width: 300px;
                    height: 100px;
                }

                .iconbtn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    padding: 4px 8px;
                    border-radius: 8px;
                    text-decoration: none;
                    color: #666;
                    cursor: pointer;
                }

                .iconbtn .count {
                    font-style: normal;
                    color: #9aa0a6;
                }

                /* 레이아웃을 flex로 */
                .review-row {
                    display: flex;
                    align-items: flex-start;
                    gap: 16px;
                    margin: 12px 0;
                }

                /* 왼쪽 카드 고정폭, 기존 스타일 유지 */
                #view.review-card {
                    flex: 0 0 300px;
                    /* 고정 300px */
                    height: 100px;
                    /* 필요시 auto로 */
                    border: 1px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                    border-radius: 5px;
                }

                /* 오른쪽 칼럼은 남은 공간 차지 */
                .review-body {
                    flex: 1;
                    min-width: 0;
                    padding: 0 8px;
                }

                /* 긴 텍스트/이모지 줄바꿈 안정화 */
                .comment-text,
                .comment-line {
                    white-space: pre-wrap;
                    /* 개행 유지 + 줄바꿈 허용 */
                    word-break: keep-all;
                    /* 한글은 자연 줄바꿈 */
                    overflow-wrap: anywhere;
                    /* 긴 연속문자/URL 강제 줄바꿈 */
                }

                .comments {
                    margin-top: 6px;
                    padding-left: 0;
                }

                .muted {
                    color: #9aa0a6;
                }

                .review-sep {
                    margin: 8px 0;
                }

                .iconbtn svg {
                    width: 16px;
                    height: 16px;
                    flex: 0 0 auto;
                }

                .actions {
                    display: grid;
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                    gap: 10px 12px;
                    /* 위아래, 좌우 간격 */
                    max-width: 500px;
                    /* 내용 폭에 맞추고 싶으면 유지, 아니면 지워도 OK */
                }

                .actions .btn {
                    min-width: 0;
                    /* ← 기존 240px 무효화 */
                    width: 100%;
                    /* 그리드 칸을 꽉 채움 */
                }

                /* 기존 .iconbtn 그대로 사용 */
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="prod-wrap">
                            <div class="prod-media" id="img">
                                <img src="/resources/img/snowCrab.png" alt="">
                            </div>

                            <div class="prod-info" id="container">
                                <div id="store">윤자네 수산</div>
                                <div id="title">[경북 포항 김지윤] 구룡포 연지홍게 홍게제철 실속 가성비 3kg(10~12미)</div>

                                <div class="badge-row">
                                    <img src="/resources/img/sale.png" style="width: 62px;">
                                    <input v-model="shareUrl" type="hidden">
                                    <input v-model="shareTitle" type="hidden">

                                    <div class="share-wrap" style="margin-left: 350px;">
                                        <button type="button" class="share-icon-btn"
                                            @click.stop="shareOpen = !shareOpen" aria-label="공유">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                aria-hidden="true">
                                                <path
                                                    d="M15 7a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm0 16a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"
                                                    stroke="#333" stroke-width="1.5" />
                                                <path d="M5.5 12.5 12.5 6M5.5 11.5 12.5 17" stroke="#333"
                                                    stroke-width="1.5" />
                                            </svg>
                                        </button>
                                        <!-- 하트 토글 아이콘 (버튼 태그 없음) -->
                                        <span class="heart-btn" @click="liked = !liked"
                                            @keydown.space.prevent="liked = !liked"
                                            @keydown.enter.prevent="liked = !liked" role="button" :aria-pressed="liked"
                                            tabindex="0" aria-label="찜">
                                            <!-- 채워진 하트 -->
                                            <svg v-if="liked" width="20" height="20" viewBox="0 0 24 24"
                                                aria-hidden="true">
                                                <path
                                                    d="M12.1 21.35l-.1.1-.1-.1C7.14 17.24 4 14.36 4 10.9 4 8.5 5.9 6.6 8.3 6.6c1.4 0 2.75.65 3.7 1.68C12.95 7.25 14.3 6.6 15.7 6.6 18.1 6.6 20 8.5 20 10.9c0 3.46-3.14 6.34-7.9 10.45Z"
                                                    fill="currentColor" />
                                            </svg>

                                            <!-- 테두리 하트 -->
                                            <svg v-else width="20" height="20" viewBox="0 0 24 24" aria-hidden="true">
                                                <path
                                                    d="M12.1 21.35l-.1.1-.1-.1C7.14 17.24 4 14.36 4 10.9 4 8.5 5.9 6.6 8.3 6.6c1.4 0 2.75.65 3.7 1.68C12.95 7.25 14.3 6.6 15.7 6.6 18.1 6.6 20 8.5 20 10.9c0 3.46-3.14 6.34-7.9 10.45Z"
                                                    fill="none" stroke="currentColor" stroke-width="1.5" />
                                            </svg>
                                        </span>


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

                                <div id="price">15,900원</div>
                                <hr style="margin: 60px 0px;">
                                <div id="sub">
                                    <p style="line-height: 2px;">타 홍게류 보다 크기는 작지만 장맛이 일품인 연지홍게입니다</p>
                                    <p style="line-height: 2px;">가정에서 실속 가성비로 저렴하게 드셔보세요!</p>
                                    <p style="line-height: 2px;">모든 홍게는 고압스팀기 자숙 후 배송해드립니다</p>
                                </div>

                                <div v-if="fulfillment == 'delivery'">
                                    <div><span style="font-weight: bold;">원산지</span> 국산(구룡포)</div>
                                    <div><span style="font-weight: bold;">구매혜택</span> 318 포인트 적립예정</div>
                                    <div><span style="font-weight: bold;">배송비</span> 3,000원 | 도서산간 배송비 추가</div>
                                    <div><span style="font-weight: bold;">배송 안내</span> 배송비 3,000원</div>
                                </div>
                                <div v-else>
                                    <div><span style="font-weight: bold;">원산지</span> 국산(구룡포)</div>
                                    <div><span style="font-weight: bold;">구매혜택</span> 318 포인트 적립예정</div>
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
                                    <p v-if="week && before"><span style="color:#ff4100;">당일 15:00까지 결제</span>시 당일 바로
                                        발송됩니다.
                                    </p>
                                    <p v-else>오늘출발 마감되었습니다. (평일 15:00까지)</p>
                                </div>

                                <div style="margin: 50px 0px;">
                                    수율 상세페이지 참조 *
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
                                            <div>
                                                {{ it.name }}
                                                <button @click="removeExtra(i)" style="margin-left:270px">삭제</button>
                                            </div>
                                            <hr
                                                style="border-width:1px 0 0 0; border-style:dashed; border-color:#9d9c9c; width: 480px;">
                                            <div
                                                style="font-size:18px;font-weight:700; display:flex; align-items:center; gap:8px; margin-top:6px">
                                                <button @click="fnMinus(i)"
                                                    style="width: 30px; height: 30px;">-</button>
                                                <input v-model.number="it.qty" @input="recomputeTotal"
                                                    style="width: 50px; text-align: center; height: 24px; margin: 5px -9px;">
                                                <button @click="fnPlus(i)" style="width: 30px; height: 30px;">+</button>
                                                <span style="margin-left: auto;">{{ (it.price *
                                                    it.qty).toLocaleString()}}원</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="selections.length"
                                        style="margin-top:12px; text-align: right; font-size:20px; font-weight:800;">
                                        총 상품금액({{ totalQty }}개) {{ totalSum.toLocaleString() }}원
                                    </div>
                                    <div style="margin: 65px 0px;">
                                        <div class="actions">
                                            <button @click="fnPurchase" class="btn btn-primary">구매하기</button>
                                            <button @click="fnBasket" class="btn btn-outline">장바구니</button>
                                            <button @click="fnChat" class="btn btn-ghost">실시간 문의</button>
                                            <button @click="fnWish" class="btn btn-like">찜</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 탭: 단순 앵커 -->
                        <div class="irq">
                            <div class="tab"><a href="#in">상세정보</a></div>
                            <div class="tab"><a href="#re">구매평</a></div>
                            <div class="tab"><a href="#qa">Q&amp;A</a></div>
                        </div>

                        <!-- 섹션: 항상 표시, 클릭 시 해당 위치로 스크롤 -->
                        <section id="in">
                            <div id="img2"><img src="/resources/img/class.png" style="width: 100%;"></div>
                        </section>

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
                        <section id="re">
                            <div>
                                리뷰
                                <div style="text-align:right;">
                                    <a href="javascript:;" style="padding:0 8px; text-decoration: none;">추천순</a>
                                    <span
                                        style="display:inline-block; width:1px; height:12px; background:#ccc; vertical-align:middle;"></span>
                                    <a href="javascript:;" style="padding:0 8px; text-decoration: none;">최신순</a>
                                    <span
                                        style="display:inline-block; width:1px; height:12px; background:#ccc; vertical-align:middle;"></span>
                                    <a href="javascript:;" style="padding:0 8px; text-decoration: none;">별점 높은순</a>
                                    <span
                                        style="display:inline-block; width:1px; height:12px; background:#ccc; vertical-align:middle;"></span>
                                    <a href="javascript:;" style="padding:0 8px; text-decoration: none;">별점 낮은순</a>
                                </div>
                                <hr>
                                <div>
                                    <div class="review-row">
                                        <div id="view" class="review-card">
                                            <!-- 기존 카드 내용 그대로 -->
                                            <div style="display:flex;justify-content:space-between;">
                                                <div style="padding:15px 20px;">권혁준</div>
                                                <div style="padding:15px 20px;">2025.09.30</div>
                                            </div>
                                            <div style="display:flex;">
                                                <div style="padding:0 20px;">구매옵션</div>
                                                <div>가성비 B급 3kg (10~12미)</div>
                                            </div>
                                        </div>
                                        <div class="review-body">
                                            <div style="padding:8px 0; letter-spacing:4px; white-space:nowrap;">
                                                ★★★★★
                                            </div>
                                            <div class="comment-text">맛있네요</div>

                                            <a href="#" class="iconbtn" @click.prevent="toggleComments"
                                                :aria-expanded="commentOpen.toString()" aria-controls="cmt-1">
                                                <span aria-hidden="true" style="margin-right:6px;">
                                                    {{ commentOpen ? '▲' : '▼' }}
                                                </span>
                                                <span>댓글</span>
                                                <em class="count">{{ commentCount }}</em>
                                            </a>

                                            <section id="cmt-1" v-show="commentOpen" class="comments">
                                                <div v-if="comments.length === 0" class="muted">댓글이 없습니다.</div>
                                                <div v-else>
                                                    <div v-for="c in comments" :key="c.id" class="comment-line">{{
                                                        c.text }}</div>
                                                </div>
                                            </section>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <hr class="review-sep">
                                </div>
                            </div>
                        </section>
                        <section id="qa">
                            <div>
                                Q&amp;A
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
                        </section>
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
                        shareOpen: false,
                        shareUrl: window.location.href,
                        shareTitle: '',
                        selections: [],
                        totalSum: 0,
                        showDetail: false,
                        week: false,
                        before: false,
                        liked: false,
                        commentOpen: false,
                        commentCount: 0,
                        comments: []
                    }
                },
                computed: {
                    fulfillmentSel() { return this.deliveryOptions.find(o => o.value === this.fulfillment) || null; },
                    skuSel() { return this.skuOptions.find(o => o.value === this.sku) || null; },
                    totalQty() { return this.selections.reduce((n, it) => n + (it.qty || 0), 0); }
                },
                methods: {
                    alreadyAdded(opt) { return this.selections.some(s => s.sku === opt.value); },
                    pickFulfillment(opt) { this.fulfillment = opt.value; this.ddOpen1 = false; },
                    pickSku(opt) {
                        if (this.alreadyAdded(opt)) { alert("이미 추가한 옵션입니다."); this.ddOpen2 = false; return; }
                        this.selections.push({ sku: opt.value, name: opt.l1, price: opt.l2, qty: 1 });
                        this.sku = opt.value; this.ddOpen2 = false; this.recomputeTotal();
                    },
                    shareNaver() {
                        if (!this.shareUrl || !this.shareTitle) { alert('공유할 URL/제목이 비었습니다.'); return; }
                        let encUrl = encodeURI(encodeURIComponent(this.shareUrl));
                        let encTitle = encodeURI(this.shareTitle);
                        window.open("https://share.naver.com/web/shareView?url=" + encUrl + "&title=" + encTitle, "_blank");
                        this.shareOpen = false;
                    },
                    shareKakao() {
                        if (!(window.Kakao && window.Kakao.isInitialized && window.Kakao.isInitialized())) {
                            alert('카카오 SDK가 초기화되지 않았습니다.'); return;
                        }
                        window.Kakao.Share.sendDefault({
                            objectType: 'feed',
                            content: {
                                title: this.shareTitle || document.title,
                                description: '상품을 공유합니다',
                                imageUrl: location.origin + '/resources/img/snowCrab.png',
                                link: { webUrl: this.shareUrl || location.href, mobileWebUrl: this.shareUrl || location.href }
                            },
                            buttons: [{ title: '바로 보기', link: { webUrl: this.shareUrl || location.href, mobileWebUrl: this.shareUrl || location.href } }]
                        });
                        this.shareOpen = false;
                    },
                    shareCopy() {
                        let link = this.shareUrl || location.href;
                        (navigator.clipboard ? navigator.clipboard.writeText(link)
                            : new Promise(res => {
                                var ta = document.createElement('textarea'); ta.value = link; document.body.appendChild(ta);
                                ta.select(); document.execCommand('copy'); document.body.removeChild(ta); res();
                            })
                        ).then(() => alert('링크가 복사되었습니다.'));
                        this.shareOpen = false;
                    },
                    fnMinus(i) { const it = this.selections[i]; if (it && it.qty > 1) { it.qty--; this.recomputeTotal(); } },
                    fnPlus(i) { const it = this.selections[i]; if (it) { it.qty++; this.recomputeTotal(); } },
                    removeExtra(i) { this.selections.splice(i, 1); this.recomputeTotal(); },
                    recomputeTotal() { this.totalSum = this.selections.reduce((s, it) => s + it.price * it.qty, 0); },
                    openDetail() { this.showDetail = true; },
                    closeDetail() { this.showDetail = false; },
                    fnPurchase() { }, fnBasket() { }, fnWish() { },
                    toggleComments() {
                        this.commentOpen = !this.commentOpen;
                        // 처음 펼칠 때만 로드(실서비스에선 AJAX로 대체)
                        if (this.commentOpen && this.comments.length === 0) {
                            this.loadCommentsOnce();
                        }
                    },
                    loadCommentsOnce() {
                        // TODO: 실제 API 연동으로 교체
                        this.comments = [
                            { id: 1, text: '고객님, [경북 포항 김지윤] 구룡포 연지홍게 홍게제철 실속 가성비 3kg(10~12미) 구매해주시고 소중한 리뷰 남겨주셔서 진심으로 감사드립니다. 달큰하고 싱싱하게 드셨다니 저희도 정말 기쁩니다! 앞으로도 저희 대한민국농수산 직거래마켓에 많은 관심 부탁드리며, 또 찾아주시길 바라겠습니다. 😊' },
                            // 필요 시 더 추가
                        ];
                        this.commentCount = this.comments.length;
                    }
                },
                mounted() {
                    this.shareTitle = (document.getElementById('title')?.textContent || document.title).trim();
                    this._docHandler = () => { this.ddOpen1 = false; this.ddOpen2 = false; this.shareOpen = false; };
                    document.addEventListener('click', this._docHandler);
                    const now = new Date(), day = now.getDay(); this.week = day >= 1 && day <= 5; this.before = now.getHours() < 15;
                    if (location.hash) {
                        history.replaceState(null, '', location.pathname + location.search);
                        // window.scrollTo(0, 0);
                    }
                    window.addEventListener('pageshow', (e) => {
                        if (e.persisted) window.location.reload();
                    });
                },
                beforeUnmount() { document.removeEventListener('click', this._docHandler); }
            });
            app.mount('#app');
        </script>