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
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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

                /* ✅ 고객문의 헤더 (공지사항과 동일하게 정렬) */
                .inquiry-header {
                    display: flex;
                    justify-content: space-between;
                    /* 검색창을 오른쪽으로 정렬 */
                    align-items: flex-end;
                    /* 제목과 검색창 아래쪽 맞춤 */
                    margin-bottom: 25px;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                /* 공지사항 왼쪽 영역 */
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

                /* ✅ 고객문의 왼쪽 영역 (공지사항 동일 스타일) */
                .inquiry-left {
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                }

                .inquiry-left h3 {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin: 0 0 5px 0;
                }

                .inquiry-left .total-count {
                    font-size: 14px;
                    color: #666;
                }

                .inquiry-left .total-count strong {
                    color: #1a5d1a;
                    font-weight: 700;
                }

                /* 오른쪽 검색창 */
                .notice-header .search-bar,
                .inquiry-header .search-bar {
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
                .inquiry-header select,
                .notice-header input,
                .inquiry-header input {
                    border: none;
                    background: transparent;
                    outline: none;
                    font-size: 13px;
                    color: #333;
                }

                .notice-header select,
                .inquiry-header select {
                    width: 70px;
                }

                .notice-header input,
                .inquiry-header input {
                    flex: 1;
                    min-width: 80px;
                }

                .notice-header button,
                .inquiry-header button {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    padding: 6px 14px;
                    border-radius: 25px;
                    font-size: 13px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .notice-header button:hover,
                .inquiry-header button:hover {
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

                .notice-table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: center;
                    font-size: 15px;
                    table-layout: fixed;
                    /* ✅ 열 너비 고정 */
                }

                .notice-table th,
                .notice-table td {
                    padding: 12px 10px;
                    border-bottom: 1px solid #eee;
                    word-wrap: break-word;
                    /* ✅ 긴 글도 줄바꿈 */
                }

                .notice-table a,
                table a {
                    color: inherit;
                    text-decoration: none;
                }

                .notice-table a:hover,
                table a:hover {
                    color: #1a5d1a;
                    text-decoration: underline;
                    font-weight: 600;
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
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.4);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    z-index: 1000;
                }

                .modal-content {
                    background: #fff;
                    padding: 25px;
                    border-radius: 10px;
                    width: 320px;
                    text-align: center;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                }

                .modal-content h4 {
                    color: #1a5d1a;
                    margin-bottom: 15px;
                    font-size: 18px;
                }

                .modal-content input {
                    width: 90%;
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                }

                .modal-content button {
                    background: #5dbb63;
                    color: #fff;
                    border: none;
                    padding: 8px 14px;
                    border-radius: 6px;
                    margin-top: 12px;
                    cursor: pointer;
                    transition: 0.25s;
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

                .notice-bottom-actions {
                    text-align: right;
                    margin-top: 20px;
                    margin-bottom: 20px;
                }

                .btn-write-notice {
                    background: #1a5d1a;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 6px;
                    font-size: 15px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-write-notice:hover {
                    background: #154a15;
                }

                .comment-count-badge {
                    color: #5dbb63;
                    font-size: 13px;
                    font-weight: 600;
                    margin-left: 5px;
                }


                .btn-write-inquiry {
                    position: fixed;
                    bottom: 40px;
                    right: 50px;
                    background: #5dbb63;
                    color: #fff;
                    font-size: 15px;
                    font-weight: 600;
                    border: none;
                    border-radius: 50px;
                    padding: 14px 22px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    cursor: pointer;
                    z-index: 999;
                    transition: all 0.3s ease;
                }

                .btn-write-inquiry:hover {
                    background: #4ba954;
                    transform: translateY(-2px);
                }

                .product-thumb {
                    width: 45px;
                    height: 45px;
                    object-fit: cover;
                    border-radius: 6px;
                    margin-right: 8px;
                }

                .product-name {
                    font-size: 14px;
                    font-weight: 500;
                    color: #1a5d1a;
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
                                <input type="text" v-model="keyword" placeholder="검색어를 입력하세요">
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
                                <tr v-for="n in noticeList" :key="n.noticeNo" @click="fnDetail(n.noticeNo)"
                                    class="row-link">
                                    <td>{{ n.noticeNo }}</td>
                                    <td style="text-align:left; padding-left:15px; cursor:pointer;">{{ n.title }}<span
                                            v-if="n.commentCount > 0" class="comment-count-badge">({{ n.commentCount
                                            }})</span></td>
                                    <td>{{ n.userId }}</td>
                                    <td>{{ n.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="notice-bottom-actions">
                            <button v-if="userRole === 'ADMIN'" class="btn-write-notice" @click="fnGoToNoticeWrite">공지사항
                                작성</button>
                        </div>

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

                    <!-- ✅ 상품문의 (검색창 + 페이지네이션 완전 동일 구조) -->
                    <c:if test="${param.tab eq 'qna'}">
                        <div class="inquiry-header">
                            <div class="inquiry-left">
                                <h3>상품문의</h3>
                                <p class="total-count">총 <strong>{{ qnaList.length }}</strong>개의 게시물</p>
                            </div>

                            <div class="search-bar">
                                <select v-model="qnaSearchType">
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                    <option value="userId">작성자</option>
                                </select>
                                <input type="text" v-model="qnaKeyword" placeholder="검색어를 입력하세요">
                                <button @click="fnSearchQna">검색</button>
                            </div>
                        </div>

                        <div v-if="qnaList.length === 0" class="empty">등록된 상품문의가 없습니다.</div>

                        <table v-if="qnaList.length > 0" class="notice-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>상품정보</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>조회수</th>
                                    <th>처리상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="q in qnaList" :key="q.qnaNo" class="row-link">
                                    <td>{{ q.qnaNo }}</td>
                                    <td style="text-align:left; display:flex; align-items:center;">
                                        <img :src="q.thumbUrl" class="product-thumb" v-if="q.thumbUrl">
                                        <div style="margin-left:10px;">
                                            <div class="product-name">{{ q.pname }}</div>
                                        </div>
                                    </td>
                                    <td style="text-align:left; padding-left:15px;">
                                        <a href="javascript:void(0);" @click="fnOpenQnaDetail(q.qnaNo, q.isSecret)"
                                            style="text-decoration:none; color:inherit;">
                                            {{ q.title }}
                                            <span v-if="q.isSecret === 'Y'" class="lock">🔒</span>
                                        </a>
                                    </td>
                                    <td>{{ q.userId }}</td>
                                    <td>{{ q.regDate }}</td>
                                    <td>{{ q.cnt }}</td>
                                    <td>{{ q.status }}</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ✅ 페이지네이션 -->
                        <div class="pagination" v-if="qnaTotalPage > 1">
                            <button :disabled="qnaPage === 1" @click="fnChangeQnaPage(qnaPage - 1)">이전</button>
                            <button v-for="p in qnaTotalPage" :key="p" :class="{active: p === qnaPage}"
                                @click="fnChangeQnaPage(p)">
                                {{ p }}
                            </button>
                            <button :disabled="qnaPage === qnaTotalPage"
                                @click="fnChangeQnaPage(qnaPage + 1)">다음</button>
                        </div>
                    </c:if>

                    <!-- ✅ 고객문의 (비밀번호 모달 적용) -->
                    <c:if test="${param.tab eq 'inquiry'}">
                        <div class="inquiry-header">
                            <div class="inquiry-left">
                                <h3>고객문의</h3>
                                <p class="total-count">총 <strong>{{ inquiryList.length }}</strong>개의 게시물</p>
                            </div>

                            <div class="search-bar">
                                <select v-model="inquirySearchType">
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                    <option value="userId">작성자</option>
                                </select>
                                <input type="text" v-model="inquiryKeyword" placeholder="검색어를 입력하세요">
                                <button @click="fnSearchInquiry">검색</button>
                            </div>
                        </div>

                        <div v-if="inquiryList.length === 0" class="empty">고객문의 내역이 없습니다.</div>

                        <table v-if="inquiryList.length > 0" class="notice-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>조회수</th>
                                    <th>처리상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="i in inquiryList" :key="i.inquiryNo" class="row-link">
                                    <td>{{ i.inquiryNo }}</td>
                                    <td style="text-align:left; padding-left:15px;">
                                        <a href="javascript:void(0);"
                                            @click="fnOpenInquiryDetail(i.inquiryNo, i.isSecret)">
                                            {{ i.title }}
                                            <span v-if="i.isSecret === 'Y'" class="lock">🔒</span>
                                        </a>
                                    </td>
                                    <td>{{ i.userId }}</td>
                                    <td>{{ i.regDate }}</td>
                                    <td>{{ i.cnt }}</td>
                                    <td>{{ i.status }}</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ✅ 페이지네이션 -->
                        <div class="pagination" v-if="inquiryTotalPage > 1">
                            <button :disabled="inquiryPage === 1"
                                @click="fnChangeInquiryPage(inquiryPage - 1)">이전</button>
                            <button v-for="p in inquiryTotalPage" :key="p" :class="{active: p === inquiryPage}"
                                @click="fnChangeInquiryPage(p)">
                                {{ p }}
                            </button>
                            <button :disabled="inquiryPage === inquiryTotalPage"
                                @click="fnChangeInquiryPage(inquiryPage + 1)">다음</button>
                        </div>

                        <button class="btn-write-inquiry" @click="fnGoToInquiryWrite">
                            ✏️ 문의글 작성
                        </button>
                    </c:if>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}",
                                    // 공지사항
                                    noticeList: [],
                                    searchType: "title",
                                    keyword: "",
                                    page: 1,
                                    totalPage: 1,
                                    userRole: "${sessionScope.sessionStatus}",

                                    // 상품문의
                                    qnaList: [],
                                    qnaKeyword: "",
                                    qnaSearchType: "title",
                                    qnaPage: 1,
                                    qnaTotalPage: 1,
                                    qnaPageSize: 10,


                                    // 고객문의
                                    inquiryList: [],
                                    inquirySearchType: "title",
                                    inquiryKeyword: "",
                                    inquiryPage: 1,
                                    inquiryTotalPage: 1,
                                    inquiryPageSize: 10
                                };
                            },
                            methods: {
                                /* =========================
                                   ✅ 공지사항 불러오기
                                ========================== */
                                fnLoadNotice() {
                                    const self = this;
                                    const params = {
                                        searchType: self.searchType,
                                        keyword: self.keyword,
                                        page: self.page // 페이지 번호 파라미터 추가
                                    };

                                    $.ajax({
                                        url: "/noticeList.dox",
                                        type: "POST",
                                        data: params,
                                        dataType: "json",
                                        success(res) {
                                            // 서버로부터 받은 데이터로 갱신
                                            console.log(res);
                                            self.noticeList = res.list;
                                            self.page = res.page;
                                            self.totalPage = res.totalPage;

                                            // 총 게시물 개수 표시 업데이트
                                            const totalCountEl = document.querySelector('.total-count strong');
                                            if (totalCountEl) totalCountEl.textContent = res.totalCount;
                                        },
                                        error() {
                                            console.error("공지사항 불러오기 실패");
                                        }
                                    });
                                },
                                // ✅ 공지사항 검색
                                fnSearchNotice() {
                                    let self = this;
                                    self.page = 1;
                                    self.fnLoadNotice();
                                },

                                // ✅ 페이지 변경
                                fnChangePage(p) {
                                    // 유효하지 않은 페이지는 무시
                                    if (p < 1 || p > this.totalPage) {
                                        return;
                                    }
                                    this.page = p;
                                    this.fnLoadNotice();
                                },

                                /* =========================
                                    ✅ 상품문의 목록 불러오기
                                ========================== */
                                fnLoadQna(keyword = "", searchType = "", page = 1) {
                                    const self = this;
                                    $.ajax({
                                        url: "/productQnaList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            keyword: self.qnaKeyword,
                                            searchType: self.qnaSearchType,
                                            page: self.qnaPage,
                                            pageSize: self.qnaPageSize,
                                        },
                                        success(res) {
                                            self.qnaList = res.list || [];
                                            self.qnaPage = res.page;
                                            self.qnaTotalPage = res.totalPage;
                                        },
                                        error() {
                                            console.error("상품문의 불러오기 실패");
                                        }
                                    });
                                },

                                fnSearchQna() {
                                    if (!this.qnaKeyword.trim()) {
                                        Swal.fire("검색어 입력", "검색어를 입력하세요.", "warning");
                                        return;
                                    }
                                    this.qnaPage = 1;
                                    this.fnLoadQna(this.qnaKeyword, this.qnaSearchType, 1);
                                },

                                fnChangeQnaPage(p) {
                                    this.qnaPage = p;
                                    this.fnLoadQna(this.qnaKeyword, this.qnaSearchType, p);
                                },

                                fnOpenQnaDetail(id, isSecret) {
                                    // 공개글
                                    if (isSecret !== "Y") {
                                        location.href = "/productQna/detail.do?qnaNo=" + id;
                                        return;
                                    }

                                    // 비공개글 → 비밀번호 입력창
                                    Swal.fire({
                                        title: "비밀번호 확인",
                                        input: "password",
                                        inputLabel: "비공개 게시글입니다. 비밀번호를 입력해주세요.",
                                        confirmButtonText: "확인",
                                        showCancelButton: true,
                                        cancelButtonText: "취소",
                                        confirmButtonColor: "#5dbb63",
                                        cancelButtonColor: "#aaa",
                                        preConfirm: (password) => {
                                            if (!password) {
                                                Swal.showValidationMessage("비밀번호를 입력해주세요.");
                                                return false;
                                            }
                                            return password;
                                        }
                                    }).then((result) => {
                                        if (result.isConfirmed && result.value) {
                                            $.ajax({
                                                url: "/productQna/checkPwd.dox",
                                                type: "POST",
                                                dataType: "json",
                                                data: {
                                                    qnaNo: id,
                                                    pw: result.value
                                                },
                                                success: (res) => {
                                                    if (res.result === "success") {
                                                        Swal.fire({
                                                            icon: "success",
                                                            title: "인증 완료",
                                                            text: "게시글로 이동합니다.",
                                                            confirmButtonColor: "#5dbb63",
                                                            timer: 1200,
                                                            showConfirmButton: false
                                                        }).then(() => {
                                                            location.href = "/productQna/detail.do?qnaNo=" + id;
                                                        });
                                                    } else {
                                                        Swal.fire({
                                                            icon: "error",
                                                            title: "인증 실패",
                                                            text: "비밀번호가 올바르지 않습니다.",
                                                            confirmButtonColor: "#5dbb63"
                                                        });
                                                    }
                                                }
                                            });
                                        }
                                    });
                                },

                                fnGoToQnaWrite() {
                                    const self = this;
                                    // 로그인 체크
                                    if (!self.sessionId || self.sessionId.trim() === "") {
                                        Swal.fire({
                                            icon: "warning",
                                            title: "로그인이 필요합니다",
                                            text: "상품문의 작성은 로그인 후 이용 가능합니다.",
                                            confirmButtonColor: "#5dbb63"
                                        }).then(() => {
                                            location.href = "/login.do";
                                        });
                                        return;
                                    }

                                    // 상품문의 작성 페이지로 이동
                                    location.href = "/productQna/write.do";
                                },

                                /* =========================
                                   ✅ 고객문의 목록 불러오기
                                ========================== */
                                fnLoadInquiry(keyword = "", searchType = "", page = 1) {
                                    const self = this;
                                    $.ajax({
                                        url: "/inquiryList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            keyword: self.inquiryKeyword,
                                            searchType: self.inquirySearchType,
                                            page: self.inquiryPage,
                                            pageSize: self.inquiryPageSize
                                        },
                                        success(res) {
                                            self.inquiryList = res.list || [];
                                            self.inquiryPage = res.page;
                                            self.inquiryTotalPage = res.totalPage;
                                        },
                                        error() {
                                            console.error("고객문의 불러오기 실패");
                                        }
                                    });
                                },

                                fnSearchInquiry() {
                                    if (!this.inquiryKeyword.trim()) return alert("검색어를 입력하세요.");
                                    this.inquiryPage = 1;
                                    this.fnLoadInquiry(this.inquiryKeyword, this.inquirySearchType, 1);
                                },

                                // ===== 페이지 전환 =====
                                fnChangeInquiryPage(p) {
                                    this.inquiryPage = p;
                                    this.fnLoadInquiry(this.inquiryKeyword, this.inquirySearchType, p);
                                },

                                fnDetail(noticeNo) {
                                    location.href = "/noticeView.do?noticeNo=" + noticeNo;
                                },
                                fnGoToNoticeWrite: function () {
                                    location.href = "/notice/write.do";
                                },

                                /* =========================
                                ✅ 고객문의 제목 클릭 시 동작
                                ========================== */
                                fnOpenInquiryDetail(id, isSecret) {
                                    const self = this;
                                    // 공개글이면 바로 이동
                                    if (isSecret !== 'Y') {
                                        location.href = "/inquiry/detail.do?inquiryNo=" + id;
                                        return;
                                    }

                                    // ✅ 로그인하지 않은 사용자는 접근 제한
                                    if (!self.sessionId || self.sessionId.trim() === "") {
                                        Swal.fire({
                                            icon: "warning",
                                            title: "로그인이 필요합니다",
                                            text: "비공개 문의는 로그인 후 확인할 수 있습니다.",
                                            confirmButtonColor: "#5dbb63"
                                        }).then(() => {
                                            location.href = "/login.do";
                                        });
                                        return;
                                    }

                                    // ✅ 로그인한 사용자별 인증 여부 체크
                                    const authKey = `auth_inquiry_${self.sessionId}_${id}`;

                                    if (sessionStorage.getItem(authKey) === "true") {
                                        // 이미 인증된 글이면 바로 이동
                                        location.href = "/inquiry/detail.do?inquiryNo=" + id;
                                        return;
                                    }

                                    // ✅ SweetAlert2 비밀번호 입력창
                                    Swal.fire({
                                        title: "비밀번호 확인",
                                        input: "password",
                                        inputLabel: "비공개 게시글입니다. 비밀번호를 입력해주세요.",
                                        inputPlaceholder: "비밀번호를 입력하세요",
                                        inputAttributes: {
                                            maxlength: 20,
                                            autocapitalize: "off",
                                            autocorrect: "off"
                                        },
                                        confirmButtonText: "확인",
                                        showCancelButton: true,
                                        cancelButtonText: "취소",
                                        confirmButtonColor: "#5dbb63",
                                        cancelButtonColor: "#aaa",
                                        preConfirm: (password) => {
                                            if (!password) {
                                                Swal.showValidationMessage("비밀번호를 입력해주세요.");
                                                return false;
                                            }
                                            return password;
                                        }
                                    }).then((result) => {
                                        if (result.isConfirmed && result.value) {
                                            const pw = result.value;

                                            $.ajax({
                                                url: "/inquiry/checkPwd.dox",
                                                type: "POST",
                                                dataType: "json",
                                                data: {
                                                    inquiryNo: id,
                                                    pw: pw
                                                },
                                                success: (res) => {
                                                    if (res.result === "success") {
                                                        // 인증 성공 → 세션 저장 + 이동
                                                        sessionStorage.setItem(`auth_inquiry_${id}`, "true");
                                                        Swal.fire({
                                                            icon: "success",
                                                            title: "인증 완료",
                                                            text: "게시글로 이동합니다.",
                                                            confirmButtonColor: "#5dbb63",
                                                            timer: 1200,
                                                            showConfirmButton: false
                                                        }).then(() => {
                                                            location.href = "/inquiry/detail.do?inquiryNo=" + id;
                                                        });
                                                    } else {
                                                        Swal.fire({
                                                            icon: "error",
                                                            title: "인증 실패",
                                                            text: "비밀번호가 올바르지 않습니다.",
                                                            confirmButtonColor: "#5dbb63"
                                                        });
                                                    }
                                                },
                                                error: () => {
                                                    Swal.fire({
                                                        icon: "error",
                                                        title: "오류 발생",
                                                        text: "비밀번호 확인 중 오류가 발생했습니다.",
                                                        confirmButtonColor: "#5dbb63"
                                                    });
                                                }
                                            });
                                        }
                                    });
                                },

                                fnGoToInquiryWrite() {
                                    const self = this;

                                    // 로그인 여부 확인
                                    if (!self.sessionId || self.sessionId.trim() === "") {
                                        Swal.fire({
                                            icon: "warning",
                                            title: "로그인이 필요합니다",
                                            text: "문의글 작성은 로그인 후 이용 가능합니다.",
                                            confirmButtonColor: "#5dbb63"
                                        }).then(() => {
                                            location.href = "/login.do";
                                        });
                                        return;
                                    }

                                    // 문의글 작성 페이지로 이동
                                    location.href = "/inquiry/write.do";
                                }

                            },
                            mounted() {
                                const currentTab = new URLSearchParams(window.location.search).get("tab");

                                switch (currentTab) {
                                    case "notice":
                                    case null:
                                    case "":
                                        this.fnLoadNotice();
                                        break;
                                    case "inquiry":
                                        this.fnLoadInquiry();
                                        break;
                                    case "qna":
                                        this.fnLoadQna && this.fnLoadQna(); // 필요 시
                                        break;
                                    default:
                                        break;
                                }

                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>