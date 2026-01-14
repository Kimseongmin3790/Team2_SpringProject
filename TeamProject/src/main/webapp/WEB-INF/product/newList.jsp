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
                    position: relative;
                    background: #fff;
                    border-radius: 12px;
                    border: 1px solid rgba(0, 0, 0, .06);
                    box-shadow: 0 2px 8px rgba(0, 0, 0, .08);
                    padding: 0;
                    /* 이미지와 텍스트 영역 분리 */
                    overflow: hidden;
                    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
                }

                .product-card:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 10px 18px rgba(0, 0, 0, .12);
                    border-color: rgba(0, 0, 0, .09);
                }

                .product-card img {
                    width: 100%;
                    aspect-ratio: 4 / 3;
                    object-fit: contain;
                    background: #f3f4f6;
                    display: block;
                    border-bottom: 1px solid rgba(0, 0, 0, .06);
                }

                /* 텍스트 공통 여백 */
                .product-card .product-name,
                .product-card .product-desc,
                .product-card .product-price,
                .product-card .date,
                .product-card .region,
                .product-card .seller {
                    margin-left: 14px;
                    margin-right: 14px;
                }

                /* 상품명 */
                .product-card .product-name {
                    margin-top: 12px;
                    margin-bottom: 6px;
                    color: #1a5d1a;
                    font-weight: 700;
                    font-size: 16px;
                    line-height: 1.35;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    /* 2줄 말줄임 */
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                /* 설명 */
                .product-card .product-desc {
                    margin-top: 0;
                    margin-bottom: 8px;
                    color: #667085;
                    font-size: 13px;
                    line-height: 1.5;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    /* 2줄 말줄임 */
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                /* 가격 */
                .product-card .product-price {
                    margin-top: 6px;
                    margin-bottom: 10px;
                    color: #ff8a00;
                    font-weight: 800;
                    font-size: 17px;
                }

                /* 메타(생산일/원산지/판매자) */
                .product-card .date,
                .product-card .region,
                .product-card .seller {
                    margin-bottom: 8px;
                    font-size: 12px;
                    color: #6b7280;
                    line-height: 1.4;
                }

                .product-card .seller {
                    color: #1a5d1a;
                    font-weight: 600;
                    margin-bottom: 14px;
                    /* 카드 하단 여백 */
                }

                .product-card {
                    cursor: pointer;
                }

                .product-card img {
                    cursor: inherit;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <h2 class="title">🌾 AGRICOLA 신상품</h2>
                        <div class="product-list">
                            <div v-for="p in list" :key="p.productNo" class="product-card" @click="goInfo(p.productNo)">
                                <img :src="getImage(p)" :alt="(p.pName || '상품') + ' 이미지'" loading="lazy"
                                    @error="onImgError" />
                                <div class="product-name">{{ p.pName }}</div>
                                <div class="product-desc">{{ p.pInfo }}</div>
                                <div class="product-price">{{ p.price.toLocaleString() }}원</div>
                                <div class="date">📅생산일: {{ p.cdate }}</div>
                                <div class="region">🌾원산지: {{ p.origin }}</div>
                                <div class="seller">👨‍🌾Agricola:{{p.businessName}}</div>
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
                                    sessionId: "${sessionId}",
                                    placeholder: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 400 300'><rect width='400' height='300' fill='%23f3f4f6'/><g fill='%239aa3af' font-family='sans-serif' text-anchor='middle'><text x='200' y='160' font-size='24'>이미지 없음</text></g></svg>"
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
                                },
                                getImage(p) {
                                    return (p.imageUrl && p.imageUrl.trim()) ? p.imageUrl : this.placeholder;
                                },
                                // 로드 실패시(404 등) 기본 이미지로 교체
                                onImgError(e) {
                                    if (e && e.target) {
                                        e.target.onerror = null; // 무한루프 방지
                                        e.target.src = this.placeholder;
                                    }
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