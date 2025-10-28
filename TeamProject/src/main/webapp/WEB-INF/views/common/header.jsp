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
                            <c:when test="${not empty sessionId}">
                                <button class="btn-logout" id="btnLogout">로그아웃</button>
                                <span class="user-name">${{sessionId}}님</span>
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
                        <a href="javascript:;" id="btnMyPage" title="마이페이지">
                            <i class="fa-solid fa-user"></i>
                        </a>
                        <a href="javascript:;" id="btnFavorite" title="찜한상품">
                            <i class="fa-solid fa-heart"></i>
                        </a>
                        <a href="javascript:;" id="btnCart" title="장바구니">
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

                $.ajax({
                    url: path + "/categoryList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (res) {
                        const menu = $("#dropdownMenu");
                        menu.empty();

                        // ✅ 1단계: 대분류 분리
                        const topLevel = res.list.filter(c => !c.parentCategoryNo);
                        const children = res.list.filter(c => c.parentCategoryNo);

                        topLevel.forEach(top => {
                            const liTop = $("<li>");
                            const aTop = $("<a>").text(top.categoryName).attr("href", path + "/category/" + top.categoryNo);
                            liTop.append(aTop);

                            // ✅ 2단계: 중분류 생성
                            const midList = children.filter(m => m.parentCategoryNo === top.categoryNo);
                            if (midList.length > 0) {
                                const ulMid = $("<ul>");
                                midList.forEach(mid => {
                                    const liMid = $("<li>");
                                    const aMid = $("<a>").text(mid.categoryName).attr("href", path + "/category/" + mid.categoryNo);

                                    // ✅ 3단계: 소분류 생성
                                    const lowList = children.filter(s => s.parentCategoryNo === mid.categoryNo);
                                    if (lowList.length > 0) {
                                        const ulLow = $("<ul>");
                                        lowList.forEach(low => {
                                            const liLow = $("<li>");
                                            const aLow = $("<a>").text(low.categoryName).attr("href", path + "/category/" + low.categoryNo);
                                            liLow.append(aLow);
                                            ulLow.append(liLow);
                                        });
                                        liMid.append(ulLow);
                                    }

                                    liMid.append(aMid);
                                    ulMid.append(liMid);
                                });
                                liTop.append(ulMid);
                            }

                            menu.append(liTop);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("카테고리 불러오기 실패:", error);
                        $("#dropdownMenu").append("<li><span>불러오기 실패</span></li>");
                    }
                });



                // 로고 클릭 → 홈으로 이동
                $("#logoClick").on("click", function () {
                    location.href = path + "/main.do";
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
                        $.ajax({
                            url: path + "/logout.dox",
                            type: "POST",
                            success: function (res) {
                                if (res.result === "success") {
                                    alert("로그아웃 되었습니다.");
                                    location.href = path + "/login.do";
                                }
                            },
                            error: function () {
                                alert("로그아웃 중 오류가 발생했습니다.");
                            }
                        });
                    }
                });

                // 아이콘 클릭
                $("#btnMyPage").on("click", function () {
                    const sessionStatus = "${sessionScope.sessionStatus}";
                    const path = "${pageContext.request.contextPath}";
                    if (!sessionStatus) {
                        alert("로그인이 필요합니다.");
                        location.href = path + "/login.do";
                        return;
                    }
                    if (sessionStatus === "BUYER") {
                        location.href = path + "/buyerMyPage.do"
                    } else if (sessionStatus === "SELLER") {
                        location.href = path + "/sellerMypage.do";
                    } else {
                        alert("잘못된 사용자 정보입니다.");
                    }
                });
                $("#btnFavorite").on("click", () => location.href = path + "/favorite");
                $("#btnCart").on("click", () => location.href = path + "/cart");

                // 카테고리 버튼 클릭은 토글 기능만 수행
                $("#btnCategory").on("click", function () {
                    // 이미 데이터가 채워진 상태이므로 토글 기능만 남깁니다.
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