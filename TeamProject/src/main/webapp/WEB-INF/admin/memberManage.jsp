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

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #f9f9f9;
                }

                .admin-container {
                    max-width: 1200px;
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
                    overflow-x: auto;
                    margin: 0 auto;
                }

                .member-table {
                    width: 100%;
                    min-width: 1000px;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                    margin: 0 auto;
                }

                .member-table th {
                    background: #4caf50;
                    color: white;
                    padding: 12px;
                    font-weight: 600;
                    text-align: center;
                    white-space: nowrap;
                }

                .member-table td {
                    padding: 10px;
                    text-align: center;
                    border-bottom: 1px solid #eee;
                    vertical-align: middle;
                }

                .member-table th,
                .member-table td {
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .member-table td:nth-child(2) {
                    max-width: 120px;
                }

                .member-table td:nth-child(7) {
                    max-width: 100px;
                }

                .member-table tr:hover {
                    background-color: #f9f9f9;
                }

                .btn-action {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    padding: 5px 10px;
                    border-radius: 6px;
                    font-size: 13px;
                    cursor: pointer;
                    transition: 0.2s;
                    margin: 0 3px;
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
                    justify-content: center;
                    align-items: center;
                    gap: 6px;
                }

                .status-box select {
                    padding: 4px 8px;
                    border-radius: 6px;
                    border: 1px solid #ccc;
                    font-size: 13px;
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

                                        <!-- 판매자 승인 상태 -->
                                        <td>
                                            <span v-if="item.userRole === 'SELLER'">
                                                {{ item.verified === 'Y' ? '승인완료' : '미승인' }}
                                            </span>
                                            <span v-else>-</span>
                                        </td>

                                        <!-- 판매자 승인 관리 버튼 (여기서 로직 강화) -->
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
                                                alert("오류가 발생했습니다.");
                                            }
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
                                    // SELLER가 아닌 경우는 애초에 승인 대상이 아님
                                    if (item.userRole !== "SELLER") return false;

                                    // 판매자 유형 필수
                                    if (!item.sellerType) {
                                        alert("판매자 유형이 설정되지 않았습니다.");
                                        return false;
                                    }

                                    // 통신판매업 신고번호 필수
                                    if (!item.teleSaleNo) {
                                        alert("통신판매업 신고번호가 없습니다.");
                                        return false;
                                    }

                                    // 판매 품목 최소 1개 이상
                                    if (!this.hasAnySaleCategory(item)) {
                                        alert("판매 품목이 설정되지 않았습니다.");
                                        return false;
                                    }

                                    // 가공식품 선택 시 영업유형/번호 필수
                                    if (item.saleProcessed === "Y") {
                                        if (!item.foodBizType || !item.foodBizNo) {
                                            alert("가공식품 판매 시 식품 영업유형/신고번호가 필요합니다.");
                                            return false;
                                        }
                                    }

                                    // 축산물 선택 시 영업유형/번호 필수
                                    if (item.saleLivestock === "Y") {
                                        if (!item.livestockBizType || !item.livestockBizNo) {
                                            alert("축산물 판매 시 축산물 영업유형/신고번호가 필요합니다.");
                                            return false;
                                        }
                                    }

                                    // 수산물 선택 시 영업유형/번호 필수
                                    if (item.saleSeafood === "Y") {
                                        if (!item.seafoodBizType || !item.seafoodBizNo) {
                                            alert("수산물 판매 시 수산물 영업유형/신고번호가 필요합니다.");
                                            return false;
                                        }
                                    }

                                    // 여기까지 통과하면 OK
                                    return true;
                                },

                                fnApprove(item) {
                                    // 1) 법적 요건 체크
                                    if (!this.isSellerLegalReady(item)) {
                                        // 조건 미충족이면 여기서 막고 return
                                        return;
                                    }

                                    if (!confirm(item.userId + " 판매자를 승인하시겠습니까?")) return;

                                    const self = this;
                                    const param = {
                                        userId: item.userId
                                    };

                                    $.ajax({
                                        url: "/approveSeller.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            if (data.result === "success") {
                                                alert("승인 완료");
                                                self.fnUserList();
                                            } else {
                                                alert(data.msg || "승인 처리에 실패했습니다.");
                                            }
                                        },
                                        error: function () {
                                            alert("승인 처리 중 오류가 발생했습니다.");
                                        },
                                    });
                                },

                                fnReject(item) {
                                    if (!confirm(item.userId + " 판매자 승인을 취소하시겠습니까?")) return;

                                    const self = this;
                                    const param = {
                                        userId: item.userId
                                    };

                                    $.ajax({
                                        url: "/rejectSeller.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            if (data.result === "success") {
                                                alert("승인 취소 완료");
                                                self.fnUserList();
                                            } else {
                                                alert(data.msg || "취소 처리에 실패했습니다.");
                                            }
                                        },
                                        error: function () {
                                            alert("취소 처리 중 오류가 발생했습니다.");
                                        },
                                    });
                                },

                                fnSaveStatus(item) {
                                    if (!confirm(item.userId + " 회원 상태를 '" + item.status + "'로 변경하시겠습니까?")) {
                                        return;
                                    }
                                    let self = this;
                                    let param = {
                                        userId: item.userId,
                                        userStatus: item.status
                                    };
                                    $.ajax({
                                        url: "/updateUserStatus.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            if (data.result === "success") {
                                                alert("회원 상태가 변경되었습니다.");
                                                self.fnUserList();
                                            } else {
                                                alert("상태 변경에 실패했습니다.");
                                            }
                                        },
                                        error: function () {
                                            alert("처리 중 오류가 발생했습니다.");
                                        },
                                    });
                                },

                            },
                            mounted() {
                                let self = this;
                                self.fnUserList();
                            },
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>