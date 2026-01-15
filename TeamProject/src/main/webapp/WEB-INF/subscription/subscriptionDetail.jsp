<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>정기배송 상세 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #faf8f0;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main.content {
                    flex: 1;
                    max-width: 1100px;
                    margin: 40px auto 60px;
                    padding: 0 20px;
                    box-sizing: border-box;
                }

                .btn-back {
                    background: #5dbb63;
                    color: #fff;
                    border: none;
                    border-radius: 8px;
                    padding: 8px 16px;
                    font-size: 0.9rem;
                    cursor: pointer;
                    margin-bottom: 18px;
                    transition: 0.2s;
                }

                .btn-back:hover {
                    background: #4ba954;
                }

                .detail-wrap {
                    display: flex;
                    gap: 24px;
                    align-items: flex-start;
                }

                .detail-left {
                    flex: 0 0 380px;
                }

                .detail-right {
                    flex: 1;
                }

                .hero-image {
                    width: 100%;
                    height: 320px;
                    border-radius: 12px;
                    object-fit: cover;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                    background-color: #eee;
                }

                .plan-title {
                    font-size: 1.6rem;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 8px;
                }

                .plan-short {
                    font-size: 0.95rem;
                    color: #555;
                    margin-bottom: 14px;
                }

                .chip-row {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    margin-bottom: 16px;
                }

                .chip {
                    border-radius: 999px;
                    padding: 4px 10px;
                    font-size: 0.8rem;
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                }

                .chip-period {
                    background: #e8f5e9;
                    color: #2e7d32;
                }

                .chip-status {
                    background: #fffbe6;
                    color: #a57c00;
                    border: 1px solid #ffe082;
                }

                .price-box {
                    background: #ffffff;
                    border-radius: 10px;
                    border: 1px solid #e0e0e0;
                    padding: 12px 14px;
                    margin-bottom: 20px;
                }

                .price-main {
                    font-size: 1.2rem;
                    font-weight: 700;
                    color: #388e3c;
                }

                .price-sub {
                    margin-top: 4px;
                    font-size: 0.85rem;
                    color: #777;
                }

                .section-title {
                    font-size: 1.1rem;
                    font-weight: 700;
                    color: #333;
                    margin: 24px 0 10px;
                }

                .desc-box {
                    background: #fff;
                    border-radius: 10px;
                    padding: 14px 16px;
                    border: 1px solid #eee;
                    font-size: 0.95rem;
                    color: #444;
                    line-height: 1.6;
                    white-space: pre-line;
                }

                .guide-list {
                    background: #fff;
                    border-radius: 10px;
                    padding: 14px 16px;
                    border: 1px solid #eee;
                    font-size: 0.9rem;
                    color: #555;
                }

                .guide-list ul {
                    margin: 0;
                    padding-left: 18px;
                }

                .guide-list li {
                    margin-bottom: 6px;
                }

                .cta-box {
                    margin-top: 18px;
                    display: flex;
                    gap: 10px;
                }

                .btn-cta-primary {
                    flex: 1;
                    height: 44px;
                    border-radius: 10px;
                    border: none;
                    background: linear-gradient(90deg, #4caf50, #5dbb63);
                    color: #fff;
                    font-size: 1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.2s;
                }

                .btn-cta-primary:hover {
                    box-shadow: 0 3px 10px rgba(93, 187, 99, 0.4);
                    transform: translateY(-1px);
                }

                .btn-cta-sub {
                    flex: 0 0 130px;
                    height: 44px;
                    border-radius: 10px;
                    border: 1px solid #ccc;
                    background: #fff;
                    color: #555;
                    font-size: 0.9rem;
                    cursor: pointer;
                }

                @media (max-width: 900px) {
                    .detail-wrap {
                        flex-direction: column;
                    }

                    .detail-left {
                        width: 100%;
                        flex: 1;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content" v-if="detail">
                        <button class="btn-back" @click="goBack">이전으로</button>

                        <div class="detail-wrap">
                            <div class="detail-left">
                                <img class="hero-image" :src="fullUrl(detail.imageUrl)" alt=""
                                    @error="onImgError($event)">
                            </div>

                            <div class="detail-right">
                                <h1 class="plan-title">{{ detail.planName }}</h1>
                                <div class="plan-short" v-if="detail.shortDesc">
                                    {{ detail.shortDesc }}
                                </div>

                                <div class="chip-row">
                                    <span class="chip chip-period">
                                        📅 {{ formatPeriod(detail.periodType) }}
                                    </span>
                                    <span class="chip chip-status"
                                        v-if="detail.isActive === 'Y' || detail.isActive === undefined">
                                        ✅ 신청 가능
                                    </span>
                                </div>

                                <div class="price-box">
                                    <div class="price-main">
                                        {{ formatPrice(detail.price) }}원 / {{ formatPeriod(detail.periodType) }}
                                    </div>
                                    <div class="price-sub">
                                        표기된 금액은 기본 구성 기준이며, 상세 구성 및 시즌에 따라 변동될 수 있습니다.
                                    </div>
                                </div>

                                <div class="cta-box">
                                    <button class="btn-cta-primary" @click="goSubscribe">
                                        정기배송 신청하기
                                    </button>
                                    <button class="btn-cta-sub" @click="goList">
                                        목록 보기
                                    </button>
                                </div>
                            </div>
                        </div>

                        <h2 class="section-title">상세 설명</h2>
                        <div class="desc-box">
                            {{ detail.description || '상세 설명이 준비 중입니다.' }}
                        </div>

                        <h2 class="section-title">정기배송 안내</h2>
                        <div class="guide-list">
                            <ul>                                                
                                <li>서울/수도권 외 지역은 배송 일정이 1~2일 추가 소요될 수 있습니다.</li>
                                <li>기상 상황, 산지 수급 상황 등에 따라 일부 구성품이 동급 품목으로 변경될 수 있습니다.</li>
                            </ul>
                        </div>
                    </main>

                    <main class="content" v-else>
                        로딩 중이거나, 플랜 정보를 찾을 수 없습니다.
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${pageContext.request.contextPath}",
                                    userId: "${sessionScope.sessionId}",
                                    planId: "${planId}",
                                    detail: null,
                                    plan: null
                                };
                            },
                            methods: {
                                fullUrl(u) {
                                    if (!u) return this.path + "/resources/img/no-image.png";
                                    if (/^https?:\/\//i.test(u)) return u;
                                    return this.path + (u.startsWith("/") ? u : "/" + u);
                                },
                                onImgError(e) {
                                    e.target.onerror = null;
                                    e.target.src = this.path + "/resources/img/no-image.png";
                                },
                                formatPrice(val) {
                                    if (val === null || val === undefined || val === "") return "0";
                                    const num = Number(val);
                                    return isNaN(num) ? val : num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                },
                                formatPeriod(type) {
                                    switch (type) {
                                        case "WEEKLY": return "주 1회";
                                        case "BIWEEKLY": return "격주 1회";
                                        case "MONTHLY": return "월 1회";
                                        default: return "정기배송";
                                    }
                                },
                                loadDetail() {
                                    const self = this;
                                    $.ajax({
                                        url: self.path + "/data/subscriptionDetail.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { planId: self.planId },
                                        success(res) {
                                            if (res.result === "success") {
                                                self.detail = res.detail;
                                            } else {
                                                alert("정기배송 상세 조회 중 오류가 발생했습니다.");
                                            }
                                        },
                                        error() {
                                            alert("서버 통신 중 오류가 발생했습니다.");
                                        }
                                    });
                                },
                                goBack() {
                                    if (document.referrer && document.referrer !== location.href) {
                                        history.back();
                                    } else {
                                        this.goList();
                                    }
                                },
                                goSubscribe() {
                                    if (!this.userId) {
                                        alert("로그인이 필요합니다.");
                                        location.href = this.path + "/login.do";
                                        return;
                                    }

                                    location.href = this.path + "/product/payment.do?mode=subscription&planId=" + this.planId + "&test=1";
                                },
                                goList() {
                                    location.href = this.path + "/subscription/list.do";
                                },
                                alertNotReady() {
                                    alert("정기배송 결제/신청 기능은 추후 구현 예정입니다.");
                                }
                            },
                            mounted() {
                                if (!this.userId) {
                                    alert("로그인이 필요한 페이지입니다.");
                                    location.href = this.path + "/login.do";
                                    return;
                                }

                                this.loadDetail();
                            }
                        });

                        app.mount("#app");
                    </script>

        </body>

        </html>