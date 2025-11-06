<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 | AGRICOLA</title>

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
        html, body { height: 100%; margin: 0; }
        #app { min-height: 100vh; display: flex; flex-direction: column; }
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
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 420px;
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

        .btn {
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
        .btn:hover { background-color: #4ca857; }

        .btn-secondary {
            background-color: #888;
        }
        .btn-secondary:hover {
            background-color: #666;
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
        .link-login a:hover { text-decoration: underline; }
    </style>
</head>

<body>
<div id="app">
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content">
        <div class="find-container">
            <h2 class="find-title">비밀번호 재설정</h2>

            <!-- 1단계: 이메일 인증 요청 -->
            <div v-if="step === 1">
                <div class="input-group">
                    <label>아이디</label>
                    <input type="text" v-model="userId" placeholder="가입한 아이디를 입력하세요">
                </div>

                <div class="input-group">
                    <label>이름</label>
                    <input type="text" v-model="userName" placeholder="가입 시 입력한 이름">
                </div>

                <div class="input-group">
                    <label>이메일</label>
                    <input type="email" v-model="userEmail" placeholder="가입 시 입력한 이메일">
                </div>

                <button class="btn" @click="fnSendEmail">인증코드 발송</button>
                <div class="result-box" v-if="emailSent">
                    ✅ 인증코드가 이메일로 전송되었습니다.
                </div>
                <div class="result-box" v-if="notFound">
                    ❌ 일치하는 회원정보가 없습니다.
                </div>
            </div>

            <!-- 2단계: 코드 인증 + 새 비밀번호 설정 -->
            <div v-if="step === 2">
                <div class="input-group">
                    <label>이메일 인증코드</label>
                    <input type="text" v-model="authCode" placeholder="이메일로 받은 코드를 입력하세요">
                </div>

                <div class="input-group">
                    <label>새 비밀번호</label>
                    <input type="password" v-model="newPwd" placeholder="새 비밀번호 입력">
                </div>

                <div class="input-group">
                    <label>비밀번호 확인</label>
                    <input type="password" v-model="newPwdChk" placeholder="비밀번호 확인">
                </div>

                <button class="btn" @click="fnResetPwd">비밀번호 재설정</button>
                <button class="btn btn-secondary" style="margin-top:10px;" @click="step=1">← 돌아가기</button>

                <div class="result-box" v-if="resetDone">
                    ✅ 비밀번호가 성공적으로 변경되었습니다.<br>
                    <a :href="path + '/login.do'">로그인하러 가기</a>
                </div>
                <div class="result-box" v-if="codeFail">
                    ❌ 인증코드가 올바르지 않습니다.
                </div>
            </div>

            <div class="link-login" v-if="step===1">
                <a :href="path + '/login.do'">로그인</a> | 
                <a :href="path + '/findId.do'">아이디 찾기</a>
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
            step: 1,               // 1단계: 이메일 입력, 2단계: 코드 확인
            userId: "",
            userName: "",
            userEmail: "",
            authCode: "",
            newPwd: "",
            newPwdChk: "",
            emailSent: false,
            notFound: false,
            resetDone: false,
            codeFail: false
        };
    },
    methods: {
        // ✅ 1단계: 인증코드 발송
        fnSendEmail() {
            let self = this;
            if (!self.userId || !self.userName || !self.userEmail) {
                alert("모든 항목을 입력해주세요.");
                return;
            }
            let param = {
                userId: self.userId,
                userName: self.userName,
                userEmail: self.userEmail
            };
            $.ajax({
                url: "/findPwdSendCode.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: (data) => {
                    if (data.result === "success") {
                        self.emailSent = true;
                        self.notFound = false;
                        self.step = 2;
                    } else {
                        self.emailSent = false;
                        self.notFound = true;
                    }
                }
            });
        },

        // ✅ 2단계: 코드 확인 + 비밀번호 변경
        fnResetPwd() {
            let self = this;
            if (!self.authCode || !self.newPwd || !self.newPwdChk) {
                alert("모든 항목을 입력해주세요.");
                return;
            }
            if (self.newPwd !== self.newPwdChk) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }
            let param = {
                userId: self.userId,
                userEmail: self.userEmail,
                authCode: self.authCode,
                newPwd: self.newPwd
            };
            $.ajax({
                url: "/findPwdReset.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: (data) => {
                    if (data.result === "success") {
                        self.resetDone = true;
                        self.codeFail = false;
                    } else {
                        self.resetDone = false;
                        self.codeFail = true;
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
