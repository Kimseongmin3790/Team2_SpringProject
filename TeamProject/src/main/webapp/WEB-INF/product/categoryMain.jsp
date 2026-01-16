<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>카테고리</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/resources/js/page-change.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <style>
                [v-cloak] {
                    display: none !important;
                }

                body {
                    font-family: "Noto Sans KR", sans-serif;
                    background: #f9f9f9;
                    margin: 0;
                    font-size: 18px;
                    line-height: 1.6;
                }

                /* ===== 전체 레이아웃 ===== */
                .product-category-page {
                    display: flex;
                    flex-direction: row;
                    align-items: flex-start;
                    justify-content: space-between;
                    max-width: 1900px;
                    margin: 30px auto;
                    padding: 0 60px;
                    gap: 60px;
                }

                /* ===== 좌측 카테고리 ===== */
                .product-category-page .sidebar {
                    flex: 0 0 320px;
                    position: sticky;
                    top: 100px;

                    /* ✅ 기존 calc(100vh - 1200px) 때문에 높이 0이 됨 → 정상 높이로 */
                    height: calc(100vh - 140px);
                    overflow-y: auto;
                    overflow-x: hidden;

                    /* 기존 스타일 유지하면서 보기좋게 */
                    padding: 10px 10px 20px 0;
                    background: transparent;
                    border: none;
                    box-shadow: none;
                    align-self: flex-start;
                }

                .product-category-page .sidebar::-webkit-scrollbar {
                    width: 8px;
                }

                .product-category-page .sidebar::-webkit-scrollbar-thumb {
                    background: #d7e7d8;
                    border-radius: 8px;
                }

                .sidebar-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                }

                /* ===== 상품등록 버튼 (크기 고정 포함) ===== */
                .btn-register {
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    min-width: 90px;
                    max-width: 110px;
                    height: 50px;
                    padding: 12px 20px;
                    font-size: 18px;

                    cursor: pointer;
                    transition: background-color 0.2s, transform 0.1s;
                    flex-shrink: 0;
                }

                .btn-register:hover {
                    background-color: #ddd;
                    transform: scale(1.05);
                }

                .sidebar h3 {
                    color: #1a5d1a;
                    font-size: 24px;
                    margin-bottom: 15px;
                    font-weight: bold;
                    margin: 35px 0;
                }

                .sidebar ul {
                    list-style: none;
                    padding-left: 10px;
                }

                .sidebar li {
                    cursor: pointer;
                    padding: 10px 12px;
                    border-radius: 8px;
                    transition: background-color 0.2s, transform 0.1s;
                    font-size: 19px;
                }

                .sidebar li:hover {
                    background: #e8f5e9;
                    transform: translateX(3px);
                }

                .active {
                    font-weight: bold;
                }

                /* ===== 좌우 구분선 ===== */
                .division-bar {
                    width: 1px;
                    background: #ddd;
                    border-radius: 1px;
                    align-self: stretch;
                    height: auto;
                }

                /* ===== 우측 콘텐츠 ===== */
                .content {
                    flex: 3;
                    background: transparent;
                    padding: 0;
                    border: none;
                    box-shadow: none;
                }

                /* ===== 그림 Grid ===== */
                .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 50px;
                    width: 80%;
                }

                /* ===== 카드 공통 ===== */
                .grid-item {
                    display: flex;
                    flex-direction: column;
                    justify-content: flex-start;
                    background: transparent;
                    border-radius: 0;
                    aspect-ratio: 3 / 5.5;
                    overflow: hidden;
                    cursor: pointer;
                    transition: transform 0.25s ease;
                    box-shadow: none;
                    margin-top: 25px;
                }

                .grid-item:hover {
                    transform: translateY(-6px);
                }

                .grid-item .image-wrapper {
                    flex: 5;
                    overflow: hidden;
                    position: relative;
                    border-radius: 5px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                .grid-item .image-wrapper img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    object-position: center;
                    display: block;
                    transition: transform 0.3s ease;
                    border-radius: 5px;
                }

                .grid-item:hover .image-wrapper img {
                    transform: scale(1.05);
                }

                .grid-item .info {
                    flex: 1;
                    background: transparent;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: left;
                    padding: 8px;
                }

                .grid-item .info h4 {
                    font-size: 25px;
                    font-weight: 600;
                    margin-top: -10px;
                    color: #1a5d1a;
                }

                /* ===== 상품 카드 ===== */
                .grid-item.product {
                    height: 610px;
                    /* 원하는 카드 높이로 고정 (필요하면 조절) */
                    display: flex;
                    flex-direction: column;
                }

                .grid-item.product .image-wrapper {
                    height: 320px;
                    /* 이미지 영역 고정 높이 */
                    flex: 0 0 320px;
                    border-radius: 10px;
                    overflow: hidden;
                }

                /* ✅ 이미지가 어떤 비율이든 꽉 채우되 잘리도록 */
                .grid-item.product .image-wrapper img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    /* 비율 달라도 카드 규격 유지 */
                    object-position: center;
                    display: block;
                }

                .grid-item.product .info {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    padding: 10px 8px;
                    text-align: center;
                }

                .grid-item.product .info h4 {
                    margin: 0 0 6px;
                    font-size: 22px;
                    line-height: 1.2;
                    display: -webkit-box;
                    -webkit-line-clamp: 1;
                    /* 제목 1줄 */
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                .grid-item.product .info .meta-bottom {                    
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                /* animation */
                .wave-text,
                .wave-price {
                    display: inline-block;
                    animation: wave 2s ease-in-out infinite;
                    transform-origin: center;
                }

                /* 물결 애니메이션 정의 */
                @keyframes wave {

                    0%,
                    100% {
                        transform: translateY(0);
                    }

                    25% {
                        transform: translateY(-4px) rotate(1deg);
                    }

                    50% {
                        transform: translateY(3px) rotate(-1deg);
                    }

                    75% {
                        transform: translateY(-2px) rotate(0.5deg);
                    }
                }

                /* 가격은 좀 더 강하게 출렁이게 */
                .wave-price {
                    animation: wave 1.6s ease-in-out infinite;
                    font-weight: bold;
                    color: #d35400;
                }

                .wave-text {
                    animation-delay: 0.2s;
                }

                .grid-item.product .info .desc {
                    margin: 0 0 8px;
                    line-height: 1.35;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    /* 설명 2줄 */
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                .grid-item.product .info .price {
                    color: orange;
                    font-weight: bold;
                    font-size: 22px;
                    text-align: center !important;
                }

                .grid-item.product .info .review {
                    display: flex;
                    align-items: center;
                    gap: 4px;
                    margin-top: 4px;
                    justify-content: center;
                }

                /* 별 평점 */
                .full-star,
                .half-star {
                    color: #FFD700;
                }

                .empty-star {
                    color: #ccc;
                }

                .rating-number {
                    margin-left: 4px;
                    font-size: 0.9em;
                    color: #555;
                }

                .grid-item.product .info .date,
                .grid-item.product .info .region,
                .grid-item.product .info .seller {
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    font-size: 14px;
                    line-height: 1.2;
                }

                /* ===== 가격 필터 ===== */
                .price-filter {
                    margin-top: 40px;
                }

                .price-filter h3 {
                    color: #1a5d1a;
                    font-size: 22px;
                    margin-bottom: 15px;
                    font-weight: bold;
                }

                .price-filter ul {
                    list-style: none;
                    padding-left: 10px;
                }

                .price-filter li {
                    cursor: pointer;
                    padding: 10px 12px;
                    border-radius: 8px;
                    transition: background-color 0.2s, transform 0.1s;
                    font-size: 18px;
                }

                .price-filter li:hover {
                    background: #e8f5e9;
                    transform: translateX(3px);
                }

                .price-filter li.active {
                    background: #c8e6c9;
                    font-weight: bold;
                    border-left: 5px solid #388e3c;
                }

                .custom-price-range {
                    display: flex;
                    align-items: center;
                    margin-bottom: 35px;
                }

                .custom-price-range button {
                    border-radius: 5px;
                    border-color: #388e3c;
                    background-color: #388e3c;
                    color: white;
                    margin-left: 2px;
                    height: 40px;
                    font-size: 18px;
                    margin-bottom: 5px;
                }

                .custom-price-range button:hover {
                    background-color: #ddd;
                }

                .custom-price-range input {
                    width: 80px;
                    height: 30px;
                    padding: 4px;
                    font-size: 18px;
                    color: black;
                    border: solid 1px #ebe3e3;
                    margin-bottom: 5px;
                }

                .custom-price-range-left {
                    margin-left: 20px;
                    margin-right: 10px;
                }

                .custom-price-range-right {
                    margin-left: 10px;
                }

                /* ===== 생산지역필터 ==== */
                .region-filter {
                    margin-top: -30px;
                    padding-top: 10px;
                    /* border-top: 1px solid #ddd; */
                }

                .region-filter h3 {
                    color: #1a5d1a;
                    font-size: 22px;
                    margin-bottom: 15px;
                    font-weight: bold;
                }

                .region-filter ul {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .region-filter li {
                    padding: 6px 8px;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: background-color 0.2s ease;
                }

                .region-filter li:hover {
                    background: #f3f3f3;
                }

                .region-filter li.active {
                    background: #007bff;
                    color: white;
                    font-weight: bold;
                }

                .region-filter .count {
                    font-size: 0.9em;
                    color: #777;
                }

                .pagination {
                    display: flex;
                    justify-content: flex-start;
                    align-items: center;
                    margin-top: 3px;
                    margin-left: 30px;
                }

                .pagination button {
                    border: none;
                    background: #eee;
                    padding: 4px 8px;
                    border-radius: 4px;
                    cursor: pointer;
                }

                .pagination button:disabled {
                    opacity: 1.4;
                    cursor: not-allowed;
                }

                .clear-region {
                    font-size: 18px;
                    margin: 10px 0;
                    background-color: #388e3c;
                    border: 1px solid #388e3c;
                    color: white;
                    border-radius: 6px;
                    padding: 4px 8px;
                    cursor: pointer;
                    margin-left: 10px;
                }

                .clear-region:hover {
                    background-color: #ddd;
                }

                /* ===== 구분선 ===== */
                .sidebar-divider {
                    width: 100%;
                    height: 1px;
                    background-color: #ddd;
                    margin: 25px 0;
                }

                .topbar-divider {
                    width: 90%;
                    height: 1px;
                    background-color: #ddd;
                    margin-top: -5px;
                }

                /* ===== breadcrumb ===== */
                .breadcrumb {
                    font-size: 18px;
                    margin-bottom: 25px;
                    color: #555;
                }

                .home {
                    color: #2e7d32;
                    font-weight: bold;
                    cursor: pointer;
                    text-decoration: none;
                }

                .breadcrumb span {
                    color: #2e7d32;
                    font-weight: bold;
                    cursor: pointer;
                }

                .breadcrumb-sep {
                    margin: 0 8px;
                    color: #aaa;
                }

                /* ===== 검색결과 적을 때 ===== */
                .content .grid {
                    justify-content: start;
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    max-width: 1500px;
                    margin: 0 50px;
                    text-align: center;
                }

                @media (min-width: 1200px) {
                    .content .grid:has(.grid-item:nth-child(3)) {
                        max-width: 100%;
                    }
                }

                /* ===== 반응형 ===== */
                @media (max-width: 1400px) {
                    .product-category-page {
                        display: flex;
                        flex-direction: column;
                        align-items: stretch;
                        padding: 0 20px;
                        gap: 30px;
                    }

                    .sidebar {
                        position: relative !important;
                        top: auto !important;
                        width: 100% !important;
                        max-width: 100%;
                        order: 1;
                        z-index: 1;
                        background: #fff;
                        border-radius: 12px;
                        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                        padding: 15px;
                    }

                    .division-bar {
                        display: none !important;
                    }

                    .content {
                        width: 100% !important;
                        order: 2;
                        position: relative;
                        z-index: 0;
                    }

                    .content .grid {
                        width: 100%;
                        margin: 0 auto;
                        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                        gap: 30px;
                    }

                    /* 반응형에서도 버튼 크기 유지 */
                    .btn-register {
                        width: 110px !important;
                        font-size: 18px !important;
                        padding: 12px 20px !important;
                    }
                }

                @media (max-width: 900px) {

                    .sidebar,
                    .content {
                        padding: 0 10px;
                    }

                    .btn-register {
                        width: 110px !important;
                        font-size: 18px !important;
                        padding: 12px 20px !important;
                    }
                }

                @media (max-width: 600px) {
                    body {
                        font-size: 16px;
                        line-height: 1.5;
                    }

                    .product-category-page {
                        padding: 0 10px;
                        gap: 20px;
                    }

                    .sidebar {
                        padding: 10px;
                    }

                    .content .grid {
                        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                    }

                    .btn-register {
                        width: 110px !important;
                        font-size: 18px !important;
                        padding: 12px 20px !important;
                    }

                    /* 카테고리 그리드일 때: 카드 폭/간격 축소, 너비 100% */
                    .content .grid:has(.grid-item:not(.product)) {
                        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                        gap: 24px;
                        width: 100%;
                    }

                    /* 카테고리 카드 비율을 낮게(가로가 더 넓게) */
                    .grid-item:not(.product) {
                        aspect-ratio: 4 / 3;
                        /* 기존 3/5.5 → 4/3 로 변경 */
                        max-width: 260px;
                        /* 필요 시 최대폭 제한 */
                        margin: 10px auto;
                        /* 가운데 정렬 느낌 */
                    }

                    /* 카테고리 카드 이미지 래퍼 높이 안정화 */
                    .grid-item:not(.product) .image-wrapper {
                        border-radius: 8px;
                    }

                    /* 카테고리 텍스트도 살짝 축소 */
                    .grid-item:not(.product) .info h4 {
                        font-size: 18px;
                        margin-top: 2px;
                    }
                }

                .status-badge {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    padding: 6px 10px;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 14px;
                    background: rgba(0, 0, 0, .7);
                    color: #fff;
                    z-index: 2;
                }

                .product--soldout .status-badge {
                    background: #757575;
                }

                /* 회색 */
                .product--hidden .status-badge {
                    background: #b71c1c;
                }

                /* 레드 */

                .product--soldout .image-wrapper img,
                .product--hidden .image-wrapper img {
                    filter: grayscale(40%) brightness(0.85);
                }

                /* 상태일 때 가격/텍스트 톤다운 */
                .product--soldout .info .price,
                .product--hidden .info .price {
                    color: #8d8d8d;
                }

                /* 상태 카드에선 hover 줌 약화 */
                .product--soldout:hover .image-wrapper img,
                .product--hidden:hover .image-wrapper img {
                    transform: scale(1.01);
                }

                .sidebar-actions {
                    display: flex;
                    gap: 8px;
                    margin: 10px 0 18px;
                }

                .sidebar-actions .btn-side {
                    border: 1px solid #dcdcdc;
                    background: #fff;
                    color: #1a5d1a;
                    border-radius: 10px;
                    padding: 8px 10px;
                    font-size: 14px;
                    cursor: pointer;
                    transition: .2s;
                }

                .sidebar-actions .btn-side:hover {
                    background: #e8f5e9;
                    border-color: #a9d6ad;
                }

                .cat-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 10px;
                }

                .cat-row .chev {
                    font-size: 14px;
                    color: #6b7280;
                    transition: transform .2s;
                }

                .cat-row.open .chev {
                    transform: rotate(90deg);
                }

                .cat-all {
                    font-size: 15px;
                    padding: 8px 12px;
                    margin: 6px 0 8px;
                    border-radius: 8px;
                    background: #f7faf7;
                    color: #2e7d32;
                    border: 1px dashed #cfe6d2;
                }

                .cat-all:hover {
                    background: #e8f5e9;
                }

                /* ===== Product pagination (softer UI) ===== */
                .product-pagination {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 8px;
                    margin: 28px 0 10px;
                    flex-wrap: wrap;
                }

                .product-pagination .page-btn,
                .product-pagination .page-num {
                    border: 1px solid #e5e7eb;
                    background: #fff;
                    border-radius: 12px;
                    padding: 10px 12px;
                    font-size: 14px;
                    cursor: pointer;
                    transition: .2s;
                }

                .product-pagination .page-btn:hover,
                .product-pagination .page-num:hover {
                    background: #e8f5e9;
                    border-color: #a9d6ad;
                }

                .product-pagination .page-num.active {
                    background: #4caf50;
                    border-color: #4caf50;
                    color: #fff;
                    font-weight: 700;
                }

                .product-pagination .page-num.ellipsis {
                    cursor: default;
                    background: transparent;
                    border-color: transparent;
                }

                .product-pagination button:disabled {
                    opacity: .45;
                    cursor: not-allowed;
                }

                .product-toolbar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin: 10px 50px 0;
                    padding: 12px 14px;
                    background: #fff;
                    border: 1px solid #e6e6e6;
                    border-radius: 12px;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
                }

                .result-count {
                    font-size: 16px;
                    color: #2e7d32;
                    font-weight: 700;
                }

                .sort-select {
                    height: 40px;
                    padding: 0 12px;
                    border-radius: 10px;
                    border: 1px solid #d9d9d9;
                    font-size: 15px;
                    outline: none;
                    cursor: pointer;
                }

                .sort-select:focus {
                    border-color: #4caf50;
                    box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.15);
                }

                .quick-filter {
                    margin-top: 10px;
                }

                .quick-filter h3 {
                    color: #1a5d1a;
                    font-size: 22px;
                    margin-bottom: 12px;
                    font-weight: bold;
                }

                .qf-row {
                    position: relative;
                    display: flex;
                    align-items: center;
                    margin-bottom: 12px;
                }

                .qf-input {
                    width: 100%;
                    height: 42px;
                    padding: 0 40px 0 12px;
                    border: 1px solid #dfe7df;
                    border-radius: 10px;
                    outline: none;
                    font-size: 15px;
                    background: #fff;
                    transition: border-color .2s, box-shadow .2s;
                }

                .qf-input:focus {
                    border-color: #5dbb63;
                    box-shadow: 0 0 0 4px rgba(93, 187, 99, .15);
                }

                .qf-clear {
                    position: absolute;
                    right: 10px;
                    height: 28px;
                    width: 28px;
                    border: none;
                    border-radius: 50%;
                    background: #eef4ee;
                    cursor: pointer;
                    font-size: 14px;
                }

                .qf-toggle {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 10px 12px;
                    border-radius: 10px;
                    cursor: pointer;
                    user-select: none;
                    background: rgba(255, 255, 255, .6);
                    border: 1px solid #e8efe8;
                    margin-bottom: 10px;
                    transition: transform .12s, background .2s;
                }

                .qf-toggle:hover {
                    background: #f3fbf3;
                    transform: translateX(2px);
                }

                .qf-toggle input[type="checkbox"] {
                    width: 18px;
                    height: 18px;
                    accent-color: #4CAF50;
                }
            </style>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app" class="product-category-page" data-session-status="<c:out value='${sessionStatus}'/>">
                    <!-- 좌측 트리 -->
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h3>카테고리</h3>
                            <button class="btn-register" @click="goToProductRegister" v-cloak
                                v-if="isSeller">상품등록</button>
                        </div>

                        <div class="sidebar-actions">
                            <button class="btn-side" @click="showAllProducts">
                                <i class="fa-solid fa-list"></i> 전체상품
                            </button>
                            <button class="btn-side" @click="collapseCategories">
                                <i class="fa-solid fa-angles-up"></i> 접기
                            </button>
                        </div>

                        <ul>
                            <li v-for="p in parentCategories" :key="p.categoryNo">
                                <div class="cat-row" :class="{ open: String(selectedParent) === String(p.categoryNo) }"
                                    @click="toggleParent(p.categoryNo, true)">
                                    <span :class="{ active: String(selectedParent) === String(p.categoryNo) }">
                                        {{ p.categoryName }}
                                    </span>
                                    <i class="fa-solid fa-chevron-right chev"></i>
                                </div>

                                <ul v-if="String(selectedParent) === String(p.categoryNo)">
                                    <!-- ✅ 대분류 전체보기 -->
                                    <li class="cat-all" @click.stop="selectParentOnly(p.categoryNo)">
                                        전체 보기
                                    </li>

                                    <li v-for="m in getChildCategories(p.categoryNo)" :key="m.categoryNo">
                                        <div class="cat-row"
                                            :class="{ open: String(selectedChild) === String(m.categoryNo) }"
                                            @click.stop="toggleChild(m.categoryNo, true)">
                                            <span :class="{ active: String(selectedChild) === String(m.categoryNo) }">
                                                {{ m.categoryName }}
                                            </span>
                                            <i class="fa-solid fa-chevron-right chev"></i>
                                        </div>

                                        <ul v-if="String(selectedChild) === String(m.categoryNo)">
                                            <!-- ✅ 중분류 전체보기 -->
                                            <li class="cat-all" @click.stop="selectChildOnly(m.categoryNo)">
                                                전체 보기
                                            </li>

                                            <li v-for="s in getChildCategories(m.categoryNo)" :key="s.categoryNo"
                                                @click.stop="selectSub(s.categoryNo)"
                                                :class="{ active: String(selectedSub) === String(s.categoryNo) }">
                                                {{ s.categoryName }}
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>

                        <span v-if="viewLevel === 'product'">
                            <div class="sidebar-divider"></div>

                            <div class="quick-filter">
                                <h3>빠른 필터</h3>

                                <!-- 검색어 즉시 필터 -->
                                <div class="qf-row">
                                    <input type="text" v-model.trim="keyword" placeholder="상품명/설명/판매자 검색"
                                        class="qf-input" />
                                    <button v-if="keyword" class="qf-clear" @click="keyword=''">✕</button>
                                </div>

                                <!-- 토글들 -->
                                <label class="qf-toggle">
                                    <input type="checkbox" v-model="hideSoldout" />
                                    <span>품절 제외</span>
                                </label>

                                <label class="qf-toggle">
                                    <input type="checkbox" v-model="hideHidden" />
                                    <span>판매중지 제외</span>
                                </label>

                                <label class="qf-toggle">
                                    <input type="checkbox" v-model="onlyRating4" />
                                    <span>별점 4.0 이상만</span>
                                </label>
                            </div>

                            <div class="price-filter">
                                <h3>가격</h3>
                                <ul>
                                    <li v-for="(range, index) in priceRanges" :key="index"
                                        :class="{ active: selectedPriceRange === index }"
                                        @click="selectedPriceRange = index">
                                        {{ range.label }}
                                    </li>
                                </ul>
                                <div class="custom-price-range">
                                    <input class="custom-price-range-left" type="number" v-model.number="customMinPrice"
                                        placeholder="최소가격" />
                                    ~
                                    <input class="custom-price-range-right" type="number"
                                        v-model.number="customMaxPrice" placeholder="최대가격" />
                                    <span>(원)</span>
                                    <button @click="applyCustomPrice">검색</button>
                                    <button v-if="selectedPriceRange === 'custom'"
                                        @click="resetCustomPrice">초기화</button>
                                </div>
                            </div>
                        </span>


                        <div class="sidebar-divider"></div>

                        <div class="region-filter">
                            <h3>전국 아그리콜라들의 상품</h3>

                            <button @click="clearRegion" class="clear-region">
                                모든 상품 보기
                            </button>

                            <ul>
                                <li v-for="region in pagedRegions" :key="region.region"
                                    :class="{ active: selectedRegion === region.region }"
                                    @click="selectRegion(region.region)">
                                    {{ region.region }}
                                    <span class="count">({{region.productCount}})</span>
                                </li>
                            </ul>

                            <div class="pagination">
                                <button @click="prevRegionPage" :disabled="currentRegionPage === 1">이전</button>
                                <span>{{currentRegionPage}} / {{totalRegionPages}}</span>
                                <button @click="nextRegionPage"
                                    :disabled="currentRegionPage === totalRegionPages">다음</button>
                            </div>

                        </div>

                    </div>

                    <div class="division-bar"></div>

                    <!-- 우측 콘텐츠 -->
                    <div class="content">
                        <!-- Breadcrumb -->
                        <div class="breadcrumb">
                            <a href="main.do" class="home">홈<span class="breadcrumb-sep">></span></a>
                            <a href="productCategory.do#v=product" class="home">상품목록
                                <span class="breadcrumb-sep" v-if="breadcrumb.length > 0">></span>
                            </a>
                            <span v-for="(b, i) in breadcrumb" :key="i" @click="goToLevel(i)">
                                {{ b }}
                                <span v-if="i < breadcrumb.length - 1" class="breadcrumb-sep">></span>
                            </span>
                        </div>

                        <div class="topbar-divider"></div>

                        <!-- 대분류 -->
                        <div v-if="viewLevel === 'parent'">
                            <div class="grid">
                                <div class="grid-item" v-for="p in parentCategories" :key="p.categoryNo"
                                    @click="toggleParent(p.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="p.imageUrl || '/resources/img/category/noimage.png'" alt="대분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ p.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 중분류 -->
                        <div v-else-if="viewLevel === 'child'">
                            <div class="grid">
                                <div class="grid-item" v-for="m in getChildCategories(selectedParent)"
                                    :key="m.categoryNo" @click="toggleChild(m.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="m.imageUrl || '/resources/img/category/noimage.png'" alt="중분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ m.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 소분류 -->
                        <div v-else-if="viewLevel === 'sub'">
                            <div class="grid">
                                <div class="grid-item" v-for="s in getChildCategories(selectedChild)"
                                    :key="s.categoryNo" @click="selectSub(s.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="s.imageUrl || '/resources/img/category/noimage.png'" alt="소분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ s.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 상품 -->
                        <div v-else-if="viewLevel === 'product'">
                            <!-- ✅ 상품 정렬 바 -->
                            <div class="product-toolbar">
                                <div class="toolbar-left">
                                    <span class="result-count">총 {{ sortedProducts.length }}개</span>
                                </div>

                                <div class="toolbar-right">
                                    <select v-model="sortKey" class="sort-select">
                                        <option value="latest">최신순</option>
                                        <option value="ratingDesc">별점 높은순</option>
                                        <option value="nameAsc">가나다순</option>
                                        <option value="priceAsc">가격 낮은순</option>
                                        <option value="priceDesc">가격 높은순</option>
                                    </select>
                                </div>
                            </div>

                            <div class="grid">
                                <div class="grid-item product" v-for="p in pagedProducts" :key="p.productNo"
                                    :class="statusClass(p)" @click="onProductClick(p)">
                                    <div class="image-wrapper">
                                        <span v-if="statusLabel(p)" class="status-badge">{{ statusLabel(p) }}</span>
                                        <img :src="p.filePath || '/resources/img/category/noimage.jpg'"
                                            :alt="altText(p)">
                                    </div>
                                    <div class="info">
                                        <h4>{{ p.pName }}</h4>
                                        <div class="desc">{{ p.pInfo }}</div>

                                        <div class="meta-bottom">
                                            <div class="price">{{ Number(p.price).toLocaleString() }}원</div>

                                            <div class="review">
                                                <span v-for="i in 5" :key="i">
                                                    <i v-if="Number(p.rating) >= i" class="fas fa-star full-star"></i>
                                                    <i v-else-if="Number(p.rating) >= i - 0.5"
                                                        class="fas fa-star-half-alt half-star"></i>
                                                    <i v-else class="far fa-star empty-star"></i>
                                                </span>
                                                <span class="rating-number">
                                                    ({{ p.rating ? Number(p.rating).toFixed(1) : '0.0' }})
                                                </span>
                                            </div>

                                            <div class="date">📅생산일: {{ p.cdate }}</div>
                                            <div class="region">🌾원산지: {{ p.origin }}</div>
                                            <div class="seller">👨‍🌾판매자: {{p.businessName}}({{ p.userName }})
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="filteredProducts.length === 0"
                                style="font-size: 50px; text-align: left; color: #2e7d32; padding-top: 30px;">
                                등록된 상품이 없습니다. 곧 다시 뵙겠습니다.
                            </div>
                            <div v-if="filteredProducts.length > 0" class="product-pagination">
                                <button class="page-btn" @click="prevProductPage"
                                    :disabled="currentProductPage === 1">이전</button>

                                <button v-for="(p, idx) in pageWindow" :key="p + '-' + idx" class="page-num"
                                    :class="{ active: p === currentProductPage, ellipsis: p === '...' }"
                                    :disabled="p === '...'" @click="p !== '...' && goProductPage(p)">
                                    {{ p }}
                                </button>

                                <button class="page-btn" @click="nextProductPage"
                                    :disabled="currentProductPage === totalProductPages">다음</button>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </body>

        </html>



        <script>
            const SERVER_CATEGORY_NO = '<c:out value="${categoryNo}" default="" />';
            const app = Vue.createApp({
                data() {
                    return {
                        categoryList: [],
                        productList: [],
                        selectedParent: null,
                        selectedChild: null,
                        selectedSub: null,
                        viewLevel: 'product',
                        initialCategoryNo: '${categoryNo}',

                        priceRanges: [
                            { label: '가격전체', min: 0, max: Infinity },
                            { label: '5,000원 미만', min: 0, max: 5000 },
                            { label: '5,000원 ~ 10,000원', min: 5000, max: 10000 },
                            { label: '10,000원 ~ 20,000원', min: 10000, max: 20000 },
                            { label: '20,000원 ~ 30,000원', min: 20000, max: 30000 },
                            { label: '30,000원 이상', min: 30000, max: Infinity }
                        ],
                        selectedPriceRange: 0,
                        customMinPrice: null,
                        customMaxPrice: null,

                        regionList: [],
                        selectedRegion: null,
                        currentRegionPage: 1,
                        regionsPerPage: 10,
                        sessionStatus: '',
                        currentProductPage: 1,
                        productsPerPage: 12,
                        sortKey: "latest",
                        keyword: '',
                        hideSoldout: false,
                        hideHidden: false,
                        onlyRating4: false,
                    };
                },

                computed: {
                    parentCategories() {
                        return this.categoryList.filter(c => c.parentCategoryNo === '');
                    },

                    pagedRegions() {
                        const start = (this.currentRegionPage - 1) * this.regionsPerPage;
                        return this.regionList.slice(start, start + this.regionsPerPage);
                    },

                    totalRegionPages() {
                        return Math.ceil(this.regionList.length / this.regionsPerPage);
                    },

                    filteredProducts() {
                        let result = this.productList || [];

                        // 카테고리 필터
                        if (this.selectedSub) {
                            result = result.filter(p => String(p.categoryNo) === String(this.selectedSub));
                        } else if (this.selectedChild) {
                            const cats = this.getDescendants(this.selectedChild);
                            result = result.filter(p => cats.includes(String(p.categoryNo)));
                        } else if (this.selectedParent) {
                            const cats = this.getDescendants(this.selectedParent);
                            result = result.filter(p => cats.includes(String(p.categoryNo)));
                        }

                        // 가격 필터
                        if (this.selectedPriceRange === 'custom') {
                            const min = this.customMinPrice || 0;
                            const max = this.customMaxPrice || Infinity;
                            result = result.filter(p => {
                                const price = Number(p.price);
                                if (isNaN(price)) return false;
                                return price >= min && price <= max;
                            });
                        } else if (this.selectedPriceRange !== null && this.selectedPriceRange !== undefined) {
                            const range = this.priceRanges[this.selectedPriceRange];
                            result = result.filter((p) => {
                                const price = Number(p.price);
                                if (isNaN(price)) return false;
                                return price >= range.min && price < range.max;
                            });
                        }

                        // 지역 필터
                        if (this.selectedRegion && typeof this.selectedRegion === 'string' && this.selectedRegion.trim() !== '') {
                            result = result.filter((p) => (p.region || '').includes(this.selectedRegion));
                        }

                        // ✅ 상태 토글 (품절/판매중지 제외)
                        if (this.hideSoldout) {
                            result = result.filter(p => String(p.productStatus || '').toUpperCase() !== 'SOLDOUT');
                        }
                        if (this.hideHidden) {
                            result = result.filter(p => String(p.productStatus || '').toUpperCase() !== 'HIDDEN');
                        }

                        // ✅ 별점 4.0 이상만
                        if (this.onlyRating4) {
                            result = result.filter(p => Number(p.rating || 0) >= 4.0);
                        }

                        // ✅ 검색어 즉시 필터 (상품명/설명/판매자/원산지 등)
                        const kw = (this.keyword || '').trim().toLowerCase();
                        if (kw) {
                            result = result.filter(p => {
                                const hay = [
                                    p.pName, p.pInfo, p.businessName, p.userName, p.origin, p.region
                                ].map(v => String(v || '').toLowerCase()).join(' ');
                                return hay.includes(kw);
                            });
                        }

                        return result;
                    },

                    breadcrumb() {
                        const r = [];
                        if (this.selectedParent) r.push(this.getCategoryName(this.selectedParent));
                        if (this.selectedChild) r.push(this.getCategoryName(this.selectedChild));
                        if (this.selectedSub) r.push(this.getCategoryName(this.selectedSub));
                        return r;
                    },

                    isSeller() {
                        return (this.sessionStatus || '').toUpperCase() === 'SELLER';
                    },

                    totalProductPages() {
                        const n = Math.ceil((this.sortedProducts?.length || 0) / this.productsPerPage);
                        return Math.max(1, n);
                    },

                    pagedProducts() {
                        const start = (this.currentProductPage - 1) * this.productsPerPage;
                        return (this.sortedProducts || []).slice(start, start + this.productsPerPage);
                    },

                    childrenMap() {
                        const map = {};
                        (this.categoryList || []).forEach(c => {
                            const p = String(c.parentCategoryNo ?? '');
                            const id = String(c.categoryNo ?? '');
                            if (!map[p]) map[p] = [];
                            map[p].push(id);
                        });
                        return map;
                    },

                    pageWindow() {
                        const total = this.totalProductPages;
                        const cur = this.currentProductPage;

                        if (total <= 7) {
                            return Array.from({ length: total }, (_, i) => i + 1);
                        }

                        const out = [];
                        const push = (v) => out.push(v);

                        push(1);

                        let start = Math.max(2, cur - 2);
                        let end = Math.min(total - 1, cur + 2);

                        if (start > 2) push('...');

                        for (let i = start; i <= end; i++) push(i);

                        if (end < total - 1) push('...');

                        push(total);
                        return out;
                    },

                    sortedProducts() {
                        const list = [...(this.filteredProducts || [])];

                        const toNum = (v) => {
                            const n = Number(v);
                            return isNaN(n) ? 0 : n;
                        };

                        // ✅ 최신순 기준: 1) regDate/udatetime 같은 게 있으면 그걸로, 2) 없으면 productNo DESC로
                        const getLatestValue = (p) => {
                            // 있으면 이 키들 중 하나로 정렬 (프로젝트에 맞는 키로 하나만 써도 됨)
                            const d = p.cdatetimeRaw;
                            if (d) return new Date(p.cdatetimeRaw).getTime() || 0;
                            return toNum(p.productNo); // fallback
                        };

                        switch (this.sortKey) {
                            case 'ratingDesc':
                                list.sort((a, b) => toNum(b.rating) - toNum(a.rating));
                                break;

                            case 'nameAsc':
                                list.sort((a, b) => String(a.pName || '').localeCompare(String(b.pName || ''), 'ko'));
                                break;

                            case 'priceAsc':
                                list.sort((a, b) => toNum(a.price) - toNum(b.price));
                                break;

                            case 'priceDesc':
                                list.sort((a, b) => toNum(b.price) - toNum(a.price));
                                break;

                            case 'latest':
                            default:
                                list.sort((a, b) => getLatestValue(b) - getLatestValue(a));
                                break;
                        }

                        return list;
                    },

                },

                watch: {
                    selectedRegion(newVal, oldVal) {
                        if (!newVal || newVal === oldVal) return;
                    },
                    selectedParent() { this.currentProductPage = 1; },
                    selectedChild() { this.currentProductPage = 1; },
                    selectedSub() { this.currentProductPage = 1; },
                    selectedRegion() { this.currentProductPage = 1; },
                    selectedPriceRange() { this.currentProductPage = 1; },
                    customMinPrice() { this.currentProductPage = 1; },
                    customMaxPrice() { this.currentProductPage = 1; },
                    sortKey() { this.currentProductPage = 1; },
                    keyword() { this.currentProductPage = 1; },
                    hideSoldout() { this.currentProductPage = 1; },
                    hideHidden() { this.currentProductPage = 1; },
                    onlyRating4() { this.currentProductPage = 1; },
                },

                methods: {
                    normalize(c) {
                        return {
                            categoryNo: String(c.categoryNo),
                            parentCategoryNo:
                                (c.parentCategoryNo == null ||
                                    String(c.parentCategoryNo).trim() === '' ||
                                    String(c.parentCategoryNo) === '0')
                                    ? ''
                                    : String(c.parentCategoryNo),
                            categoryName: c.categoryName || '',
                            imageUrl: c.imageUrl || ''
                        };
                    },

                    clearRegion() {
                        this.selectedRegion = null;
                        this.viewLevel = 'product';
                    },

                    selectRegion(regionName) {
                        const reg = regionName ? String(regionName).trim() : '';
                        this.selectedRegion = reg;

                        if (this.viewLevel !== 'product') {
                            this.viewLevel = 'product';
                        }

                        this.writeHash(true);

                        this.$nextTick(() => {
                        });

                        const q = new URLSearchParams();
                        if (this.selectedParent) q.set('p', this.selectedParent);
                        if (this.selectedChild) q.set('c', this.selectedChild);
                        if (this.selectedSub) q.set('s', this.selectedSub);
                        q.set('v', 'product');
                        if (reg) q.set('r', reg);

                        location.href = location.pathname + '#' + q.toString();
                    },

                    fnList() {
                        $.ajax({
                            url: "/categoryProductList.dox",
                            dataType: "json",
                            type: "POST",
                            success: (data) => {
                                this.categoryList = (data.categories || []).map(this.normalize);

                                this.productList = (data.list || []).map(p => {
                                    const status = String(
                                        p.productStatus ?? p.PRODUCT_STATUS ?? p.product_status ?? ""
                                    ).trim().toUpperCase();

                                    return {
                                        ...p,
                                        // 안전한 키 정규화
                                        categoryNo: String(p.categoryNo ?? p.CATEGORY_NO ?? p.category_no ?? ""),
                                        productStatus: status,
                                        filePath: p.filePath ?? p.FILE_PATH ?? p.thumbnailPath ?? p.THUMBNAIL_PATH ?? ""
                                    };
                                });

                                // 해시 우선 복원
                                if (this.applyFromHash()) return;

                                // 초기 카테고리 진입
                                this.applyInitialCategory();
                                this.writeHash(false);
                                this.fnSellerRegionList();
                            }
                        });
                    },

                    fnSellerRegionList() {
                        $.ajax({
                            url: "/sellerRegions.dox",
                            dataType: "json",
                            type: "POST",
                            data: { page: this.page, pageSize: this.pageSize },
                            success: (data) => {
                                this.regionList = data.list || [];
                                this.totalRegions = data.totalCount || 0;
                                this.currentRegionPage = data.page || 1;
                            },
                            error: (xhr, status, error) => {
                                console.error("지역목록 불러오기 실패: ", error);
                            }
                        });
                    },

                    nextRegionPage() {
                        if (this.currentRegionPage < this.totalRegionPages) {
                            this.currentRegionPage++;
                        }
                    },
                    prevRegionPage() {
                        if (this.currentRegionPage > 1) {
                            this.currentRegionPage--;
                        }
                    },

                    // ✅ region(r) 포함되도록 수정
                    writeHash(push = true) {
                        const q = new URLSearchParams();

                        if (this.selectedParent) q.set('p', this.selectedParent);
                        if (this.selectedChild) q.set('c', this.selectedChild);
                        if (this.selectedSub) q.set('s', this.selectedSub);
                        q.set('v', this.viewLevel);

                        // ✅ 지역도 해시에 반영
                        if (this.selectedRegion && this.selectedRegion.trim() !== '') {
                            q.set('r', encodeURIComponent(this.selectedRegion.trim()));
                        }

                        const newHash = '#' + q.toString();

                        if (location.hash !== newHash) {
                            if (push) {
                                history.pushState(null, '', location.pathname + newHash);
                            } else {
                                history.replaceState(null, '', location.pathname + newHash);
                            }
                        }
                    },

                    // ✅ region 복원 추가
                    applyFromHash() {
                        const raw = (location.hash || '').replace(/^#/, '');
                        if (!raw) return false;

                        const qs = new URLSearchParams(raw);
                        const p = qs.get('p') || '';
                        const c = qs.get('c') || '';
                        const s = qs.get('s') || '';
                        const v = qs.get('v') || 'product';
                        const r = qs.get('r') ? decodeURIComponent(qs.get('r')) : ''; // ✅ 지역 복원

                        const has = (no) => this.categoryList.some(x => x.categoryNo === String(no));
                        const okP = p && has(p);
                        const okC = c && has(c);
                        const okS = s && has(s);

                        this.selectedParent = okP ? String(p) : '';
                        this.selectedChild = okP && okC ? String(c) : '';
                        this.selectedSub = okP && okC && okS ? String(s) : '';

                        // ✅ 지역 필터 복원
                        if (r && typeof r === 'string') {
                            this.selectedRegion = r;
                        }

                        // ✅ viewLevel 설정 로직 개선
                        // ✅ viewLevel 설정 로직 (수정)
                        if (v === 'product') {
                            // p만 있어도, p+c만 있어도 "상품 화면"이 기본
                            this.viewLevel = 'product';
                        } else if (okP && okC && v === 'sub') {
                            this.viewLevel = 'sub';
                        } else if (okP && v === 'child') {
                            this.viewLevel = 'child';
                        } else {
                            this.viewLevel = 'parent';
                        }

                        // ✅ 지역만 설정되어 있고 카테고리 선택 안 되어 있으면 상품목록으로 강제 전환
                        if (r && !okS) {
                            this.viewLevel = 'product';
                        }

                        return true;
                    },

                    getChildCategories(parentNo) {
                        const pid = String(parentNo || '');
                        return this.categoryList.filter(c => c.parentCategoryNo === pid);
                    },
                    getCategoryName(no) {
                        const cat = this.categoryList.find(c => c.categoryNo === String(no));
                        return cat ? cat.categoryName : '';
                    },

                    toggleParent(no, fromSidebar = false) {
                        const id = String(no);

                        if (this.selectedParent === id) {
                            this.selectedParent = '';
                            this.selectedChild = '';
                            this.selectedSub = '';
                        } else {
                            this.selectedParent = id;
                            this.selectedChild = '';
                            this.selectedSub = '';
                        }

                        // ✅ 사이드바 클릭이면 항상 상품 화면
                        this.viewLevel = fromSidebar ? 'product' : 'child';
                        this.writeHash(true);
                    },

                    toggleChild(no, fromSidebar = false) {
                        const id = String(no);

                        if (this.selectedChild === id) {
                            this.selectedChild = '';
                            this.selectedSub = '';
                        } else {
                            this.selectedChild = id;
                            this.selectedSub = '';
                        }

                        // ✅ 사이드바 클릭이면 항상 상품 화면
                        this.viewLevel = fromSidebar ? 'product' : 'sub';
                        this.writeHash(true);
                    },
                    selectSub(no) {
                        this.selectedSub = String(no);
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },
                    goToLevel(index) {
                        if (index === 0) { this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child'; }
                        else if (index === 1) { this.selectedSub = ''; this.viewLevel = 'sub'; }
                        this.writeHash(true);
                    },

                    fnView(productNo) {
                        pageChange("/productInfo.do", { productNo });
                    },

                    applyInitialCategory() {
                        const no = this.initialCategoryNo ? String(this.initialCategoryNo) : '';

                        if (!no) {
                            this.selectedParent = '';
                            this.selectedChild = '';
                            this.selectedSub = '';
                            this.viewLevel = 'product';
                            if (this.selectedPriceRange == null) this.selectPriceRange = 0;
                            return;
                        }

                        const target = this.categoryList.find(c => c.categoryNo === no);
                        if (!target) { this.selectedParent = ''; this.viewLevel = 'parent'; return; }

                        if (target.parentCategoryNo === '') {
                            this.selectedParent = target.categoryNo;
                            this.viewLevel = 'child';
                        } else {
                            const parent = this.categoryList.find(c => c.categoryNo === target.parentCategoryNo);
                            if (parent && parent.parentCategoryNo === '') {
                                this.selectedParent = parent.categoryNo;
                                this.selectedChild = target.categoryNo;
                                this.viewLevel = 'sub';
                            } else if (parent && parent.parentCategoryNo !== '') {
                                const top = this.categoryList.find(c => c.categoryNo === parent.parentCategoryNo);
                                this.selectedParent = top ? top.categoryNo : '';
                                this.selectedChild = parent.categoryNo;
                                this.selectedSub = target.categoryNo;
                                this.viewLevel = 'product';
                            }
                        }
                    },

                    readCategoryNoFromURL() {
                        const qs = new URLSearchParams(location.search);
                        const v = qs.get('categoryNo');
                        if (v) return String(v);
                        const segs = location.pathname.split('/').filter(Boolean);
                        const last = segs[segs.length - 1];
                        if (last && /^\d+$/.test(last)) return String(last);
                        return '';
                    },

                    goToProductRegister() {
                        window.location.href = '/product/add.do';
                    },

                    // 가격범위 입력
                    selectPriceRange(index) {
                        this.selectedPriceRange = index;
                        this.customMinPrice = null;
                        this.customMaxPrice = null;
                    },

                    applyCustomPrice() {
                        if (this.customMinPrice == null && this.customMaxPrice == null) return;
                        this.selectedPriceRange = 'custom';
                    },

                    resetCustomPrice() {
                        this.customMinPrice = null;
                        this.customMaxPrice = null;
                        this.selectedPriceRange = null;
                    },

                    getStatus(p) {
                        return String(p.productStatus || "").trim().toUpperCase();
                    },
                    statusLabel(p) {
                        const s = this.getStatus(p);
                        if (s === 'SOLDOUT') return '품절';
                        if (s === 'HIDDEN') return '판매 중지';
                        return '';
                    },
                    statusClass(p) {
                        const s = this.getStatus(p);
                        return {
                            'product--soldout': s === 'SOLDOUT',
                            'product--hidden': s === 'HIDDEN'
                        };
                    },
                    onProductClick(p) {
                        const s = this.getStatus(p);
                        if (s === 'HIDDEN') {
                            alert('판매 중지된 상품입니다.');
                            return;
                        }
                        location.href = "/productInfo.do?productNo=" + p.productNo;
                    },
                    altText(p) {
                        const s = this.getStatus(p);
                        if (s === 'SOLDOUT') return '품절된 상품 이미지';
                        if (s === 'HIDDEN') return '판매 중지된 상품 이미지';
                        return '상품 이미지';
                    },

                    nextProductPage() {
                        if (this.currentProductPage < this.totalProductPages) {
                            this.currentProductPage++;
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }
                    },
                    prevProductPage() {
                        if (this.currentProductPage > 1) {
                            this.currentProductPage--;
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }
                    },
                    goProductPage(p) {
                        this.currentProductPage = p;
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    },

                    getDescendants(rootNo) {
                        const root = String(rootNo || '');
                        if (!root) return [];
                        const out = new Set([root]);
                        const stack = [root];
                        while (stack.length) {
                            const cur = stack.pop();
                            const kids = this.childrenMap[cur] || [];
                            kids.forEach(k => {
                                if (!out.has(k)) { out.add(k); stack.push(k); }
                            });
                        }
                        return Array.from(out);
                    },

                    showAllProducts() {
                        this.selectedParent = '';
                        this.selectedChild = '';
                        this.selectedSub = '';
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },

                    collapseCategories() {
                        this.selectedParent = '';
                        this.selectedChild = '';
                        this.selectedSub = '';
                        // 상품은 그대로 보고, 카테고리만 접는 UX
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },

                    selectParentOnly(parentNo) {
                        this.selectedParent = String(parentNo);
                        this.selectedChild = '';
                        this.selectedSub = '';
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },

                    selectChildOnly(childNo) {
                        this.selectedChild = String(childNo);
                        this.selectedSub = '';
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },

                },

                mounted() {
                    if (!this.initialCategoryNo) {
                        this.initialCategoryNo = this.readCategoryNoFromURL();
                    }

                    const root = document.getElementById('app');
                    // 1차: 현재 페이지의 data-session-status
                    let role = root?.dataset?.sessionStatus || '';
                    // 2차 보조: 헤더의 마이페이지 버튼에 data-status가 박혀있다면 활용
                    if (!role) {
                        role = document.querySelector('#btnMyPage')?.dataset?.status || '';
                    }
                    this.sessionStatus = role;


                    window.addEventListener('hashchange', () => this.applyFromHash());
                    this.fnList();
                    this.fnSellerRegionList();
                }
            });
            app.mount("#app");
        </script>