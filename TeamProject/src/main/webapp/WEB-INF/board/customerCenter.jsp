<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>고객센터 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                html,
                body {
                    margin: 0;
                    padding: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background: #faf8f0;
                }

                /* ✅ 페이지 전체 컨테이너 */
                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    width: 100%;
                    box-sizing: border-box;
                    padding: 0 120px;
                    /* ✅ 좌우에 120px 마진처럼 여백 부여 */
                }

                /* 내부 컨텐츠 */
                .page-container {
                    flex: 1;
                    background: #fff;
                    padding: 60px 0;
                    /* 상하 여백만 유지 */
                    box-sizing: border-box;
                    border-radius: 10px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                }

                /* 제목 */
                h1.title {
                    text-align: center;
                    color: #1a5d1a;
                    font-size: 30px;
                    font-weight: 700;
                    margin-bottom: 40px;
                }

                /* ============================= */
                /* 📋 탭 메뉴 */
                .tab-menu {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    border-bottom: 2px solid #5dbb63;
                    flex-wrap: wrap;
                    margin-bottom: 35px;
                    padding: 0;
                    gap: 10px;
                }

                .tab-menu li {
                    list-style: none;
                }

                .tab-menu a {
                    display: block;
                    padding: 14px 35px;
                    color: #555;
                    text-decoration: none;
                    font-weight: 600;
                    font-size: 16px;
                    transition: all 0.3s;
                    border-radius: 6px 6px 0 0;
                }

                .tab-menu li:hover a {
                    background: #f3ebd3;
                    color: #1a5d1a;
                }

                .tab-menu .active a {
                    color: #1a5d1a;
                    border-bottom: 3px solid #5dbb63;
                    background: #f9f9f9;
                }

                /* ============================= */
                /* 📋 공지사항 헤더 */
                .notice-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-end;
                    /* ✅ 제목/검색창 라인 하단 정렬 */
                    margin-bottom: 25px;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                /* 왼쪽 영역 */
                .notice-left {
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                }

                .notice-left h3 {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin: 0 0 5px 0;
                }

                .notice-left .total-count {
                    font-size: 14px;
                    color: #666;
                }

                .notice-left .total-count strong {
                    color: #1a5d1a;
                    font-weight: 700;
                }

                /* 오른쪽 검색창 */
                .notice-header .search-bar {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    background: #f5f5f5;
                    border: 1px solid #ddd;
                    border-radius: 25px;
                    padding: 6px 12px;
                    width: 260px;
                    /* ✅ 줄인 검색창 */
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                }

                .notice-header select,
                .notice-header input {
                    border: none;
                    background: transparent;
                    outline: none;
                    font-size: 13px;
                    color: #333;
                }

                .notice-header select {
                    width: 70px;
                }

                .notice-header input {
                    flex: 1;
                    min-width: 80px;
                }

                .notice-header button {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    padding: 6px 14px;
                    border-radius: 25px;
                    font-size: 13px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .notice-header button:hover {
                    background: #4ba954;
                }

                /* ============================= */
                /* 📋 테이블 */
                table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: center;
                    font-size: 15px;
                }

                thead {
                    background: #f3ebd3;
                    border-bottom: 2px solid #ddd;
                }

                th {
                    color: #333;
                    padding: 12px;
                    font-weight: 700;
                }

                td {
                    padding: 12px 10px;
                    border-bottom: 1px solid #eee;
                    color: #555;
                }

                tr:hover {
                    background: #fafafa;
                    cursor: pointer;
                }

                .lock {
                    color: #e74c3c;
                    font-size: 14px;
                    margin-left: 4px;
                }

                .empty {
                    text-align: center;
                    padding: 50px 0;
                    color: #888;
                }

                /* ============================= */
                /* 📑 페이지네이션 */
                .pagination {
                    display: flex;
                    justify-content: center;
                    margin-top: 30px;
                    gap: 6px;
                }

                .pagination button {
                    border: 1px solid #ccc;
                    background: white;
                    color: #333;
                    padding: 7px 14px;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: 0.25s;
                }

                .pagination button:hover {
                    background: #5dbb63;
                    color: white;
                    border-color: #5dbb63;
                }

                .pagination .active {
                    background: #5dbb63;
                    color: white;
                    font-weight: 600;
                }

                /* ============================= */
                /* 📘 FAQ / QNA */
                h3 {
                    font-size: 20px;
                    margin-bottom: 20px;
                    color: #1a5d1a;
                    border-left: 4px solid #5dbb63;
                    padding-left: 10px;
                }

                .faq-item {
                    background: #fafafa;
                    border: 1px solid #eee;
                    border-radius: 8px;
                    padding: 15px;
                    margin-bottom: 12px;
                    transition: 0.2s;
                }

                .faq-item:hover {
                    background: #f3ebd3;
                }

                /* ============================= */
                /* 🔐 비밀번호 모달 */
                .modal {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    justify-content: center;
                    align-items: center;
                    z-index: 1000;
                }

                .modal-content {
                    background: #fff;
                    padding: 25px 30px;
                    border-radius: 10px;
                    text-align: center;
                    width: 320px;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.25);
                }

                .modal-content p {
                    font-weight: 500;
                    margin-bottom: 15px;
                    color: #333;
                }

                .modal-content input {
                    width: 100%;
                    padding: 8px;
                    margin-top: 8px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                }

                .modal-content button {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    padding: 8px 16px;
                    border-radius: 6px;
                    margin-top: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .modal-content button:hover {
                    background: #4ba954;
                }

                /* ============================= */
                /* 📱 반응형 */
                @media (max-width: 1024px) {
                    #app {
                        padding: 0 60px;
                        /* ✅ 태블릿은 여백 줄이기 */
                    }

                    .page-container {
                        padding: 40px 20px;
                    }

                    table {
                        font-size: 14px;
                    }

                    .notice-header {
                        flex-direction: column;
                        align-items: stretch;
                    }

                    .notice-header .search-bar {
                        width: 100%;
                        justify-content: space-between;
                    }
                }

                @media (max-width: 768px) {
                    #app {
                        padding: 0 20px;
                        /* ✅ 모바일은 좌우 여백 최소화 */
                    }

                    .tab-menu {
                        flex-direction: column;
                        gap: 0;
                    }

                    .tab-menu a {
                        padding: 10px 15px;
                        border-radius: 0;
                        width: 100%;
                        text-align: center;
                    }

                    .notice-header {
                        flex-direction: column;
                        align-items: flex-start;
                    }

                    .notice-header .search-bar {
                        width: 100%;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <h1 class="title">고객센터</h1>

                    <!-- ✅ 탭 메뉴 -->
                    <ul class="tab-menu">
                        <li class="${param.tab eq 'notice' || empty param.tab ? 'active' : ''}">
                            <a href="?tab=notice">공지사항</a>
                        </li>
                        <li class="${param.tab eq 'faq' ? 'active' : ''}">
                            <a href="?tab=faq">자주하는질문</a>
                        </li>
                        <li class="${param.tab eq 'qna' ? 'active' : ''}">
                            <a href="?tab=qna">상품문의</a>
                        </li>
                        <li class="${param.tab eq 'inquiry' ? 'active' : ''}">
                            <a href="?tab=inquiry">고객문의</a>
                        </li>
                    </ul>

                    <!-- ✅ 공지사항 탭 -->
                    <c:if test="${param.tab eq 'notice' || empty param.tab}">
                        <div class="notice-header">
                            <div class="notice-left">
                                <h3>공지사항</h3>
                                <p class="total-count">총 <strong>{{ noticeList.length }}</strong>개의 게시물</p>
                            </div>

                            <div class="search-bar">
                                <select v-model="searchType">
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                    <option value="writer">작성자</option>
                                </select>
                                <input type="text" v-model="keyword" placeholder="검색어 입력">
                                <button @click="fnSearchNotice">검색</button>
                            </div>
                        </div>

                        <div v-if="noticeList.length === 0" class="empty">공지사항을 불러오는 중...</div>

                        <table v-if="noticeList.length > 0" class="notice-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="n in noticeList" :key="n.noticeNo" @click="fnDetail(n.boardNo)"
                                    class="row-link">
                                    <td>{{ n.noticeNo }}</td>
                                    <td style="text-align:left; padding-left:15px; cursor:pointer;">{{ n.title }}
                                    </td>
                                    <td>{{ n.userId }}</td>
                                    <td>{{ n.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ✅ 페이지네이션 -->
                        <div class="pagination" v-if="totalPage > 1">
                            <button :disabled="page === 1" @click="fnChangePage(page - 1)">이전</button>
                            <button v-for="p in totalPage" :key="p" :class="{active: p === page}"
                                @click="fnChangePage(p)">
                                {{ p }}
                            </button>
                            <button :disabled="page === totalPage" @click="fnChangePage(page + 1)">다음</button>
                        </div>
                    </c:if>

                    <!-- ✅ FAQ 탭 (기존 JSTL 그대로) -->
                    <c:if test="${param.tab eq 'faq'}">
                        <h3>자주하는 질문</h3>
                        <c:forEach var="f" items="${faqList}">
                            <div style="margin-bottom:15px;">
                                <strong>Q. ${f.question}</strong><br>
                                <span style="color:#555;">A. ${f.answer}</span>
                            </div>
                        </c:forEach>
                    </c:if>

                    <!-- ✅ 상품문의 (비밀번호 모달 유지) -->
                    <c:if test="${param.tab eq 'qna'}">
                        <h3>상품문의</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="q" items="${qnaList}">
                                    <tr>
                                        <td>${q.qnaNo}</td>
                                        <td>
                                            <a href="javascript:void(0);" @click="fnOpenQna(${q.qnaNo}, '${q.secret}')">
                                                ${q.title}
                                                <c:if test="${q.secret eq 'Y'}"><span class="lock">🔒</span></c:if>
                                            </a>
                                        </td>
                                        <td>${q.writer}</td>
                                        <td>${q.regDate}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- ✅ 고객문의 (비밀번호 모달 적용) -->
                    <c:if test="${param.tab eq 'inquiry'}">
                        <h3>고객문의</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="i" items="${inquiryList}">
                                    <tr>
                                        <td>${i.inquiryNo}</td>
                                        <td>
                                            <a href="javascript:void(0);"
                                                @click="fnOpenInquiry(${i.inquiryNo}, '${i.secret}')">
                                                ${i.title}
                                                <c:if test="${i.secret eq 'Y'}"><span class="lock">🔒</span></c:if>
                                            </a>
                                        </td>
                                        <td>${i.writer}</td>
                                        <td>${i.regDate}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>

                <!-- 비밀번호 확인 모달 -->
                <div id="pwModal" class="modal">
                    <div class="modal-content">
                        <p>비밀번호를 입력해주세요.</p>
                        <input type="password" id="pwInput" placeholder="비밀번호 입력">
                        <button id="btnPwCheck">확인</button>
                        <button onclick="$('#pwModal').fadeOut()">닫기</button>
                    </div>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}",
                                    noticeList: []
                                };
                            },
                            methods: {
                                // ✅ 공지사항 불러오기 (AJAX)
                                fnLoadNotice() {
                                    const self = this;
                                    $.ajax({
                                        url: "/noticeList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success(res) {
                                            self.noticeList = res.list;
                                        },
                                        error() {
                                            console.error("공지사항 불러오기 실패");
                                        }
                                    });
                                },

                                // ✅ 상품문의 비밀번호 확인
                                fnOpenQna(qnaNo, secret) {
                                    if (secret !== 'Y') {
                                        location.href = "/qna/detail.do?qnaNo=" + qnaNo;
                                        return;
                                    }
                                    if (sessionStorage.getItem("auth_qna_" + qnaNo) === "true") {
                                        location.href = "/qna/detail.do?qnaNo=" + qnaNo;
                                        return;
                                    }

                                    $("#pwModal").fadeIn();
                                    $("#pwInput").val("").focus();

                                    $("#btnPwCheck").off("click").on("click", function () {
                                        const pw = $("#pwInput").val();
                                        if (!pw) return alert("비밀번호를 입력해주세요.");

                                        $.ajax({
                                            url: "/qna/checkPw.dox",
                                            type: "POST",
                                            dataType: "json",
                                            data: { qnaNo, pw },
                                            success(res) {
                                                if (res.result === "success") {
                                                    sessionStorage.setItem("auth_qna_" + qnaNo, "true");
                                                    $("#pwModal").fadeOut();
                                                    location.href = "/qna/detail.do?qnaNo=" + qnaNo;
                                                } else {
                                                    alert("비밀번호가 올바르지 않습니다.");
                                                }
                                            }
                                        });
                                    });
                                },

                                // ✅ 고객문의 비밀번호 확인
                                fnOpenInquiry(inquiryNo, secret) {
                                    if (secret !== 'Y') {
                                        location.href = "/inquiry/detail.do?inquiryNo=" + inquiryNo;
                                        return;
                                    }
                                    if (sessionStorage.getItem("auth_inquiry_" + inquiryNo) === "true") {
                                        location.href = "/inquiry/detail.do?inquiryNo=" + inquiryNo;
                                        return;
                                    }

                                    $("#pwModal").fadeIn();
                                    $("#pwInput").val("").focus();

                                    $("#btnPwCheck").off("click").on("click", function () {
                                        const pw = $("#pwInput").val();
                                        if (!pw) return alert("비밀번호를 입력해주세요.");

                                        $.ajax({
                                            url: "/inquiry/checkPw.dox",
                                            type: "POST",
                                            dataType: "json",
                                            data: { inquiryNo, pw },
                                            success(res) {
                                                if (res.result === "success") {
                                                    sessionStorage.setItem("auth_inquiry_" + inquiryNo, "true");
                                                    $("#pwModal").fadeOut();
                                                    location.href = "/inquiry/detail.do?inquiryNo=" + inquiryNo;
                                                } else {
                                                    alert("비밀번호가 올바르지 않습니다.");
                                                }
                                            }
                                        });
                                    });
                                }
                            },
                            mounted() {
                                // 현재 탭이 notice면 자동으로 불러오기
                                const currentTab = new URLSearchParams(window.location.search).get("tab");
                                if (!currentTab || currentTab === "notice") {
                                    this.fnLoadNotice();
                                }
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>