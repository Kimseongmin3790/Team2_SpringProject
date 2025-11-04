<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            crossorigin="anonymous" referrerpolicy="no-referrer" />

        <c:set var="path" value="${pageContext.request.contextPath}" />

        <header class="header">
            <div class="header-top">
                <!-- 로고 -->
                <div class="logo" id="logoClick" style="cursor:pointer;">
                    <img src="${path}/resources/img/logo.png" alt="로고" class="logo-img">
                </div>

                <!-- ✅ 모바일 전용 토글 버튼 영역 -->
                <div class="mobile-buttons">
                    <button class="btn-hamburger" id="btnHamburger">
                        <i class="fa fa-bars"></i>
                    </button>
                    <button class="btn-search-toggle" id="btnSearchToggle">
                        <i class="fa fa-search"></i>
                    </button>
                </div>

                <!-- PC용 검색창 -->
                <div class="search-section">
                    <div class="search-bar">
                        <i class="fa fa-search"></i>
                        <input type="text" placeholder="검색창" id="searchInput">
                    </div>
                    <button class="btn-search" id="btnSearch">검색</button>
                </div>

                <!-- 오른쪽 메뉴 -->
                <div class="header-right">
                    <div class="login-group">
                        <c:choose>
                            <c:when test="${not empty sessionId}">
                                <span class="user-name">[${sessionName}님]</span>
                                <button class="btn-logout" id="btnLogout">로그아웃</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-login" onclick="location.href='${path}/login.do'">로그인</button>
                                <button class="btn-join" onclick="location.href='${path}/chooseJoin.do'">회원가입</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- 관리자 버튼 (ADMIN 전용) -->
                    <c:if test="${sessionScope.sessionStatus eq 'ADMIN'}">
                        <div class="admin-group">
                            <button class="btn-admin" onclick="location.href='${path}/dashboard.do'">
                                관리자페이지
                            </button>
                        </div>
                    </c:if>

                    <div class="icon-group">
                        <a href="javascript:;" id="btnMyPage" title="마이페이지" data-status="${sessionScope.sessionStatus}">
                            <i class="fa-solid fa-user"></i>
                        </a>
                        <a href="javascript:;" id="btnFavorite" title="찜한상품">
                            <i class="fa-solid fa-heart"></i>
                        </a>
                        <a href="javascript:;" id="btnCart" title="장바구니" data-status="${sessionScope.sessionStatus}">
                            <i class="fa-solid fa-cart-shopping"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- 하단 메뉴 -->
            <div class="header-bottom">
                <div class="category-container">
                    <button class="btn-category" id="btnCategory">
                        <i class="fa fa-bars"></i> 카테고리
                    </button>
                    <ul class="category-menu" id="dropdownMenu">
                        <!-- AJAX로 대분류, 중분류, 소분류가 자동 생성됨 -->
                    </ul>
                </div>

                <nav class="nav-menu">
                    <a href="${path}/main.do">홈</a>
                    <a href="${path}/productCategory.do">상품목록</a>               
                    <a href="${path}/review/list">베스트</a>
                    <a href="${path}/board.do">커뮤니티</a>
                    <a href="${path}/event">상품후기</a>
                </nav>
            </div>


<script>
$(document).ready(function () {
    const path = "${pageContext.request.contextPath}";

    // 로고 클릭 → 홈으로 이동
    $("#logoClick").on("click", function () {
        location.href = path + "/default.do";
    });

    // 검색
    $("#btnSearch").on("click", function () {
        const keyword = $("#searchInput").val().trim();
        if (keyword === "") {
            alert("검색어를 입력하세요!");
            return;
        }
        location.href = path + "/search?keyword=" + encodeURIComponent(keyword);
    });

    // 로그아웃
    $("#btnLogout").on("click", function () {
        if (confirm("로그아웃 하시겠습니까?")) {
            location.href = path + "/logout";
        }
    });

    // 아이콘 클릭
    $("#btnMyPage").on("click", () => location.href = path + "/mypage");
    $("#btnFavorite").on("click", () => location.href = path + "/favorite");
    $("#btnCart").on("click", () => location.href = path + "/cart");

    // 카테고리 토글
    $("#btnCategory").on("click", function () {
        $("#dropdownMenu").toggleClass("show");
    });

    // 외부 클릭 시 닫기
    $(document).on("click", function (e) {
        if (!$(e.target).closest(".category-container").length) {
            $("#dropdownMenu").removeClass("show");
        }
    });
});
</script>
        </header>
                
        <script src="${path}/resources/js/header.js"></script>
