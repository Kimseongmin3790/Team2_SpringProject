<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&icon_names=favorite,person,shopping_cart&display=block" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
</head>

<body>
    <c:set var="path" value="${pageContext.request.contextPath}" />

    <header class="header">
        <div class="header-top">
            <!-- 로고 -->
            <div class="logo" id="logoClick" style="cursor:pointer;">
                <img src="${path}/resources/img/logo.png" alt="로고" class="logo-img">
            </div>

            <!-- 검색창 -->
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
                        <c:when test="${not empty sessionScope.loginId}">
                            <button class="btn-logout" id="btnLogout">로그아웃</button>
                            <span class="user-name">${sessionScope.userName}님</span>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-login" onclick="location.href='${path}/login.do'">로그인</button>
                            <button class="btn-join" onclick="location.href='${path}/join'">회원가입</button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="icon-group">
                    <a href="javascript:;" id="btnMyPage">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                    <a href="javascript:;" id="btnFavorite">
                        <span class="material-symbols-outlined">favorite</span>
                    </a>
                    <a href="javascript:;" id="btnCart">
                        <span class="material-symbols-outlined">shopping_cart</span>
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
                <ul class="dropdown-menu" id="dropdownMenu">
                    <li><a href="${path}/category/fruits">농산물</a></li>
                    <li><a href="${path}/category/vegetables">수산물</a></li>
                    <li><a href="${path}/category/meat">축산물</a></li>
                    <li><a href="${path}/category/seafood">가공식품</a></li>
                    <li><a href="${path}/category/others">기타</a></li>
                </ul>
            </div>

            <nav class="nav-menu">
                <a href="${path}/">홈</a>
                <a href="${path}/product/list">상품목록</a>
                <a href="${path}/product/new">신상품</a>
                <a href="${path}/review/list">상품후기</a>
                <a href="${path}/event">번쩍장터</a>
            </nav>
        </div>
    </header>

    <script>
        $(document).ready(function () {
            const path = "${pageContext.request.contextPath}";

            // ✅ 로고 클릭 시 홈으로 이동
            $("#logoClick").on("click", function () {
                location.href = path + "/";
            });

            // ✅ 검색 버튼 클릭
            $("#btnSearch").on("click", function () {
                const keyword = $("#searchInput").val().trim();
                if (keyword === "") {
                    alert("검색어를 입력하세요!");
                    return;
                }
                location.href = path + "/search?keyword=" + encodeURIComponent(keyword);
            });

            // ✅ 로그아웃 버튼 클릭
            $("#btnLogout").on("click", function () {
                if (confirm("로그아웃 하시겠습니까?")) {
                    location.href = path + "/logout";
                }
            });

            // ✅ 아이콘 클릭 이벤트
            $("#btnMyPage").on("click", function () {
                location.href = path + "/mypage";
            });

            $("#btnFavorite").on("click", function () {
                location.href = path + "/favorite";
            });

            $("#btnCart").on("click", function () {
                location.href = path + "/cart";
            });

            // ✅ 카테고리 드롭다운 메뉴 토글
            $("#btnCategory").on("click", function () {
                $("#dropdownMenu").toggleClass("show");
            });

            // ✅ 외부 클릭 시 드롭다운 닫기
            $(document).on("click", function (e) {
                if (!$(e.target).closest(".category-container").length) {
                    $("#dropdownMenu").removeClass("show");
                }
            });
        });
    </script>
</body>
</html>
