<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>판매자 회원가입 | AGRICOLA</title>

            <!-- ✅ 외부 라이브러리 -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                crossorigin="anonymous" referrerpolicy="no-referrer" />

            <!-- ✅ 공통 CSS -->
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

                /* ✅ 전체 배경 */
                .content {
                    flex: 1;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    background: linear-gradient(to bottom right, #faf8f0, #f3ebd3);
                    padding: 50px 20px;
                }

                /* ✅ 회원가입 폼 */
                .join-container {
                    background: linear-gradient(135deg, #f7f3e6, #f3ebd3);
                    padding: 40px 50px;
                    border-radius: 16px;
                    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 550px;
                }

                .join-title {
                    font-size: 26px;
                    font-weight: 700;
                    text-align: center;
                    color: #1a5d1a;
                    margin-bottom: 30px;
                }

                /* ✅ input 그룹 */
                .input-group {
                    margin-bottom: 20px;
                }

                .input-group label {
                    display: block;
                    font-weight: 600;
                    color: #1a5d1a;
                    margin-bottom: 6px;
                    font-size: 14px;
                }

                .input-group label i {
                    margin-right: 5px;
                    color: #5dbb63;
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

                .input-wrapper input:focus,
                .input-wrapper select:focus {
                    border-color: #5dbb63;
                    box-shadow: 0 0 5px rgba(93, 187, 99, 0.4);
                    outline: none;
                }

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
                    transition: 0.3s;
                }

                .input-wrapper button:hover {
                    background-color: #4ba954;
                    transform: translateY(-2px);
                    box-shadow: 0 3px 8px rgba(76, 169, 84, 0.3);
                }

                /* ✅ 판매자 전용 구분선 */
                .seller-section {
                    margin-top: 30px;
                    padding-top: 25px;
                    border-top: 2px solid #d9d0b6;
                }

                .seller-section-title {
                    font-size: 18px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 15px;
                    text-align: center;
                }

                /* ✅ 약관 */
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

                /* ✅ 회원가입 버튼 */
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

                /* ✅ 로그인 링크 */
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

                /* ✅ 파일 업로드 영역 */
                .file-upload {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    position: relative;
                }

                .file-upload input[type="file"] {
                    display: none;
                }

                .file-label {
                    background-color: #5dbb63;
                    color: white;
                    padding: 8px 14px;
                    border-radius: 8px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    white-space: nowrap;
                }

                .file-label:hover {
                    background-color: #4ba954;
                    transform: translateY(-2px);
                    box-shadow: 0 3px 8px rgba(76, 169, 84, 0.3);
                }

                .file-name {
                    font-size: 14px;
                    color: #333;
                    font-weight: 500;
                    text-overflow: ellipsis;
                    overflow: hidden;
                    white-space: nowrap;
                    max-width: 250px;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <div class="join-container">
                            <h2 class="join-title">판매자 회원가입</h2>

                            <!-- 기본 정보 -->
                            <div class="input-group">
                                <label><i class="fa-solid fa-user"></i> 아이디</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userId" placeholder="영문+숫자 4~20자 사이만 입력 가능합니다">
                                    <button @click="fnCheck">중복확인</button>
                                </div>
                            </div>

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

                            <div class="input-group">
                                <label><i class="fa-solid fa-id-card"></i> 이름</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userName" placeholder="이름은 한글 2~10자 이내만 가능합니다">
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-cake-candles"></i> 생년월일</label>
                                <div class="input-wrapper">
                                    <input type="date" v-model="userBirth">
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-venus-mars"></i> 성별</label>
                                <div class="input-wrapper gender-options">
                                    <label><input type="radio" value="M" v-model="userGender"> 남성</label>
                                    <label><input type="radio" value="F" v-model="userGender"> 여성</label>
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-envelope"></i> 이메일</label>
                                <div class="input-wrapper">
                                    <input type="email" v-model="userEmail" placeholder="이메일 주소를 입력하세요">
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-location-dot"></i> 주소</label>
                                <div class="input-wrapper">
                                    <input v-model="userAddr" placeholder="주소 검색 버튼으로 입력해주세요" disabled>
                                    <button @click="fnAddr">주소검색</button>
                                </div>
                            </div>

                            <div class="input-group">
                                <label><i class="fa-solid fa-mobile-screen"></i> 휴대폰</label>
                                <div class="input-wrapper">
                                    <input type="text" v-model="userPhone" placeholder="예: 01012345678">
                                </div>
                            </div>

                            <!-- 판매자 전용 -->
                            <div class="seller-section">
                                <h3 class="seller-section-title">판매자 정보</h3>

                                <div class="input-group">
                                    <label><i class="fa-solid fa-leaf"></i> 상호명 (농가명) </label>
                                    <div class="input-wrapper">
                                        <input type="text" v-model="farmName" placeholder="상호명 (농가명)을 입력하세요">
                                    </div>
                                </div>

                                <div class="input-group">
                                    <label><i class="fa-solid fa-image"></i> 프로필 사진</label>
                                    <div class="input-wrapper file-upload">
                                        <input type="file" id="profileUpload" @change="fnProfileChange"
                                            accept=".jpg,.jpeg,.png">
                                        <label for="profileUpload" class="file-label">파일 선택</label>
                                        <span class="file-name" v-if="profileName">{{ profileName }}</span>
                                    </div>
                                </div>

                                <div class="input-group">
                                    <label><i class="fa-solid fa-briefcase"></i> 사업자등록번호</label>
                                    <div class="input-wrapper">
                                        <input type="text" v-model="bizNo" placeholder="'-'없이 숫자 10자리">
                                    </div>
                                </div>

                                <div class="input-group">
                                    <label><i class="fa-solid fa-file-arrow-up"></i> 인증서 / 사업자등록증 업로드</label>
                                    <div class="input-wrapper file-upload">
                                        <input type="file" id="fileUpload" @change="fnFileChange"
                                            accept=".jpg,.jpeg,.png,.pdf">
                                        <label for="fileUpload" class="file-label">파일 선택</label>
                                        <span class="file-name" v-if="fileName">{{ fileName }}</span>
                                    </div>
                                </div>

                                <div class="input-group">
                                    <label><i class="fa-solid fa-building-columns"></i> 정산 계좌정보</label>
                                    <div class="input-wrapper">
                                        <select v-model="bankName">
                                            <option value="">은행 선택</option>
                                            <option>국민은행</option>
                                            <option>신한은행</option>
                                            <option>우리은행</option>
                                            <option>하나은행</option>
                                            <option>농협은행</option>
                                            <option>기업은행</option>
                                            <option>SC제일은행</option>
                                            <option>부산은행</option>
                                            <option>대구은행</option>
                                            <option>카카오뱅크</option>
                                            <option>토스뱅크</option>
                                        </select>
                                        <input type="text" v-model="account" placeholder="계좌번호 입력">
                                    </div>
                                </div>
                            </div>

                            <div class="terms">
                                <strong>판매자 회원 약관</strong><br><br>
                                1. 판매자는 관련 법규에 따라 올바른 상품을 판매해야 합니다.<br>
                                2. 사업자 정보 및 정산 계좌는 정확히 기입해야 합니다.<br>
                                3. 인증유형이 허위로 판명될 경우, 계정이 제한될 수 있습니다.
                            </div>

                            <div class="check-terms">
                                <input type="checkbox" v-model="agree" id="agree">
                                <label for="agree">위 약관에 동의합니다.</label>
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
                function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                    window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
                }
                const app = Vue.createApp({
                    data() {
                        return {
                            path: "${pageContext.request.contextPath}",
                            // 일반 회원가입 정보
                            userId: "",
                            userPwd: "",
                            userPwdChk: "",
                            userName: "",
                            userBirth: "",
                            userGender: "",
                            userEmail: "",
                            userAddr: "",
                            userPhone: "",
                            role: "SELLER",

                            // 판매자 회원가입 정보
                            farmName: "",
                            bizNo: "",
                            bankName: "",
                            account: "",
                            agree: false,
                            checkFlg: false,
                            file: null,
                            fileName: "",
                            profile: null,
                            profileName: "",
                        };
                    },
                    methods: {
                        fnCheck() {
                            let self = this;
                            if (!self.userId) {
                                Swal.fire('⚠️', '아이디를 입력해주세요.', 'warning');
                                return;
                            }
                            $.ajax({
                                url: "/check.dox", type: "POST", dataType: "json", data: { userId: self.userId },
                                success: function (data) {
                                    if (data.result == "Y") {
                                        Swal.fire('✅', '사용 가능한 아이디입니다.', 'success');
                                        self.checkFlg = true;
                                    } else {
                                        Swal.fire('❌', '이미 사용 중인 아이디입니다.', 'error');
                                    }
                                }
                            });
                        },
                        fnSellerJoin() {
                            let self = this;
                            if (!self.userId || !self.userPwd || !self.userPwdChk || !self.userName || !self.userEmail || !self.userAddr) {
                                Swal.fire('⚠️', '모든 항목을 입력해주세요.', 'warning');
                                return;
                            }
                            const birthDate = new Date(self.userBirth);
                            const today = new Date();
                            const age = today.getFullYear() - birthDate.getFullYear();
                            if (age < 14) {
                                Swal.fire('⚠️', '14세 미만은 가입할 수 없습니다.', 'warning');
                                return;
                            }

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

                            $.ajax({
                                url: "/join.dox",
                                type: "POST",
                                dataType: "json",
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
                                        self.fnAddSeller();
                                    } else {
                                        alert("오류 발생");
                                    }
                                }
                            });

                        },
                        fnAddSeller() {
                            let self = this;

                            if (!self.farmName) {
                                Swal.fire('⚠️', '상호명(농가명)을 입력해주세요.', 'warning');
                                return;
                            }

                            if (!self.bizNo) {
                                Swal.fire('⚠️', '사업자등록번호를 입력해주세요.', 'warning');
                                return;
                            } else {
                                const bizNoRegex = /^\d{10}$/;
                                if (!bizNoRegex.test(self.bizNo)) {
                                    Swal.fire('⚠️', '사업자등록번호는 10자리 숫자로 정확히 입력해주세요.', 'warning');
                                    return;
                                }
                            }

                            if (!self.file) {
                                Swal.fire('⚠️', '사업자 등록증을 첨부해주세요.', 'warning');
                                return;
                            }

                            if (!self.bankName) {
                                Swal.fire('⚠️', '은행명을 선택해주세요.', 'warning');
                                return;
                            }

                            if (!self.account) {
                                Swal.fire('⚠️', '계좌번호를 입력해주세요.', 'warning');
                                return;
                            } else {
                                const accountRegex = /^[0-9]+$/;
                                if (!accountRegex.test(self.account)) {
                                    Swal.fire('⚠️', '계좌번호는 숫자만 입력해주세요.', 'warning');
                                    return;
                                }
                            }
                            if (!self.agree) {
                                Swal.fire('⚠️', '모든 약관에 동의해주세요.', 'warning');
                                return;
                            }

                            let formData = new FormData();

                            formData.append("userId", self.userId);
                            formData.append("farmName", self.farmName);
                            formData.append("bizNo", self.bizNo);
                            formData.append("bankName", self.bankName);
                            formData.append("account", self.account);
                            if (self.file) formData.append("bizLicense", self.file);
                            if (self.profile) formData.append("profileImage", self.profile);
                            formData.append("userAddr", self.userAddr);

                            $.ajax({
                                url: "sellerJoin.dox",
                                type: "POST",
                                dataType: "json",
                                data: formData,
                                processData: false,
                                contentType: false,
                                success: function (data) {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '판매자 회원가입 완료!',
                                        text: 'AGRICOLA와 함께 성장하세요 🌾',
                                        confirmButtonColor: '#5dbb63'
                                    }).then(() => location.href = self.path + "/login.do");
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    console.error("신청 실패:", textStatus, errorThrown);
                                    Swal.fire('❌', '회원가입 중 오류가 발생했습니다.', 'error');
                                }
                            });
                        },
                        fnAddr() {
                            window.open("/addr.do", "addr", "width=500, height=500");
                        },
                        fnResult(roadFullAddr) {
                            this.userAddr = roadFullAddr;
                        },
                        fnFileChange(event) {
                            const file = event.target.files[0];
                            if (file) {
                                this.file = file;
                                this.fileName = file.name;
                            }
                        },
                        fnProfileChange(event) {
                            const file = event.target.files[0];
                            if (file) {
                                this.profile = file;
                                this.profileName = file.name;
                            }
                        },
                    },
                    mounted() {
                        window.vueObj = this;
                    }
                });
                app.mount('#app');
            </script>
        </body>

        </html>