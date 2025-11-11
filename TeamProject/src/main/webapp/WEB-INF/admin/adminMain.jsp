<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>관리자 대시보드</title>

            <!-- jQuery & Vue -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

            <!-- 공통 CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">


            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #f9f9f9;
                }

                .admin-container {
                    max-width: 1200px;
                    margin: 60px auto;
                    padding: 0 30px 60px;
                    box-sizing: border-box;
                }

                .admin-title {
                    text-align: center;
                    font-size: 2rem;
                    color: #2e5d2e;
                    margin-bottom: 40px;
                    font-weight: 700;
                }

                /* 카드 그리드 */
                .admin-grid {
                    display: flex;
                    flex-wrap: wrap;
                    /* 👉 줄바꿈 허용 */
                    justify-content: center;
                    /* 가운데 정렬 */
                    gap: 25px;
                    /* 카드 간 간격 */
                    margin-bottom: 40px;
                }

                .admin-card {
                    flex: 1 1 calc(20% - 25px);
                    /* 👉 5개 균등 (100% / 5) */
                    max-width: 230px;
                    /* 카드 최대 폭 */
                    min-width: 200px;
                    /* 너무 작아지지 않게 제한 */
                    background-color: #f3ebd3;
                    border-radius: 14px;
                    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
                    padding: 30px 20px;
                    text-align: center;
                    cursor: pointer;
                    transition: 0.25s ease;
                    box-sizing: border-box;
                    /* 👉 padding 포함 폭 계산 */
                }

                .admin-card:hover {
                    background-color: #e6d5b2;
                    transform: translateY(-5px);
                }

                .admin-card i {
                    font-size: 42px;
                    color: #4A773C;
                    margin-bottom: 10px;
                }

                .admin-card h3 {
                    font-size: 1.3rem;
                    margin: 8px 0 5px;
                    color: #1a5d1a;
                }

                .admin-card p {
                    font-size: 0.9rem;
                    color: #555;
                }

                /* 통계 영역 */
                .admin-stats {
                    margin-top: 60px;
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                    /* 4개 균등 */
                    gap: 25px;
                    justify-items: center;
                }

                .admin-stat-box {
                    background-color: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                    padding: 25px 40px;
                    text-align: center;
                    min-width: 280px;
                    width: 100%;
                    box-sizing: border-box;
                }

                .admin-stat-box h4 {
                    color: #2e5d2e;
                    margin-bottom: 8px;
                    font-size: 1rem;
                    font-weight: 600;
                }

                .admin-stat-box span {
                    display: block;
                    font-size: 1.6rem;
                    color: #4A773C;
                    font-weight: 700;
                }

                /* footer 상단 여백 보정 */
                .admin-bottom-space {
                    height: 40px;
                }


                /* ✅ 반응형 대응 */
                @media (max-width: 1200px) {
                    .admin-card {
                        flex: 1 1 calc(33.33% - 25px);
                        /* 👉 3개씩 */
                    }
                }

                @media (max-width: 992px) {
                    .admin-card {
                        flex: 1 1 calc(50% - 25px);
                        /* 👉 2개씩 */
                    }
                }

                @media (max-width: 600px) {
                    .admin-card {
                        flex: 1 1 100%;
                        /* 👉 1개씩 */
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">

                    <!-- ↓↓ 관리자 콘텐츠 래퍼 ↓↓ -->
                    <div class="admin-container">
                        <h2 class="admin-title">관리자 대시보드</h2>

                        <div class="admin-grid">
                            <div class="admin-card" @click="goPage('memberManage.do')">
                                <i class="fa-solid fa-users"></i>
                                <h3>회원관리</h3>
                                <p>회원 목록 / 판매자 인증</p>
                            </div>
                            <div class="admin-card" @click="goPage('productManage.do')">
                                <i class="fa-solid fa-box-open"></i>
                                <h3>상품관리</h3>
                                <p>상품 목록 / 상품 추천여부</p>
                            </div>
                            <div class="admin-card" @click="goPage('stats.do')">
                                <i class="fa-solid fa-chart-line"></i>
                                <h3>통계</h3>
                                <p>회원/ 매출 / 품목 / 가입자 통계 및 추이</p>
                            </div>
                            <div class="admin-card" @click="goPage('categoryManage.do')">
                                <i class="fa-solid fa-tags"></i>
                                <h3>카테고리 관리</h3>
                                <p>대/중/소 분류 관리</p>
                            </div>
                        </div>

                        <div class="admin-stats">
                            <div class="admin-stat-box">
                                <h4>전체 회원 수</h4>
                                <span>{{ stats.uCount }}</span>
                            </div>
                            <div class="admin-stat-box">
                                <h4>등록 상품 수</h4>
                                <span>{{ stats.pCount }}</span>
                            </div>
                            <div class="admin-stat-box">
                                <h4>총 주문 건수</h4>
                                <span>{{ stats.allOrderCount }}</span>
                            </div>
                            <div class="admin-stat-box">
                                <h4>오늘 주문 건수</h4>
                                <span>{{ stats.oCount }}</span>
                            </div>
                        </div>

                        <div class="admin-bottom-space"></div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}",
                                    stats: {}
                                };
                            },
                            methods: {
                                goPage(page) {
                                    const path = "${pageContext.request.contextPath}";
                                    location.href = path + "/admin/" + page;
                                },
                                fnLoadStats() {
                                    // this.stats = { members: 1342, products: 286, orders: 117 };
                                    let self = this;
                                    let param = {};
                                    $.ajax({
                                        url: "/dashboardCount.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            self.stats = data;
                                        }
                                    });
                                }
                            },
                            mounted() {
                                let self = this;
                                self.fnLoadStats();
                            }
                        });
                        app.mount('#app');
                    </script>
        </body>

        </html>