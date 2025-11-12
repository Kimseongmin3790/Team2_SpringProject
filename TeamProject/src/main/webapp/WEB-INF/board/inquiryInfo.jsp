<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>고객문의 상세보기 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                html,
                body {
                    height: 100%;
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background: #faf8f0;
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
                    align-items: flex-start;
                    padding: 60px 20px;
                }

                .detail-container {
                    width: 100%;
                    max-width: 800px;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                    padding: 40px;
                    box-sizing: border-box;
                }

                .detail-title {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 20px;
                }

                .detail-info {
                    font-size: 14px;
                    color: #666;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 8px;
                    margin-bottom: 30px;
                }

                .detail-content {
                    font-size: 16px;
                    color: #333;
                    line-height: 1.7;
                    white-space: pre-line;
                    margin-bottom: 40px;
                }

                .answer-container {
                    background: #f9f9f9;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    padding: 20px;
                    margin-top: 30px;
                }

                .answer-title {
                    font-size: 18px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 15px;
                }

                .answer-content {
                    font-size: 15px;
                    color: #333;
                    line-height: 1.6;
                    white-space: pre-line;
                }

                .answer-form textarea {
                    width: 100%;
                    height: 120px;
                    resize: none;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    padding: 10px;
                    font-size: 14px;
                    box-sizing: border-box;
                }

                .answer-form button {
                    margin-top: 12px;
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 8px 16px;
                    cursor: pointer;
                }

                .answer-form button:hover {
                    background: #4ba954;
                }

                .btn-back {
                    display: inline-block;
                    margin-top: 40px;
                    padding: 10px 20px;
                    background: #5dbb63;
                    color: white;
                    border-radius: 6px;
                    text-decoration: none;
                    transition: 0.3s;
                }

                .btn-back:hover {
                    background: #4ba954;
                }

                .detail-actions {
                    text-align: right;
                    margin-top: 20px;
                }

                .detail-actions button {
                    margin-left: 10px;
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 8px 14px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .detail-actions button:hover {
                    background: #4ba954;
                }

                @media (max-width: 768px) {
                    .detail-container {
                        padding: 25px;
                    }

                    .detail-title {
                        font-size: 20px;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <div class="detail-container" v-if="inquiry">
                            <div class="detail-title">{{ inquiry.title }}</div>
                            <div class="detail-info">
                                작성자: {{ inquiry.userId }} ｜ 작성일시: {{ inquiry.regDate }} ｜ 조회수: {{ inquiry.cnt }}
                            </div>
                            <div class="detail-content">{{ inquiry.content }}</div>

                            <div class="detail-actions" v-if="canEditOrDelete">
                                <button class="btn-edit" @click="fnGoEdit">수정</button>
                                <button class="btn-delete" @click="fnDelete">삭제</button>
                            </div>

                            <div class="answer-container" v-if="answer">
                                <div class="answer-title">관리자 답변</div>
                                <div class="answer-content">{{ answer.content }}</div>
                                <div style="text-align:right; color:#666; font-size:13px; margin-top:5px;">
                                    작성자: {{ answer.sellerId }} ｜ 작성일시: {{ answer.cdatetime }}
                                </div>
                            </div>

                            <div class="answer-container" v-else-if="sessionStatus === 'ADMIN'">
                                <div class="answer-title">답변 작성</div>
                                <div class="answer-form">
                                    <textarea v-model="newAnswer" placeholder="답변을 입력하세요."></textarea>
                                    <button @click="fnSubmitAnswer">등록하기</button>
                                </div>
                            </div>

                            <a href="/board.do?tab=inquiry" class="btn-back">목록으로</a>
                        </div>

                        <div v-else class="detail-container" style="text-align:center; color:#777;">
                            데이터를 불러오는 중입니다...
                        </div>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}",
                                    sessionStatus: "${sessionStatus}",
                                    inquiryNo: null,
                                    inquiry: null,
                                    answer: "",
                                    newAnswer: ""
                                };
                            },
                            computed: {
                                canEditOrDelete() {
                                    if (!this.inquiry) return false;
                                    return this.sessionStatus === "ADMIN" || this.sessionId === this.inquiry.userId;
                                }
                            },
                            methods: {
                                fnLoadDetail() {
                                    const self = this;

                                    $.ajax({
                                        url: "/inquiryInfo.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            inquiryNo: self.inquiryNo
                                        },
                                        success: function (res) {
                                            if (res.result === "success") {
                                                self.inquiry = res.info;
                                            }
                                        },
                                        error: function () {
                                            alert("서버 오류가 발생했습니다.");
                                        }
                                    });
                                },

                                fnGoEdit() {
                                    location.href = "/inquiry/edit.do?inquiryNo=" + this.inquiryNo;
                                },

                                fnDelete() {
                                    Swal.fire({
                                        title: "정말 삭제하시겠습니까?",
                                        text: "삭제 후에는 복구할 수 없습니다.",
                                        icon: "warning",
                                        showCancelButton: true,
                                        confirmButtonColor: "#5dbb63",
                                        cancelButtonColor: "#aaa",
                                        confirmButtonText: "삭제",
                                        cancelButtonText: "취소"
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            $.ajax({
                                                url: "/inquiryDelete.dox",
                                                type: "POST",
                                                dataType: "json",
                                                data: { 
                                                    inquiryNo: this.inquiryNo 
                                                },
                                                success: (res) => {
                                                    if (res.result === "success") {
                                                        Swal.fire({
                                                            icon: "success",
                                                            title: "삭제 완료",
                                                            text: "게시글이 삭제되었습니다.",
                                                            timer: 1500,
                                                            showConfirmButton: false
                                                        }).then(() => {
                                                            location.href = "/board.do?tab=inquiry";
                                                        });
                                                    } else {
                                                        Swal.fire("삭제 실패", "서버 오류가 발생했습니다.", "error");
                                                    }
                                                },
                                                error: () => {
                                                    Swal.fire("삭제 실패", "서버 오류가 발생했습니다.", "error");
                                                }
                                            });
                                        }
                                    });
                                },

                                fnLoadAnswer() {
                                    const self = this;
                                    $.ajax({
                                        url: "/answerInfo.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            inquiryNo: self.inquiryNo
                                        },
                                        success: function (res) {
                                            if (res.result === "success" && res.info) {
                                                self.answer = res.info;
                                            }
                                        }
                                    });
                                },

                                fnSubmitAnswer() {
                                    const self = this;

                                    if (!self.newAnswer.trim()) {
                                        alert("답변 내용을 입력하세요.");
                                        return;
                                    }

                                    let param = {
                                        inquiryNo: self.inquiryNo,
                                        content: self.newAnswer,
                                        userId: self.sessionId
                                    };

                                    $.ajax({
                                        url: "/answerInsert.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: param,
                                        success: function (res) {
                                            if (res.result === "success") {
                                                alert("답변이 등록되었습니다.");
                                                self.fnLoadAnswer();
                                                self.newAnswer = "";
                                            } else {
                                                alert("등록에 실패했습니다.");
                                            }
                                        },
                                        error: function () {
                                            alert("서버 오류가 발생했습니다.");
                                        }
                                    });
                                }
                            },
                            mounted() {
                                const urlParams = new URLSearchParams(window.location.search);
                                this.inquiryNo = urlParams.get("inquiryNo");
                                this.fnLoadDetail();
                                this.fnLoadAnswer();
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>