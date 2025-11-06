<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색 결과 | AGRICOLA</title>

    <!-- ✅ header, footer CSS만 로드 -->
    <link rel="stylesheet" href="${path}/resources/css/header.css">
    <link rel="stylesheet" href="${path}/resources/css/footer.css">

    <!-- ✅ jQuery는 header.jsp에서 이미 로드됨 -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>
        html, body {
            margin: 0;
            padding: 0;
            background: #faf8f0;
            font-family: "Noto Sans KR", sans-serif;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        main.content {
            flex: 1;
            padding: 50px 60px;
        }

        .product-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            width: 220px;
            text-align: center;
            padding: 15px;
            cursor: pointer;
            transition: 0.25s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }

        .product-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
        }

        .no-result {
            text-align: center;
            color: #555;
            font-size: 16px;
            margin-top: 40px;
        }
    </style>
</head>

<body>
    <!-- ✅ header.jsp에는 이미 jQuery + header.js 포함 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <!-- ✅ Vue mount 영역(header/footer 밖) -->
    <div id="app">
        <main class="content">
            <div v-if="list.length > 0">
                <h3>"{{ keyword }}" 검색 결과</h3>

                <div class="product-grid">
                    <div class="product-card"
                         v-for="p in list"
                         :key="p.productNo"
                         @click="goProduct(p.productNo)">
                        <img :src="p.imageUrl" 
                             :alt="p.pName">
                        <h4>{{ p.pName }}</h4>
                        <p>가격: {{ p.price }}원</p>                        
                    </div>
                </div>
            </div>

            <div v-else class="no-result">
                "{{ keyword }}"에 대한 검색 결과가 없습니다.
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <!-- ✅ Vue 전용 코드 -->
    <script>
    const app = Vue.createApp({
        data() {
            return {
                keyword: "${keyword}",
                list: JSON.parse('${list}'),
                path: "${path}"
            };
        },
        methods: {
            goProduct(productNo) {
                location.href = this.path + "/productInfo.do?productNo=" + productNo;
            }
        },
        mounted() {
            // ✅ search.jsp에서 header.js 이벤트가 안 먹을 경우 대비 (보정)
            // 로고 클릭 복구
            if ($("#logoClick").length && !$._data($("#logoClick")[0], "events")) {
                $("#logoClick").on("click", () => location.href = this.path + "/main.do");
            }

            // 카테고리 hover/dropdown 복구
            if ($(".category-container").length && !$._data($("#btnCategory")[0], "events")) {
                $(".category-container").hover(
                    function(){ $("#dropdownMenu").addClass("active"); },
                    function(){ $("#dropdownMenu").removeClass("active"); }
                );
                $("#btnCategory").on("click", function(){
                    $("#dropdownMenu").toggleClass("active");
                });
            }
        }
    });
    app.mount("#app");
    </script>
</body>
</html>
