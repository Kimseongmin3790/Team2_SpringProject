<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>아이디 찾기 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                html,
                body {
                    height: 100%;
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
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
                    background: #faf8f0;
                    padding: 50px 20px;
                }

                .find-container {
                    background: #f3ebd3;
                    padding: 40px 50px;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    max-width: 420px;
                    width: 100%;
                    text-align: center;
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

                .radio-group {
                    display: flex;
                    justify-content: center;
                    gap: 20px;
                    margin-bottom: 20px;
                }

                .btn-find {
                    width: 100%;
                    height: 45px;
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.25s;
                }

                .btn-find:hover {
                    background: #4ca857;
                }

                .timer-label-inline {
                    color: #e74c3c;
                    font-weight: bold;
                    font-size: 14px;
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

                /* ✅ 버튼 기본 스타일 (회원가입 페이지와 통일) */
                .input-wrapper button {
                    background-color: #5dbb63;
                    border: none;
                    color: white;
                    padding: 8px 14px;
                    border-radius: 8px;
                    font-size: 13px;
                    font-weight: 600;
                    margin-left: 8px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .input-wrapper button:hover {
                    background-color: #4ba954;
                    transform: translateY(-2px);
                    box-shadow: 0 3px 8px rgba(76, 169, 84, 0.3);
                }

                /* ✅ 버튼 안 글씨 수평 정렬 */
                .input-wrapper {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                /* ✅ 타이머 텍스트 */
                .timer-label-inline {
                    color: #e74c3c;
                    font-weight: bold;
                    font-size: 14px;
                    white-space: nowrap;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="find-container">
                            <h2 class="find-title">아이디 찾기</h2>

                            <!-- ✅ 찾기 방식 선택 -->
                            <div class="radio-group">
                                <label><input type="radio" value="email" v-model="searchType"> 이메일로 찾기</label>
                                <label><input type="radio" value="phone" v-model="searchType"> 휴대폰으로 찾기</label>
                            </div>

                            <div class="input-group">
                                <label>이름</label>
                                <input type="text" v-model="userName" placeholder="가입 시 입력한 이름">
                            </div>

                            <!-- ✅ 이메일 찾기 -->
                            <div v-if="searchType === 'email'" class="input-group">
                                <label>이메일</label>
                                <input type="email" v-model="userEmail" placeholder="가입 시 입력한 이메일">
                            </div>

                            <!-- ✅ 휴대폰 찾기 -->
                            <div v-if="searchType === 'phone'" class="input-group">
                                <label>휴대폰 번호</label>
                                <div class="input-wrapper" style="display:flex; gap:10px;">
                                    <input type="text" v-model="userPhone" placeholder="01012345678">
                                    <button @click="fnSendCode">인증번호 전송</button>
                                </div>
                            </div>

                            <div v-if="smsFlg && searchType === 'phone'" class="input-group">
                                <label>인증번호 입력</label>
                                <div class="input-wrapper" style="display:flex; gap:10px; align-items:center;">
                                    <input type="text" v-model="verifyCode" placeholder="인증번호 6자리">
                                    <button @click="fnVerifyCode">확인</button>
                                    <span v-if="count > 0" class="timer-label-inline">{{ timer }}</span>
                                </div>
                            </div>

                            <button class="btn-find" @click="fnFindId">아이디 찾기</button>

                            <!-- ✅ 결과 표시 -->
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
                            userPhone: "",
                            verifyCode: "",
                            searchType: "email", // 기본값
                            userInfo: {},
                            found: false,
                            notFound: false,
                            // 문자 인증 관련
                            smsFlg: false,
                            count: 0,
                            timer: "",
                            timerInterval: null,
                            phoneVerified: false
                        };
                    },
                    methods: {
                        fnFindId() {
                            let self = this;
                            self.found = false; self.notFound = false;

                            if (!self.userName) {
                                Swal.fire('⚠️', '이름을 입력해주세요.', 'warning');
                                return;
                            }

                            // 이메일로 찾기
                            if (self.searchType === "email") {
                                if (!self.userEmail) {
                                    Swal.fire('⚠️', '이메일을 입력해주세요.', 'warning');
                                    return;
                                }
                                $.ajax({
                                    url: "/findId.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { userName: self.userName, userEmail: self.userEmail },
                                    success: function (data) {
                                        if (data.result == "success") {
                                            self.userInfo = data.user;
                                            self.found = true;
                                        } else {
                                            self.notFound = true;
                                        }
                                    }
                                });
                            }
                            // 휴대폰으로 찾기
                            else if (self.searchType === "phone") {
                                if (!self.phoneVerified) {
                                    Swal.fire('⚠️', '휴대폰 인증을 완료해주세요.', 'warning');
                                    return;
                                }
                                $.ajax({
                                    url: "/findIdByPhone.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { userName: self.userName, userPhone: self.userPhone },
                                    success: function (data) {
                                        if (data.result == "success") {
                                            self.userInfo = data.user;
                                            self.found = true;
                                        } else {
                                            self.notFound = true;
                                        }
                                    }
                                });
                            }
                        },
                        fnSendCode() {
                            let self = this;
                            const phoneRegex = /^01[0-9]\d{7,8}$/;
                            if (!phoneRegex.test(self.userPhone)) {
                                Swal.fire('⚠️', '휴대폰 번호를 올바르게 입력해주세요.', 'warning');
                                return;
                            }
                            $.ajax({
                                url: self.path + "/send-one",
                                type: "POST",
                                dataType: "json",
                                data: { phone: self.userPhone },
                                success: function (data) {
                                    if (data.result === "success" || data.res) {
                                        Swal.fire('✅', '인증번호가 발송되었습니다.', 'success');
                                        self.smsFlg = true;
                                        self.fnTimer();
                                    } else {
                                        Swal.fire('❌', '문자 발송 실패', 'error');
                                    }
                                }
                            });
                        },
                        fnVerifyCode() {
                            let self = this;
                            $.ajax({
                                url: self.path + "/verify-code",
                                type: "POST",
                                dataType: "json",
                                data: { phone: self.userPhone, code: self.verifyCode },
                                success: function (data) {
                                    if (data.result === "success") {
                                        Swal.fire('✅', '휴대폰 인증이 완료되었습니다.', 'success');
                                        self.phoneVerified = true;
                                        clearInterval(self.timerInterval);
                                        self.timer = "";
                                    } else {
                                        Swal.fire('❌', '인증번호가 일치하지 않습니다.', 'error');
                                    }
                                }
                            });
                        },
                        fnTimer: function () {
                            let self = this;

                            self.count = 180;

                            self.timerInterval = setInterval(function () {
                                if (self.count <= 0) {
                                    clearInterval(self.timerInterval);
                                    this.timer = "00 : 00";
                                    Swal.fire("⏰", "시간이 만료되었습니다.", "warning");
                                } else {
                                    let min = parseInt(self.count / 60);
                                    let sec = self.count % 60;
                                    min = min < 10 ? "0" + min : min;
                                    sec = sec < 10 ? "0" + sec : sec;
                                    self.timer = min + " : " + sec;

                                    self.count--;
                                }
                            }, 1000);
                        },
                    }
                });
                app.mount('#app');
            </script>
        </body>

        </html>