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
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
            <style>
                html,
                body {
                    height: 100%;
                    margin: 0;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                }

                .main-banner {
    background-color: #f7fcf7; /* 배경색: 매우 연한 녹색 */
    padding: 60px 20px 0; /* 상하 패딩 (하단 아이콘 영역이 겹치므로 하단 패딩은 적게) */
    text-align: center;
    display: flex; /* 아이콘 영역을 아래에 배치하기 위해 flex 사용 */
    flex-direction: column;
    align-items: center;
}

.banner-text-area {
    margin-bottom: 80px; /* 텍스트와 아이콘 영역 사이의 간격 */
}

.main-banner h1 {
    font-size: 2.5em; /* 글자 크기 조정 */
    font-weight: bold;
    color: #333;
    margin-bottom: 10px;
}

.main-banner p {
    font-size: 1.1em;
    color: #666;
    margin-bottom: 30px;
}

.banner-buttons .primary-btn {
    background-color: #5cb85c; /* Primary 버튼: 녹색 계열 */
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    margin-right: 10px;
}

.banner-buttons .secondary-btn {
    background-color: white; /* Secondary 버튼: 흰색 배경 */
    color: #333;
    border: 1px solid #ccc;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
}


/* -------------------------------------- */
/* 🟣 3가지 핵심 가치 아이콘 섹션 스타일 */
/* -------------------------------------- */
.value-propositions {
    display: flex;
    justify-content: center;
    gap: 40px; /* 아이템 간격 */
    width: 100%;
    max-width: 1000px; /* 최대 너비 설정 */
    transform: translateY(50%); /* 텍스트 영역에 절반 정도 걸치도록 위로 이동 */
    background-color: white; /* 아이콘 영역 배경을 흰색으로 설정 */
    padding: 20px 0;
}

.value-item {
    text-align: center;
    width: calc(33.33% - 40px);
}

.value-item h4 {
    margin-top: 10px;
    margin-bottom: 5px;
    font-size: 1.1em;
    font-weight: bold;
}

.value-item p {
    font-size: 0.9em;
    color: #999;
}

.icon-circle {
    width: 60px;
    height: 60px;
    border: 1px solid #ddd;
    border-radius: 50%; /* 원형 */
    background-color: #fff; /* 아이콘 배경색 */
    margin: 0 auto 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* -------------------------------------- */
/* 🟢 상품 리스트 섹션 스타일 */
/* -------------------------------------- */
.best-products {
    padding: 100px 20px 50px; /* 상단 패딩은 아이콘이 내려온 만큼 확보 */
    text-align: center;
}

.best-products h2 {
    font-size: 2em;
    font-weight: bold;
    margin-bottom: 40px;
    color: #333;
}

.product-grid {
    display: grid;
    /* 4개의 상품을 배치 */
    grid-template-columns: repeat(4, 1fr); 
    gap: 20px;
    max-width: 1200px; /* 그리드의 최대 너비 */
    margin: 0 auto;
}

.product-card {
    border: 1px solid #eee;
    padding: 10px;
    border-radius: 5px;
    text-align: left;
    transition: box-shadow 0.3s;
}

.product-card:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.product-image-placeholder {
    /* 이미지 대신 연한 회색 박스 사용 */
    background-color: #e0e0e0; 
    height: 200px; /* 이미지 높이 */
    width: 100%;
    margin-bottom: 10px;
    border-radius: 3px;
}

.product-info .category {
    font-size: 0.8em;
    color: #888;
    display: block;
    margin-bottom: 5px;
}

.product-info .name {
    font-weight: bold;
    font-size: 1em;
    margin-bottom: 5px;
}

.product-info .price {
    color: #5cb85c; /* 가격 강조 색상 */
    font-size: 1.1em;
    font-weight: bold;
}

/* -------------------------------------- */
/* 🖥️ 반응형 디자인 (선택 사항) */
/* -------------------------------------- */
@media (max-width: 992px) {
    .product-grid {
        /* 화면이 작아지면 2열로 변경 */
        grid-template-columns: repeat(2, 1fr);
    }

    .value-propositions {
        /* 아이콘 영역도 래핑되도록 변경 */
        flex-wrap: wrap; 
        gap: 20px;
    }

    .value-item {
        /* 아이콘 아이템 너비를 조정 */
        width: calc(50% - 20px); 
    }
}

@media (max-width: 576px) {
    .product-grid {
        /* 모바일에서는 1열로 변경 */
        grid-template-columns: 1fr;
    }
}
            </style>
        </head>

        <body>
            <div id="app">
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                                <main class="content">
                    <section class="main-banner">
                        <div class="banner-text-area">
                            <h1>신선함의 기준</h1>
                            <p>농장에서 바로 배송되는 프리미엄 농수산물</p>
                            <div class="banner-buttons">
                                <button class="primary-btn">쇼핑 시작하기</button>
                                <button class="secondary-btn">내 판매글 보기</button>
                            </div>
                        </div>
                        
                        <div class="value-propositions">
                            <div class="value-item">
                                <div class="icon-circle"></div> <h4>당일 배송</h4>
                                <p>오전 주문시 당일 배송</p>
                            </div>
                            <div class="value-item">
                                <div class="icon-circle"></div>
                                <h4>신선 포장</h4>
                                <p>100% 친환경 포장</p>
                            </div>
                            <div class="value-item">
                                <div class="icon-circle"></div>
                                <h4>직거래</h4>
                                <p>생산자 직거래 시스템</p>
                            </div>
                        </div>
                    </section>

                    <section class="best-products">
                        <h2>이번 주 베스트</h2>
                        <div class="product-grid">
                            <div class="product-card">
                                <div class="product-image-placeholder"></div>
                                <div class="product-info">
                                    <span class="category">생산자 직거래</span>
                                    <p class="name">프리미엄 상품 1</p>
                                    <p class="price">25,000원</p>
                                </div>
                            </div>
                            <div class="product-card">
                                <div class="product-image-placeholder"></div>
                                <div class="product-info">
                                    <span class="category">생산자 직거래</span>
                                    <p class="name">프리미엄 상품 2</p>
                                    <p class="price">25,000원</p>
                                </div>
                            </div>
                            <div class="product-card">
                                <div class="product-image-placeholder"></div>
                                <div class="product-info">
                                    <span class="category">생산자 직거래</span>
                                    <p class="name">프리미엄 상품 3</p>
                                    <p class="price">25,000원</p>
                                </div>
                            </div>
                            <div class="product-card">
                                <div class="product-image-placeholder"></div>
                                <div class="product-info">
                                    <span class="category">생산자 직거래</span>
                                    <p class="name">프리미엄 상품 4</p>
                                    <p class="price">25,000원</p>
                                </div>
                            </div>
                            
                        </div>
                    </section>
                </main>
                <!-- 공통 푸터 -->
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
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