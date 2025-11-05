<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>상품 상세</title>

            <!-- 라이브러리 -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js" crossorigin="anonymous"></script>
            <script>
                if (window.Kakao && !window.Kakao.isInitialized()) {
                    window.Kakao.init('8e779c5d556d3d49da94596f97d290c4');
                }
            </script>
            <script src="/resources/js/page-change.js"></script>

            <!-- 공통 헤더/푸터 CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                html,
                body {
                    height: 100%;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                    margin: 0;
                    color: #333;
                    background-color: #f9fafb;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                    margin: 20px auto;
                    max-width: 1100px;
                    width: 100%;
                }

                .prod-wrap {
                    display: flex;
                    align-items: flex-start;
                    gap: 32px;
                    max-width: 1200px;
                    margin: 20px auto;
                }

                .prod-media .main-box {
                    width: 100%;
                    aspect-ratio: 1 / 1;
                    /* 정사각형 */
                    background: #f8f8f8;
                    border: 1px solid #eee;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .prod-media .main-box img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                    /* 이미지 비율 유지해서 맞춤 */
                    background: #fff;
                    /* 투명/폴백일 때도 하얀 배경 */
                }

                .prod-media {
                    flex: 0 0 580px;
                }

                .prod-info {
                    flex: 1;
                    min-width: 0;
                }

                .prod-media img {
                    display: block;
                    width: 100%;
                    height: auto;
                    max-width: 100%;
                }

                @media (max-width: 900px) {
                    .prod-wrap {
                        flex-direction: column;
                        gap: 16px;
                    }

                    .prod-media {
                        flex-basis: auto;
                    }
                }

                #title {
                    font-size: 24px;
                    color: #000;
                    font-weight: bold;
                }

                #store {
                    font-size: 12px;
                    color: #000;
                }

                #sub {
                    font-size: 15px;
                    color: #000;
                    margin: 50px 0;
                }

                #price {
                    font-size: 24px;
                    color: #000;
                    font-weight: bold;
                }

                #delivery {
                    margin: 10px 0;
                    border: 2px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                }

                .dd {
                    position: relative;
                    width: 500px;
                    font-size: 16px;
                }

                .dd-btn {
                    width: 100%;
                    height: 50px;
                    margin: 15px 0;
                    padding: 6px 12px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    background: #fff;
                    text-align: left;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    gap: 2px;
                    cursor: pointer;
                }

                .dd-btn .l1 {
                    font-weight: 600;
                    line-height: 1.1;
                }

                .dd-btn .l2 {
                    font-size: 14px;
                    opacity: .8;
                    line-height: 1.1;
                }

                .dd-list {
                    position: absolute;
                    z-index: 10;
                    width: 488px;
                    margin-top: 6px;
                    padding: 6px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    background: #fff;
                    max-height: 260px;
                    overflow: auto;
                    box-shadow: 0 6px 16px rgba(0, 0, 0, .08);
                }

                .dd-opt {
                    padding: 10px;
                    border-radius: 6px;
                    cursor: pointer;
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .dd-opt:hover {
                    background: #f5f5f5;
                }

                .badge-row {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .share-wrap {
                    position: relative;
                }

                .share-icon-btn {
                    width: 36px;
                    height: 36px;
                    border: 1px solid #ddd;
                    border-radius: 50%;
                    background: #fff;
                    cursor: pointer;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }

                .share-pop {
                    position: absolute;
                    right: 0;
                    top: 42px;
                    z-index: 20;
                    min-width: 160px;
                    background: #fff;
                    border: 1px solid #e5e5e5;
                    border-radius: 10px;
                    padding: 8px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, .08);
                }

                .share-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    width: 100%;
                    padding: 8px;
                    border: 0;
                    background: #fff;
                    cursor: pointer;
                    border-radius: 8px;
                }

                .share-item:hover {
                    background: #f7f7f7;
                }

                .share-badge {
                    width: 22px;
                    height: 22px;
                    border-radius: 6px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-weight: 700;
                }

                .naver-badge {
                    background: #03c75a;
                }

                .kakao-badge {
                    background: #fee500;
                    color: #000;
                }

                .link-badge {
                    background: #888;
                }

                .selection-summary {
                    margin: 10px 0;
                    border: 2px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                }

                .irq {
                    position: sticky;
                    top: 0;
                    z-index: 50;
                    background: #fff;
                    border-bottom: 1px solid #eee;
                    display: flex;
                    gap: 12px;
                    padding: 6px 0;
                }

                .tab {
                    flex: 1;
                    text-align: center;
                    padding: 5px 10px;
                    box-sizing: border-box;
                }

                .tab a {
                    display: block;
                    text-decoration: none;
                    font-weight: 700;
                    padding: 6px 0;
                    background: #f5f5f5;
                    color: #111;
                    border: 1px solid #e5e5e5;
                    border-radius: 8px;
                }

                #in,
                #re,
                #qa {
                    scroll-margin-top: 64px;
                }

                #re {
                    width: 100%;
                }

                :root {
                    --active-bg: #4caf50;
                    --active-color: #fff;
                }

                :root:not(:has(:target)) .irq .tab a[href="#in"] {
                    background: var(--active-bg);
                    color: var(--active-color);
                    border-color: var(--active-bg);
                }

                :root:has(#in:target) .irq .tab a[href="#in"],
                :root:has(#re:target) .irq .tab a[href="#re"],
                :root:has(#qa:target) .irq .tab a[href="#qa"] {
                    background: var(--active-bg);
                    color: var(--active-color);
                    border-color: var(--active-bg);
                }

                table,
                tr,
                td,
                th {
                    border: 1px solid #000;
                    border-collapse: collapse;
                    padding: 5px 10px;
                }

                th {
                    background-color: rgba(0, 0, 0, .03);
                }

                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                    min-width: 240px;
                    height: 50px;
                    padding: 0 16px;
                    border-radius: 10px;
                    font-family: "Noto Sans KR", sans-serif;
                    font-size: 15px;
                    font-weight: 700;
                    border: 1px solid transparent;
                    cursor: pointer;
                    transition: transform .06s ease, box-shadow .2s ease, background .2s ease, color .2s ease, border-color .2s ease;
                }

                .btn:active {
                    transform: translateY(1px);
                }

                :root {
                    --green-700: #1a5d1a;
                    --green-500: #5dbb63;
                    --green-500-d: #4ba954;
                    --beige-100: #f5efd8;
                    --beige-150: #f3ebd3;
                    --text-900: #1f1f1f;
                    --line: #ddd;
                }

                .btn-primary {
                    background: var(--green-500);
                    color: #fff;
                    box-shadow: 0 6px 14px rgba(26, 93, 26, .18);
                }

                .btn-primary:hover {
                    background: var(--green-500-d);
                }

                .btn-outline {
                    background: #fff;
                    color: var(--green-700);
                    border-color: var(--green-700);
                }

                .btn-outline:hover {
                    background: var(--beige-150);
                }

                .btn-ghost {
                    background: var(--beige-100);
                    color: var(--green-700);
                    border-color: var(--line);
                }

                .btn-ghost:hover {
                    background: #fff;
                    border-color: var(--green-700);
                }

                .btn-like {
                    background: #fff;
                    color: var(--text-900);
                    border-color: var(--line);
                }

                .btn-like:hover {
                    background: var(--beige-100);
                    border-color: var(--green-700);
                    color: var(--green-700);
                }

                #container>div button.btn {
                    margin-right: 8px;
                }

                #container>div+div button.btn {
                    margin-top: 8px;
                }

                .heart-btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                }

                .heart-btn:focus {
                    outline-offset: 2px;
                }

                .heart-btn:hover {
                    filter: brightness(.95);
                }

                #view {
                    border: 1px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                    border-radius: 5px;
                    width: 300px;
                    height: 100px;
                }

                .iconbtn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    padding: 4px 8px;
                    border-radius: 8px;
                    text-decoration: none;
                    color: #666;
                    cursor: pointer;
                }

                .iconbtn .count {
                    font-style: normal;
                    color: #9aa0a6;
                }

                .review-row {
                    display: flex;
                    align-items: flex-start;
                    gap: 16px;
                    margin: 12px 0;
                }

                #view.review-card {
                    flex: 0 0 300px;
                    height: 100px;
                    border: 1px solid rgba(0, 0, 0, .03);
                    background: rgba(0, 0, 0, .03);
                    border-radius: 5px;
                }

                .review-body {
                    flex: 1;
                    min-width: 0;
                    padding: 0 8px;
                }

                .comment-text,
                .comment-line {
                    white-space: pre-wrap;
                    word-break: keep-all;
                    overflow-wrap: anywhere;
                }

                .comments {
                    margin-top: 6px;
                    padding-left: 0;
                }

                .muted {
                    color: #9aa0a6;
                }

                .review-sep {
                    margin: 8px 0;
                }

                .iconbtn svg {
                    width: 16px;
                    height: 16px;
                    flex: 0 0 auto;
                }

                .actions {
                    display: grid;
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                    gap: 10px 12px;
                    max-width: 500px;
                }

                .actions .btn {
                    min-width: 0;
                    width: 100%;
                }

                .detail-img-wrap {
                    width: 100%;
                    aspect-ratio: 4 / 3;
                    /* 모두 같은 비율로 맞춤 (원하면 1/1 로 바꿔도 됨) */
                    margin: 0;
                    /* 카드 사이 여백 제거 */
                    overflow: hidden;
                    border-radius: 8px;
                    background: #000;
                }

                .detail-img {
                    display: block;
                    /* img의 하단 기본 공백 제거 */
                    width: 100%;
                    height: 100%;
                }

                .detail-img.cover {
                    object-fit: cover;
                }

                .detail-img.contain {
                    object-fit: contain;
                    background: #fff;
                }

                .thumbs {
                    display: flex;
                    gap: 8px;
                    margin-top: 10px;
                    flex-wrap: wrap;
                }

                .thumb {
                    width: 74px;
                    height: 74px;
                    padding: 0;
                    border: 1px solid #ddd;
                    background: #fff;
                    border-radius: 6px;
                    overflow: hidden;
                    cursor: pointer;
                }

                .thumb img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    display: block;
                }

                .thumb.active {
                    outline: 2px solid #000;
                }
             /* ======= 리뷰 ======= */
                .content {
                    flex: 1;
                }

                /* Header */
                .page-header {
                    background: white;
                    border-bottom: 1px solid #e5e7eb;
                    position: sticky;
                    top: 0;
                    z-index: 10;
                    padding: 1rem 0;
                }

                .page-header h1 {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: #059669;
                }

                .container {
                    max-width: 896px;
                    margin: 0 auto;
                    padding: 0 1rem;
                }

                /* Review Summary Card */
                .summary-card {
                    background: white;
                    border-radius: 8px;
                    padding: 1.5rem;
                    margin: 2rem 0;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                .summary-content {
                    display: flex;
                    gap: 2rem;
                    align-items: center;
                }

                .rating-overview {
                    text-align: center;
                    padding-right: 2rem;
                    border-right: 1px solid #e5e7eb;
                    min-width: 150px;
                }

                .rating-number {
                    font-size: 3rem;
                    font-weight: bold;
                    color: #059669;
                    margin-bottom: 0.5rem;
                }

                .stars {
                    display: flex;
                    gap: 0.25rem;
                    justify-content: center;
                    margin-bottom: 0.5rem;
                }

                .star {
                    width: 20px;
                    height: 20px;
                }

                .star.filled {
                    color: #fbbf24;
                    fill: #fbbf24;
                }

                .star.empty {
                    color: #d1d5db;
                    fill: none;
                }

                .rating-count {
                    font-size: 0.875rem;
                    color: #6b7280;
                }

                .rating-bars {
                    flex: 1;
                }

                .rating-bar-row {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    margin-bottom: 0.5rem;
                }

                .rating-bar-stars {
                    display: flex;
                    gap: 0.125rem;
                    width: 80px;
                }

                .rating-bar-stars .star {
                    width: 12px;
                    height: 12px;
                }

                .rating-bar-bg {
                    flex: 1;
                    height: 8px;
                    background: #e5e7eb;
                    border-radius: 9999px;
                    overflow: hidden;
                }

                .rating-bar-fill {
                    height: 100%;
                    background: #059669;
                    transition: width 0.3s;
                }

                .rating-bar-count {
                    font-size: 0.875rem;
                    color: #6b7280;
                    width: 48px;
                    text-align: right;
                }

                /* Filters */
                .filters {
                    display: flex;
                    gap: 0.5rem;
                    margin-bottom: 1.5rem;
                    overflow-x: auto;
                    padding-bottom: 0.5rem;
                }

                .filter-btn {
                    padding: 0.5rem 1rem;
                    border: 1px solid #d1d5db;
                    background: white;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 0.875rem;
                    white-space: nowrap;
                    transition: all 0.2s;
                }

                .filter-btn:hover {
                    background: #f3f4f6;
                }

                .filter-btn.active {
                    background: #059669;
                    color: white;
                    border-color: #059669;
                }

                /* Review Card */
                .review-card {
                    background: white;
                    border-radius: 8px;
                    padding: 1.5rem;
                    margin-bottom: 1.5rem;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                .review-header {
                    display: flex;
                    gap: 1rem;
                    margin-bottom: 1rem;
                }

                .user-info {
                    flex: 1;
                }

                .user-name-row {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    margin-bottom: 0.25rem;
                }

                .user-name {
                    font-weight: 600;
                }

                .verified-badge {
                    background: #e5e7eb;
                    color: #374151;
                    padding: 0.125rem 0.5rem;
                    border-radius: 4px;
                    font-size: 0.75rem;
                }

                .review-meta {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .review-stars {
                    display: flex;
                    gap: 0.125rem;
                }

                .review-stars .star {
                    width: 16px;
                    height: 16px;
                }

                .review-date {
                    font-size: 0.875rem;
                    color: #6b7280;
                }

                .product-name {
                    font-size: 0.875rem;
                    color: #059669;
                    font-weight: 500;
                    margin-bottom: 0.75rem;
                }

                .review-content {
                    line-height: 1.6;
                    margin-bottom: 1rem;
                    color: #374151;
                    white-space: pre-wrap;
                }

                .review-images {
                    display: flex;
                    gap: 0.5rem;
                    margin-bottom: 1rem;
                    overflow-x: auto;
                    padding-bottom: 0.5rem;
                }

                .review-image {
                    width: 96px;
                    height: 96px;
                    border-radius: 8px;
                    object-fit: cover;
                    cursor: pointer;
                    transition: opacity 0.2s;
                }

                .review-image:hover {
                    opacity: 0.8;
                }

                .review-actions {
                    display: flex;
                    gap: 0.5rem;
                    padding-top: 1rem;
                    border-top: 1px solid #e5e7eb;
                }

                .action-btn {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    padding: 0.5rem 1rem;
                    background: transparent;
                    border: none;
                    cursor: pointer;
                    font-size: 0.875rem;
                    color: #6b7280;
                    border-radius: 6px;
                    transition: background 0.2s;
                }

                .action-btn.active {
                    color: var(--green-700);
                }

                .action-btn:hover {
                    background: #f3f4f6;
                }

                .action-btn svg {
                    width: 16px;
                    height: 16px;
                    fill: none;      
                    stroke: #6b7280; 
                    stroke-width: 2;
                }
                .action-btn.active svg {
                    fill: var(--green-700);  
                    stroke: var(--green-700);
                }

                /* Load More Button */
                .load-more {
                    text-align: center;
                    margin: 2rem 0;
                }

                .load-more-btn {
                    padding: 0.75rem 2rem;
                    border: 1px solid #d1d5db;
                    background: white;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 1rem;
                    transition: all 0.2s;
                }

                .load-more-btn:hover {
                    background: #f3f4f6;
                }

                /* Image Modal */
                .modal {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.8);
                    z-index: 1000;
                    align-items: center;
                    justify-content: center;
                }

                .modal.active {
                    display: flex;
                }

                .modal-content {
                    max-width: 90%;
                    max-height: 90%;
                }

                .modal-image {
                    max-width: 100%;
                    max-height: 90vh;
                    border-radius: 8px;
                }

                .modal-close {
                    position: absolute;
                    top: 20px;
                    right: 20px;
                    background: white;
                    border: none;
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    cursor: pointer;
                    font-size: 1.5rem;
                }

                /* Responsive */
                
                @media (max-width: 768px) {
                    .summary-content { 
                        flex-direction: column;
                    }

                    .rating-overview {
                    border-right: none;
                        border-bottom: 1px solid #e5e7eb;
                        padding-right: 0;
                        padding-bottom: 1rem;
                        width: 100%;
                    }

                    .filters {
                        flex-wrap: nowrap;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">

                    <main class="content">
                        <div class="prod-wrap">
                            <!-- 왼쪽: 이미지 -->
                            <div class="prod-media" id="img">
                                <div class="main-box">
                                    <img :src="mainImageUrl" :alt="info.pName" @error="onImgError($event)">
                                </div>

                                <div class="thumbs" id="small-img">
                                    <button v-for="u in thumbImages" :key="u" class="thumb"
                                        :class="{ active: u === mainImageUrl }" @click="mainImageUrl = u">
                                        <img :src="u" :alt="info.pName">
                                    </button>
                                </div>
                            </div>

                            <!-- 오른쪽: 정보 -->
                            <div class="prod-info" id="container">
                                <div id="store">윤자네 수산</div>
                                <div id="title">{{ info.pName }}</div>

                                <div class="badge-row">
                                    <img src="<c:url value='/resources/img/sale.png'/>" style="width:62px;">
                                    <input v-model="shareUrl" type="hidden">
                                    <input v-model="shareTitle" type="hidden">

                                    <div class="share-wrap" style="margin-left:auto;">
                                        <button type="button" class="share-icon-btn"
                                            @click.stop="shareOpen = !shareOpen" aria-label="공유">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                aria-hidden="true">
                                                <path
                                                    d="M15 7a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm0 16a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"
                                                    stroke="#333" stroke-width="1.5" />
                                                <path d="M5.5 12.5 12.5 6M5.5 11.5 12.5 17" stroke="#333"
                                                    stroke-width="1.5" />
                                            </svg>
                                        </button>

                                        <span class="heart-btn" @click="liked=!liked" role="button"
                                            :aria-pressed="liked" tabindex="0" aria-label="찜">
                                            <svg v-if="liked" width="20" height="20" viewBox="0 0 24 24"
                                                aria-hidden="true">
                                                <path
                                                    d="M12.1 21.35l-.1.1-.1-.1C7.14 17.24 4 14.36 4 10.9 4 8.5 5.9 6.6 8.3 6.6c1.4 0 2.75.65 3.7 1.68C12.95 7.25 14.3 6.6 15.7 6.6 18.1 6.6 20 8.5 20 10.9c0 3.46-3.14 6.34-7.9 10.45Z"
                                                    fill="currentColor" />
                                            </svg>
                                            <svg v-else width="20" height="20" viewBox="0 0 24 24" aria-hidden="true">
                                                <path
                                                    d="M12.1 21.35l-.1.1-.1-.1C7.14 17.24 4 14.36 4 10.9 4 8.5 5.9 6.6 8.3 6.6c1.4 0 2.75.65 3.7 1.68C12.95 7.25 14.3 6.6 15.7 6.6 18.1 6.6 20 8.5 20 10.9c0 3.46-3.14 6.34-7.9 10.45Z"
                                                    fill="none" stroke="currentColor" stroke-width="1.5" />
                                            </svg>
                                        </span>

                                        <div class="share-pop" v-if="shareOpen" @click.stop>
                                            <button type="button" class="share-item" @click="shareNaver">
                                                <span class="share-badge naver-badge">N</span><span>네이버로 공유</span>
                                            </button>
                                            <button type="button" class="share-item" @click="shareKakao">
                                                <span class="share-badge kakao-badge">K</span><span>카카오로 공유</span>
                                            </button>
                                            <button type="button" class="share-item" @click="shareCopy">
                                                <span class="share-badge link-badge">⧉</span><span>링크 복사</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div id="price">￦{{ Number(info.price || 0).toLocaleString() }}원</div>
                                <hr style="margin: 60px 0;">
                                <div id="sub">
                                    <p style="line-height:2px;">{{ info.pInfo }}</p>
                                </div>

                                <div v-if="fulfillment=='delivery'">
                                    <div><b>원산지</b> {{info.origin}}</div>
                                    <div><b>구매혜택</b> 318 포인트 적립예정</div>
                                    <div><b>배송비</b> 3,000원 | 도서산간 배송비 추가</div>
                                    <div><b>배송 안내</b> 배송비 3,000원</div>
                                </div>
                                <div v-else>
                                    <div><b>원산지</b> {{info.origin}}</div>
                                    <div><b>구매혜택</b> 318 포인트 적립예정</div>
                                </div>

                                <!-- 수령방법 -->
                                <div class="dd">
                                    <button type="button" class="dd-btn" @click.stop="ddOpen1=!ddOpen1">
                                        <span class="l1">{{ fulfillmentSel?.l1 || '수령 방법 선택' }}</span>
                                        <span class="l2" v-if="fulfillmentSel?.l2">{{ fulfillmentSel.l2 }}</span>
                                    </button>
                                    <div class="dd-list" v-if="ddOpen1" @click.stop>
                                        <div class="dd-opt" v-for="opt in deliveryOptions" :key="opt.value"
                                            @click="pickFulfillment(opt)">
                                            <span class="l1">{{ opt.l1 }}</span>
                                        </div>
                                    </div>
                                    <input type="hidden" name="fulfillment" :value="fulfillment">
                                </div>

                                <div id="delivery">
                                    <p>오늘출발 상품</p>
                                    <p v-if="week && before"><span style="color:#ff4100;">당일 15:00까지 결제</span>시 당일 바로
                                        발송됩니다.</p>
                                    <p v-else>오늘출발 마감되었습니다. (평일 15:00까지)</p>
                                </div>

                                <!-- 옵션/금액 -->
                                <div style="margin: 50px 0;">
                                    수율 상세페이지 참조 *
                                    <div class="dd" style="margin-top:8px;">
                                        <button type="button" class="dd-btn" @click.stop="ddOpen2=!ddOpen2">
                                            <span class="l1">수율 상세페이지 참조 (필수)</span>
                                        </button>
                                        <div class="dd-list" v-if="ddOpen2" @click.stop>
                                            <div class="dd-opt" @click="pickProduct()">
                                                <span class="l1">{{ info.stock }}{{ info.unit }}</span>
                                                <span class="l2">￦{{ (info.price||0).toLocaleString() }}원</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="selection-summary" v-if="selected" style="margin-top:12px">
                                        <div style="padding:8px 0;border-top:1px solid #eee">
                                            <div>
                                                {{ info.pName }}
                                                <button @click="removeProduct" style="margin-left:270px">삭제</button>
                                            </div>
                                            <hr
                                                style="border-width:1px 0 0 0; border-style:dashed; border-color:#9d9c9c; width:480px;">
                                            <div
                                                style="font-size:18px;font-weight:700; display:flex; align-items:center; gap:8px; margin-top:6px">
                                                <button @click="fnMinus" style="width:30px; height:30px;">-</button>
                                                <input v-model.number="qty" @input="recomputeTotal"
                                                    style="width:50px; text-align:center; height:24px; margin:5px -9px;">
                                                <button @click="fnPlus" style="width:30px; height:30px;">+</button>
                                                <span style="margin-left:auto;">{{ (qty * price).toLocaleString()
                                                    }}원</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="selected" style="text-align:right; font-size:20px; font-weight:800;">
                                        총 상품금액({{ qty }}개) {{ totalSum.toLocaleString() }}원
                                    </div>

                                    <div style="margin: 24px 0 0;">
                                        <div class="actions">
                                            <button @click="fnPurchase" class="btn btn-primary">구매하기</button>
                                            <button @click="fnBasket(info.productNo, qty)"
                                                class="btn btn-outline">장바구니</button>
                                            <button @click="fnChat" class="btn btn-ghost">실시간 문의</button>
                                            <button @click="fnWish" class="btn btn-like">찜</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 탭 -->
                        <div class="irq">
                            <div class="tab"><a href="#in">상세정보</a></div>
                            <div class="tab"><a href="#re">구매평</a></div>
                            <div class="tab"><a href="#qa">Q&amp;A</a></div>
                        </div>

                        <section id="in">
                            <img src="<c:url value='/resources/img/class.png'/>"
                                style="max-width:100%;width:1100px;height:auto;display:block;">
                        </section>

                        <div v-if="!showDetail" style="margin:16px 0; text-align:center;">
                            <button @click="openDetail"
                                style="padding:10px 16px; border:1px solid #ddd; border-radius:8px; background:#fff; cursor:pointer;">
                                ▼ 상세 보기
                            </button>
                        </div>

                        <div v-show="showDetail">
                            <div v-for="img in detailOnly" :key="img" class="detail-img-wrap">
                                <img :src="img" :alt="info.pName || '상세 이미지'" class="detail-img cover" loading="lazy">
                            </div>

                            <div>
                                상품정보 제공고시
                                <table>
                                    <tr>
                                        <th>품목 또는 명칭</th>
                                        <td>연지홍게</td>
                                    </tr>
                                    <tr>
                                        <th>포장단위별 용량(중량), 수량, 크기</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>생산자</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>원산지</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>제조연월일, 소비기한 또는 유통기한 또는 품질유지기한</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>세부 품목군별 표시사항</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>상품구성</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>보관방법 또는 취급방법</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>소비자안전을 위한 주의사항</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                    <tr>
                                        <th>소비자상담 관련 전화번호</th>
                                        <td>상품상세참조</td>
                                    </tr>
                                </table>
                            </div>

                            <div style="margin:16px 0; text-align:center;">
                                <button @click="closeDetail"
                                    style="padding:10px 16px; border:1px solid #ddd; border-radius:8px; background:#fff; cursor:pointer;">
                                    ▲ 상세 접기
                                </button>
                            </div>
                        </div>

                        <section id="re">
                            <%@ include file="/WEB-INF/board/review.jsp" %>
                        </section>

                        <section id="qa">
                            <div>
                                Q&amp;A
                                <div>
                                    <button>상품문의</button>
                                    <button>실시간 문의</button>
                                </div>
                                <div>
                                    <table>
                                        <tr>
                                            <th>상태</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>등록일</th>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </section>
                    </main>

                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

        </body>

        </html>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        ddOpen1: false, ddOpen2: false,
                        fulfillment: 'delivery',
                        shareOpen: false,
                        shareUrl: window.location.href,
                        shareTitle: '',
                        showDetail: false,
                        week: false, before: false,
                        liked: false,

                        userId: "${sessionId}",
                        productNo: "${productNo}",
                        info: {},
                        fileList: [],

                        selected: false,
                        qty: 0,
                        price: 0,
                        totalSum: 0,

                        commentOpen: false,
                        commentCount: 0,
                        comments: [],

                        mainImageUrl: '',
                        detailImages: [],
                        thumbImages: [],

                        // ====== 리뷰 ======
                        averageRating: 0,
                        totalReviews: 0,
                        ratingDistribution: {
                            5: 0,
                            4: 0,
                            3: 0,
                            2: 0,
                            1: 0
                        },
                        reviews: [],
                        currentFilter: 'all', 
                        modalImage: null,

                        currentPage: 1,
                        pageSize: 5, 
                        totalReviewCount: 0
                        //============================
                    }
                },
                computed: {
                    fulfillmentSel() {
                        return this.deliveryOptions.find(o => o.value === this.fulfillment) || null;
                    },
                    deliveryOptions() {
                        return [
                            { value: 'delivery', l1: '택배' },
                            { value: 'pickup', l1: '방문 수령' }
                        ];
                    },

                    detailOnly() {
                        const norm = (u) => {
                            try {
                                const x = new URL(u, location.origin);
                                return x.origin + x.pathname.replace(/\/+$/, '');
                            } catch {
                                return String(u).trim().replace(/[?#].*$/, '').replace(/\/+$/, '');
                            }
                        };
                        const tset = new Set((this.thumbImages || []).map(norm));
                        const main = norm(this.mainImageUrl || '');
                        return (this.detailImages || []).filter(u => {
                            const nu = norm(u);
                            return !tset.has(nu) && nu !== main;
                        });
                    },
                    //====== 리뷰 ======
                     filteredReviews() {
                        let self = this;
                        let reviewsToShow = [...self.reviews];

                        // 1. 필터링
                        if (self.currentFilter === 'photo') {
                            reviewsToShow = reviewsToShow.filter(r => r.images && r.images.length > 0);
                        } else if (self.currentFilter === '5' || self.currentFilter === '4') {
                            reviewsToShow = reviewsToShow.filter(r => r.rating === parseInt(this.currentFilter));
                        }
                        // 2. 정렬
                        if (self.currentFilter === 'latest') {
                            reviewsToShow.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
                        } else {
                            reviewsToShow.sort((a, b) => b.recommend - a.recommend);
                        }
                        return reviewsToShow;
                    }
                    // ======================================
                },
                methods: {
                    // 상품/이미지 로드
                    fnInfo() {
                        let self = this;
                        let param = {
                            productNo: self.productNo
                        };

                        $.ajax({
                            url: "product-view.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                self.info = data.info;
                                self.fileList = data.fileList;

                                // --- 도우미 ---
                                const CTX = '<c:out value="${pageContext.request.contextPath}"/>';

                                const isBlank = v => v == null || String(v).trim() === '';
                                const toUrl = (u) => {
                                    if (isBlank(u)) return '';
                                    u = String(u).trim();
                                    if (/^https?:\/\//i.test(u)) return u;     // 절대 URL
                                    if (u.startsWith('/')) return CTX + u;     // 루트 시작
                                    return (CTX ? CTX + '/' : '/') + u;        // 상대경로
                                };

                                // ✅ URL 정규화: 쿼리/해시 제거, 호스트 소문자, 끝 슬래시 제거
                                const normalizeUrl = (u) => {
                                    try {
                                        const url = new URL(u, location.origin);
                                        const origin = url.origin;                       // ← http://localhost:8082 유지
                                        const path = url.pathname.replace(/\/+$/, '');
                                        return origin + path;
                                    } catch {
                                        return String(u).trim().replace(/[?#].*$/, '').replace(/\/+$/, '');
                                    }
                                };

                                // 각 행에서 URL 뽑기
                                const getUrl = (row) => {
                                    let u =
                                        row.imageUrl ?? row.IMAGE_URL ?? row.image_url ??
                                        row.fileUrl ?? row.FILE_URL ?? row.file_url ??
                                        row.url ?? row.URL ?? row.fullUrl ?? row.full_url;
                                    if (isBlank(u)) {
                                        const p = row.filePath ?? row.FILE_PATH ?? row.path ?? row.PATH ?? row.uploadPath ?? row.upload_path ?? '';
                                        const n = row.fileName ?? row.FILE_NAME ?? row.saveName ?? row.save_name ?? row.storedFileName ?? row.stored_file_name ?? '';
                                        if (!isBlank(p) && !isBlank(n)) u = (String(p).endsWith('/') ? p : p + '/') + n;
                                        else if (!isBlank(p)) u = p;
                                        else if (!isBlank(n)) u = n;
                                    }
                                    u = toUrl(u);
                                    return normalizeUrl(u);  // ✅ 정규화해서 반환
                                };

                                // A/N 플래그 (여분 케이스까지 포함)
                                const flag = (row) => {
                                    // 여러 키 중 하나라도 오면 집어냄
                                    let f = row?.thumbnailYn ?? row?.THUMBNAIL_YN ??
                                        row?.isThumbnail ?? row?.IS_THUMBNAIL ??
                                        row?.thumbFlag ?? row?.THUMB_FLAG ?? '';
                                    // 유니코드 공백까지 싹 제거
                                    f = String(f).replace(/\s+/g, '').toUpperCase();
                                    if (['A', 'Y', '1', 'T', 'TRUE'].includes(f)) return 'A';
                                    if (['N', '0', 'F', 'FALSE'].includes(f)) return 'N';
                                    return ''; // 알 수 없음
                                };

                                // --- 분류 ---
                                const rawA = self.fileList.filter(r => flag(r) === 'A').map(getUrl).filter(u => !isBlank(u));
                                const rawN = self.fileList.filter(r => flag(r) === 'N').map(getUrl).filter(u => !isBlank(u));

                                // 중복 제거 (정규화된 상태라 Set으로 OK)
                                const uniq = arr => Array.from(new Set(arr));
                                let aList = uniq(rawA);
                                let nList = uniq(rawN);

                                // ✅ 안전장치: A가 비어있으면 업로드 순서 기준으로 첫 장을 A로 간주
                                if (aList.length === 0) {
                                    const all = uniq(self.fileList.map(getUrl).filter(Boolean));
                                    if (all.length) aList = [all[0]];            // 최소 1장 보장
                                }
                                if (aList.length === 1) {
                                    const all = uniq(self.fileList.map(getUrl).filter(Boolean));
                                    // 첫 번째 상세 후보를 추가로 승격 (중복은 자동 제거)
                                    const firstDetail = all.find(u => !aList.includes(u));
                                    if (firstDetail) aList.push(firstDetail);
                                }

                                // 상세에서 A 겹치는 것 제거
                                const aSet = new Set(aList);
                                const nListOnly = nList.filter(u => !aSet.has(u));

                                // --- 바인딩 ---
                                self.thumbImages = aList;

                                const NOIMG = CTX + '/resources/img/no-image.png';
                                self.mainImageUrl = aList[0] || nListOnly[0] || NOIMG;

                                // 상세 = N만 + 메인도 제거
                                self.detailImages = nListOnly.filter(u => u !== self.mainImageUrl);

                                // 디버그
                                console.log('[A/thumb]', self.thumbImages);
                                console.log('[N/detailOnly]', self.detailImages);

                                // 가격/수량 초기화
                                self.price = Number(self.info?.price || 0);
                                self.selected = false;
                                self.qty = 0;
                                self.recomputeTotal();
                                const NOIMG_DATA =
                                    'data:image/svg+xml;utf8,' +
                                    encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800"><rect width="100%" height="100%" fill="#f2f2f2"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="#999" font-size="24">no image</text></svg>');
                                self.mainImageUrl = aList[0] || nListOnly[0] || NOIMG_DATA;
                            },
                            error(xhr) { console.error('product-view.dox error', xhr?.status, xhr?.responseText); }

                        });
                    },

                    onImgError(e) {
                        // 0차: 즉시 보이는 data URI (항상 성공)
                        if (!e.target.dataset.fallback0) {
                            e.target.dataset.fallback0 = '1';
                            e.target.src =
                                'data:image/svg+xml;utf8,' +
                                encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800"><rect width="100%" height="100%" fill="#f2f2f2"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="#999" font-size="24">no image</text></svg>');
                            return;
                        }

                        // 1차: 서버 기본 이미지(매핑이 제대로면 표시됨)
                        const CTX = '<c:out value="${pageContext.request.contextPath}"/>';
                        const alt1 = CTX + '/resources/img/no-image.png';
                        if (!e.target.dataset.fallback1) {
                            e.target.dataset.fallback1 = '1';
                            e.target.src = alt1;
                            return;
                        }

                        // 2차: 그래도 실패하면 더 이상 시도 안 함 (data URI 그대로 유지)
                    },

                    pickFulfillment(opt) { this.fulfillment = opt.value; this.ddOpen1 = false; },

                    shareNaver() {
                        if (!this.shareUrl || !this.shareTitle) { alert('공유할 URL/제목이 비었습니다.'); return; }
                        const encUrl = encodeURI(encodeURIComponent(this.shareUrl));
                        const encTitle = encodeURI(this.shareTitle);
                        window.open("https://share.naver.com/web/shareView?url=" + encUrl + "&title=" + encTitle, "_blank");
                        this.shareOpen = false;
                    },
                    shareKakao() {
                        if (!(window.Kakao && window.Kakao.isInitialized && window.Kakao.isInitialized())) {
                            alert('카카오 SDK가 초기화되지 않았습니다.'); return;
                        }
                        window.Kakao.Share.sendDefault({
                            objectType: 'feed',
                            content: {
                                title: this.shareTitle || document.title,
                                description: '상품을 공유합니다',
                                imageUrl: location.origin + '<c:url value="/img/snowCrab.png"/>', // 또는 '/resources/img/snowCrab.png'
                                link: { webUrl: this.shareUrl || location.href, mobileWebUrl: this.shareUrl || location.href }
                            },
                            buttons: [{ title: '바로 보기', link: { webUrl: this.shareUrl || location.href, mobileWebUrl: this.shareUrl || location.href } }]
                        });
                        this.shareOpen = false;
                    },
                    shareCopy() {
                        const link = this.shareUrl || location.href;
                        (navigator.clipboard ? navigator.clipboard.writeText(link)
                            : new Promise(res => {
                                const ta = document.createElement('textarea'); ta.value = link; document.body.appendChild(ta);
                                ta.select(); document.execCommand('copy'); document.body.removeChild(ta); res();
                            })
                        ).then(() => alert('링크가 복사되었습니다.'));
                        this.shareOpen = false;
                    },

                    // 구매 선택
                    pickProduct() { this.selected = true; if (this.qty < 1) this.qty = 1; this.ddOpen2 = false; this.recomputeTotal(); },
                    removeProduct() { this.selected = false; this.qty = 0; this.recomputeTotal(); },
                    fnMinus() { if (!this.selected) return; if (this.qty > 1) { this.qty--; this.recomputeTotal(); } },
                    fnPlus() { if (!this.selected) return; this.qty++; this.recomputeTotal(); },
                    recomputeTotal() { this.totalSum = this.selected ? (this.qty * this.price) : 0; },

                    // 상세 토글
                    openDetail() { this.showDetail = true; },
                    closeDetail() { this.showDetail = false; },

                    // CTA
                    fnPurchase() { /* TODO */ },

                    fnBasket: function (productNo, qty) {
                        let self = this;
                        if (!self.selected || (self.qty | 0) <= 0) {
                            alert("옵션 선택 후 수량을 확인해 주세요.");
                            return;
                        }
                        let param = {
                            userId: self.userId,
                            productNo: productNo,
                            quantity: qty
                        };
                        $.ajax({
                            url: '/cart/add.dox',
                            type: 'POST',
                            dataType: 'json',
                            data: param,
                            success: function (data) {
                                if (data.result == 'success') {
                                    pageChange('/buyerMyPage.do', {productNo}); // 장바구니로 이동
                                } else {
                                    alert('장바구니 담기 실패');
                                }
                            },
                            error: function (xhr) { alert('서버오류: ' + xhr.status); }
                        });
                    },

                    fnWish() { /* TODO */ },
                    fnChat() { console.log('fnChat clicked'); },

                    // 댓글
                    toggleComments() {
                        this.commentOpen = !this.commentOpen;
                        if (this.commentOpen && this.comments.length === 0) {
                            this.loadCommentsOnce();
                        }
                    },
                    loadCommentsOnce() {
                        this.comments = [
                            { id: 1, text: '고객님, 소중한 리뷰 감사드립니다. 다음에도 찾아주세요! 😊' }
                        ];
                        this.commentCount = this.comments.length;
                    },
                    // ====== 리뷰 =======
                    getRatingPercentage(rating) {
                        let self = this;
                        if (self.totalReviews === 0) return 0;
                        return (self.ratingDistribution[rating] / self.totalReviews) * 100;
                    },
                    getRatingCount(rating) {
                        return this.ratingDistribution[rating];
                    },
                     toggleRecommend(review) {
                        let self = this;
                        if (review.isRecommended) {
                            review.recommend--;
                            review.isRecommended = false;
                            self.sendRecommendRequest(review.reviewNo, 'decrement');       
                        } else {
                            review.recommend++;
                            review.isRecommended = true;
                            self.sendRecommendRequest(review.reviewNo, 'increment');      
                        }
                    },
                    openImageModal(image) {
                        this.modalImage = image;
                    },
                    closeImageModal() {
                        this.modalImage = null;
                    },
                    loadMore() {
                        let self = this;
                        const productNo = self.productNo;

                        if (!productNo) {
                            console.warn("리뷰 로드: productNo가 아직 없습니다.");
                            return;
                        }

                        self.currentPage++; // 다음 페이지로 이동

                        $.ajax({
                            url: "${pageContext.request.contextPath}/product/reviews.dox",
                            dataType: "json",
                            type: "GET",
                            data: {
                                productNo: productNo,
                                page: self.currentPage,
                                pageSize: self.pageSize
                            },
                            success: function (response) {
                                if (response && response.result === "success") {
                                    const reviewsWithState = response.reviews.map(review => {
                                        review.isRecommended = review.isRecommendedByMe;
                                        return review;
                                    });
                                    // 기존 리뷰 목록에 새로 불러온 리뷰들을 추가합니다.
                                    self.reviews.push(...reviewsWithState);
                                    self.totalReviewCount = response.totalCount || 0;
                                } else {
                                    alert("리뷰 데이터를 불러오는 데 실패했습니다.");
                                    self.currentPage--; // 실패 시 페이지 번호 되돌리기
                                }
                            },
                            error: function(xhr, status, error) {
                                console.error("리뷰 목록 조회 중 오류 발생:", status, error, xhr.responseText);
                                alert("리뷰 목록 조회 중 오류가 발생했습니다.");
                                self.currentPage--; // 오류 시 페이지 번호 되돌리기
                            }
                        });
                    },
                    formatDate(dateString) {

                        if (!dateString) {
                            return '';
                        }

                        const date = new Date(dateString);

                        if (isNaN(date.getTime())) {
                            return dateString;
                        }

                        const year = date.getFullYear();
                        const month = date.getMonth() + 1;
                        const day = date.getDate();

                        const final = year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0');

                        return final;
                    },
   
                    fnLoadReviews() {
                        let self = this;
        
                        const productNo = self.productNo;
                        if (!productNo) {
                            console.warn("리뷰 로드: productNo가 아직 없습니다.");
                            return;
                        }

                        self.currentPage = 1;

                        $.ajax({
                            url: "${pageContext.request.contextPath}/product/reviews.dox",
                            dataType: "json",
                            type: "GET",
                            data: { 
                                productNo: productNo,
                                page: self.currentPage,
                                pageSize: self.pageSize
                            },
                            success: function (response) {
                                if (response && response.result === "success") {
                                    const reviewsWithState = response.reviews.map(review => {
                                        review.isRecommended = review.isRecommendedByMe; 
                                        return review;
                                    });

                                    self.reviews = reviewsWithState || [];
                                    self.totalReviewCount = response.totalCount || 0; 
                                    self.averageRating = response.averageRating || 0;
                                    self.totalReviews = response.totalReviews || 0;
                                    self.ratingDistribution = response.ratingDistribution || { 5:0,4:0,3:0,2:0,1:0 };
                                } else {
                                    alert("리뷰 데이터를 불러오는 데 실패했습니다.");
                                }
                            },
                            error: function(xhr, status, error) {
                                console.error("리뷰 목록 조회 중 오류 발생:", status, error, xhr.responseText);
                                alert("리뷰 목록 조회 중 오류가 발생했습니다.");
                            }
                        });
                    },
                    sendRecommendRequest(reviewNo, action) {
                        let self = this;
                        let param = {
                            reviewNo: reviewNo,
                            action: action
                        };
                        $.ajax({
                            url: "${pageContext.request.contextPath}/review/toggleRecommend.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function(data) {
                                if (data.result === "success") {
                                    console.log("추천 상태 변경 성공:", data.message);
                                } else {
                                    const targetReview = self.reviews.find(r => r.reviewNo === reviewNo);
                                    if (targetReview) {
                                        if (action === "increment") {
                                            targetReview.recommend--;
                                            targetReview.isRecommended = false;
                                        } else { 
                                            targetReview.recommend++;
                                            targetReview.isRecommended = true;
                                        }
                                    }
                                    alert("추천 처리 실패: " + data.message);
                                }
                            },
                            error: function(xhr, status, error) {
                                console.error("추천 처리 AJAX 오류:", status, error, xhr.responseText);
                                alert("서버 통신 오류가 발생했습니다.");
                                const targetReview = self.reviews.find(r => r.reviewNo === reviewNo);
                                if (targetReview) {
                                    if (action === "increment") {
                                        targetReview.recommend--;
                                        targetReview.isRecommended = false;
                                    } else { 
                                        targetReview.recommend++;
                                        targetReview.isRecommended = true;
                                    }
                                }
                            }
                        });
                    },
                },
                mounted() {
                    this.fnInfo();
                    this.fnLoadReviews(); // 리뷰 
                    this.shareTitle = (document.getElementById('title')?.textContent || document.title).trim();

                    this._docHandler = () => { this.ddOpen1 = false; this.ddOpen2 = false; this.shareOpen = false; };
                    document.addEventListener('click', this._docHandler);

                    const now = new Date(), day = now.getDay();
                    this.week = day >= 1 && day <= 5;
                    this.before = now.getHours() < 15;

                    if (location.hash) {
                        history.replaceState(null, '', location.pathname + location.search);
                    }
                    window.addEventListener('pageshow', (e) => { if (e.persisted) window.location.reload(); });
                    
                },
                beforeUnmount() { document.removeEventListener('click', this._docHandler); }
            });
            app.mount('#app');
        </script>