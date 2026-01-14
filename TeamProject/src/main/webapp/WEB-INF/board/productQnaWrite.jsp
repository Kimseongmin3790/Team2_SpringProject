<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품문의 작성 | AGRICOLA</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/resources/js/page-change.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        html, body {
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
            background-color: #faf8f0;
        }

        main {
            max-width: 800px;
            margin: 60px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 40px 60px;
        }

        h2 {
            font-size: 22px;
            color: #1a5d1a;
            margin-bottom: 24px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
            font-family: inherit;
        }

        textarea {
            height: 160px;
            resize: none;
        }

        .secret-check {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .btn-area {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 30px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            border: none;
            transition: all .2s;
        }

        .btn-submit {
            background: #5dbb63;
            color: #fff;
        }

        .btn-submit:hover {
            background: #4ca454;
        }

        .btn-cancel {
            background: #e5e5e5;
            color: #333;
        }

        .btn-cancel:hover {
            background: #d8d8d8;
        }

        .password-box {
            margin-top: 8px;
            animation: fadeIn 0.2s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0;}
            to {opacity: 1;}
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main id="app">
        <h2>상품 문의 작성</h2>

        <div class="form-group">
            <label>상품명</label>
            <input type="text" v-model="productName" readonly>
        </div>

        <div class="form-group">
            <label>제목</label>
            <input type="text" v-model="title" placeholder="제목을 입력하세요">
        </div>

        <div class="form-group">
            <label>내용</label>
            <textarea v-model="content" placeholder="문의 내용을 입력하세요"></textarea>
        </div>

        <div class="form-group secret-check">
            <input type="checkbox" id="isSecret" v-model="isSecret">
            <label for="isSecret">비밀글로 등록하기</label>
        </div>

        <div class="form-group password-box" v-if="isSecret">
            <label>비밀번호</label>
            <input type="password" v-model="secretPw" placeholder="비밀글 확인용 비밀번호를 입력하세요">
        </div>

        <div class="btn-area">
            <button class="btn btn-submit" @click="fnSubmit">등록</button>
            <button class="btn btn-cancel" @click="fnCancel">취소</button>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    productNo: "${productNo}",
                    productName: "${productName}",
                    userId: "${sessionId}",
                    title: "",
                    content: "",
                    isSecret: false,
                    secretPw: ""
                };
            },
            methods: {
                fnSubmit() {
                    if (!this.title.trim() || !this.content.trim()) {
                        alert("제목과 내용을 모두 입력해주세요.");
                        return;
                    }
                    if (this.isSecret && !this.secretPw.trim()) {
                        alert("비밀글 비밀번호를 입력해주세요.");
                        return;
                    }

                    const param = {
                        productNo: this.productNo,
                        userId: this.userId,
                        title: this.title,
                        content: this.content,
                        isSecret: this.isSecret ? 'Y' : 'N',
                        password: this.isSecret ? this.secretPw : null
                    };

                    $.ajax({
                        url: "${pageContext.request.contextPath}/productQnaInsert.dox",
                        type: "POST",
                        dataType: "json",
                        data: param,
                        success: (data) => {
                            if (data.result === "success") {
                                alert("문의가 등록되었습니다.");
                                pageChange('/productInfo.do', { productNo: this.productNo });
                            } else {
                                alert("문의 등록에 실패했습니다.");
                            }
                        },
                        error: (xhr) => {
                            console.error("등록 오류:", xhr.responseText);
                            alert("서버 오류가 발생했습니다.");
                        }
                    });
                },
                fnCancel() {
                    if (confirm("작성을 취소하시겠습니까?")) {
                        pageChange('/productInfo.do', { productNo: this.productNo });
                    }
                }
            }
        });
        app.mount("#app");
    </script>
</body>

</html>
