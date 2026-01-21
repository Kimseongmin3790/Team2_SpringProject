<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta name="_csrf_parameter" content="${_csrf.parameterName}">
            <meta name="_csrf" content="${_csrf.token}">
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
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                    background: #f8f8f8;
                    border: 1px solid #eee;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .prod-media .main-box img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    background: #fff;
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
                    width: 490px;
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
                    padding: 5px 140px;
                    margin: 0 auto;
                    text-align: center;
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
                    flex: 0 0 50px;
                    /* 가로 50px 고정 */
                    min-width: 50px !important;
                    background: #fff;
                    color: var(--text-900);
                    border: 1px solid var(--line);
                    padding: 0;
                    font-size: 20px;
                }

                .btn-like.active {
                    border-color: #ff4100;
                    color: #ff4100;
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
                    grid-template-columns: 1fr 1fr;
                    gap: 10px 12px;
                    max-width: 500px;
                }

                .actions .btn-primary,
                .actions .btn-outline {
                    flex: 1;
                }

                .actions .btn {
                    width: 100%;
                    min-width: 0;
                }

                .detail-img-wrap {
                    width: 100%;
                    overflow: hidden;
                    border-radius: 8px;
                    background: #fff;
                }

                .detail-img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                    display: block;
                }

                .detail--portrait {
                    aspect-ratio: 3 / 4;
                }

                /* 세로형(포스터 같은 이미지) */
                .detail--land {
                    aspect-ratio: 4 / 3;
                }

                /* 가로형 */
                .detail--square {
                    aspect-ratio: 1 / 1;
                }

                /* 정사각 */

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

                /* 판매자 답글 컨테이너 */
                .seller-reply-container {
                    margin-top: 1rem;
                    background-color: #f9fafb;
                    border-radius: 0.5rem;
                    padding: 1rem;
                }

                /* 판매자 답글 개별 항목 */
                .seller-reply-item {
                    padding-top: 0.5rem;
                    padding-bottom: 0.5rem;
                    border-bottom: 1px solid #e5e7eb;
                }

                .seller-reply-header {
                    display: flex;
                    justify-content: space-between;
                    /* 양쪽 끝으로 정렬 */
                    align-items: center;
                    /* 세로 중앙 정렬 */
                    margin-bottom: 0.5rem;
                    /* 내용과의 간격 */
                }

                .seller-reply-item:last-child {
                    border-bottom: none;
                }

                /* 판매자 답글 작성자 */
                .seller-reply-author {
                    font-weight: 600;
                    color: #16a34a;
                    margin: 0;
                }

                /* 판매자 답글 내용 */
                .seller-reply-content {
                    color: #374151;
                    margin-top: 0.5rem;
                }

                /* 판매자 답글 날짜 */
                .seller-reply-date {
                    font-size: 0.875rem;
                    color: #6b7280;
                    margin-top: 0.25rem;
                }

                .btn-info {
                    background-color: #007bff;
                    color: white;
                }

                .btn-info:hover {
                    background-color: #0056b3;
                }

                .seller-reply-actions {
                    display: flex;
                    gap: 0.5rem;
                }

                .btn-sm {
                    padding: 0.25rem 0.5rem;
                    font-size: 0.875rem;
                }

                .btn-danger {
                    background-color: #dc3545;
                    color: white;
                }

                .btn-danger:hover {
                    background-color: #c82333;
                }

                .btn-sm {
                    height: auto;
                    min-width: 0;
                    padding: 4px 10px;
                    font-size: 13px;
                    font-weight: 500;
                }

                /* ▼ 옵션/공유 드롭다운이 sticky 탭 위로 뜨도록 */
                .dd {
                    position: relative;
                }

                /* 이미 있으니 안전하게 명시 */
                .share-wrap {
                    position: relative;
                }

                /* 공유 팝업 부모도 기준점 명시 */

                .dd-list,
                .share-pop {
                    position: absolute;
                    /* 기존과 동일 */
                    z-index: 1001;
                    /* .irq(50) 보다 확실히 높게 */
                    max-height: min(60vh, 480px);
                    /* 옵션 많아도 화면 높이 기준으로 스크롤 */
                    overflow: auto;
                    /* 내부 스크롤 */
                }

                /* 굳이 내릴 필요는 없지만, 혹시 모를 테마 충돌 대비해 살짝만 조정 */
                .irq {
                    z-index: 30;
                    /* sticky 유지 + 드롭다운보다 낮게 */
                }

                .status-badge-detail {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    padding: 8px 12px;
                    border-radius: 10px;
                    font-weight: 700;
                    font-size: 14px;
                    color: #fff;
                    z-index: 2;
                }

                .status-badge-detail.soldout {
                    background: #757575;
                }

                /* 회색 */
                .status-badge-detail.hidden {
                    background: #b71c1c;
                }

                /* 레드 */

                .main-box img.dimmed {
                    filter: grayscale(40%) brightness(0.85);
                }

                .status-note {
                    margin: 12px 0;
                    padding: 10px 12px;
                    border-radius: 8px;
                    font-weight: 600;
                }

                .status-note.soldout {
                    background: #f3f4f6;
                    color: #6b7280;
                }

                .status-note.hidden {
                    background: #fee2e2;
                    color: #b91c1c;
                }

                .btn[disabled] {
                    opacity: .6;
                    cursor: not-allowed;
                }

                .sel-head {
                    display: flex;
                    align-items: center;
                    width: 100%;
                }

                .btn-remove {
                    margin-left: auto;
                    background: none;
                    border: none;
                    color: #888;
                    cursor: pointer;
                }

                .btn-remove:hover {
                    color: #d32f2f;
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
                                    <span v-if="isSoldOut" class="status-badge-detail soldout">품절</span>
                                    <span v-else-if="isHidden" class="status-badge-detail hidden">판매 중지</span>
                                    <img :src="mainImageUrl" :alt="info.pName"
                                        :class="{ dimmed: isSoldOut || isHidden }" @error="onImgError($event)">
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
                                <div><a href="javascript:;" style="text-decoration:none; color:inherit;"
                                        @click="fnMovement(info.sellerId)">{{info.businessName}}</a></div>
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
                                <div v-if="isSoldOut" class="status-note soldout">현재 <b>품절</b>된 상품입니다. 재입고 후 구매하실 수 있어요.
                                </div>
                                <div v-else-if="isHidden" class="status-note hidden">이 상품은 <b>판매 중지</b>되었습니다.</div>
                                <hr style="margin: 60px 0;">
                                <div id="sub">
                                    <p style="line-height:20px;">{{ info.pInfo }}</p>
                                </div>

                                <div>
                                    <div><b>원산지</b> {{ info.origin }}</div>

                                    <div v-if="fulfillment === 'delivery'">
                                        <div><b>배송 유형</b> {{ shippingTypeLabel }}</div>
                                        <div>
                                            <b>배송비</b> {{ shippingFee.toLocaleString() }}원
                                            <span class="muted">| 도서산간 추가 배송비 별도</span>
                                        </div>
                                        <div class="muted" style="margin-top:4px;">{{ shippingGuideText }}</div>
                                    </div>

                                    <div v-else>
                                        <div><b>수령 방식</b> 방문 수령</div>
                                        <div><b>배송비</b> 0원</div>
                                        <div class="muted" style="margin-top:4px;">방문 수령 상품입니다. 배송비가 부과되지 않습니다.</div>
                                    </div>
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
                                        <!-- 🔹 버튼 라벨: 선택 전/후 UI -->
                                        <button type="button" class="dd-btn" @click.stop="ddOpen2=!ddOpen2">
                                            <span class="l1">
                                                {{ selectedOption ? selectedOption.unit : '옵션 선택 (필수)' }}
                                            </span>
                                            <span class="l2" v-if="selectedOption">
                                                단가: ￦{{ price.toLocaleString() }}
                                            </span>
                                        </button>

                                        <!-- 🔹 리스트: 옵션 클릭 시 pickProduct(item, idx) 호출 -->
                                        <div class="dd-list" v-if="ddOpen2" @click.stop>
                                            <div class="dd-opt" v-for="(item, idx) in options"
                                                :key="item.optionNo ?? idx" @click="pickProduct(item, idx)">
                                                <span class="l1">{{ item.unit }}</span>
                                                <span class="l2">￦{{
                                                    (Number(info.price || 0) + Number(item.addPrice ||
                                                    0)).toLocaleString()
                                                    }}원</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="selection-summary" v-if="selected" style="margin-top:12px">
                                        <div style="padding:8px 0;border-top:1px solid #eee">
                                            <div class="sel-head">
                                                {{ info.pName }} <span style="color:#666">/ {{ selectedOption?.unit
                                                    }}</span>
                                                <button type="button" @click="removeProduct" class="btn-remove">삭제</button>
                                            </div>
                                            <hr
                                                style="border-width:1px 0 0 0; border-style:dashed; border-color:#9d9d9d; width:480px; margin: 10px 0px;">
                                            <div
                                                style="font-size:18px;font-weight:700; display:flex; align-items:center; gap:8px; margin-top:6px">
                                                <button @click="fnMinus" style="width:30px; height:30px;">-</button>
                                                <input v-model.number="qty" @input="recomputeTotal"
                                                    style="width:50px; text-align:center; height:30px; margin:5px -9px;">
                                                <button @click="fnPlus" style="width:30px; height:30px;">+</button>
                                                <span style="margin-left:auto;">{{ (qty * price).toLocaleString()
                                                    }}원</span>
                                            </div>
                                        </div>

                                        <!-- (선택 옵션, 단가, 총액) 서버 필요 시 참고용 히든필드 -->
                                        <input type="hidden" name="optionUnit" :value="selectedOption?.unit">
                                        <input type="hidden" name="optionAddPrice" :value="selectedOption?.addPrice">
                                        <input type="hidden" name="optionIdx" :value="selectedOption?.idx">
                                        <input type="hidden" name="unitPrice" :value="price">
                                        <input type="hidden" name="totalPrice" :value="totalSum">
                                    </div>

                                    <div v-if="selected" style="text-align:right; font-size:20px; font-weight:800;">
                                        총 상품금액({{ qty }}개) {{ totalSum.toLocaleString() }}원
                                    </div>

                                    <div style="margin: 24px 0 0;">
                                        <div class="actions">
                                            <button @click="fnPurchase(info.productNo, qty)" class="btn btn-primary"
                                                :disabled="!canBuy || !selected || qty <= 0"
                                                :title="!canBuy ? (isSoldOut ? '품절된 상품입니다' : '판매 중지된 상품입니다') : ''">구매하기</button>

                                            <button @click="fnBasket(info.productNo, qty)" class="btn btn-outline"
                                                :disabled="!canBuy || !selected || qty <= 0"
                                                :title="!canBuy ? (isSoldOut ? '품절된 상품입니다' : '판매 중지된 상품입니다') : ''">장바구니</button>
                                            <button @click="fnChat" class="btn btn-primary">실시간 채팅</button>
                                            <button @click="fnToggleWish" class="btn btn-outline"
                                                :class="{active: liked}">
                                                {{ liked ? '❤️' : '♡' }}찜하기
                                            </button>
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

                        </section>

                        <div v-if="!showDetail" style="margin:16px 0; text-align:center;">
                            <button @click="openDetail"
                                style="padding:10px 16px; border:1px solid #ddd; border-radius:8px; background:#fff; cursor:pointer;">
                                ▼ 상세 보기
                            </button>
                        </div>

                        <div v-show="showDetail">
                            <div v-for="img in detailOnly" :key="img" class="detail-img-wrap" :class="pickAR(img)">
                                <img :src="img" :alt="info.pName || '상세 이미지'" class="detail-img" loading="lazy"
                                    @load="onDetailLoad($event, img)">
                            </div>

                            <div style="margin: 30px 40px;">
                                상품정보 제공고시
                                <table>
                                    <tr>
                                        <th>품목 또는 명칭</th>
                                        <td>{{info.pName}}</td>
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

                        <section id="qa" style="margin-top:60px;">
                            <div class="qa-container" style="max-width:900px; margin:0 auto; padding:40px 0;">
                                <h2 style="font-size:24px; font-weight:700; margin-bottom:10px;">상품 문의</h2>
                                <p style="color:#666; font-size:14px; line-height:1.6; margin-bottom:20px;">
                                    상품에 대한 문의를 남기는 공간입니다. 배송·교환·환불 관련 문의는 1:1 문의를 이용해주세요.
                                </p>

                                <div style="text-align:right; margin-bottom:20px;">
                                    <button @click="fnWriteQuestion"
                                        style="padding:10px 20px; border:none; background:#5b21b6; color:#fff; border-radius:6px; cursor:pointer;">
                                        문의하기
                                    </button>
                                </div>

                                <table style="width:100%; border-collapse:collapse; font-size:14px;">
                                    <thead style="border-bottom:2px solid #eee;">
                                        <tr style="text-align:left; background:#fafafa;">
                                            <th style="padding:12px;">제목</th>
                                            <th style="padding:12px;">작성자</th>
                                            <th style="padding:12px;">작성일</th>
                                            <th style="padding:12px;">답변상태</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <template v-for="(q, index) in qaList" :key="q.qnaNo">
                                            <!-- 문의 본문 -->
                                            <tr style="border-bottom:1px solid #f0f0f0;">
                                                <td style="padding:12px; cursor:pointer;" @click="toggleAnswer(q)">
                                                    <span v-if="!canViewQuestion(q)">🔒 비밀글입니다.</span>
                                                    <span v-else> {{ q.title }} </span>
                                                </td>
                                                <td style="padding:12px;">{{ q.userId }}</td>
                                                <td style="padding:12px;">{{ q.regDate }}</td>
                                                <td style="padding:12px; color:#9333ea; font-weight:500;">
                                                    {{ q.status }}
                                                </td>
                                            </tr>

                                            <!-- 답변 표시 영역 -->
                                            <tr v-if="q.showAnswer && canViewQuestion(q)">
                                                <td colspan="4" style="background:#fafafa; padding:16px 24px;">
                                                    <b style="color:#5b21b6;">문의 내용</b><br>
                                                    <div style="margin-top:8px; white-space:pre-wrap;">{{ q.content }}
                                                    </div>

                                                    <div v-if="q.answer" style="margin-top:12px;">
                                                        <b style="color:#5b21b6;">판매자 답변</b><br>
                                                        <div style="margin-top:8px; white-space:pre-wrap;">{{
                                                            q.answer }}</div>
                                                    </div>
                                                    <div v-else style="margin-top:8px; color:#888;">아직 답변이 등록되지 않았습니다.
                                                    </div>
                                                </td>
                                            </tr>
                                        </template>

                                        <tr v-if="qaList.length === 0">
                                            <td colspan="4" style="text-align:center; padding:20px; color:#888;">
                                                등록된 문의가 없습니다.
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
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
                        ddOpen1: false,
                        ddOpen2: false,
                        fulfillment: 'delivery',
                        shareOpen: false,
                        shareUrl: window.location.href,
                        shareTitle: '',
                        showDetail: false,
                        week: false,
                        before: false,
                        liked: false,
                        detailMeta: {},

                        userId: "${sessionScope.sessionId}",
                        userName: "${sessionScope.sessionName}",
                        productNo: "${productNo}",
                        info: {},
                        fileList: [],
                        options: [],

                        selected: false,
                        selectedOption: null,
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
                        totalReviewCount: 0,

                        editingCommentNo: null,
                        //============================

                        qaList: []
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

                    shippingTypeKey() {
                        // 서버에서 오는 값: info.shippingType (ROOM/REFRIGERATED/FROZEN)
                        return String(this.info?.shippingType || "ROOM").trim().toUpperCase();
                    },

                    shippingTypeLabel() {
                        const m = { ROOM: "상온", REFRIGERATED: "냉장", FROZEN: "냉동" };
                        return m[this.shippingTypeKey] || "상온";
                    },

                    shippingFee() {
                        // ✅ 방문수령이면 무조건 0원
                        if (this.fulfillment !== "delivery") return 0;

                        // ✅ 택배일 때 배송유형별 기본 배송비
                        const feeMap = {
                            ROOM: 3000,
                            REFRIGERATED: 4000,
                            FROZEN: 5000
                        };
                        return feeMap[this.shippingTypeKey] ?? 3000;
                    },

                    shippingGuideText() {
                        if (this.fulfillment !== "delivery") return "방문 수령 상품입니다. 배송비가 부과되지 않습니다.";
                        return "신선도 유지를 위해 " + this.shippingTypeLabel + " 배송으로 발송됩니다.";
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
                    },
                    // ======================================
                    status() {
                        return String(this.info?.productStatus || "").trim().toUpperCase();
                    },
                    isSoldOut() { return this.status === 'SOLDOUT'; },
                    isHidden() { return this.status === 'HIDDEN'; },
                    canBuy() { return !this.isSoldOut && !this.isHidden; }
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
                                self.info = {
                                    ...data.info,
                                    productStatus: String(
                                        data.info?.productStatus ?? data.info?.PRODUCT_STATUS ?? ""
                                    ).trim().toUpperCase(),
                                    // shippingType 정규화 추가
                                    shippingType: String(
                                        data.info?.shippingType ??
                                        data.info?.SHIPPING_TYPE ??
                                        data.info?.shipping_type ??
                                        "ROOM"
                                    ).trim().toUpperCase()
                                };
                                self.fileList = data.fileList;
                                self.options = data.options;
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

                    fnMovement: function (sellerId) {
                        location.href = "/seller/detail.do?sellerId=" + sellerId;
                    },

                    onDetailLoad(e, url) {
                        const w = e.target.naturalWidth || 1;
                        const h = e.target.naturalHeight || 1;
                        this.detailMeta[url] = { w, h };
                    },
                    pickAR(url) {
                        const m = this.detailMeta[url];
                        if (!m) return 'detail--portrait';      // 로딩 전 임시값(세로형이 많다면 이렇게)
                        const r = m.w / m.h;                   // 가로/세로 비
                        if (r > 1.15) return 'detail--land';   // 충분히 가로 넓으면 4:3
                        if (r < 0.87) return 'detail--portrait'; // 충분히 세로 길면 3:4
                        return 'detail--square';               // 애매하면 정사각
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

                    normalizedShareUrl() {
                        const u = new URL(this.shareUrl || location.href, location.origin);
                        return u.origin + u.pathname + u.search; // 해시 제거
                    },

                    shareNaver() {
                        const url = this.normalizedShareUrl();
                        const title = (this.shareTitle || document.title || '').trim();

                        if (!url || !title) {
                            Swal.fire('⚠️', '공유할 URL/제목이 비었습니다.', 'warning');
                            return;
                        }

                        // ✅ 단일 인코딩만 적용
                        const encUrl = encodeURIComponent(url);
                        const encTitle = encodeURIComponent(title);

                        window.open(
                            `https://share.naver.com/web/shareView?url=${encUrl}&title=${encTitle}`,
                            '_blank',
                            'noopener'
                        );
                        this.shareOpen = false;
                    },
                    shareKakao() {
                        if (!(window.Kakao && window.Kakao.isInitialized && window.Kakao.isInitialized())) {
                            Swal.fire('⚠️', '카카오 SDK가 초기화되지 않았습니다.', 'warning');
                            return;
                        }
                        const url = this.normalizedShareUrl();
                        const title = (this.shareTitle || document.title || '').trim();

                        // ✅ 실제 존재하는 절대 경로 이미지로 교체
                        const thumb = location.origin + `<c:url value="/resources/img/snowCrab.png"/>`;

                        window.Kakao.Share.sendDefault({
                            objectType: 'feed',
                            content: {
                                title: title || '상품을 공유합니다',
                                description: '상품을 공유합니다',
                                imageUrl: thumb,
                                link: { webUrl: url, mobileWebUrl: url }
                            },
                            buttons: [
                                { title: '바로 보기', link: { webUrl: url, mobileWebUrl: url } }
                            ]
                        });
                        this.shareOpen = false;
                    },
                    shareCopy() {
                        const link = this.normalizedShareUrl();
                        (navigator.clipboard
                            ? navigator.clipboard.writeText(link)
                            : new Promise(res => {
                                const ta = document.createElement('textarea');
                                ta.value = link; document.body.appendChild(ta);
                                ta.select(); document.execCommand('copy');
                                document.body.removeChild(ta); res();
                            })
                        ).then(() => {
                            Swal.fire({
                                icon: 'success',
                                title: '✅',
                                text: '링크가 복사되었습니다.',
                                confirmButtonColor: '#5dbb63'
                            });
                        });
                        this.shareOpen = false;
                    },

                    // 구매 선택
                    pickProduct(item, idx) {
                        // 옵션 지정
                        this.selectedOption = {
                            ...item,
                            idx: (item?.idx ?? idx)
                        };

                        // 선택 상태/수량
                        this.selected = true;
                        if ((this.qty | 0) < 1) this.qty = 1;

                        // 단가(기본가 + 추가금)
                        const base = Number(this.info?.price || 0);
                        const add = Number(item?.addPrice || 0);
                        this.price = base + add;

                        this.ddOpen2 = false;
                        this.recomputeTotal();
                    },

                    removeProduct() {
                        this.selected = false;
                        this.selectedOption = null;
                        this.qty = 0;
                        this.price = Number(this.info?.price || 0); // 기본가로 복귀(표시용)
                        this.recomputeTotal();
                    },
                    fnMinus() { if (!this.selected) return; if (this.qty > 1) { this.qty--; this.recomputeTotal(); } },
                    fnPlus() { if (!this.selected) return; this.qty++; this.recomputeTotal(); },
                    recomputeTotal() {
                        const unit = Number(this.price || 0);
                        const q = Number(this.qty || 0);
                        this.totalSum = (this.selected && q > 0) ? (unit * q) : 0;
                    },

                    // 상세 토글
                    openDetail() { this.showDetail = true; },

                    closeDetail() { this.showDetail = false; },

                    calcShippingFee() {
                        if (this.fulfillment !== 'delivery') return 0;

                        const t = String(this.info?.shippingType || 'ROOM').toUpperCase();
                        // 예시 정책(너가 원하는 값으로 조정)
                        if (t === 'FROZEN') return 5000;
                        if (t === 'REFRIGERATED') return 4000;
                        return 3000; // ROOM
                    },

                    // CTA
                    fnPurchase(productNo, qty) {
                        if (this.isHidden) { Swal.fire('⚠️', '판매 중지된 상품입니다.', 'warning'); return; }
                        if (this.isSoldOut) { Swal.fire('⚠️', '품절된 상품입니다.', 'warning'); return; }

                        if (!this.userId) {
                            Swal.fire('⚠️', '로그인 후 이용바랍니다.', 'warning').then(() => {
                                location.href = "http://localhost:8082/login.do";
                            });
                            return;
                        }
                        if (!this.selected || (this.qty | 0) <= 0) {
                            Swal.fire('⚠️', '옵션 선택 후 수량을 확인해 주세요.', 'warning');
                            return;
                        }
                        if (!this.selectedOption) {
                            Swal.fire('⚠️', '옵션을 선택해 주세요.', 'warning');
                            return;
                        }

                        const fee = this.shippingFee;

                        const opt = this.selectedOption;

                        // 서버에서 고유 옵션키를 쓰면 optionNo/id, 없다면 idx 전송
                        const optionNo = opt.optionNo ?? opt.id ?? opt.idx;

                        const param = {
                            productNo,
                            userId: this.userId,
                            qty: this.qty, // 결제 페이지에서 사용할 수량
                            optionNo,                           // 서버가 받는 옵션 키
                            optionUnit: opt.unit,               // 표시용
                            optionAddPrice: Number(opt.addPrice || 0),
                            unitPrice: Number(this.price || 0), // 단가(기본가+추가금)
                            totalPrice: Number(this.totalSum || 0),
                            fulfillment: this.fulfillment,
                            shippingFee: fee
                        };

                        // 결제 페이지로 이동(POST Form 전송 가정)
                        pageChange('/product/payment.do', param);
                    },

                    fnBasket(productNo, qty) {
                        if (this.isHidden) { Swal.fire('⚠️', '판매 중지된 상품입니다.', 'warning'); return; }
                        if (this.isSoldOut) { Swal.fire('⚠️', '품절된 상품입니다.', 'warning'); return; }

                        if (!this.userId) {
                            Swal.fire('⚠️', '로그인 후 이용바랍니다.', 'warning').then(() => {
                                location.href = "http://localhost:8082/login.do";
                            });
                            return;
                        }
                        if (!this.selected || (this.qty | 0) <= 0) {
                            Swal.fire('⚠️', '옵션 선택 후 수량을 확인해 주세요.', 'warning');
                            return;
                        }
                        if (!this.selectedOption) {
                            Swal.fire('⚠️', '옵션을 선택해 주세요.', 'warning');
                            return;
                        }

                        console.log('shippingTypeKey=', this.shippingTypeKey);
                        console.log('computed shippingFee=', this.shippingFee);
                        const fee = this.shippingFee; // <- 이렇게 고정
                        console.log('fee to send=', fee);

                        const opt = this.selectedOption;
                        const optionNo = opt.optionNo ?? opt.id ?? opt.idx;

                        const param = {
                            userId: this.userId,
                            productNo: productNo,
                            quantity: this.qty,                 // 장바구니 API는 quantity 사용 중이므로 유지
                            fulfillment: this.fulfillment,
                            shippingFee: fee,
                            optionNo,                           // 장바구니에도 옵션키 저장
                            optionUnit: opt.unit,
                            optionAddPrice: Number(opt.addPrice || 0),
                            unitPrice: Number(this.price || 0), // 선택 단가 저장(주문서 계산용)
                            totalPrice: Number(this.totalSum || 0)
                        };

                        $.ajax({
                            url: '/cart/add.dox',
                            type: 'POST',
                            dataType: 'json',
                            data: param,
                            success: (data) => {
                                if (data.result === 'success') {
                                    console.log(this.shippingTypeKey, this.shippingFee);

                                    Swal.fire({
                                        icon: 'success',
                                        title: '✅',
                                        text: '장바구니에 담겼습니다. 장바구니로 이동하시겠습니까?',
                                        showCancelButton: true,
                                        confirmButtonText: '이동',
                                        cancelButtonText: '계속 쇼핑',
                                        confirmButtonColor: '#5dbb63'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            pageChange('/buyerMyPage.do', { productNo });
                                        } else {
                                            this.fnInfo(); // 화면 갱신
                                        }
                                    });
                                } else {
                                    Swal.fire('❌', '장바구니 담기 실패', 'error');
                                }
                            },
                            error: (xhr) => {
                                Swal.fire('❌', '서버오류: ' + xhr.status, 'error');
                            }
                        });
                    },

                    fnChat() {
                        if (!this.userId) {
                            Swal.fire('⚠️', '로그인 후 이용 가능합니다.', 'warning').then(() => {
                                location.href = "/login.do";
                            });
                            return;
                        }

                        const productNo = String(this.productNo ?? "").trim();
                        const sellerId = String(this.info?.sellerId ?? "").trim();

                        const params = new URLSearchParams({ productNo, sellerId });
                        const url = "/chat.do?" + params.toString();

                        window.open(url, "chatPopup", "width=520,height=720,resizable=yes,scrollbars=yes");
                    },

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
                                    Swal.fire('❌', '리뷰 데이터를 불러오는 데 실패했습니다.', 'error');
                                    self.currentPage--; // 실패 시 페이지 번호 되돌리기
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("리뷰 목록 조회 중 오류 발생:", status, error, xhr.responseText);
                                Swal.fire('❌', '리뷰 목록 조회 중 오류가 발생했습니다.', 'error');
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
                                    self.ratingDistribution = response.ratingDistribution || { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
                                } else {
                                    Swal.fire('❌', '리뷰 데이터를 불러오는 데 실패했습니다.', 'error');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("리뷰 목록 조회 중 오류 발생:", status, error, xhr.responseText);
                                Swal.fire('❌', '리뷰 목록 조회 중 오류가 발생했습니다.', 'error');
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
                            success: function (data) {
                                if (data.result === "success") {
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
                                    Swal.fire('❌', "추천 처리 실패: " + data.message, 'error');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("추천 처리 AJAX 오류:", status, error, xhr.responseText);
                                Swal.fire('❌', '서버 통신 오류가 발생했습니다.', 'error');
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
                    editComment: function (comment) {
                        let self = this;
                        comment.originalContents = comment.contents;
                        self.editingCommentNo = comment.commentNo;
                    },

                    cancelEdit: function () {
                        let self = this;
                        const comment = this.reviews.flatMap(r => r.comments || []).find(c => c.commentNo === self.editingCommentNo);
                        if (comment && comment.originalContents !== undefined) {
                            comment.contents = comment.originalContents;
                        }
                        self.editingCommentNo = null;
                    },

                    saveEditedComment: function (comment) {
                        let self = this;

                        if (comment.contents.trim() === '') {
                            Swal.fire('⚠️', '답글 내용을 입력해주세요.', 'warning');
                            return;
                        }

                        $.ajax({
                            url: "${pageContext.request.contextPath}/seller/review/updateComment.dox",
                            dataType: "json",
                            type: "POST",
                            data: {
                                commentNo: comment.commentNo,
                                contents: comment.contents
                            },
                            success: function (response) {
                                if (response.result === 'success') {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '✅',
                                        text: '답글이 수정되었습니다.',
                                        confirmButtonColor: '#5dbb63'
                                    }).then(() => {
                                        self.editingCommentNo = null;
                                        self.fnLoadReviews();
                                    });
                                } else {
                                    Swal.fire('❌', '답글 수정에 실패했습니다: ' + response.message, 'error');
                                }
                            },
                            error: function () {
                                Swal.fire('❌', '답글 수정 중 오류가 발생했습니다.', 'error');
                            }
                        });
                    },

                    deleteComment: function (commentNo) {
                        Swal.fire({
                            icon: 'warning',
                            title: '⚠️',
                            text: '정말로 이 답글을 삭제하시겠습니까?',
                            showCancelButton: true,
                            confirmButtonText: '삭제',
                            cancelButtonText: '취소',
                            confirmButtonColor: '#5dbb63'
                        }).then((result) => {
                            if (!result.isConfirmed) return;

                            let self = this;
                            $.ajax({
                                url: "${pageContext.request.contextPath}/seller/review/deleteComment.dox",
                                dataType: "json",
                                type: "POST",
                                data: {
                                    commentNo: commentNo
                                },
                                success: function (response) {
                                    if (response.result === 'success') {
                                        Swal.fire({
                                            icon: 'success',
                                            title: '✅',
                                            text: '답글이 삭제되었습니다.',
                                            confirmButtonColor: '#5dbb63'
                                        }).then(() => {
                                            self.fnLoadReviews();
                                        });
                                    } else {
                                        Swal.fire('❌', '답글 삭제에 실패했습니다: ' + response.message, 'error');
                                    }
                                },
                                error: function () {
                                    Swal.fire('❌', '답글 삭제 중 오류가 발생했습니다.', 'error');
                                }
                            });
                        });
                    },

                    fnLoadQA() {
                        let self = this;
                        $.ajax({
                            url: "${pageContext.request.contextPath}/product/questions.dox",
                            type: "GET",
                            dataType: "json",
                            data: {
                                productNo: self.productNo
                            },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.qaList = data.list.map(q => ({ ...q, showAnswer: false }));
                                } else {
                                    Swal.fire('❌', '상품문의 데이터를 불러오는데 실패했습니다', 'error');
                                }
                            }
                        });
                    },
                    toggleAnswer(q) {
                        if (q.isSecret === 'Y' && !this.canViewQuestion(q)) {
                            Swal.fire('⚠️', '비밀글은 작성자 또는 판매자만 확인할 수 있습니다.', 'warning');
                            return;
                        }
                        q.showAnswer = !q.showAnswer;
                    },
                    fnWriteQuestion() {
                        if (!this.userId) {
                            Swal.fire('⚠️', '로그인 후 이용 가능합니다.', 'warning').then(() => {
                                pageChange('/login.do');
                            });
                            return;
                        }
                        pageChange('/productQna/write.do', { productNo: this.productNo, productName: this.info.pName });
                    },
                    canViewQuestion(q) {
                        // 1. 비밀글 아닌 경우 → 누구나 열람 가능
                        if (q.isSecret !== 'Y') return true;

                        // 2. 작성자 본인 또는 판매자인 경우만 허용
                        if (this.userId === q.userId) return true;
                        if (this.userId === q.sellerId) return true;

                        // 3. 그 외 사용자 → 비밀글 차단
                        return false;
                    },
                    // 찜 기능 
                    fnCheckWish() {
                        let self = this;
                        if (!self.userId) return;
                        $.ajax({
                            url: "/wishlist/check.dox",
                            type: "POST",
                            dataType: "json",
                            data: { productNo: self.productNo },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.liked = data.isWish;
                                }
                            }
                        });
                    },
                    // 찜 토글
                    fnToggleWish() {
                        let self = this;
                        if (!self.userId) {
                            Swal.fire({
                                icon: 'warning',
                                title: '⚠️',
                                text: '로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?',
                                showCancelButton: true,
                                confirmButtonText: '이동',
                                cancelButtonText: '취소',
                                confirmButtonColor: '#5dbb63'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    location.href = "/login.do";
                                }
                            });
                            return;
                        }
                        $.ajax({
                            url: "/wishlist/toggle.dox",
                            type: "POST",
                            dataType: "json",
                            data: { productNo: self.productNo },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.liked = (data.status === 'added');
                                }
                            }
                        });
                    }
                },
                mounted() {
                    const hid = document.getElementById('sessionId');
                    if (hid && hid.value) this.userId = hid.value;
                    const hnm = document.getElementById('sessionName');
                    if (hnm && hnm.value) this.userName = hnm.value;
                    this.userId = (hid && hid.value) || this.userId || '';
                    this.fnCheckWish();
                    this.fnInfo();
                    this.fnLoadReviews(); // 리뷰 
                    this.fnLoadQA(); // 상품문의
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