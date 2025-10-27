<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>agricola 회원가입</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
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

                .join-container {
                    background: #f3ebd3;
                    padding: 40px 50px;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 500px;
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

                .input-group input {
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

                .btn-join2:hover {
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
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="join-container">
                            <h2 class="join-title">회원가입</h2>

                            <!-- ✅ Vue 데이터 바인딩 -->
                            <div class="input-group">
                                <label>아이디</label>
                                <input v-if="!check" v-model="userId" placeholder="영문+숫자 4~20자 사이만 입력 가능합니다">
                                <input v-else v-model="userId" disabled>
                                <button @click="fnCheck">중복확인</button>
                            </div>

                            <div class="input-group">
                                <label>비밀번호</label>
                                <input type="password" v-model="userPwd" placeholder="소문자, 숫자, 특수문자가 각각 최소 1개 포함되어야 하며 길이는 8~16자 이내여야 합니다">
                            </div>

                            <div class="input-group">
                                <label>비밀번호 확인</label>
                                <input type="password" v-model="userPwdChk" placeholder="비밀번호를 다시 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>이름</label>
                                <input type="text" v-model="userName" placeholder="이름은 한글 2~10자 이내만 가능합니다">
                            </div>

                            <div class="input-group">
                                <label>이메일</label>
                                <input type="email" v-model="userEmail" placeholder="이메일 주소를 입력하세요">
                            </div>

                            <div class="input-group">
                                <label>주소</label>
                                <input v-model="userAddr" placeholder="주소 검색 버튼으로 입력해주세요" disabled><button
                                    @click="fnAddr">주소 검색</button>
                            </div>

                            <div class="input-group">
                                <label>휴대폰</label>
                                <input type="text" v-model="userPhone" placeholder="예: 010-1234-5678 ">
                            </div>

                            <div class="input-group">
                                <label>추천인</label>
                                <input type="text" v-model="userRecommend" placeholder="추천인을 입력하세요">
                            </div>

                            <div class="terms">
                                AGRICOLA 서비스 이용약관<br><br>
                                1. 회원은 본 약관을 동의함으로써 서비스를 이용할 수 있습니다.<br>
                                2. 개인정보는 회원가입 및 서비스 제공 목적 외로 사용되지 않습니다.<br>
                                3. 기타 자세한 내용은 개인정보처리방침을 참고하시기 바랍니다.
                            </div>

                            <div class="check-terms">
                                <input type="checkbox" v-model="agree">
                                <label>위 약관에 동의합니다.</label>
                            </div>

                            <button class="btn-join2" @click="fnJoin">회원가입</button>

                            <div class="link-login">
                                이미 회원이신가요? <a :href="path + '/login.do'">로그인</a>
                            </div>
                        </div>
                    </main>

                    <!-- 공통 푸터 -->
                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>
        </body>

        </html>

        <script>
            function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                console.log(roadFullAddr);
                console.log(addrDetail);
                console.log(zipNo);
                window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
            }
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        path: "${pageContext.request.contextPath}",
                        userId: "",
                        userPwd: "",
                        userPwdChk: "",
                        userName: "",
                        userEmail: "",
                        userAddr: "",
                        userPhone: "",
                        userRecommend: "",
                        agree: false,
                        checkFlg: false,
                        role: "BUYER",
                        check: false

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnCheck() {
                        let self = this;
                        const idRegex = /^[a-z][a-z0-9._]{3,19}$/;
                        if (!idRegex.test(self.userId)) {
                            alert("영문 + 숫자 4~20자 사이만 입력 가능합니다");
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
                                    self.check = true;
                                } else if (data.result == "N") {
                                    alert("중복된 아이디입니다");
                                    return;
                                }
                            }
                        });
                    },
                    fnJoin: function () {
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
                            userRecommend: self.userRecommend,
                            userRole: self.role
                        };
                        $.ajax({
                            url: "/join.dox",
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
                    },
                    fnAddr: function () {
                        window.open("/addr.do", "addr", "width=500, height=500");
                    },
                    fnResult: function (roadFullAddr, addrDetail, zipNo) {
                        let self = this;
                        self.userAddr = roadFullAddr;
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    window.vueObj = this;
                }
            });

            app.mount('#app');
        </script>