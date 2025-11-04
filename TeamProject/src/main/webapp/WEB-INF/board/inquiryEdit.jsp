<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의글 수정 | AGRICOLA</title>

    <!-- ✅ 외부 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- ✅ 공통 헤더 / 푸터 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        html,
        body {
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
            background: #faf8f0;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        main.content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 60px 20px;
        }

        .edit-container {
            width: 100%;
            max-width: 800px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            padding: 40px;
            box-sizing: border-box;
        }

        .edit-container h2 {
            text-align: center;
            color: #1a5d1a;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1a5d1a;
            font-weight: 600;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            box-sizing: border-box;
        }

        .form-group textarea {
            resize: none;
            height: 180px;
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
        }

        .btn-save,
        .btn-cancel {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-save {
            background: #5dbb63;
            color: white;
            margin-right: 10px;
        }

        .btn-save:hover {
            background: #4ba954;
        }

        .btn-cancel {
            background: #ccc;
            color: #333;
        }

        .btn-cancel:hover {
            background: #bbb;
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div id="app">
        <main class="content">
            <div class="edit-container" v-if="inquiry">
                <h2>문의글 수정</h2>

                <div class="form-group">
                    <label>카테고리</label>
                    <select v-model="inquiry.category">
                        <option>주문/배송</option>
                        <option>결제</option>
                        <option>상품</option>
                        <option>취소/환불</option>
                        <option>기타</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>제목</label>
                    <input type="text" v-model="inquiry.title">
                </div>

                <div class="form-group">
                    <label>내용</label>
                    <textarea v-model="inquiry.content"></textarea>
                </div>

                <div class="form-group">
                    <label>
                        <input type="checkbox" v-model="isSecret" @change="toggleSecret"> 비공개 문의로 설정
                    </label>
                    <input v-if="isSecret" type="password" v-model="inquiry.password" placeholder="비밀번호를 입력하세요">
                </div>

                <div class="form-actions">
                    <button class="btn-save" @click="fnUpdateInquiry">수정 완료</button>
                    <button class="btn-cancel" @click="fnCancel">취소</button>
                </div>
            </div>

            <div v-else class="edit-container" style="text-align:center; color:#777;">
                데이터를 불러오는 중입니다...
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    inquiryNo: null,
                    inquiry: null,
                    isSecret: false,
                    sessionId: "${sessionId}"
                };
            },
            methods: {
                // ✅ 기존 데이터 불러오기
                fnLoadDetail() {
                    $.ajax({
                        url: "/inquiryInfo.dox",
                        type: "POST",
                        dataType: "json",
                        data: { inquiryNo: this.inquiryNo },
                        success: (res) => {
                            if (res.result === "success") {
                                this.inquiry = res.info;
                                this.isSecret = this.inquiry.isSecret === "Y";
                            }
                        },
                        error: () => alert("데이터를 불러오는 중 오류가 발생했습니다.")
                    });
                },

                toggleSecret() {
                    this.inquiry.isSecret = this.isSecret ? "Y" : "N";
                },

                // ✅ 수정 요청
                fnUpdateInquiry() {
                    if (!this.inquiry.title.trim()) {
                        alert("제목을 입력하세요.");
                        return;
                    }
                    if (!this.inquiry.content.trim()) {
                        alert("내용을 입력하세요.");
                        return;
                    }
                    if (this.isSecret && !this.inquiry.password) {
                        alert("비공개 설정 시 비밀번호를 입력하세요.");
                        return;
                    }

                    $.ajax({
                        url: "/inquiryUpdate.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            inquiryNo: this.inquiryNo,
                            category: this.inquiry.category,
                            title: this.inquiry.title,
                            content: this.inquiry.content,
                            isSecret: this.inquiry.isSecret,
                            password: this.inquiry.password || "",
                            userId: this.sessionId
                        },
                        success: (res) => {
                            if (res.result === "success") {
                                Swal.fire({
                                    icon: "success",
                                    title: "수정 완료",
                                    text: "문의글이 수정되었습니다.",
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    location.href = "/inquiry/detail.do?inquiryNo=" + this.inquiryNo;
                                });
                            } else {
                                Swal.fire("오류", "수정 중 문제가 발생했습니다.", "error");
                            }
                        },
                        error: () => Swal.fire("오류", "서버 오류가 발생했습니다.", "error")
                    });
                },

                fnCancel() {
                    location.href = "/inquiry/detail.do?inquiryNo=" + this.inquiryNo;
                }
            },
            mounted() {
                const urlParams = new URLSearchParams(window.location.search);
                this.inquiryNo = urlParams.get("inquiryNo");
                this.fnLoadDetail();
            }
        });

        app.mount("#app");
    </script>
</body>

</html>
