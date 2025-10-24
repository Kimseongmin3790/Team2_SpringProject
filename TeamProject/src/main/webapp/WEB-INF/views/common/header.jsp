<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <link rel="stylesheet" href="${path}/resources/css/header.css">
            <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&icon_names=shopping_cart,Person,Favorite&display=block" rel="stylesheet" />
        </head>

        <body>
            <div id="app">
                <c:set var="path" value="${pageContext.request.contextPath}" />

                <header class="header">
                    <div class="header-top">
                        <!-- 로고 -->
                        <div class="logo">
                            <img src="${path}/resources/img/logo.png" alt="로고" class="logo-img">            
                        </div>

                        <!-- 검색창 -->
                        <div class="search-bar">
                            <i class="fa fa-search"></i>
                            <input type="text" placeholder="검색창" id="searchInput">
                        </div>

                        <!-- 오른쪽 메뉴 -->
                        <div class="header-right">
                            <div class="login-group">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loginId}">
                                        <button class="btn-logout" onclick="fnLogout()">로그아웃</button>
                                        <span class="user-name">${sessionScope.userName}님</span>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-login" onclick="location.href='${path}/login'">로그인</button>
                                        <button class="btn-join" onclick="location.href='${path}/join'">회원가입</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="icon-group">
                                <i class="fa fa-user icon">
                                    <span class="material-symbols-outlined">
                                        person
                                    </span>
                                </i>
                                <i class="fa fa-heart icon">
                                    <span class="material-symbols-outlined">
                                        favorite
                                    </span>
                                </i>
                                <i class="fa fa-shopping-cart icon">
                                    <span class="material-symbols-outlined">
                                        shopping_cart
                                    </span>
                                </i>
                            </div>
                        </div>
                    </div>

                    <!-- 하단 메뉴 -->
                    <div class="header-bottom">
                        <button class="btn-category">
                            <i class="fa fa-bars"></i> 카테고리
                        </button>
                        <nav class="nav-menu">
                            <a href="${path}/">홈</a>
                            <a href="${path}/product/list">상품목록</a>
                            <a href="${path}/product/new">신상품</a>
                            <a href="${path}/review/list">상품후기</a>
                            <a href="${path}/event">번쩍장터</a>
                        </nav>
                    </div>
                </header>
            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                            }
                        });
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                }
            });

            app.mount('#app');
        </script>