<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>AGRICOLA 회원가입</title>

            <!-- 외부 라이브러리 -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                crossorigin="anonymous" referrerpolicy="no-referrer" />

            <!-- 공통 헤더/푸터 CSS -->
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

                /* ======================= 메인 영역 ======================= */
                .content {
                    flex: 1;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    background: linear-gradient(to bottom right, #faf8f0, #f3ebd3);
                    padding: 50px 20px;
                }

                .join-container {
                    background: linear-gradient(135deg, #f7f3e6, #f3ebd3);
                    padding: 40px 50px;
                    border-radius: 16px;
                    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 520px;
                }

                .join-title {
                    font-size: 26px;
                    font-weight: 700;
                    text-align: center;
                    color: #1a5d1a;
                    margin-bottom: 30px;
                }

                /* ======================= 입력 그룹 ======================= */
                .input-group {
                    margin-bottom: 20px;
                }

                .input-group label {
                    display: block;
                    font-size: 14px;
                    font-weight: 600;
                    margin-bottom: 5px;
                    color: #1a5d1a;
                }

                .input-wrapper {
                    display: flex;
                    align-items: center;
                }

                .input-wrapper input,
                .input-wrapper select {
                    flex: 1;
                    padding: 10px 12px;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    font-size: 14px;
                    transition: 0.3s;
                }

                .input-wrapper input:focus {
                    border-color: #5dbb63;
                    box-shadow: 0 0 5px rgba(93, 187, 99, 0.5);
                    outline: none;
                }

                .gender-options {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                }

                /* ======================= 버튼 ======================= */
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

                .timer-label-inline {
                    color: #e74c3c;
                    font-weight: bold;
                    font-size: 14px;
                }

                /* ======================= 약관 섹션 ======================= */
                .terms {
                    margin-top: 20px;
                    padding: 15px;
                    background: #fff;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    font-size: 13px;
                    line-height: 1.6;
                    color: #555;
                    max-height: 120px;
                    overflow-y: auto;
                    box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.1);
                }

                .terms::-webkit-scrollbar {
                    width: 6px;
                }

                .terms::-webkit-scrollbar-thumb {
                    background-color: #5dbb63;
                    border-radius: 3px;
                }

                .check-terms {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-top: 10px;
                    font-size: 14px;
                }

                .check-terms input[type="checkbox"]:checked+label {
                    color: #1a5d1a;
                    font-weight: 600;
                }

                /* ======================= 회원가입 버튼 ======================= */
                .btn-join2 {
                    width: 100%;
                    height: 50px;
                    margin-top: 25px;
                    background: linear-gradient(90deg, #4caf50, #5dbb63);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.3s;
                    box-shadow: 0 4px 10px rgba(93, 187, 99, 0.3);
                }

                .btn-join2:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 12px rgba(76, 169, 84, 0.4);
                }

                .link-login {
                    text-align: center;
                    margin-top: 18px;
                    font-size: 14px;
                }

                .link-login a {
                    color: #1a5d1a;
                    text-decoration: none;
                    font-weight: 600;
                }

                .link-login a:hover {
                    text-decoration: underline;
                }

                /* ======================= 아이콘 추가 ======================= */
                .input-group label i {
                    margin-right: 5px;
                    color: #5dbb63;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">

                    <main class="content">
                        <div class="join-container">
                            <h2 class="join-title">회원가입</h2>

                            <!-- 아이디 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-user"></i> 아이디</label>
                                <div class="input-wrapper">
                                    <input v-if="!check" v-model="userId" placeholder="영문+숫자 4~20자 사이만 입력 가능합니다">
                                    <input v-else v-model="userId" disabled>
                                    <button @click="fnCheck">중복확인</button>
                                </div>
                            </div>

                            <!-- 비밀번호 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-lock"></i> 비밀번호</label>
                                <div class="input-wrapper">
                                    <input type="password" v-model="userPwd"
                                        placeholder="소문자, 숫자, 특수문자 포함 8~16자 이내로 입력해주세요">
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-lock"></i> 비밀번호 확인</label>
                                <div class="input-wrapper">
                                    <input type="password" v-model="userPwdChk" placeholder="비밀번호를 다시 입력하세요">
                                </div>
                            </div>

                            <!-- 이름 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-id-card"></i> 이름</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userName" placeholder="이름은 한글 2~10자 이내만 가능합니다">
                                </div>
                            </div>

                            <!-- ✅ 생년월일 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-cake-candles"></i> 생년월일</label>
                                <div class="input-wrapper">
                                    <input type="date" v-model="userBirth">
                                </div>
                            </div>

                            <!-- ✅ 성별 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-venus-mars"></i> 성별</label>
                                <div class="input-wrapper gender-options">
                                    <label><input type="radio" value="M" v-model="userGender"> 남성</label>
                                    <label><input type="radio" value="F" v-model="userGender"> 여성</label>
                                </div>
                            </div>

                            <!-- 이메일 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-envelope"></i> 이메일</label>
                                <div class="input-wrapper">
                                    <input type="email" v-model="userEmail" placeholder="이메일 주소를 입력하세요">
                                </div>
                            </div>

                            <!-- 주소 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-location-dot"></i> 주소</label>
                                <div class="input-wrapper">
                                    <input v-model="userAddr" placeholder="주소 검색 버튼으로 입력해주세요" disabled>
                                    <button @click="fnAddr">주소검색</button>
                                </div>
                            </div>

                            <!-- 휴대폰 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-mobile-screen"></i> 휴대폰 인증</label>
                                <div class="input-wrapper">
                                    <input v-if="!joinFlg" type="text" v-model="userPhone" placeholder="-는 빼고 입력해주세요">
                                    <input v-else type="text" v-model="userPhone" disabled>
                                    <button @click="fnSendCode">인증번호 전송</button>
                                </div>
                            </div>

                            <div class="input-group" v-if="smsFlg">
                                <label><i class="fa-solid fa-shield"></i>인증번호 입력</label>
                                <div class="input-wrapper" style="display:flex; align-items:center; gap:10px;">
                                    <input type="text" v-model="verifyCode" placeholder="인증번호 입력">
                                    <button @click="fnVerifyCode">확인</button>

                                    <span v-if="count > 0" class="timer-label-inline">
                                        {{ timer }}
                                    </span>
                                </div>
                            </div>

                            <!-- 약관 -->
                            <div class="terms">
                                <strong>AGRICOLA 서비스 이용약관</strong><br><br>
                                1. 회원은 본 약관을 동의함으로써 서비스를 이용할 수 있습니다.<br>
                                2. 개인정보는 회원가입 및 서비스 제공 목적 외로 사용되지 않습니다.<br>
                                3. 기타 자세한 내용은 개인정보처리방침을 참고하시기 바랍니다.
                            </div>

                            <div class="check-terms">
                                <input type="checkbox" v-model="agree" id="agree">
                                <label for="agree">위 약관에 동의합니다.</label>
                            </div>

                            <button class="btn-join2" @click="fnJoin">회원가입</button>

                            <div class="link-login">
                                이미 회원이신가요? <a :href="path + '/login.do'">로그인</a>
                            </div>
                        </div>
                    </main>

                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
                        }

                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${pageContext.request.contextPath}",
                                    userId: "",
                                    userPwd: "",
                                    userPwdChk: "",
                                    userName: "",
                                    userBirth: "",
                                    userGender: "",
                                    userEmail: "",
                                    userAddr: "",
                                    userPhone: "",
                                    agree: false,
                                    checkFlg: false,
                                    role: "BUYER",
                                    check: false,

                                    // 핸드폰번호 인증 관련
                                    ranStr: "", //  서버에서 보낸 인증번호
                                    smsFlg: false, // 문자인증 성공 여부
                                    joinFlg: false, // 회원가입할 시 문자인증 여부
                                    count: 180, // 180초 타이머 설정
                                    timer: "", // 3:00으로 보이도록 하는 값
                                    verifyCode: "", // 인증번호 입력받은 값
                                    timerInterval: null // 타이머 값
                                };
                            },
                            methods: {
                                fnCheck() {
                                    let self = this;
                                    const idRegex = /^[a-z][a-z0-9._]{3,19}$/;
                                    if (!idRegex.test(self.userId)) {
                                        Swal.fire('⚠️', '영문 + 숫자 4~20자 사이만 입력 가능합니다.', 'warning');
                                        return;
                                    }
                                    $.ajax({
                                        url: "/check.dox", type: "POST", dataType: "json", data: { userId: self.userId },
                                        success: function (data) {
                                            if (data.result == "Y") {
                                                Swal.fire('✅', '사용 가능한 아이디입니다.', 'success');
                                                self.checkFlg = true; self.check = true;
                                            } else {
                                                Swal.fire('❌', '이미 사용 중인 아이디입니다.', 'error');
                                            }
                                        }
                                    });
                                },
                                fnJoin() {
                                    let self = this;
                                    if (!self.userId || !self.userPwd || !self.userPwdChk || !self.userName || !self.userEmail || !self.userAddr) {
                                        Swal.fire('⚠️', '모든 항목을 입력해주세요.', 'warning');
                                        return;
                                    }
                                    // 생년월일 유효성 검사
                                    const birthDate = new Date(self.userBirth);
                                    const today = new Date();
                                    const age = today.getFullYear() - birthDate.getFullYear();
                                    if (age < 14) {
                                        Swal.fire('⚠️', '14세 미만은 가입할 수 없습니다.', 'warning');
                                        return;
                                    }

                                    // 성별 검사
                                    if (self.userGender !== "M" && self.userGender !== "F") {
                                        Swal.fire('⚠️', '성별을 선택해주세요.', 'warning');
                                        return;
                                    }
                                    if (!self.checkFlg) {
                                        Swal.fire('⚠️', '아이디 중복확인을 해주세요.', 'warning');
                                        return;
                                    }
                                    if (self.userPwd !== self.userPwdChk) {
                                        Swal.fire('❌', '비밀번호가 일치하지 않습니다.', 'error');
                                        return;
                                    }
                                    const pwdRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+\[\]{};:'",.<>\/?\\|`~])(?!.*\s).{8,16}$/;
                                    if (!pwdRegex.test(self.userPwd)) {
                                        Swal.fire('⚠️', '비밀번호는 소문자, 숫자, 특수문자 포함 8~16자 이내여야 합니다.', 'warning');
                                        return;
                                    }
                                    const nameRegex = /^[가-힣]{2,10}$/;
                                    if (!nameRegex.test(self.userName)) {
                                        Swal.fire('⚠️', '이름은 한글 2~10자 이내만 가능합니다.', 'warning');
                                        return;
                                    }
                                    const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                                    if (!emailRegex.test(self.userEmail)) {
                                        Swal.fire('⚠️', '이메일 형식에 맞게 입력해주세요.', 'warning');
                                        return;
                                    }
                                    const phoneRegex = /^01[0-9]\d{3,4}\d{4}$/;
                                    if (!phoneRegex.test(self.userPhone)) {
                                        Swal.fire('⚠️', '휴대폰 번호는 01012345678 형태로 입력해주세요.', 'warning');
                                        return;
                                    }
                                    if (!self.agree) {
                                        Swal.fire('⚠️', '이용약관에 동의해야 합니다.', 'warning');
                                        return;
                                    }
                                    if (!self.joinFlg) {
                                        Swal.fire('⚠️', '휴대폰 인증을 진행해주세요.', 'warning');
                                        return;
                                    }
                                    $.ajax({
                                        url: "/join.dox", type: "POST", dataType: "json",
                                        data: {
                                            userId: self.userId,
                                            userPwd: self.userPwd,
                                            userName: self.userName,
                                            userBirth: self.userBirth,
                                            userGender: self.userGender,
                                            userEmail: self.userEmail,
                                            userAddr: self.userAddr,
                                            userPhone: self.userPhone,
                                            userRole: self.role
                                        },
                                        success: function (data) {
                                            if (data.result == "success") {
                                                Swal.fire({
                                                    icon: 'success',
                                                    title: '회원가입 완료!',
                                                    text: 'AGRICOLA에 오신 것을 환영합니다 🌾',
                                                    confirmButtonColor: '#5dbb63'
                                                }).then(() => location.href = self.path + "/login.do");
                                            } else {
                                                Swal.fire('❌', '회원가입 중 오류가 발생했습니다.', 'error');
                                            }
                                        }
                                    });
                                },
                                fnAddr() {
                                    window.open("/addr.do", "addr", "width=500, height=500");
                                },
                                fnResult(roadFullAddr) {
                                    this.userAddr = roadFullAddr;
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
                                                self.smsFlg = true; // 인증번호 입력창 표시
                                                self.fnTimer(); // 타이머 시작
                                            } else {
                                                Swal.fire('❌', '문자 발송 실패. 잠시 후 다시 시도해주세요.', 'error');
                                            }
                                        },
                                        error: function () {
                                            Swal.fire('❌', '서버 오류로 문자 전송에 실패했습니다.', 'error');
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
                                fnVerifyCode: function () {
                                    let self = this;

                                    if (!self.verifyCode) {
                                        Swal.fire('⚠️', '인증번호를 입력해주세요.', 'warning');
                                        return;
                                    }

                                    $.ajax({
                                        url: self.path + "/verify-code",
                                        type: "POST",
                                        dataType: "json",
                                        data: { phone: self.userPhone, code: self.verifyCode },
                                        success: function (data) {
                                            if (data.result === "success") {
                                                Swal.fire('✅', '휴대폰 인증이 완료되었습니다.', 'success');
                                                self.joinFlg = true;

                                                // 타이머 중지
                                                if (self.timerInterval) {
                                                    clearInterval(self.timerInterval);
                                                    self.timer = "";
                                                }
                                            } else {
                                                Swal.fire('❌', '인증번호가 일치하지 않습니다.', 'error');
                                            }
                                        },
                                        error: function () {
                                            Swal.fire('❌', '서버 오류로 인증 확인에 실패했습니다.', 'error');
                                        }
                                    });
                                }
                            },
                            mounted() {
                                window.vueObj = this;
                            }
                        });

                        app.mount('#app');
                    </script>
        </body>

        </html>