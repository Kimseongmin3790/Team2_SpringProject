<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String sessionId = (String) session.getAttribute("sessionId");
    String sessionStatus = (String) session.getAttribute("sessionStatus");

    if (sessionId == null || sessionId.equals("")) {
%>
        <script>
            alert("로그인이 필요합니다.");
            location.href = "<%= request.getContextPath() %>/login.do";
        </script>
<%
        return;
    } else if (sessionStatus == null || !sessionStatus.equals("SELLER")) {
%>
        <script>
            alert("판매자 전용 페이지입니다.");
            location.href = "<%= request.getContextPath() %>/main.do";
        </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록 | AGRICOLA</title>

    <!-- 외부 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!-- 공통 헤더/푸터 CSS -->
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
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
        }

        h2 {
            color: #1a5d1a;
            text-align: center;
            margin-bottom: 20px;
        }

        form label {
            display: block;
            margin-top: 10px;
            font-weight: 600;
        }

        input,
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            background-color: #5dbb63;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            margin-top: 20px;
            cursor: pointer;
        }

        button:hover {
            background-color: #4caf50;
        }

        h4 {
            margin-top: 20px;
            color: #1a5d1a;
        }
    </style>
</head>

<body>
    <!-- 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div id="app">
        <main class="content">
            <h2>상품 등록</h2>

            <form id="productForm" enctype="multipart/form-data">
                <input type="hidden" name="sellerId" value="${sessionScope.sessionId}">

                <label>카테고리 번호</label>
                <input type="number" name="categoryNo" placeholder="예: 1 (농산물)" required>

                <label>상품명</label>
                <input type="text" name="pname" placeholder="상품명을 입력하세요" required>

                <label>상품 설명</label>
                <textarea name="pinfo" rows="4" placeholder="상품 상세 설명을 입력하세요" required></textarea>

                <label>가격</label>
                <input type="number" name="price" placeholder="가격을 입력하세요" required>

                <label>재고 수량</label>
                <input type="number" name="stock" placeholder="재고 수량을 입력하세요" required>

                <label>단위</label>
                <input type="text" name="unit" placeholder="예: kg, 개, 상자" required>

                <label>원산지</label>
                <input type="text" name="origin" placeholder="원산지를 입력하세요" required>

                <h4>대표 이미지</h4>
                <input type="file" name="thumbnail" accept="image/*" required>

                <h4>상품 이미지 (여러 장 가능)</h4>
                <input type="file" name="galleryImages" accept="image/*" multiple>

                <h4>상세 이미지 (여러 장 가능)</h4>
                <input type="file" name="detailImages" accept="image/*" multiple>

                <button type="submit">상품 등록하기</button>
            </form>
        </main>
    </div>

    <!-- 공통 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            sessionId: "${sessionScope.sessionId}"
        };
    },
    methods: {
        fnSubmit() {
            const form = document.getElementById("productForm");
            const formData = new FormData(form);

            $.ajax({
                url: "/productUpload.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function (res) {
                    if (res.status === "success") {
                        alert("✅ " + res.message);
                        form.reset();
                    } else {
                        alert("❌ " + res.message);
                    }
                },
                error: function () {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        }
    },
    mounted() {
        const self = this;        
        // form 이벤트 등록
        $("#productForm").on("submit", function (e) {
            e.preventDefault();
            self.fnSubmit();
        });
    }
});

app.mount('#app');
</script>
