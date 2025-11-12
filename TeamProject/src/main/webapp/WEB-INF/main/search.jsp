<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>검색 결과 | AGRICOLA</title>

            <!-- ✅ header, footer CSS만 로드 -->
            <link rel="stylesheet" href="${path}/resources/css/header.css">
            <link rel="stylesheet" href="${path}/resources/css/footer.css">

            <!-- ✅ jQuery는 header.jsp에서 이미 로드됨 -->
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

            <style>
                :root {
                    --brand-ink: #1a5d1a;
                    --brand-green: #5dbb63;
                    --paper: #faf8f0;
                    --muted: #667085;
                    --accent: #ff8a00;
                    --line: rgba(0, 0, 0, 0.06);
                }

                html,
                body {
                    margin: 0;
                    padding: 0;
                    background: var(--paper);
                    font-family: "Noto Sans KR", sans-serif;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main.content {
                    flex: 1;
                    padding: 50px 60px;
                }

                /* 카드 그리드 */
                .product-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                    gap: 24px;
                }

                /* 카드 */
                .product-card {
                    background: #fff;
                    border-radius: 14px;
                    border: 1px solid var(--line);
                    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.06);
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                    cursor: pointer;
                    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
                }

                .product-card:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 10px 18px rgba(0, 0, 0, 0.12);
                    border-color: rgba(0, 0, 0, 0.09);
                }

                .product-card:active {
                    transform: translateY(-1px);
                }

                /* 이미지: 일정 비율 유지 */
                .product-card img {
                    width: 100%;
                    aspect-ratio: 4 / 3;
                    /* 이미지를 고르게 */
                    object-fit: cover;
                    display: block;
                }

                /* 텍스트 공통 여백 */
                .product-card .product-name,
                .product-card .product-desc,
                .product-card .product-price,
                .product-card .date,
                .product-card .region,
                .product-card .seller {
                    margin-left: 12px;
                    margin-right: 12px;
                }

                /* 상품명 */
                .product-name {
                    margin-top: 12px;
                    margin-bottom: 6px;
                    color: var(--brand-ink);
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
                .product-desc {
                    margin-top: 0;
                    margin-bottom: 8px;
                    color: var(--muted);
                    font-size: 13px;
                    line-height: 1.5;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    /* 2줄 말줄임 */
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                /* 가격 */
                .product-price {
                    margin-top: 6px;
                    margin-bottom: 10px;
                    color: var(--accent);
                    font-weight: 800;
                    font-size: 17px;
                }

                /* 메타 정보(생산일/원산지/판매자) */
                .date,
                .region,
                .seller {
                    margin-bottom: 8px;
                    font-size: 12px;
                    color: #6b7280;
                    /* 중간 회색 */
                    line-height: 1.4;
                }

                .seller {
                    color: var(--brand-ink);
                    font-weight: 600;
                    margin-bottom: 12px;
                    /* 카드 하단과 거리 */
                }

                /* 결과 없음 */
                .no-result {
                    text-align: center;
                    color: #555;
                    font-size: 16px;
                    margin-top: 40px;
                }

                /* 반응형 */
                @media (max-width: 900px) {
                    main.content {
                        padding: 32px 20px;
                    }

                    .product-grid {
                        gap: 18px;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    }
                }

                @media (max-width: 480px) {
                    .product-grid {
                        grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                    }

                    .product-name {
                        font-size: 15px;
                    }

                    .product-price {
                        font-size: 16px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- ✅ header.jsp에는 이미 jQuery + header.js 포함 -->
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <!-- ✅ Vue mount 영역(header/footer 밖) -->
                <div id="app">
                    <main class="content">
                        <div v-if="list.length > 0">
                            <h3>"{{ keyword }}" 검색 결과</h3>

                            <div class="product-grid">
                                <div class="product-card" v-for="p in list" :key="p.productNo"
                                    @click="goProduct(p.productNo)">
                                    <img :src="p.imageUrl" :alt="p.pName">
                                    <div class="product-name">{{ p.pName }}</div>
                                    <div class="product-desc">{{ p.pInfo }}</div>
                                    <div class="product-price">{{ p.price.toLocaleString() }}원</div>
                                    <div class="date">📅생산일: {{ p.cdate }}</div>
                                    <div class="region">🌾원산지: {{ p.origin }}</div>
                                    <div class="seller">👨‍🌾Agricola:{{p.businessName}}</div>
                                </div>
                            </div>
                        </div>

                        <div v-else class="no-result">
                            "{{ keyword }}"에 대한 검색 결과가 없습니다.
                        </div>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <!-- ✅ Vue 전용 코드 -->
                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    keyword: "${keyword}",
                                    list: JSON.parse('${list}'),
                                    path: "${path}"
                                };
                            },
                            methods: {
                                goProduct(productNo) {
                                    location.href = this.path + "/productInfo.do?productNo=" + productNo;
                                }
                            },
                            mounted() {
                                // ✅ search.jsp에서 header.js 이벤트가 안 먹을 경우 대비 (보정)
                                // 로고 클릭 복구
                                if ($("#logoClick").length && !$._data($("#logoClick")[0], "events")) {
                                    $("#logoClick").on("click", () => location.href = this.path + "/main.do");
                                }

                                // 카테고리 hover/dropdown 복구
                                if ($(".category-container").length && !$._data($("#btnCategory")[0], "events")) {
                                    $(".category-container").hover(
                                        function () { $("#dropdownMenu").addClass("active"); },
                                        function () { $("#dropdownMenu").removeClass("active"); }
                                    );
                                    $("#btnCategory").on("click", function () {
                                        $("#dropdownMenu").toggleClass("active");
                                    });
                                }
                            }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>