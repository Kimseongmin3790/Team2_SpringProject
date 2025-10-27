<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
            <c:set var="path" value="${pageContext.request.contextPath}" />
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
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    flex-direction: column;
                    gap: 30px;
                    text-align: center;
                }

                .content h2 {
                    color: #1a5d1a;
                    margin-bottom: 10px;
                    font-size: 26px;
                }

                .join-btn {
                    display: inline-block;
                    width: 250px;
                    padding: 15px 0;
                    border: none;
                    border-radius: 8px;
                    font-size: 18px;
                    font-weight: 600;
                    cursor: pointer;
                    color: white;
                    transition: all 0.3s ease;
                }

                .btn-buyer {
                    background: #5dbb63;
                }

                .btn-buyer:hover {
                    background: #4aa454;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(77, 167, 84, 0.3);
                }

                .btn-seller {
                    background: #1a5d1a;
                }

                .btn-seller:hover {
                    background: #144c14;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(26, 93, 26, 0.3);
                }

                .desc {
                    color: #666;
                    font-size: 15px;
                }
            </style>
        </head>

        <body>

            <div id="app">
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <h2>회원가입 유형을 선택해주세요</h2>

                        <div>
                            <a href="${path}/join.do">
                                <button class="join-btn btn-buyer">👤 일반 회원가입</button>
                            </a>
                            <p class="desc">소비자로 가입하여 상품을 구매할 수 있습니다.</p>
                        </div>

                        <div>
                            <a href="${path}/sellerJoin.do">
                                <button class="join-btn btn-seller">🏪 판매자 회원가입</button>
                            </a>
                            <p class="desc">판매자로 가입하여 상품을 등록하고 판매할 수 있습니다.</p>
                        </div>
                    </main>

                <!-- 공통 푸터 -->
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
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