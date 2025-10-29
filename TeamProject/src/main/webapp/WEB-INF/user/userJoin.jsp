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

                .input-wrapper input {
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
                                <label><i class="fa-solid fa-mobile-screen"></i> 휴대폰</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userPhone" placeholder="예: 010-1234-5678">
                                </div>
                            </div>

                            <!-- 추천인 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-user-plus"></i> 추천인</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userRecommend" placeholder="추천인 ID를 입력하세요">
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
                            const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/;
                            if (!phoneRegex.test(self.userPhone)) {
                                Swal.fire('⚠️', '휴대폰 번호는 010-1234-5678 형태로 입력해주세요.', 'warning');
                                return;
                            }
                            if (!self.agree) {
                                Swal.fire('⚠️', '이용약관에 동의해야 합니다.', 'warning');
                                return;
                            }
                            $.ajax({
                                url: "/join.dox", type: "POST", dataType: "json",
                                data: {
                                    userId: self.userId, userPwd: self.userPwd, userName: self.userName,
                                    userEmail: self.userEmail, userAddr: self.userAddr, userPhone: self.userPhone,
                                    userRecommend: self.userRecommend, userRole: self.role
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