<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>판매자 마이페이지 | AGRICOLA</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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

                .content {
                    flex: 1;
                    max-width: 1000px;
                    margin: 40px auto;
                    font-family: "Noto Sans KR", sans-serif;
                }

                .section {
                    background: #fff;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    padding: 20px;
                    margin-bottom: 30px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                }

                h2 {
                    color: #1a5d1a;
                    margin-bottom: 15px;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <h1>판매자 마이페이지</h1>

                        <div class="section" id="sectionPosts">
                            <h2>📢 내 글 목록</h2>
                            <div id="postList">데이터를 불러오는 중...</div>
                        </div>

                        <div class="section" id="sectionOrders">
                            <h2>🧾 주문 관리</h2>
                            <div id="orderList">데이터를 불러오는 중...</div>
                        </div>

                        <div class="section" id="sectionReviews">
                            <h2>⭐ 후기 확인</h2>
                            <div id="reviewList">데이터를 불러오는 중...</div>
                        </div>

                        <div class="section" id="sectionInfo">
                            <h2>🏪 내 정보 / 가게 정보</h2>
                            <div id="sellerInfo">데이터를 불러오는 중...</div>
                        </div>

                        <div class="section" id="sectionSettlement">
                            <h2>💰 정산 관리</h2>
                            <div id="settlementList">데이터를 불러오는 중...</div>
                        </div>

                        <div class="section" id="sectionWithdraw">
                            <h2>🚫 회원탈퇴</h2>
                            <button id="btnWithdraw">회원 탈퇴</button>
                        </div>
                    </main>

                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        sessionId: "${sessionId}"
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                            }
                        });
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                }
            });

            app.mount('#app');
        </script>