<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>입점/제휴 문의</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
            <style>
                /* 기본 스타일 및 변수 */
                :root {
                    --background: #ffffff;
                    --foreground: #020817;
                    --card: #ffffff;
                    --card-foreground: #020817;
                    --popover: #ffffff;
                    --popover-foreground: #020817;
                    --primary: #1a73e8;
                    --primary-foreground: #f8f9fa;
                    --secondary: #f1f3f4;
                    --secondary-foreground: #202124;
                    --muted: #f1f3f4;
                    --muted-foreground: #5f6368;
                    --accent: #e8f0fe;
                    --accent-foreground: #1967d2;
                    --destructive: #d93025;
                    --destructive-foreground: #f8f9fa;
                    --border: #dadce0;
                    --input: #dadce0;
                    --ring: #1a73e8;
                    --radius: 0.5rem;
                }

                html,
                body {
                    height: 100%;
                    margin: 0;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                    background-color: var(--background);
                    color: var(--foreground);
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                }

                /* 컨테이너 */
                .container {
                    width: 100%;
                    margin-left: auto;
                    margin-right: auto;
                    padding-left: 1rem;
                    padding-right: 1rem;
                }

                @media (min-width: 768px) {
                    .container {
                        max-width: 768px;
                    }
                }

                @media (min-width: 1024px) {
                    .container {
                        max-width: 1024px;
                    }
                }

                /* 메인 컨텐츠 영역 */
                .main-content {
                    padding-top: 2rem;
                    padding-bottom: 2rem;
                }

                .max-w-3xl {
                    max-width: 48rem;
                    /* 768px */
                }

                .mx-auto {
                    margin-left: auto;
                    margin-right: auto;
                }

                /* 스텝 UI */
                .steps {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 1rem;
                    margin-bottom: 2rem;
                }

                .step {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .step-circle {
                    width: 2rem;
                    height: 2rem;
                    border-radius: 9999px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 500;
                    transition: background-color 0.2s, color 0.2s;
                }

                .step-circle.active {
                    background-color: var(--primary);
                    color: var(--primary-foreground);
                }

                .step-circle.inactive {
                    background-color: var(--muted);
                    color: var(--muted-foreground);
                }

                .step-line {
                    width: 3rem;
                    height: 2px;
                    background-color: var(--muted);
                }

                .step-label {
                    font-size: 0.875rem;
                    font-weight: 500;
                    transition: color 0.2s;
                }

                /* === 수정된 부분 시작 === */
                .step-circle.active+.step-label {
                    color: var(--foreground);
                    /* 활성 스텝 텍스트 색상 (기본 텍스트 색) */
                }

                .step-circle.inactive+.step-label {
                    color: var(--muted-foreground);
                    /* 비활성 스텝 텍스트 색상 (회색) */
                }

                /* === 수정된 부분 끝 === */


                /* 텍스트 스타일 */
                .text-center {
                    text-align: center;
                }

                .text-3xl {
                    font-size: 1.875rem;
                }

                .font-bold {
                    font-weight: 700;
                }

                .mb-2 {
                    margin-bottom: 0.5rem;
                }

                .mb-8 {
                    margin-bottom: 2rem;
                }

                .text-muted-foreground {
                    color: var(--muted-foreground);
                }

                /* 그리드 및 카드 */
                .grid-container {
                    display: grid;
                    gap: 1.5rem;
                }

                @media (min-width: 768px) {
                    .grid-container {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }
                }

                .type-card {
                    background-color: var(--card);
                    border: 2px solid var(--border);
                    border-radius: var(--radius);
                    padding: 2rem;
                    text-align: left;
                    transition: all 0.2s;
                    cursor: pointer;
                }

                .type-card:hover {
                    border-color: var(--primary);
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                }

                .type-card .icon-wrapper {
                    width: 4rem;
                    height: 4rem;
                    border-radius: 9999px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 1rem;
                }

                .type-card .icon-wrapper.green {
                    background-color: #e6f4ea;
                }

                .type-card .icon-wrapper.blue {
                    background-color: #e8f0fe;
                }

                .type-card .icon {
                    font-size: 2.25rem;
                }

                .type-card h3 {
                    font-size: 1.25rem;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .type-card p {
                    font-size: 0.875rem;
                    color: var(--muted-foreground);
                    margin-bottom: 1rem;
                }

                .type-card ul {
                    font-size: 0.875rem;
                    list-style-position: inside;
                    padding-left: 0;
                    margin: 0;
                    space-y: 0.25rem;
                    color: var(--muted-foreground);
                }

                .type-card ul li {
                    padding-left: 0.5rem;
                }

                /* 폼 스타일 */
                .form-container {
                    background-color: var(--card);
                    border-radius: var(--radius);
                    border: 1px solid var(--border);
                    padding: 1.5rem;
                }

                .form-container h3 {
                    font-size: 1.5rem;
                    font-weight: 600;
                    margin-bottom: 1.5rem;
                }

                .form-space-y>*+* {
                    margin-top: 1.5rem;
                }

                .form-group>*+* {
                    margin-top: 0.5rem;
                }

                .label {
                    font-size: 0.875rem;
                    font-weight: 500;
                    display: block;
                }

                .input,
                .select-trigger,
                .textarea {
                    display: flex;
                    width: 100%;
                    border-radius: var(--radius);
                    border: 1px solid var(--input);
                    background-color: var(--background);
                    padding: 0.5rem 0.75rem;
                    font-size: 0.875rem;
                    box-sizing: border-box;
                }

                .input:focus,
                .select-trigger:focus,
                .textarea:focus {
                    outline: 2px solid var(--ring);
                    outline-offset: 2px;
                }

                .textarea {
                    min-height: 80px;
                }

                .grid-cols-2 {
                    display: grid;
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                    gap: 1rem;
                }

                /* 체크박스 */
                .checkbox-group {
                    background-color: var(--muted);
                    padding: 1rem;
                    border-radius: var(--radius);
                }

                .checkbox-group h4 {
                    font-weight: 500;
                    margin-top: 0;
                    margin-bottom: 0.75rem;
                }

                .checkbox-item {
                    display: flex;
                    align-items: flex-start;
                    gap: 0.5rem;
                }

                .checkbox-item+.checkbox-item {
                    margin-top: 0.5rem;
                }

                .checkbox-item label {
                    font-size: 0.875rem;
                    line-height: 1.5;
                    cursor: pointer;
                }

                /* 버튼 */
                .button-group {
                    display: flex;
                    gap: 0.75rem;
                }

                .button {
                    flex: 1;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: var(--radius);
                    font-size: 0.875rem;
                    font-weight: 500;
                    padding: 0.6rem 1rem;
                    cursor: pointer;
                    border: 1px solid transparent;
                    transition: background-color 0.2s;
                }

                .button-primary {
                    background-color: var(--primary);
                    color: var(--primary-foreground);
                }

                .button-primary:hover {
                    background-color: #1865c9;
                }

                .button-outline {
                    background-color: transparent;
                    border-color: var(--border);
                    color: var(--foreground);
                }

                .button-outline:hover {
                    background-color: var(--accent);
                }

                /* 알림 박스 */
                .alert-box {
                    padding: 1rem;
                    border-radius: var(--radius);
                    border: 1px solid;
                }

                .alert-blue {
                    background-color: #e8f0fe;
                    border-color: #d2e3fc;
                    color: #1967d2;
                }

                .alert-box p {
                    margin: 0;
                    font-size: 0.875rem;
                    line-height: 1.5;
                }

                .error-message {
                    color: var(--destructive);
                    font-size: 0.8rem;
                    font-weight: 500;
                    margin-top: 0.25rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">
                    <main class="content main-content">
                        <div class="max-w-3xl mx-auto">
                            <!-- Progress Steps -->
                            <div class="steps">
                                <div class="step">
                                    <div class="step-circle" :class="{ active: step >= 1, inactive: step < 1 }">1</div>
                                    <span class="step-label">유형 선택</span>
                                </div>
                                <div class="step-line"></div>
                                <div class="step">
                                    <div class="step-circle" :class="{ active: step >= 2, inactive: step < 2 }">2</div>
                                    <span class="step-label">정보 입력</span>
                                </div>
                            </div>

                            <!-- Step 1: Type Selection -->
                            <div v-if="step === 1">
                                <div class="text-center mb-8">
                                    <h2 class="text-3xl font-bold mb-2">입점/제휴 문의</h2>
                                    <p class="text-muted-foreground">원하시는 문의 유형을 선택해주세요</p>
                                </div>
                                <div class="grid-container">
                                    <div @click="handleTypeSelect('seller')" class="type-card">
                                        <div class="icon-wrapper green"><span class="icon">🌾</span></div>
                                        <h3>판매자 입점 신청</h3>
                                        <p>기존 회원님의 계정에 판매자 권한을 추가합니다</p>
                                        <ul>
                                            <li>• 농가 정보 등록</li>
                                            <li>• 사업자 정보 입력</li>
                                            <li>• 정산 계좌 등록</li>
                                        </ul>
                                    </div>
                                    <div @click="handleTypeSelect('partner')" class="type-card">
                                        <div class="icon-wrapper blue"><span class="icon">🤝</span></div>
                                        <h3>제휴 문의</h3>
                                        <p>비즈니스 제휴 제안을 보내주세요</p>
                                        <ul>
                                            <li>• 업체 정보 입력</li>
                                            <li>• 제휴 제안 내용 작성</li>
                                            <li>• 이메일로 회신</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 2: Seller Application Form -->
                            <div v-if="step === 2 && selectedType === 'seller'" class="form-container">
                                <h3 class="font-semibold">판매자 입점 신청서</h3>
                                <form class="form-space-y" @submit.prevent="fnSellerSubmit">
                                    <div class="form-group">
                                        <label for="farmName" class="label">상호명 (농가명) *</label>
                                        <input id="farmName" class="input" placeholder="상호명 (농가명)을 입력하세요"
                                            v-model="farmName">
                                        <div v-if="farmNameError" class="error-message">{{ farmNameError }}</div>
                                    </div>
                                    <div class="form-group">
                                        <label for="businessNumber" class="label">사업자등록번호 *</label>
                                        <input id="businessNumber" class="input" placeholder="'-'없이 숫자 10자리"
                                            maxlength="10" v-model="bizNo">
                                        <div v-if="bizNoError" class="error-message">{{ bizNoError }}</div>
                                    </div>
                                    <div class="form-group">
                                        <label for="businessLicense" class="label">사업자 등록증 첨부 *</label>
                                        <input id="businessLicense" type="file" class="input" accept=".jpg, .png"
                                            @change="handleFileChange">
                                        <div v-if="bizLicenseError" class="error-message">{{ bizLicenseError }}</div>
                                    </div>
                                    <div class="grid-cols-2">
                                        <div class="form-group">
                                            <label for="bankName" class="label">은행명 *</label>
                                            <select id="bankName" class="input" v-model="bankName">
                                                <option value="" disabled selected>은행 선택</option>
                                                <option value="kb">국민은행</option>
                                                <option value="shinhan">신한은행</option>
                                                <option value="woori">우리은행</option>
                                                <option value="hana">하나은행</option>
                                                <option value="nh">농협은행</option>
                                            </select>
                                            <div v-if="bankNameError" class="error-message">{{ bankNameError }}</div>
                                        </div>
                                        <div class="form-group">
                                            <label for="accountNumber" class="label">계좌번호 *</label>
                                            <input id="accountNumber" class="input" placeholder="계좌번호를 입력하세요"
                                                v-model="account">
                                            <div v-if="accountError" class="error-message">{{ accountError }}</div>
                                        </div>
                                    </div>
                                    <div class="checkbox-group">
                                        <h4>판매자 약관 동의</h4>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="terms1" v-model="terms1"><label for="terms1">판매자
                                                이용약관에 동의합니다 (필수)</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="terms2" v-model="terms2"><label for="terms2">개인정보
                                                수집 및 이용에 동의합니다 (필수)</label>
                                        </div>
                                        <div v-if="termsError" class="error-message">{{ termsError }}</div>
                                    </div>
                                    <div class="button-group">
                                        <button type="button" @click="handleBack"
                                            class="button button-outline">이전</button>
                                        <button type="submit" class="button button-primary">입점 신청하기</button>
                                    </div>
                                </form>
                            </div>

                            <!-- Step 2: Partnership Inquiry Form -->
                            <div v-if="step === 2 && selectedType === 'partner'" class="form-container">
                                <h3 class="font-semibold">제휴 문의</h3>
                                <form class="form-space-y" @submit.prevent="fnPartnerSubmit">
                                    <div class="form-group">
                                        <label for="inquirerName" class="label">업체명 / 개인(채널명) *</label>
                                        <input id="inquirerName" class="input" placeholder="업체명 또는 개인명을 입력하세요"
                                            v-model="partnerInquirerName">
                                        <div v-if="partnerInquirerNameError" class="error-message">{{
                                            partnerInquirerNameError }}</div>
                                    </div>
                                    <div class="form-group">
                                        <label for="managerName" class="label">담당자 이름 *</label>
                                        <input id="managerName" class="input" placeholder="담당자 이름을 입력하세요"
                                            v-model="partnerManagerName">
                                        <div v-if="partnerManagerNameError" class="error-message">{{
                                            partnerManagerNameError }}</div>
                                    </div>
                                    <div class="grid-cols-2">
                                        <div class="form-group">
                                            <label for="email" class="label">이메일 *</label>
                                            <input id="email" type="email" class="input" placeholder="example@email.com"
                                                v-model="partnerEmail">
                                            <div v-if="partnerEmailError" class="error-message">{{ partnerEmailError }}
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="phone" class="label">전화번호</label>
                                            <input id="phone" class="input" placeholder="010-0000-0000"
                                                v-model="partnerPhone">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="proposal" class="label">제휴 제안 내용 *</label>
                                        <textarea id="proposal" class="textarea" placeholder="제휴 제안 내용을 상세히 작성해주세요"
                                            rows="6" v-model="partnerProposal"></textarea>
                                        <div v-if="partnerProposalError" class="error-message">{{ partnerProposalError
                                            }}</div>
                                    </div>
                                    <div class="alert-box alert-blue">
                                        <p>📧 제출하신 내용은 담당자 검토 후 입력하신 이메일로 회신드립니다.<br> 영업일 기준 3-5일 이내 답변드립니다.</p>
                                    </div>
                                    <div class="button-group">
                                        <button type="button" @click="handleBack"
                                            class="button button-outline">이전</button>
                                        <button type="submit" class="button button-primary">제휴 문의 보내기</button>
                                    </div>
                                </form>
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
                        //선택 부분
                        sessionId: "${sessionId}",
                        userRole: "${sessionScope.sessionStatus}",
                        step: 1, // 1: 유형 선택, 2: 정보 입력
                        selectedType: null, // 'seller' 또는 'partner'

                        //입점 문의
                        farmName: "",
                        bizNo: "",
                        bizLicense: null,
                        account: "",
                        bankName: "",

                        // 에러 메시지
                        farmNameError: "",
                        bizNoError: "",
                        bizLicenseError: "",
                        accountError: "",
                        bankNameError: "",
                        termsError: "",

                        // 약관 동의
                        terms1: false,
                        terms2: false,

                        // 제휴 문의
                        partnerInquirerName: "",
                        partnerManagerName: "",
                        partnerEmail: "",
                        partnerPhone: "",
                        partnerProposal: ""



                    };
                },
                methods: {
                    handleTypeSelect(type) {
                        let self = this;
                        if (type === 'seller') {
                            if (self.sessionId === "") {
                                Swal.fire({
                                    icon: 'warning',
                                    title: '판매자 입점 신청은 로그인이 필요합니다.',
                                    confirmButtonColor: '#5dbb63'
                                }).then(() => {
                                    location.href = "/login.do";
                                });
                                return;
                            }
                            if (self.userRole === 'SELLER') {
                                Swal.fire({
                                    icon: 'warning',
                                    title: '이미 판매자 회원입니다.',
                                    confirmButtonColor: '#5dbb63'
                                });
                                return;
                            }
                        }
                        self.selectedType = type;
                        self.step = 2;
                    },
                    handleBack() {
                        let self = this;
                        if (self.step === 2) {
                            self.step = 1;
                            self.selectedType = null;
                        }
                    },
                    handleFileChange(event) {
                        let self = this;
                        self.bizLicense = event.target.files[0];
                    },

                    fnSellerSubmit() { // 입점 문의 신청 버튼
                        let self = this;
                        let isValid = true;

                        self.farmNameError = "";
                        self.bizNoError = "";
                        self.bizLicenseError = "";
                        self.accountError = "";
                        self.bankNameError = "";

                        if (!self.farmName) {
                            self.farmNameError = "상호명(농가명)을 입력해주세요.";
                            isValid = false;
                        }

                        if (!self.bizNo) {
                            self.bizNoError = "사업자등록번호를 입력해주세요.";
                            isValid = false;
                        } else {
                            const bizNoRegex = /^\d{10}$/;
                            if (!bizNoRegex.test(self.bizNo)) {
                                self.bizNoError = "사업자등록번호는 10자리 숫자로 정확히 입력해주세요.";
                                isValid = false;
                            }
                        }

                        if (!self.bizLicense) {
                            self.bizLicenseError = "사업자 등록증을 첨부해주세요.";
                            isValid = false;
                        }

                        if (!self.bankName) {
                            self.bankNameError = "은행명을 선택해주세요.";
                            isValid = false;
                        }

                        if (!self.account) {
                            self.accountError = "계좌번호를 입력해주세요.";
                            isValid = false;
                        } else {
                            const accountRegex = /^[0-9]+$/;
                            if (!accountRegex.test(self.account)) {
                                self.accountError = "계좌번호는 숫자만 입력해주세요.";
                                isValid = false;
                            }
                        }
                        self.termsError = "";
                        if (!self.terms1 || !self.terms2) {
                            self.termsError = "모든 약관에 동의해주세요.";
                            isValid = false;
                        }

                        if (!isValid) {
                            return;
                        }
                        // console.log("유효성 검사 통과 서버로 데이터를 전송합니다.");

                        Swal.fire({
                            icon: 'question',
                            title: '입점 신청',
                            text: '입점 신청을 진행하시겠습니까?',
                            showCancelButton: true,
                            confirmButtonText: '확인',
                            cancelButtonText: '취소',
                            confirmButtonColor: '#5dbb63'
                        }).then((result) => {
                            if (!result.isConfirmed) return;

                            let formData = new FormData();

                            formData.append('farmName', self.farmName);
                            formData.append('bizNo', self.bizNo);
                            formData.append('bankName', self.bankName);
                            formData.append('account', self.account);
                            formData.append('bizLicense', self.bizLicense);


                            $.ajax({
                                url: "fileUpload.dox",
                                dataType: "json",
                                type: "POST",
                                processData: false,
                                contentType: false,
                                data: formData,
                                success: function (response) {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '입점 신청이 정상적으로 완료되었습니다.',
                                        confirmButtonColor: '#5dbb63'
                                    });
                                    // location.href = "";  다되면 어디로 보내지?
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    console.error("신청 실패:", textStatus, errorThrown);
                                    Swal.fire({
                                        icon: 'error',
                                        title: '신청 처리 중 오류가 발생했습니다.',
                                        confirmButtonColor: '#5dbb63'
                                    });
                                }
                            });
                        });
                    },
                    fnPartnerSubmit() {
                        let self = this;
                        let isValid = true;

                        self.partnerInquirerNameError = "";
                        self.partnerManagerNameError = "";
                        self.partnerEmailError = "";
                        self.partnerProposalError = "";


                        if (!self.partnerInquirerName) {
                            self.partnerInquirerNameError = "업체명을 입력해주세요.";
                            isValid = false;
                        }
                        if (!self.partnerManagerName) {
                            self.partnerManagerNameError = "담당자 이름을 입력해주세요.";
                            isValid = false;
                        }
                        if (!self.partnerEmail) {
                            self.partnerEmailError = "이메일을 입력해주세요.";
                            isValid = false;
                        } else {
                            // 간단한 이메일 형식 검사
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(self.partnerEmail)) {
                                self.partnerEmailError = "올바른 이메일 형식을 입력해주세요.";
                                isValid = false;
                            }
                        }
                        if (!self.partnerProposal) {
                            self.partnerProposalError = "제휴 제안 내용을 입력해주세요.";
                            isValid = false;
                        }

                        if (!isValid) {
                            return; // 유효성 검사 실패 시 중단
                        }

                        Swal.fire({
                            icon: 'question',
                            title: '제휴 문의',
                            text: '제휴 문의를 접수하시겠습니까?',
                            showCancelButton: true,
                            confirmButtonText: '확인',
                            cancelButtonText: '취소',
                            confirmButtonColor: '#5dbb63'
                        }).then((result) => {
                            if (!result.isConfirmed) return;

                            let params = {
                                inquirerName: self.partnerInquirerName,
                                managerName: self.partnerManagerName,
                                email: self.partnerEmail,
                                phone: self.partnerPhone,
                                proposal: self.partnerProposal
                            };

                            $.ajax({
                                url: "/partner/inquiry.dox",
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                data: JSON.stringify(params),
                                success: function (response) {
                                    if (response.status === 'success') {
                                        Swal.fire({
                                            icon: 'success',
                                            title: '제휴 문의가 성공적으로 접수되었습니다.',
                                            confirmButtonColor: '#5dbb63'
                                        }).then(() => {
                                            self.step = 1;
                                            self.selectedType = null;
                                        });
                                    } else {
                                        Swal.fire({
                                            icon: 'error',
                                            title: (response.message || "접수 중 오류가 발생했습니다."),
                                            confirmButtonColor: '#5dbb63'
                                        });
                                    }
                                },
                                error: function () {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '서버와 통신 중 오류가 발생했습니다.',
                                        confirmButtonColor: '#5dbb63'
                                    });
                                }
                            });
                        });
                    }
                },
                mounted() {
                    let self = this;


                }
            });

            app.mount('#app');
        </script>