<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>신상품 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <link rel="stylesheet" href="${path}/resources/css/header.css">
            <link rel="stylesheet" href="${path}/resources/css/footer.css">

            <style>
                html,
                body {
                    height: 100%;
                    margin: 0;
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
                    margin: 50px auto;
                    padding: 0 20px;
                }

                .title {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 25px;
                }

                .product-list {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 25px;
                }

                .product-card {
                    background: #fff;
                    border-radius: 10px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    padding: 15px;
                    text-align: center;
                    cursor: pointer;
                }

                .product-card:hover {
                    transform: translateY(-3px);
                }

                .product-card img {
                    width: 100%;
                    height: 180px;
                    object-fit: cover;
                    border-radius: 8px;
                }

                .product-name {
                    font-weight: 600;
                    margin-top: 10px;
                    color: #333;
                }

                .product-price {
                    color: #1a5d1a;
                    font-weight: 700;
                    margin-top: 5px;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <h2 class="title">🌾 AGRICOLA 신상품</h2>
                        <div class="product-list">
                            <div v-for="p in list" :key="p.productNo" class="product-card"
                                @click="goInfo(p.productNo)">
                                <img :src="p.imageUrl" alt="상품 이미지">
                                <div class="product-name">{{ p.pName }}</div>
                                <div class="product-price">{{ p.price.toLocaleString() }}원</div>
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
                                    list: [],
                                    sessionId: "${sessionId}"
                                };
                            },
                            methods: {
                                fnList() {
                                    let self = this;
                                    $.ajax({
                                        url: "/newList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success: function (data) {
                                            self.list = data.list;
                                        },
                                        error: function () {
                                            alert("신상품을 불러오는 중 오류가 발생했습니다.");
                                        }
                                    });
                                },
                                goInfo(no) {
                                    location.href = this.path + "/productInfo.do?productNo=" + no;
                                }
                            },
                            mounted() {
                                this.fnList();
                            }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>