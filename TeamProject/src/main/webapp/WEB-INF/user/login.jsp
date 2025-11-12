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

            .social-login a {
                display: block;
                width: 100%;
                text-decoration: none;
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
            height: 32px;
            width: auto;
            object-fit: contain;
            display: block;
        }

        .social-login button:hover {
            transform: scale(1.02);
            opacity: 0.95;
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
            border: none; 
            box-shadow: 0 0 0 1px #ddd inset;
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
                            <div class="input-group">
                                <label for="userId">아이디</label>
                                <input type="text" id="userId" v-model="userId" placeholder="아이디를 입력하세요" required>
                            </div>

                            <div class="input-group">
                                <label for="userPwd">비밀번호</label>
                                <input type="password" id="userPwd" v-model="userPwd" placeholder="비밀번호를 입력하세요" required @keyup.enter="fnLogin">
                            </div>

                            <button class="btn-login2" @click="fnLogin">로그인</button>

                            <!-- ✅ 소셜 로그인 -->
                            <div class="social-login">
                                <a href="/oauth2/authorization/kakao">
                                    <button type="button" class="kakao">
                                        <img src="${pageContext.request.contextPath}/resources/img/login-img/btn_login_kakao.png" alt="카카오 로그인">
                                    </button>
                                </a>
                                <a href="/oauth2/authorization/naver">
                                    <button type="button" class="naver">
                                        <img src="${pageContext.request.contextPath}/resources/img/login-img/btn_login_naver.png" alt="네이버 로그인">
                                    </button>
                                </a>
                                <a href="/oauth2/authorization/google">
                                    <button type="button" class="google">
                                        <img src="${pageContext.request.contextPath}/resources/img/login-img/btn_login_google.png" alt="구글 로그인">
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

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "",
                    userPwd: ""
                };
            },
            methods: {
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
                                location.href='${pageContext.request.contextPath}/main.do';
                            } else if (data.result == "WITHDRAWN_CAN_RECOVER") {
                                if (confirm(data.msg + "\n지금 계정을 복구하시겠습니까?")) {
                                    $.ajax({
                                        url: "/user/recover.dox", 
                                        dataType: "json",
                                        type: "POST",
                                        contentType: "application/json; charset=utf-8",
                                        data: JSON.stringify({ userId: self.userId }), 
                                        success: function(recoverResponse) {
                                            if (recoverResponse.result == "success") {
                                                alert("계정이 성공적으로 복구되었습니다. 다시 로그인해주세요.");
                                                location.reload();
                                            } else {
                                                alert(recoverResponse.msg || "계정 복구 중 오류가 발생했습니다.");
                                            }
                                        }, 
                                        error: function() {
                                            alert("계정 복구 서버와 통신 중 오류가 발생했습니다.");
                                        }
                                    });
                                } else { 
                                    alert("계정 복구를 취소했습니다.");
                                }
                            }
                            else { // 'fail' 메시지
                                alert(data.msg);
                                return;
                            }
                        },
                        error: function() { // AJAX 통신 자체의 에러
                            alert("로그인 서버와 통신 중 오류가 발생했습니다.");
                        }
                    });
                },
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('error') && urlParams.get('error') === 'true') {
                    const errorMessage = urlParams.get('message');
                    if (errorMessage) {
                        alert(decodeURIComponent(errorMessage));
                    } else {
                        alert("로그인에 실패했습니다.");
                    }
                }
            }
        });

        app.mount('#app');
    </script>