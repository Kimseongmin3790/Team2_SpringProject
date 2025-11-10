<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>추천 상품 | AGRICOLA</title>
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

                /* 이미지 래퍼 */
                .image-wrap {
                    position: relative;
                    border-radius: 8px;
                    overflow: hidden;
                    /* 배지가 둥근 모서리 밖으로 삐져나오지 않게 */
                }

                /* 순위 배지(기본) */
                .rank-badge {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    /* 오른쪽 상단을 원하면 right: 10px 로 바꾸세요 */
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    background: #1a5d1a;
                    /* 브랜드 그린 */
                    color: #fff;
                    font-weight: 800;
                    font-size: 16px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
                    user-select: none;
                    pointer-events: none;
                    /* 배지 클릭이 카드 클릭을 막지 않게 */
                }

                /* TOP3 강조 (선택) */
                .rank-1 {
                    background: #f1c40f;
                    color: #3a2c00;
                }

                /* 금 */
                .rank-2 {
                    background: #bdc3c7;
                    color: #2c3e50;
                }

                /* 은 */
                .rank-3 {
                    background: #cd7f32;
                    color: #fff;
                }

                /* 동 */

                /* 호버 시 살짝 올라가는 기존 효과 유지 */
                .product-card {
                    transition: transform .15s ease;
                }

                .product-card:hover {
                    transform: translateY(-3px);
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">
                    <main class="content">
                        <h2 class="title">🌿 AGRICOLA 베스트 상품</h2>
                        <div class="product-list">
                            <div v-for="(p, i) in list" :key="p.productNo" class="product-card"
                                @click="goInfo(p.productNo)">
                                <div class="image-wrap">
                                    <img :src="p.imageUrl" :alt="p.pName + ' 이미지'">
                                    <!-- 순위 배지 -->
                                    <span class="rank-badge"
                                        :class="{'rank-1': i === 0, 'rank-2': i === 1, 'rank-3': i === 2}">{{ i + 1
                                        }}</span>
                                    <!-- 1~4만 표시하려면 위 span에 v-if="i < 4" 추가 -->
                                </div>

                                <div class="product-name">{{ p.pName }}</div>
                                <div class="product-info">{{ p.pInfo }}</div>
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
                                        url: "/recommendList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success: function (data) {
                                            self.list = data.list;
                                        },
                                        error: function () {
                                            alert("추천 상품을 불러오는 중 오류가 발생했습니다.");
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