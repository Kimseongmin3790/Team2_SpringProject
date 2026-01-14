<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>지역별 특산물 배송 | AGRICOLA</title>

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

                main.content {
                    flex: 1;
                    max-width: 1200px;
                    margin: 60px auto 80px;
                    padding: 0 20px;
                }

                .title {
                    font-size: 1.8rem;
                    font-weight: 800;
                    color: #1a5d1a;
                    text-align: center;
                    margin-bottom: 8px;
                }

                .desc {
                    text-align: center;
                    color: #666;
                    margin-bottom: 30px;
                }

                .grid {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 20px;
                    justify-content: center;
                }

                .card {
                    width: 280px;
                    background: #fff;
                    border: 1px solid #eee;
                    border-radius: 12px;
                    overflow: hidden;
                    cursor: pointer;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, .08);
                    transition: .2s;
                }

                .card:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 4px 10px rgba(0, 0, 0, .12);
                }

                .thumb {
                    width: 100%;
                    height: 180px;
                    object-fit: cover;
                    display: block;
                }

                .body {
                    padding: 12px 14px;
                }

                .region {
                    color: #388e3c;
                    font-weight: 700;
                    font-size: .95rem;
                }

                .t {
                    margin: 6px 0 8px;
                    font-size: 1.05rem;
                    font-weight: 800;
                    color: #333;
                    line-height: 1.3;
                }

                .d {
                    margin: 0;
                    color: #777;
                    font-size: .9rem;
                    line-height: 1.4;
                    min-height: 40px;
                }

                .price {
                    margin-top: 10px;
                    color: #d84315;
                    font-weight: 900;
                    font-size: 1.05rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <div class="title">지역별 특산물 배송</div>
                        <div class="desc">전국 산지의 특산품을 한 박스로 받아보는 서비스</div>

                        <div v-if="loading" style="text-align:center;padding:40px;">로딩 중...</div>
                        <div v-else class="grid">
                            <div class="card" v-for="box in list" :key="box.regionId" @click="goDetail(box.regionId)">
                                <img class="thumb" :src="fullUrl(box.imageUrl)" @error="imgError" alt="">
                                <div class="body">
                                    <div class="region">{{ box.regionName }}</div>
                                    <div class="t">{{ box.title }}</div>
                                    <p class="d">{{ box.description }}</p>
                                    <div class="price">{{ formatPrice(box.price) }}원~</div>
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
                                    list: [],
                                    loading: true,
                                    noImg: "${path}/resources/img/no-image.png"
                                };
                            },
                            methods: {
                                fullUrl(u) {
                                    if (!u) return this.noImg;
                                    if (/^https?:\/\//i.test(u)) return u;
                                    return this.path + (u.startsWith("/") ? u : "/" + u);
                                },
                                formatPrice(v) {
                                    const n = Number(v);
                                    return isNaN(n) ? (v || "0") : n.toLocaleString();
                                },
                                imgError(e) { e.target.src = this.noImg; },
                                load() {
                                    $.ajax({
                                        url: this.path + "/data/regionList.dox",
                                        type: "GET",
                                        dataType: "json",
                                        success: (res) => {
                                            if (res.result === "success") this.list = res.list || [];
                                            else alert(res.message || "리스트 조회 실패");
                                        },
                                        error: () => alert("서버 오류"),
                                        complete: () => this.loading = false
                                    });
                                },
                                goDetail(regionId) {
                                    location.href = this.path + "/region/specialDetail.do?regionId=" + regionId;
                                }
                            },
                            mounted() { this.load(); }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>