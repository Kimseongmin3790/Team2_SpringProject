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
            <link rel="stylesheet" href="${path}/resources/css/footer.css">
        </head>

        <body>
            <c:set var="path" value="${pageContext.request.contextPath}" />
            <footer class="footer">
                <div class="footer-container">
                    <!-- 왼쪽 로고 및 설명 -->
                    <div class="footer-left">
                        <h2 class="footer-logo">AGRICOLA</h2>
                        <p class="footer-desc">
                            ‘AGRICOLA’는 농부, 농사꾼을 뜻하는 라틴어로<br>
                            농부에게 친근하게 다가가는 소비자를 위한 사이트입니다.
                        </p>
                    </div>

                    <!-- 회사/고객센터/이용안내/문의 -->
                    <div class="footer-center">
                        <div class="footer-column">
                            <h3>회사소개</h3>
                            <ul>
                                <li><a href="${path}/brand">브랜드 스토리</a></li>
                                <li><a href="${path}/contact">입점/제휴 문의</a></li>
                                <li><a href="${path}/notice">공지사항</a></li>
                            </ul>
                        </div>

                        <div class="footer-column">
                            <h3>고객센터</h3>
                            <ul>
                                <li><a href="${path}/faq">자주 묻는 질문</a></li>
                                <li><a href="${path}/qna">1:1 문의</a></li>
                                <li><a href="${path}/exchange">교환/반품 안내</a></li>
                            </ul>
                        </div>

                        <div class="footer-column">
                            <h3>이용안내</h3>
                            <ul>
                                <li><a href="${path}/terms">이용약관</a></li>
                                <li><a href="${path}/privacy">개인정보처리방침</a></li>
                            </ul>
                        </div>

                        <div class="footer-column">
                            <h3>문의</h3>
                            <ul>
                                <li>고객센터 1234-5678</li>
                                <li>평일 10:00~17:00 (점심 12:30~13:30)</li>
                                <li>이메일 test@gmail.com</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 오른쪽 SNS -->
                    <div class="footer-right">
                        <a href="#"><img src="${path}/resources/img/naver.png" alt="naver"></a>
                        <a href="#"><img src="${path}/resources/img/instagram.webp" alt="instagram"></a>
                    </div>
                </div>

                <!-- 하단 회사 정보 -->
                <div class="footer-info">
                    <p>
                        상호명: 사이트(주) | 대표: 홍길동 | 사업자등록번호: 123-45-67890 |
                        통신판매업 신고: 제2025-인천부평-000000호<br>
                        주소: 서울특별시 강남구 테헤란로 123, 10층 | 개인정보보호책임자: 김성민 |
                        이메일: help@gmail.com<br>
                        고객문의: 1234-5678 (평일 10:00~17:00, 점심 12:30~13:30) |
                        팩스: 02-0000-0000
                    </p>
                    <p class="copyright">© 2025 test. All rights reserved.</p>
                </div>
            </footer>
        </body>

        </html>