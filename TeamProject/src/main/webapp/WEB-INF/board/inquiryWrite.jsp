<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>문의글 작성 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                body {
                    margin: 0;
                    background: #faf8f0;
                    font-family: "Noto Sans KR", sans-serif;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    flex: 1;
                    display: flex;
                    justify-content: center;
                    padding: 60px 20px;
                }

                .write-container {
                    background: #fff;
                    width: 100%;
                    max-width: 800px;
                    border-radius: 10px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                    padding: 40px;
                    box-sizing: border-box;
                }

                h2 {
                    text-align: center;
                    color: #1a5d1a;
                    margin-bottom: 40px;
                }

                .form-group {
                    margin-bottom: 25px;
                }

                .form-group label {
                    display: block;
                    font-weight: 600;
                    margin-bottom: 8px;
                    color: #333;
                }

                .form-group input,
                .form-group select,
                .form-group textarea {
                    width: 100%;
                    padding: 10px 12px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                    box-sizing: border-box;
                }

                textarea {
                    resize: none;
                    height: 180px;
                }

                .checkbox-group {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    margin-top: 10px;
                }

                .checkbox-group input[type="checkbox"] {
                    width: 18px;
                    height: 18px;
                    cursor: pointer;
                    accent-color: #5dbb63;
                    /* ✅ 최신 브라우저에서 초록색 체크 표시 */
                    margin: 0;
                }

                .checkbox-group label {
                    font-size: 15px;
                    color: #333;
                    cursor: pointer;
                    user-select: none;
                }

                .btn-area {
                    text-align: center;
                    margin-top: 40px;
                }

                .btn-submit,
                .btn-cancel {
                    padding: 10px 24px;
                    border: none;
                    border-radius: 6px;
                    font-size: 15px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-submit {
                    background: #5dbb63;
                    color: white;
                    margin-right: 10px;
                }

                .btn-submit:hover {
                    background: #4ba954;
                }

                .btn-cancel {
                    background: #ccc;
                    color: #333;
                }

                .btn-cancel:hover {
                    background: #bbb;
                }

                @media (max-width: 768px) {
                    .write-container {
                        padding: 25px;
                    }

                    h2 {
                        font-size: 22px;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <div class="write-container">
                            <h2>고객문의 작성</h2>

                            <!-- 작성 폼 -->
                            <div class="form-group">
                                <label>작성자</label>
                                <input type="text" v-model="sessionId" readonly>
                            </div>

                            <div class="form-group">
                                <label>카테고리</label>
                                <select v-model="category">
                                    <option value="">선택하세요</option>
                                    <option>주문/배송</option>
                                    <option>결제</option>
                                    <option>상품</option>
                                    <option>취소/환불</option>
                                    <option>기타</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>제목</label>
                                <input type="text" v-model="title" placeholder="제목을 입력하세요">
                            </div>

                            <div class="form-group">
                                <label>내용</label>
                                <textarea v-model="content" placeholder="문의 내용을 입력하세요"></textarea>
                            </div>

                            <div class="form-group checkbox-group">
                                <input type="checkbox" id="isSecret" v-model="isSecret">
                                <label for="isSecret">비공개 문의로 설정</label>
                            </div>

                            <div class="form-group" v-if="isSecret">
                                <label>비밀번호</label>
                                <input type="password" v-model="password" placeholder="비밀번호를 입력하세요">
                            </div>

                            <div class="btn-area">
                                <button class="btn-submit" @click="fnSubmit">등록</button>
                                <button class="btn-cancel" @click="fnCancel">취소</button>
                            </div>
                        </div>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}", // 로그인 사용자
                                    category: "",
                                    title: "",
                                    content: "",
                                    isSecret: false,
                                    password: ""
                                };
                            },
                            methods: {
                                fnSubmit() {
                                    const self = this;

                                    // 유효성 검사
                                    if (!self.title.trim()) {
                                        Swal.fire("제목을 입력하세요.", "", "warning");
                                        return;
                                    }
                                    if (!self.content.trim()) {
                                        Swal.fire("내용을 입력하세요.", "", "warning");
                                        return;
                                    }
                                    if (!self.category) {
                                        Swal.fire("카테고리를 선택하세요.", "", "warning");
                                        return;
                                    }
                                    if (self.isSecret && !self.password.trim()) {
                                        Swal.fire("비밀번호를 입력하세요.", "", "warning");
                                        return;
                                    }

                                    // 등록 요청
                                    $.ajax({
                                        url: "/inquiryInsert.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            userId: self.sessionId,
                                            category: self.category,
                                            title: self.title,
                                            content: self.content,
                                            isSecret: self.isSecret ? 'Y' : 'N',
                                            password: self.password
                                        },
                                        success: function (res) {
                                            if (res.result === "success") {
                                                Swal.fire({
                                                    icon: "success",
                                                    title: "등록 완료",
                                                    text: "문의글이 등록되었습니다.",
                                                    confirmButtonColor: "#5dbb63"
                                                }).then(() => {
                                                    location.href = "/board.do?tab=inquiry";
                                                });
                                            } else {
                                                Swal.fire("등록 실패", "서버 오류가 발생했습니다.", "error");
                                            }
                                        },
                                        error: function () {
                                            Swal.fire("오류", "통신 오류가 발생했습니다.", "error");
                                        }
                                    });
                                },
                                fnCancel() {
                                    history.back();
                                }
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>