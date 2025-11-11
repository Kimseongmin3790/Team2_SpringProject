<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>회원관리</title>

            <!-- Vue & jQuery -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>

            <!-- 공통 스타일 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #f9f9f9;
                }

                /* 페이지 컨테이너 */
                .admin-container {
                    max-width: 1200px;
                    margin: 60px auto;
                    padding: 0 15px 60px;
                    box-sizing: border-box;
                }

                /* 제목 */
                .admin-title {
                    font-size: 1.8rem;
                    color: #2e5d2e;
                    font-weight: 700;
                    margin-bottom: 30px;
                    text-align: center;
                }

                /* 검색 필터 */
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

                /* ===== 테이블 스타일 ===== */
                .table-wrap {
                    width: 100%;
                    overflow-x: auto;
                    /* 가로 스크롤 허용 */
                    margin: 0 auto;
                }

                /* 테이블 */
                .member-table {
                    width: 100%;
                    min-width: 1000px;
                    /* 내용이 많을 때도 중앙 유지 */
                    border-collapse: collapse;
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                    margin: 0 auto;
                }

                /* 제목 행 */
                .member-table th {
                    background: #4caf50;
                    color: white;
                    padding: 12px;
                    font-weight: 600;
                    text-align: center;
                    white-space: nowrap;
                }

                /* 셀 기본 */
                .member-table td {
                    padding: 10px;
                    text-align: center;
                    border-bottom: 1px solid #eee;
                    vertical-align: middle;
                }

                /* 🔹 기본 줄바꿈 금지 + 말줄임 처리 */
                .member-table th,
                .member-table td {
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                /* 🔹 이름, 유형 칸 너비 제한 */
                .member-table td:nth-child(2) {
                    /* 이름 */
                    max-width: 120px;
                }

                .member-table td:nth-child(7) {
                    /* 유형 */
                    max-width: 100px;
                }

                /* hover 효과 */
                .member-table tr:hover {
                    background-color: #f9f9f9;
                }

                /* 버튼 */
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

                /* 데이터 없을 때 */
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

                        <!-- 검색 -->
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
                                        <td>{{ item.verified }}</td>
                                        <td>
                                            <!-- 🔹 판매자만 승인/거절 버튼 표시 -->
                                            <template v-if="item.userRole === 'SELLER' && item.verified === 'N'">
                                                <button class="btn-action" @click="fnApprove(item.userId)">승인</button>
                                            </template>
                                            <template v-else-if="item.userRole === 'SELLER' && item.verified === 'Y'">
                                                <button class="btn-action reject" @click="fnReject(item.userId)">승인취소</button>
                                            </template>
                                        </td>                                        
                                        <td>{{ item.status }}</td>
                                    </tr>
                                    <tr v-if="userList.length === 0">
                                        <td colspan="6" class="no-data">회원 정보가 없습니다.</td>
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
                                    keyword: "",
                                    userList: [],
                                };
                            },
                            computed: {
                                filteredList() {
                                    // keyword나 userList 중 하나라도 변경되면 자동으로 다시 계산
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
                                        // ✅ 이전 페이지로 이동
                                        history.back();
                                    } else {
                                        // ✅ 이전 페이지 정보가 없으면 관리자 메인으로
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

                                // 🔹 판매자 승인
                                fnApprove(userId) {
                                    if (!confirm(userId + " 판매자 승인하시겠습니까?")) return;
                                    let self = this;
                                    let param = {
                                        userId: userId
                                    };
                                    $.ajax({
                                        url: "/approveSeller.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            alert("승인 완료");
                                            self.fnUserList();
                                        },
                                        error: function () {
                                            alert("승인 처리 중 오류가 발생했습니다.");
                                        },
                                    });
                                },

                                // 🔹 판매자 거절
                                fnReject(userId) {
                                    if (!confirm(userId + " 판매자 승인을 취소하시겠습니까?")) return;
                                    const self = this;
                                    let param = {
                                        userId: userId
                                    };
                                    $.ajax({
                                        url: "/rejectSeller.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: param,
                                        success: function (data) {
                                            alert("취소 완료");
                                            self.fnUserList();
                                        },
                                        error: function () {
                                            alert("취소 처리 중 오류가 발생했습니다.");
                                        },
                                    });
                                },

                                // 신고 해제
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