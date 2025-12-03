<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>지역별 특산물 상세 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <link rel="stylesheet" href="${path}/resources/css/header.css" />
            <link rel="stylesheet" href="${path}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background: #faf8f0;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                    max-width: 1200px;
                    margin: 60px auto 80px;
                    padding: 0 20px;
                }

                .header-box {
                    display: flex;
                    gap: 20px;
                    align-items: flex-start;
                    background: #fff;
                    border-radius: 12px;
                    padding: 20px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                    margin-bottom: 30px;
                }

                .header-box img {
                    width: 320px;
                    height: 220px;
                    object-fit: cover;
                    border-radius: 10px;
                }

                .header-info h2 {
                    margin: 0 0 10px;
                    font-size: 1.6rem;
                    color: #1a5d1a;
                }

                .header-info .region {
                    color: #388e3c;
                    font-weight: 600;
                    margin-bottom: 6px;
                }

                .header-info p {
                    margin: 0 0 8px;
                    color: #555;
                }

                .header-info .price {
                    font-size: 1.2rem;
                    font-weight: 700;
                    color: #d84315;
                    margin-top: 8px;
                }

                .sub-title {
                    font-size: 1.3rem;
                    font-weight: 600;
                    margin: 20px 0 10px;
                    color: #2e5d2e;
                }

                .product-list {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                .product-card {
                    background: #fff;
                    border-radius: 10px;
                    border: 1px solid #eee;
                    width: 260px;
                    padding-bottom: 10px;
                    cursor: pointer;
                    transition: transform .2s, box-shadow .2s;
                }

                .product-card:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
                }

                .product-card img {
                    width: 100%;
                    height: 160px;
                    object-fit: cover;
                    border-radius: 10px 10px 0 0;
                }

                .product-body {
                    padding: 10px 12px;
                    text-align: left;
                }

                .product-body h4 {
                    margin: 0 0 6px;
                    font-size: 1rem;
                    color: #333;
                }

                .product-body p {
                    margin: 0 0 6px;
                    font-size: 0.9rem;
                    color: #777;
                }

                .product-body .origin {
                    font-size: 0.85rem;
                    color: #888;
                }

                .product-body .price {
                    margin-top: 4px;
                    font-weight: 700;
                    color: #388e3c;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content" v-if="header">
                        <div class="header-box">
                            <img :src="fullUrl(header.imageUrl)" alt="">
                            <div class="header-info">
                                <div class="region">{{ header.regionName }}</div>
                                <h2>{{ header.title }}</h2>
                                <p v-if="header.description">{{ header.description }}</p>
                                <p class="price">기본 가격 {{ formatPrice(header.price) }}원~</p>
                            </div>
                        </div>

                        <h3 class="sub-title">구성 상품</h3>
                        <div class="product-list">
                            <div class="product-card" v-for="p in products" :key="p.productNo"
                                @click="goProduct(p.productNo)">
                                <img :src="fullUrl(p.imageUrl)" alt="">
                                <div class="product-body">
                                    <h4>{{ p.pname }}</h4>
                                    <p>{{ p.pinfo }}</p>
                                    <div class="origin">원산지: {{ p.origin }}</div>
                                    <div class="price">{{ formatPrice(p.price) }}원</div>
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
                                    path: "${path}",
                                    regionId: "${regionId}",  // Controller에서 model에 넣어준 값
                                    header: null,
                                    products: []
                                };
                            },
                            methods: {
                                fullUrl(u) {
                                    if (!u) return "";
                                    if (/^https?:\/\//i.test(u)) return u;
                                    return this.path + (u.startsWith("/") ? u : "/" + u);
                                },
                                formatPrice(val) {
                                    if (val === null || val === undefined || val === "") return "0";
                                    const num = Number(val);
                                    return isNaN(num) ? val : num.toLocaleString();
                                },
                                loadDetail() {
                                    const self = this;
                                    $.ajax({
                                        url: self.path + "/data/regionDetail.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { regionId: self.regionId },
                                        success: function (data) {
                                            if (data.result === "success") {
                                                self.header = data.header;
                                                self.products = data.products || [];
                                            } else {
                                                alert(data.message || "상세 조회에 실패했습니다.");
                                            }
                                        },
                                        error: function () {
                                            alert("서버 오류가 발생했습니다.");
                                        }
                                    });
                                },
                                goProduct(productNo) {
                                    location.href = this.path + "/productInfo.do?productNo=" + productNo;
                                }
                            },
                            mounted() {
                                this.loadDetail();
                            }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>