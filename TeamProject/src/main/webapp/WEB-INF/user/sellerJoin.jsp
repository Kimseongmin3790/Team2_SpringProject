<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>판매자 회원가입 | AGRICOLA</title>

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

                .join-container {
                    background: #f3ebd3;
                    padding: 40px 50px;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 550px;
                    font-family: "Noto Sans KR", sans-serif;
                }

                .join-title {
                    font-size: 24px;
                    font-weight: 700;
                    text-align: center;
                    color: #1a5d1a;
                    margin-bottom: 30px;
                }

                .input-group {
                    margin-bottom: 18px;
                }

                .input-group label {
                    display: block;
                    font-size: 14px;
                    margin-bottom: 5px;
                    color: #333;
                }

                .input-group input,
                .input-group select {
                    width: 100%;
                    padding: 10px 12px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                    box-sizing: border-box;
                }

                .terms {
                    margin-top: 20px;
                    padding: 15px;
                    background: #f7f7f7;
                    border: 1px solid #ddd;
                    border-radius: 6px;
                    font-size: 13px;
                    line-height: 1.6;
                    color: #555;
                    max-height: 120px;
                    overflow-y: auto;
                }

                .check-terms {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-top: 10px;
                    font-size: 14px;
                }

                .btn-join2 {
                    width: 100%;
                    height: 50px;
                    margin-top: 25px;
                    background-color: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.25s;
                }

                .btn-join:hover {
                    background-color: #4ca857;
                }

                .link-login {
                    text-align: center;
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
                        <div class="join-container">
                            <h2 class="join-title">판매자 회원가입</h2>

                            <!-- ✅ Vue 데이터 바인딩 -->
                            <div class="input-group">
                                <label>아이디</label>
                                <input type="text" v-model="userId" placeholder="아이디를 입력하세요">
                                <button @click="fnCheck">중복확인</button>
                            </div>

                            <div class="input-group">
                                <label>비밀번호</label>
                                <input type="password" v-model="userPwd" placeholder="비밀번호를 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>비밀번호 확인</label>
                                <input type="password" v-model="userPwdChk" placeholder="비밀번호를 다시 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>이름</label>
                                <input type="text" v-model="userName" placeholder="이름을 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>이메일</label>
                                <input type="email" v-model="userEmail" placeholder="이메일 주소를 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>주소</label>
                                <input type="text" v-model="userAddr" placeholder="주소를 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>휴대폰</label>
                                <input type="text" v-model="userPhone" placeholder="휴대폰 번호를 입력하세요">
                            </div>

                            <!-- ✅ 판매자 전용 항목 -->
                            <div class="input-group">
                                <label>농가명</label>
                                <input type="text" v-model="farmName" placeholder="농가명을 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>농가 인증유형</label>
                                <select v-model="certType">
                                    <option value="">선택하세요</option>
                                    <option value="GAP">GAP 인증</option>
                                    <option value="유기농">유기농 인증</option>
                                    <option value="무농약">무농약 인증</option>
                                    <option value="유기가공식품">유기가공식품 인증</option>
                                    <option value="인증 없음">인증 없음</option>
                                </select>
                            </div>

                            <div class="input-group">
                                <label>사업자등록번호</label>
                                <input type="text" v-model="bizNo" placeholder="예: 123-45-67890">
                            </div>

                            <div class="input-group">
                                <label>정산 계좌정보</label>
                                <div class="account-group">
                                    <select v-model="bankName">
                                        <option value="">은행 선택</option>
                                        <option value="KB국민은행">국민은행</option>
                                        <option value="신한은행">신한은행</option>
                                        <option value="우리은행">우리은행</option>
                                        <option value="하나은행">하나은행</option>
                                        <option value="농협은행">농협은행</option>
                                        <option value="IBK기업은행">기업은행</option>
                                        <option value="SC제일은행">SC제일은행</option>
                                        <option value="부산은행">부산은행</option>
                                        <option value="대구은행">대구은행</option>
                                        <option value="카카오뱅크">카카오뱅크</option>
                                        <option value="토스뱅크">토스뱅크</option>
                                    </select>
                                    <input type="text" v-model="account" placeholder="계좌번호 입력">
                                </div>
                            </div>

                            <div class="terms">
                                판매자 회원 약관<br><br>
                                1. 판매자는 관련 법규에 따라 올바른 상품을 판매해야 합니다.<br>
                                2. 사업자 정보 및 정산 계좌는 정확히 기입해야 합니다.<br>
                                3. 인증유형이 허위로 판명될 경우, 계정이 제한될 수 있습니다.
                            </div>

                            <div class="check-terms">
                                <input type="checkbox" v-model="agree">
                                <label>위 약관에 동의합니다.</label>
                            </div>

                            <button class="btn-join2" @click="fnSellerJoin">판매자 회원가입</button>

                            <div class="link-login">
                                이미 판매자이신가요? <a :href="path + '/login.do'">로그인</a>
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
                            userId: "",
                            userPwd: "",
                            userPwdChk: "",
                            userName: "",
                            userEmail: "",
                            userAddr: "",
                            userPhone: "",
                            farmName: "",
                            certType: "",
                            bizNo: "",
                            bankName: "",
                            account: "",
                            agree: false,
                            checkFlg: false,
                            role: "SELLER"
                        };
                    },
                    methods: {
                        fnCheck() {
                            let self = this;
                            if (!self.userId) {
                                alert("빈값은 입력할 수 없습니다");
                                return;
                            }
                            let param = {
                                userId: self.userId
                            };
                            $.ajax({
                                url: "/check.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    if (data.result == "Y") {
                                        alert("사용 가능한 아이디입니다");
                                        self.checkFlg = true;
                                    } else if (data.result == "N") {
                                        alert("중복된 아이디입니다");
                                        return;
                                    }
                                }
                            });
                        },
                        fnSellerJoin: function () {
                            let self = this;
                            if (!self.userId || !self.userPwd || !self.userPwdChk || !self.userName || !self.userEmail || !self.userAddr) {
                                alert("모든 항목을 입력해주세요.");
                                return;
                            }
                            if (!self.checkFlg) {
                                alert("중복 체크 후 가입해주세요");
                                return;
                            }
                            if (self.userPwd !== self.userPwdChk) {
                                alert("비밀번호가 일치하지 않습니다.");
                                return;
                            }
                            const pwdRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+\[\]{};:'",.<>\/?\\|`~])(?!.*\s).{8,16}$/;
                            if (!pwdRegex.test(self.userPwd)) {
                                alert("비밀번호는 소문자, 숫자, 특수문자가 각각 최소 1개 포함되어야 하며 길이는 8~16자 이내여야 합니다");
                                return;
                            }
                            const nameRegex = /^[가-힣]{2,10}$/;
                            if (!nameRegex.test(self.userName)) {
                                alert("이름은 한글 2~10자 이내만 가능합니다");
                                return;
                            }
                            const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                            if (!emailRegex.test(self.userEmail)) {
                                alert("이메일 형식에 맞게 입력해주세요");
                                return;
                            }
                            const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/;
                            if (!phoneRegex.test(self.userPhone)) {
                                alert("휴대폰 번호는 010-1234-5678 형태로 입력해주세요");
                                return;
                            }
                            if (!self.agree) {
                                alert("이용약관에 동의해야 합니다.");
                                return;
                            }
                            let param = {
                                userId: self.userId,
                                userPwd: self.userPwd,
                                userName: self.userName,
                                userEmail: self.userEmail,
                                userAddr: self.userAddr,
                                userPhone: self.userPhone,
                                userRole: self.role
                            };
                            $.ajax({
                                url: "/join.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    if (data.result == "success") {
                                        self.fnAddSeller();
                                    } else {
                                        alert("오류가 발생했습니다.");
                                    }
                                }
                            });
                        },
                        fnAddSeller() {
                            let self = this;
                            let param = {
                                userId: self.userId,
                                farmName: self.farmName,
                                certType: self.certType,
                                bizNo: self.bizNo,
                                bankName: self.bankName,
                                account: self.account
                            };
                            $.ajax({
                                url: "/sellerJoin.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    if (data.result == "success") {
                                        alert("회원가입 되었습니다!");
                                        location.href = self.path + "/login.do";
                                    } else {
                                        alert("오류가 발생했습니다.");
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