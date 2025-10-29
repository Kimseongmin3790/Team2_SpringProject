<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>agricola 로그인</title>
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
                font-family: "Noto Sans KR", sans-serif;
                background-color: #faf8f0;
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
                padding: 50px 20px;
            }

            /* 로그인 박스 */
            .login-container {
                background: linear-gradient(to bottom right, #f3ebd3, #f9f6e9);
                padding: 50px 60px;
                border-radius: 16px;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 420px;
                text-align: center;
                transition: 0.3s;
            }

            .login-container:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
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
                font-weight: 500;
            }

            .input-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }

            .btn-login2 {
                width: 100%;
                height: 52px;
                background-color: #5dbb63;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.25s ease;
                margin-bottom: 18px;
            }

            .btn-login2:hover {
                background-color: #4ca857;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(77, 167, 84, 0.3);
            }

            /* ✅ 소셜 로그인 이미지 버튼 */
            .social-login {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 15px;
            }

            .social-login a {
                display: block;
                width: 100%;
                height: 52px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: 0.2s ease;
                overflow: hidden;
            }

            .social-login button {
            width: 100%;
            padding: 8px 12px; 
            border: none;
            cursor: pointer;
            border-radius: 8px;
            overflow: hidden;
            transition: 0.25s;
            display: flex;
            justify-content: center;
            align-items: center;
            box-sizing: border-box;
        }

            .social-login img {
                width: auto;
                height: 70%;
                object-fit: contain;
            }

            .login-links {
                margin-top: 25px;
                font-size: 14px;
                color: #555;
            }

            .login-links a {
                color: #1a5d1a;
                text-decoration: none;
                margin: 0 6px;
                font-weight: 500;
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

            .social-login button.google {
                background-color: #fff;
                border: 1px solid #ddd;
            }

            .social-login button:hover {
                transform: scale(1.02);
                opacity: 0.9;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <div id="app">
                <main class="content">
                    <div class="login-container">
                        <h2 class="login-title">로그인</h2>
                        
                        <div class="input-group">
                            <label for="userId">아이디</label>
                            <input type="text" id="userId" v-model="userId" placeholder="아이디를 입력하세요" required>
                        </div>

                        <div class="input-group">
                            <label for="userPwd">비밀번호</label>
                            <input type="password" id="userPwd" v-model="userPwd" placeholder="비밀번호를 입력하세요" required
                                @keyup.enter="fnLogin">
                        </div>

                        <button class="btn-login2" @click="fnLogin">로그인</button>

                        <!-- ✅ 소셜 로그인 -->
                        <div class="social-login">
                            <a href="/oauth2/authorization/kakao">
                                <button type="button" class="kakao">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_kakao.png"
                                        alt="카카오 로그인">
                                </button>
                            </a>
                            <a href="/oauth2/authorization/naver">
                                <button type="button" class="naver">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_naver.png"
                                        alt="네이버 로그인">
                                </button>
                            </a>
                            <a href="/oauth2/authorization/google">
                                <button type="button" class="google">
                                    <img src="${pageContext.request.contextPath}/resources/img/btn_login_google.png"
                                        alt="구글 로그인">
                                </button>
                            </a>
                        </div>

                        <div class="login-links">
                            <a href="${pageContext.request.contextPath}/chooseJoin.do">회원가입</a> |
                            <a href="${pageContext.request.contextPath}/findId.do">아이디 찾기</a> |
                            <a href="${pageContext.request.contextPath}/findPwd.do">비밀번호 찾기</a>
                        </div>
                    </div>
                </main>
            </div>
            <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    userId: "",
                    userPwd: ""
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnLogin: function () {
                    let self = this;
                    if (!self.userId || !self.userPwd) {
                        alert("아이디와 비밀번호를 입력해주세요.");
                        return;
                    }
                    let param = {
                        userId: self.userId,
                        userPwd: self.userPwd
                    };
                    $.ajax({
                        url: "/login.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert(data.msg);
                                location.href = '${path}/main.do';
                            } else {
                                alert(data.msg);
                                return;
                            }
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