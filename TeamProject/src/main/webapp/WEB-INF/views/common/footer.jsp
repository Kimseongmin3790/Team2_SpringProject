<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="path" value="${pageContext.request.contextPath}" />

<footer class="footer">
    <div class="footer-container">
        <div class="footer-left">
            <h2 class="footer-logo">AGRICOLA</h2>
            <p class="footer-desc">
                ‘AGRICOLA’는 농부, 농사꾼을 뜻하는 라틴어로<br>
                농부에게 친근하게 다가가는 소비자를 위한 사이트입니다.
            </p>
        </div>

        <div class="footer-center">
            <div class="footer-column">
                <h3>회사소개</h3>
                <ul>
                    <li><a href="${path}/brand">브랜드 스토리</a></li>
                    <li><a href="${path}/partnership.do">입점/제휴 문의</a></li>
                </ul>
            </div>

            <div class="footer-column">
                <h3>고객센터</h3>
                <ul>
                    <li><a href="${path}/customerService.do?tab=faq">자주 묻는 질문</a></li>
                    <li><a href="${path}/customerService.do?tab=inquiry">1:1 문의</a></li>
                    <li><a href="${path}/customerService.do?tab=notice">공지 사항</a></li>
                </ul>
            </div>

            <div class="footer-column">
                <h3>이용안내</h3>
                <ul>
                    <li><a href="#" id="open-terms-link">이용약관</a></li>
                    <li><a href="#" id="open-privacy-link">개인정보처리방침</a></li>
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

        <div class="footer-right">
            <a href="#"><img src="${path}/resources/img/naver.png" alt="naver"></a>
            <a href="#"><img src="${path}/resources/img/instagram.webp" alt="instagram"></a>
        </div>
    </div>

    <div class="footer-info">
        <p>
            상호명: 사이트(주) | 대표: 홍길동 | 사업자등록번호: 123-45-67890 |
            통신판매업 신고: 제2025-인천부평-000000호<br>
            주소: 서울특별시 강남구 테헤란로 123, 10층 | 개인정보보호책임자: 김성민 |
            이메일: help@gmail.com<br>
            고객문의: 1234-5678 (평일 10:00~17:00, 점심 12:30~13:30) |
            팩스: 02-0000-0000
        </p>
        <p class="copyright">© 2025 AGRICOLA. All rights reserved.</p>
    </div>
    <div id="terms-modal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close-btn">&times;</button>
            <h2>이용약관</h2>
            <div class="terms-text">
            </div>
        </div>
    </div>
    <div id="privacy-modal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close-btn">&times;</button>
            <h2>개인정보처리방침</h2>
            <div class="terms-text">
            </div>
        </div>
    </div>
</footer>

<script src="${path}/resources/js/footer.js"></script>
