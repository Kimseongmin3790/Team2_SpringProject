<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>회원관리</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #f9f9f9;
                }

                .admin-container {
                    max-width: 1800px;
                    margin: 60px auto;
                    padding: 0 15px 60px;
                    box-sizing: border-box;
                }

                .admin-title {
                    font-size: 1.8rem;
                    color: #2e5d2e;
                    font-weight: 700;
                    margin-bottom: 30px;
                    text-align: center;
                }

                .member-filter {
                    display: flex;
                    justify-content: flex-end;
                    align-items: center;
                    gap: 10px;
                    margin-bottom: 20px;
                }

                .member-filter input {
                    padding: 6px 10px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                }

                .member-filter button {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    padding: 6px 12px;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: 0.2s;
                }

                .member-filter button:hover {
                    background: #4aa954;
                }

                .table-wrap {
                    width: 100%;
                    overflow: hidden;
                }

                .member-table {
                    width: 100%;
                    min-width: 0;
                    table-layout: fixed;
                    border-collapse: collapse;
                    background: #fff;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                }

                .member-table th {
                    background: #4caf50;
                    color: #fff;
                    padding: 12px 6px;
                    font-weight: 700;
                    text-align: center;
                    white-space: nowrap;
                    font-size: 13px;
                }

                .member-table td {
                    text-align: center;
                    border-bottom: 1px solid #eee;
                }

                .member-table th,
                .member-table td {
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    line-height: 1.25;
                    font-size: 13px;
                    padding: 10px 6px;
                    vertical-align: middle;
                }

                .member-table th:nth-child(1),
                .member-table td:nth-child(1) {
                    width: 90px;
                }

                /* 회원ID */
                .member-table th:nth-child(2),
                .member-table td:nth-child(2) {
                    width: 70px;
                }

                /* 이름 */
                .member-table th:nth-child(3),
                .member-table td:nth-child(3) {
                    width: 95px;
                }

                /* 생년월일 */
                .member-table th:nth-child(4),
                .member-table td:nth-child(4) {
                    width: 55px;
                }

                /* 성별 */
                .member-table th:nth-child(5),
                .member-table td:nth-child(5) {
                    width: 190px;
                    text-align: left;
                }

                /* 주소 */
                .member-table th:nth-child(6),
                .member-table td:nth-child(6) {
                    width: 170px;
                    text-align: left;
                }

                /* 이메일 */
                .member-table th:nth-child(7),
                .member-table td:nth-child(7) {
                    width: 90px;
                }

                /* 가입일 */
                .member-table th:nth-child(8),
                .member-table td:nth-child(8) {
                    width: 110px;
                }

                /* 전화번호 */
                .member-table th:nth-child(9),
                .member-table td:nth-child(9) {
                    width: 70px;
                }

                /* 유형 */
                .member-table th:nth-child(10),
                .member-table td:nth-child(10) {
                    width: 260px;
                    text-align: left;
                }

                /* 판매자정보 */
                .member-table th:nth-child(11),
                .member-table td:nth-child(11) {
                    width: 90px;
                }

                /* 승인상태 */
                .member-table th:nth-child(12),
                .member-table td:nth-child(12) {
                    width: 90px;
                }

                /* 승인관리 */
                .member-table th:nth-child(13),
                .member-table td:nth-child(13) {
                    width: 140px;
                }

                .member-table tr:hover {
                    background-color: #f9f9f9;
                }

                .btn-action {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    padding: 6px 10px;
                    border-radius: 6px;
                    font-size: 12px;
                    cursor: pointer;
                    transition: 0.2s;
                    margin: 0 3px;
                    white-space: nowrap;
                }

                .btn-action.reject {
                    background: #c94c4c;
                }

                .btn-action:hover {
                    opacity: 0.9;
                }

                .no-data {
                    text-align: center;
                    padding: 20px;
                    color: #777;
                }

                .btn-back {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 10px 20px;
                    font-size: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                    margin-bottom: 25px;
                }

                .btn-back:hover {
                    background: #4ba954;
                }

                .status-box {
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: center;
                    align-items: center;
                    gap: 6px;
                }

                .status-box select {
                    padding: 4px 8px;
                    border-radius: 6px;
                    border: 1px solid #ccc;
                    font-size: 13px;
                    width: 72px;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">
                    <div class="admin-container">
                        <div class="admin-header">
                            <button class="btn-back" @click="fnGoBack">이전</button>
                            <h2 class="admin-title">회원관리</h2>
                        </div>

                        <div class="member-filter">
                            <input type="text" v-model="keyword" placeholder="회원 ID 또는 이름 검색" />
                            <button @click="fnSearch">검색</button>
                        </div>

                        <div class="table-wrap">
                            <table class="member-table">
                                <thead>
                                    <tr>
                                        <th>회원ID</th>
                                        <th>이름</th>
                                        <th>생년월일</th>
                                        <th>성별</th>
                                        <th>주소</th>
                                        <th>이메일</th>
                                        <th>가입일</th>
                                        <th>전화번호</th>
                                        <th>유형</th>
                                        <th>판매자 정보</th>
                                        <th>판매자승인상태</th>
                                        <th>판매자승인관리</th>
                                        <th>유저상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in filteredList">
                                        <td>{{ item.userId }}</td>
                                        <td>{{ item.name }}</td>
                                        <td>{{ item.userBirth }}</td>
                                        <td>{{ item.userGender }}</td>
                                        <td>{{ item.address }}</td>
                                        <td>{{ item.email }}</td>
                                        <td>{{ item.cdatetime }}</td>
                                        <td>{{ item.phone }}</td>
                                        <td>{{ item.userRole }}</td>
                                        <td>
                                            <div v-if="item.userRole === 'SELLER'">
                                                <div>유형: {{ formatSellerType(item.sellerType) }}</div>
                                                <div>통신판매업: {{ item.teleSaleNo || '-' }}</div>
                                                <div>
                                                    판매 품목:
                                                    <span v-if="item.saleRawAgri === 'Y'">농산물 </span>
                                                    <span v-if="item.saleProcessed === 'Y'">가공식품 </span>
                                                    <span v-if="item.saleLivestock === 'Y'">축산물 </span>
                                                    <span v-if="item.saleSeafood === 'Y'">수산물 </span>
                                                    <span v-if="item.saleOther === 'Y'">기타</span>
                                                    <span v-if="!hasAnySaleCategory(item)">-</span>
                                                </div>
                                                <div v-if="item.saleProcessed === 'Y'">
                                                    가공식품업: {{ item.foodBizType || '-' }} / {{ item.foodBizNo || '-' }}
                                                </div>
                                                <div v-if="item.saleLivestock === 'Y'">
                                                    축산물업: {{ item.livestockBizType || '-' }} / {{ item.livestockBizNo ||
                                                    '-' }}
                                                </div>
                                                <div v-if="item.saleSeafood === 'Y'">
                                                    수산물업: {{ item.seafoodBizType || '-' }} / {{ item.seafoodBizNo || '-'
                                                    }}
                                                </div>
                                            </div>
                                            <div v-else>-</div>
                                        </td>

                                        <td>
                                            <span v-if="item.userRole === 'SELLER'">
                                                {{ item.verified === 'Y' ? '승인완료' : '미승인' }}
                                            </span>
                                            <span v-else>-</span>
                                        </td>

                                        <td>
                                            <template v-if="item.userRole === 'SELLER'">
                                                <button v-if="item.verified === 'N'" class="btn-action"
                                                    @click="fnApprove(item)">
                                                    승인
                                                </button>
                                                <button v-else class="btn-action reject" @click="fnReject(item)">
                                                    승인취소
                                                </button>
                                            </template>
                                            <span v-else>-</span>
                                        </td>
                                        <td>
                                            <div class="status-box">
                                                <select v-model="item.status">
                                                    <option v-for="opt in statusOptions" :key="opt.value"
                                                        :value="opt.value">
                                                        {{ opt.label }}
                                                    </option>
                                                </select>
                                                <button class="btn-action" @click="fnSaveStatus(item)">
                                                    저장
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="userList.length === 0">
                                        <td colspan="13" class="no-data">회원 정보가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        // ✅ 공통 옵션(버튼 보라색 방지 + 항상 초록 confirm)
                        const swalOk = {
                            confirmButtonText: '확인',
                            confirmButtonColor: '#5dbb63',
                            allowOutsideClick: false
                        };

                        const swalConfirm = (text, confirmText = '확인', cancelText = '취소') => {
                            return Swal.fire({
                                icon: 'warning',
                                title: '⚠️',
                                text: String(text),
                                showCancelButton: true,
                                confirmButtonText: confirmText,
                                cancelButtonText: cancelText,
                                confirmButtonColor: '#5dbb63',
                                cancelButtonColor: '#999',
                                allowOutsideClick: false
                            });
                        };

                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${pageContext.request.contextPath}",
                                    keyword: "",
                                    userList: [],
                                    statusOptions: [
                                        { value: "ACTIVE", label: "정상" },
                                        { value: "WITHDRAWN", label: "탈퇴" },
                                        { value: "LOCKED", label: "잠김" },
                                    ]
                                };
                            },
                            computed: {
                                filteredList() {
                                    if (this.keyword.trim() === "") return this.userList;

                                    const k = this.keyword.toLowerCase();
                                    return this.userList.filter(
                                        (m) =>
                                            m.userId.toLowerCase().includes(k) ||
                                            m.name.toLowerCase().includes(k)
                                    );
                                },
                            },
                            methods: {
                                fnGoBack() {
                                    if (document.referrer && document.referrer !== location.href) {
                                        history.back();
                                    } else {
                                        location.href = this.path + "/admin/dashboard.do";
                                    }
                                },

                                fnUserList: function () {
                                    let self = this;
                                    let param = {};
                                    $.ajax({
                                        url: "/userList.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            if (data.result == "success") {
                                                self.userList = data.list;
                                            } else {
                                                Swal.fire({ icon: 'error', title: '❌', text: "오류가 발생했습니다.", ...swalOk });
                                            }
                                        },
                                        error: function () {
                                            Swal.fire({ icon: 'error', title: '❌', text: "서버와 통신 중 오류가 발생했습니다.", ...swalOk });
                                        }
                                    });
                                },

                                fnSearch() {
                                    // computed로 자동 반영
                                },

                                formatSellerType(type) {
                                    if (!type) return "-";
                                    switch (type) {
                                        case "INDIVIDUAL": return "개인사업자";
                                        case "CORP": return "법인사업자";
                                        case "FARMER": return "농업인(자가생산)";
                                        default: return type;
                                    }
                                },

                                hasAnySaleCategory(item) {
                                    return (
                                        item.saleRawAgri === "Y" ||
                                        item.saleProcessed === "Y" ||
                                        item.saleLivestock === "Y" ||
                                        item.saleSeafood === "Y" ||
                                        item.saleOther === "Y"
                                    );
                                },

                                isSellerLegalReady(item) {
                                    if (item.userRole !== "SELLER") return false;

                                    if (!item.sellerType) { Swal.fire({ icon: 'warning', title: '⚠️', text: "판매자 유형이 설정되지 않았습니다.", ...swalOk }); return false; }
                                    if (!item.teleSaleNo) { Swal.fire({ icon: 'warning', title: '⚠️', text: "통신판매업 신고번호가 없습니다.", ...swalOk }); return false; }
                                    if (!this.hasAnySaleCategory(item)) { Swal.fire({ icon: 'warning', title: '⚠️', text: "판매 품목이 설정되지 않았습니다.", ...swalOk }); return false; }

                                    if (item.saleProcessed === "Y") {
                                        if (!item.foodBizType || !item.foodBizNo) { Swal.fire({ icon: 'warning', title: '⚠️', text: "가공식품 판매 시 식품 영업유형/신고번호가 필요합니다.", ...swalOk }); return false; }
                                    }
                                    if (item.saleLivestock === "Y") {
                                        if (!item.livestockBizType || !item.livestockBizNo) { Swal.fire({ icon: 'warning', title: '⚠️', text: "축산물 판매 시 축산물 영업유형/신고번호가 필요합니다.", ...swalOk }); return false; }
                                    }
                                    if (item.saleSeafood === "Y") {
                                        if (!item.seafoodBizType || !item.seafoodBizNo) { Swal.fire({ icon: 'warning', title: '⚠️', text: "수산물 판매 시 수산물 영업유형/신고번호가 필요합니다.", ...swalOk }); return false; }
                                    }

                                    return true;
                                },

                                fnApprove(item) {
                                    if (!this.isSellerLegalReady(item)) return;

                                    const self = this;
                                    swalConfirm(item.userId + " 판매자를 승인하시겠습니까?", "승인", "취소")
                                        .then((r) => {
                                            if (!r.isConfirmed) return;

                                            $.ajax({
                                                url: "/approveSeller.dox",
                                                dataType: "json",
                                                type: "POST",
                                                data: { userId: item.userId },
                                                success: function (data) {
                                                    if (data.result === "success") {
                                                        Swal.fire({ icon: 'success', title: '✅', text: "승인 완료", ...swalOk })
                                                            .then(() => self.fnUserList());
                                                    } else {
                                                        Swal.fire({ icon: 'error', title: '❌', text: (data.msg || "승인 처리에 실패했습니다."), ...swalOk });
                                                    }
                                                },
                                                error: function () {
                                                    Swal.fire({ icon: 'error', title: '❌', text: "승인 처리 중 오류가 발생했습니다.", ...swalOk });
                                                },
                                            });
                                        });
                                },

                                fnReject(item) {
                                    const self = this;
                                    swalConfirm(item.userId + " 판매자 승인을 취소하시겠습니까?", "승인취소", "취소")
                                        .then((r) => {
                                            if (!r.isConfirmed) return;

                                            $.ajax({
                                                url: "/rejectSeller.dox",
                                                dataType: "json",
                                                type: "POST",
                                                data: { userId: item.userId },
                                                success: function (data) {
                                                    if (data.result === "success") {
                                                        Swal.fire({ icon: 'success', title: '✅', text: "승인 취소 완료", ...swalOk })
                                                            .then(() => self.fnUserList());
                                                    } else {
                                                        Swal.fire({ icon: 'error', title: '❌', text: (data.msg || "취소 처리에 실패했습니다."), ...swalOk });
                                                    }
                                                },
                                                error: function () {
                                                    Swal.fire({ icon: 'error', title: '❌', text: "취소 처리 중 오류가 발생했습니다.", ...swalOk });
                                                },
                                            });
                                        });
                                },

                                fnSaveStatus(item) {
                                    const self = this;
                                    swalConfirm(item.userId + " 회원 상태를 '" + item.status + "'로 변경하시겠습니까?", "변경", "취소")
                                        .then((r) => {
                                            if (!r.isConfirmed) return;

                                            $.ajax({
                                                url: "/updateUserStatus.dox",
                                                dataType: "json",
                                                type: "POST",
                                                data: {
                                                    userId: item.userId,
                                                    userStatus: item.status
                                                },
                                                success: function (data) {
                                                    if (data.result === "success") {
                                                        Swal.fire({ icon: 'success', title: '✅', text: "회원 상태가 변경되었습니다.", ...swalOk })
                                                            .then(() => self.fnUserList());
                                                    } else {
                                                        Swal.fire({ icon: 'error', title: '❌', text: "상태 변경에 실패했습니다.", ...swalOk });
                                                    }
                                                },
                                                error: function () {
                                                    Swal.fire({ icon: 'error', title: '❌', text: "처리 중 오류가 발생했습니다.", ...swalOk });
                                                },
                                            });
                                        });
                                },

                            },
                            mounted() {
                                this.fnUserList();
                            },
                        });

                        app.mount("#app");
                    </script>
        </body>

        <!--  -->
        <!--  -->

        </html>