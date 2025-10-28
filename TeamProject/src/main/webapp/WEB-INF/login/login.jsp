<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
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
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: #faf8f0;
                padding: 50px 20px;
            }

            /* 로그인 박스 */
            .login-container {
                background: #f3ebd3;
                padding: 40px 50px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
                text-align: center;
                font-family: "Noto Sans KR", sans-serif;
            }

            .login-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 30px;
                color: #1a5d1a;
            }

            .input-group {
                margin-bottom: 20px;
                text-align: left;
            }

            .input-group label {
                display: block;
                font-size: 14px;
                margin-bottom: 5px;
                color: #333;
            }

            .input-group input {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }

            .btn-login2 {
                width: 100%;
                padding: 12px;
                background-color: #5dbb63;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.25s;
                margin-bottom: 10px;
            }

            .btn-login:hover {
                background-color: #4ca857;
            }

            /* ✅ 소셜 로그인 이미지 버튼 */
            .social-login {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 10px;
            }

            .social-login button {
                width: 100%;
                height: 50px;
                /* ✅ 로그인 버튼과 동일 높이 */
                border: none;
                background: none;
                padding: 0;
                cursor: pointer;
                border-radius: 8px;
                /* 동일한 모서리 라운드 */
                overflow: hidden;
                /* 이미지가 버튼 내부에 딱 맞게 */
                transition: 0.25s;
                background-color: #fff;
                /* ✅ 이미지 여백용 배경 */
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .social-login button:hover {
                transform: scale(1.02);
                opacity: 0.95;
            }

            .social-login img {
                width: auto;
                height: 80%;
                /* ✅ 버튼 높이에 맞춤 */
                object-fit: contain;
                /* 이미지 비율 유지하며 꽉 채움 */
                display: block;
            }

            .login-links {
                margin-top: 20px;
                font-size: 14px;
                color: #555;
            }

            .login-links a {
                color: #1a5d1a;
                text-decoration: none;
                margin: 0 6px;
            }

            .login-links a:hover {
                text-decoration: underline;
            }

            .social-login button.kakao {
                background-color: #FEE500;
            }

            .social-login button.naver {
                background-color: #03C75A;
            }

            .social-login button.google {
                background-color: #fff;
                border: 1px solid #ddd;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <main class="content">
                    <div class="login-container">
                        <h2 class="login-title">로그인</h2>

                        <form id="loginForm" method="post" action="${pageContext.request.contextPath}/loginProcess.do">
                            <div class="input-group">
                                <label for="userId">아이디</label>
                                <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>
                            </div>

                            <div class="input-group">
                                <label for="userPw">비밀번호</label>
                                <input type="password" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요" required>
                            </div>

                            <button type="submit" class="btn-login2">로그인</button>

                            <!-- ✅ 소셜 로그인 -->
                            <div class="social-login">
                                <button type="button" class="kakao"
                                    onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/kakao'">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_kakao.png"
                                        alt="카카오 로그인">
                                </button>

                                <button type="button" class="naver"
                                    onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/naver'">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_naver.png"
                                        alt="네이버 로그인">
                                </button>

                                <button type="button" class="google"
                                    onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/google'">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_google.png"
                                        alt="구글 로그인">
                                </button>
                            </div>

                            <div class="login-links">
                                <a href="${pageContext.request.contextPath}/join">회원가입</a> |
                                <a href="${pageContext.request.contextPath}/findId">아이디 찾기</a> |
                                <a href="${pageContext.request.contextPath}/findPw">비밀번호 찾기</a>
                            </div>
                        </form>
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