<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGRICOLA - Main page 아아아아 테스트 123 </title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            color: #333;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            flex: 1;
        }
        
        /* 메인 콘텐츠 스타일링 시작 */
        .fresh-section {
            background-color: #f7fff7; /* 이미지 상단 연한 녹색 배경 */
            padding: 80px 20px;
            text-align: center;
        }

        .fresh-section h2 {
            font-size: 2em;
            font-weight: bold;
            color: #2e8b57;
            margin-bottom: 10px;
        }

        .fresh-section p {
            font-size: 1.1em;
            color: #555;
            margin-bottom: 30px;
        }

        .action-buttons button {
            padding: 10px 20px;
            margin: 0 5px;
            border: 1px solid #2e8b57;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        .action-buttons .btn-primary {
            background-color: #388e3c; /* 짙은 녹색 */
            color: white;
            font-weight: bold;
        }

        .action-buttons .btn-secondary {
            background-color: white;
            color: #388e3c;
        }

        /* 혜택 아이콘 섹션 */
        .benefits-section {
            display: flex;
            justify-content: center;
            padding: 50px 20px;
            gap: 80px;
            border-bottom: 1px solid #eee;
        }

        .benefit-item {
            text-align: center;
        }

        .benefit-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #eee;
            margin: 0 auto 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .benefit-item p {
            font-size: 0.9em;
            color: #777;
            margin: 5px 0 0;
        }
        
        .benefit-item strong {
            display: block;
            font-size: 1.1em;
            color: #333;
            margin-top: 5px;
        }

        /* 베스트 상품 섹션 */
        .best-product-section {
            padding: 50px 20px;
            text-align: center;
        }

        .best-product-section h3 {
            font-size: 1.8em;
            margin-bottom: 40px;
            font-weight: normal;
        }

        .product-list {
            display: flex;
            justify-content: center;
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .product-card {
            width: 250px;
            border: 1px solid #ddd;
            padding: 15px;
            text-align: left;
        }

        .product-image-placeholder {
            width: 100%;
            height: 200px;
            background-color: #f0f0f0;
            margin-bottom: 15px;
        }

        .product-category {
            font-size: 0.85em;
            color: #999;
            margin-bottom: 5px;
        }

        .product-name {
            font-size: 1.1em;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .product-price {
            font-size: 1.2em;
            color: #388e3c;
            font-weight: bold;
        }
        /* 메인 콘텐츠 스타일링 끝 */
    </style>
</head>

<body>
    <div id="app">
        <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <main class="content">
            <section class="fresh-section">
                <h2>신선함의 기준</h2>
                <p>농장에서 바로 배송되는 프리미엄 농수산물</p>
                <div class="action-buttons">
                    <button class="btn-primary" onclick="location.href='product/list'">쇼핑 시작하기</button>
                    <button class="btn-secondary" onclick="location.href='#'">더 알아보기</button>
                </div>
            </section>
            
            <section class="benefits-section">
                <div class="benefit-item">
                    <div class="benefit-icon"></div>
                    <strong>당일 배송</strong>
                    <p>오전 주문 시 당일 배송</p>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon"></div>
                    <strong>신선 보장</strong>
                    <p>100% 신선도 보장</p>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon"></div>
                    <strong>직거래</strong>
                    <p>생산자 직거래 시스템</p>
                </div>
            </section>

            <section class="best-product-section">
                <h3>이번 주 베스트</h3>
                <div class="product-list">
                    <div class="product-card" v-for="item in bestProducts" :key="item.id" @click="fnGoProductDetail(item.id)" style="cursor:pointer;">
                        <div class="product-image-placeholder"></div>
                        <p class="product-category">{{ item.category }}</p>
                        <p class="product-name">{{ item.name }}</p>
                        <p class="product-price">{{ item.price.toLocaleString() }}원</p>
                    </div>
                </div>
            </section>

        </main>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 이미지에 보이는 베스트 상품 데이터 (임시 데이터)
                bestProducts: [
                    { id: 1, category: "생산자명", name: "프리미엄 상품 1", price: 25000 },
                    { id: 2, category: "생산자명", name: "프리미엄 상품 2", price: 25000 },
                    { id: 3, category: "생산자명", name: "프리미엄 상품 3", price: 25000 },
                    { id: 4, category: "생산자명", name: "프리미엄 상품 4", price: 25000 },
                ],
                path: "${pageContext.request.contextPath}" // Context Path를 Vue 데이터로 가져옴
            };
        },
        methods: {
            // 상품 목록을 AJAX로 불러오는 로직이 여기에 추가될 수 있습니다.
            fnGoProductDetail: function (productNo) {
                let self = this;
                if (!productNo){
                    console.error("상품 번호가 없습니다");
                    return;
                }
                //상품 상세 페이지 URL로 이동 (예시: /product/detail?productNo=101)
            location.href = self.path + "/product/detail?productNo=" + productNo;
            }

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
        }
    });

    app.mount('#app');
</script>