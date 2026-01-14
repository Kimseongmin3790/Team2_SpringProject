<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>농산물 정기배송 | AGRICOLA</title>

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
                    max-width: 1200px;
                    margin: 40px auto 60px;
                    padding: 0 20px;
                    box-sizing: border-box;
                }

                .page-title {
                    font-size: 1.9rem;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 10px;
                }

                .page-desc {
                    color: #666;
                    font-size: 0.95rem;
                    margin-bottom: 25px;
                }

                .filter-bar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    gap: 10px;
                    padding: 10px 14px;
                    background: #f7fff7;
                    border-radius: 10px;
                    border: 1px solid #e1f0e1;
                }

                .filter-left {
                    font-size: 0.9rem;
                    color: #567;
                }

                .filter-right {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                }

                .filter-right select {
                    padding: 6px 8px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                    font-size: 0.9rem;
                }

                .product-grid {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                .plan-card {
                    background: #fff;
                    border-radius: 12px;
                    border: 1px solid #eee;
                    width: calc(33.333% - 14px);
                    min-width: 260px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
                    cursor: pointer;
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                    transition: transform 0.2s ease, box-shadow 0.2s ease;
                }

                .plan-card:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                }

                .plan-image {
                    width: 100%;
                    height: 180px;
                    object-fit: cover;
                }

                .plan-body {
                    padding: 12px 14px 14px;
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                }

                .plan-name {
                    font-size: 1rem;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 6px;
                }

                .plan-short {
                    font-size: 0.9rem;
                    color: #777;
                    margin-bottom: 10px;
                }

                .plan-meta {
                    margin-top: auto;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 0.9rem;
                }

                .plan-period {
                    padding: 4px 8px;
                    border-radius: 999px;
                    background: #e8f5e9;
                    color: #2e7d32;
                    font-size: 0.8rem;
                }

                .plan-price {
                    font-weight: 700;
                    color: #388e3c;
                }

                .empty-text {
                    text-align: center;
                    padding: 40px 10px;
                    color: #777;
                }

                @media (max-width: 900px) {
                    .plan-card {
                        width: calc(50% - 10px);
                    }
                }

                @media (max-width: 600px) {
                    .plan-card {
                        width: 100%;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <h1 class="page-title">농산물 정기배송</h1>
                        <p class="page-desc">
                            제철 농산물을 주기적으로 받아보는 AGRICOLA 구독 서비스입니다. <br>
                            식단 패턴과 라이프스타일에 맞는 구독 플랜을 선택해 보세요.
                        </p>

                        <div class="filter-bar">
                            <div class="filter-left">
                                총 <strong>{{ filteredPlans.length }}</strong>개의 정기배송 플랜
                            </div>
                            <div class="filter-right">
                                <span style="font-size:0.9rem;color:#555;">주기 필터</span>
                                <select v-model="periodFilter">
                                    <option value="">전체</option>
                                    <option value="WEEKLY">주 1회</option>
                                    <option value="BIWEEKLY">격주 1회</option>
                                    <option value="MONTHLY">월 1회</option>
                                </select>
                            </div>
                        </div>

                        <div v-if="filteredPlans.length === 0" class="empty-text">
                            등록된 정기배송 플랜이 없습니다.
                        </div>

                        <div v-else class="product-grid">
                            <div class="plan-card" v-for="plan in filteredPlans" :key="plan.planId"
                                @click="goDetail(plan.planId)">
                                <img class="plan-image" :src="fullUrl(plan.imageUrl)" alt=""
                                    @error="onImgError($event)">
                                <div class="plan-body">
                                    <div class="plan-name">{{ plan.planName }}</div>
                                    <div class="plan-short">{{ plan.shortDesc }}</div>
                                    <div class="plan-meta">
                                        <span class="plan-period">{{ formatPeriod(plan.periodType) }}</span>
                                        <span class="plan-price">{{ formatPrice(plan.price) }}원</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${pageContext.request.contextPath}",
                                    plans: [],
                                    periodFilter: ""
                                };
                            },
                            computed: {
                                filteredPlans() {
                                    if (!this.periodFilter) {
                                        return this.plans;
                                    }
                                    return this.plans.filter(p => p.periodType === this.periodFilter);
                                }
                            },
                            methods: {
                                fullUrl(u) {
                                    if (!u) return this.path + "/resources/img/no-image.png";
                                    if (/^https?:\/\//i.test(u)) return u;
                                    return this.path + (u.startsWith("/") ? u : "/" + u);
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
                                onImgError(e) {
                                    e.target.onerror = null;
                                    e.target.src = this.path + "/resources/img/no-image.png";
                                },
                                loadList() {
                                    const self = this;
                                    $.ajax({
                                        url: self.path + "/data/subscriptionList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {},
                                        success(res) {
                                            if (res.result === "success") {
                                                self.plans = res.list || [];
                                            } else {
                                                alert("정기배송 목록 조회 중 오류가 발생했습니다.");
                                            }
                                        },
                                        error() {
                                            alert("서버 통신 중 오류가 발생했습니다.");
                                        }
                                    });
                                },
                                goDetail(planId) {
                                    location.href = this.path + "/subscription/detail.do?planId=" + planId;
                                }
                            },
                            mounted() {
                                this.loadList();
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>