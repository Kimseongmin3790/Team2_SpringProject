<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>아이디 찾기 | AGRICOLA</title>

            <!-- ✅ jQuery -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

            <!-- ✅ Vue -->
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <!-- ✅ 공통 CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <!-- ✅ 페이지 전용 스타일 -->
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

                .find-container {
                    background: #f3ebd3;
                    padding: 40px 50px;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 400px;
                    text-align: center;
                    font-family: "Noto Sans KR", sans-serif;
                }

                .find-title {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 25px;
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
                }

                .btn-find {
                    width: 100%;
                    height: 45px;
                    background-color: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.25s;
                }

                .btn-find:hover {
                    background-color: #4ca857;
                }

                .result-box {
                    margin-top: 20px;
                    font-size: 15px;
                    color: #333;
                }

                .link-login {
                    margin-top: 15px;
                    font-size: 14px;
                }

                .link-login a {
                    color: #1a5d1a;
                    text-decoration: none;
                }

                .link-login a:hover {
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="find-container">
                            <h2 class="find-title">아이디 찾기</h2>

                            <div class="input-group">
                                <label>이름</label>
                                <input type="text" v-model="userName" placeholder="가입 시 입력한 이름">
                            </div>

                            <div class="input-group">
                                <label>이메일</label>
                                <input type="email" v-model="userEmail" placeholder="가입 시 입력한 이메일">
                            </div>

                            <button class="btn-find" @click="fnFindId">아이디 찾기</button>

                            <div class="result-box" v-if="found">
                                ✅ 회원님의 아이디는 <b>{{ userInfo.userId }}</b> 입니다.
                            </div>
                            <div class="result-box" v-if="notFound">
                                ❌ 일치하는 회원정보가 없습니다.
                            </div>

                            <div class="link-login">
                                <a :href="path + '/login.do'">로그인</a> |
                                <a :href="path + '/findPwd.do'">비밀번호 찾기</a>
                            </div>
                        </div>
                    </main>

                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>

            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            path: "${pageContext.request.contextPath}",
                            userName: "",
                            userEmail: "",
                            userInfo: {},
                            found: false,
                            notFound: false
                        };
                    },
                    methods: {
                        fnFindId() {
                            let self = this;
                            self.notFound = false;
                            let param = {
                                userName: self.userName,
                                userEmail: self.userEmail
                            };
                            if (!self.userName || !self.userEmail) {
                                alert("이름과 이메일을 모두 입력해주세요.");
                                return;
                            }
                            $.ajax({
                                url: "/findId.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    if (data.result == "success") {
                                        console.log(data);
                                        self.userInfo = data.user;
                                        self.found = true;
                                    } else {
                                        self.notFound = true;
                                    }
                                }
                            });
                        }
                    }
                });
                app.mount('#app');
            </script>
        </body>

        </html>