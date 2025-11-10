<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>상품문의 상세보기 | AGRICOLA</title> <!-- ✅ 제목 변경 -->

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
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
                }

                .product-box {
                    display: flex;
                    align-items: center;
                    border-bottom: 1px solid #eee;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                }

                .product-box img {
                    width: 70px;
                    height: 70px;
                    object-fit: cover;
                    border-radius: 8px;
                    margin-right: 12px;
                }

                .product-name {
                    font-size: 16px;
                    font-weight: 600;
                    color: #1a5d1a;
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

                .answer-form textarea {
                    width: 100%;
                    height: 120px;
                    resize: none;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    padding: 10px;
                }

                .btn-back {
                    display: inline-block;
                    margin-top: 40px;
                    padding: 10px 20px;
                    background: #5dbb63;
                    color: white;
                    border-radius: 6px;
                    text-decoration: none;
                }

                .btn-back:hover {
                    background: #4ba954;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <div class="detail-container" v-if="qna">
                            <!-- ✅ 상품 정보 영역 -->
                            <div class="product-box">
                                <img :src="qna.thumbUrl" v-if="qna.thumbUrl" alt="상품 이미지">
                                <div class="product-name">{{ qna.pname }}</div>
                            </div>

                            <!-- ✅ 제목 / 내용 -->
                            <div class="detail-title">{{ qna.title }}</div>
                            <div class="detail-info">
                                작성자: {{ qna.userId }} ｜ 작성일시: {{ qna.regDate }} ｜ 조회수: {{ qna.cnt }}
                            </div>
                            <div class="detail-content">{{ qna.content }}</div>

                            <!-- ✅ 판매자 답변 영역 -->
                            <div class="answer-container" v-if="answer">
                                <div class="answer-title">판매자 답변</div>
                                <div class="answer-content">{{ answer.content }}</div>
                                <div style="text-align:right; color:#666; font-size:13px; margin-top:5px;">
                                    작성자: {{ answer.sellerId }} ｜ 작성일시: {{ answer.cdatetime }}
                                </div>
                            </div>

                            <!-- ✅ 답변 없고 판매자일 경우 -->
                            <div class="answer-container"
                                v-else-if="sessionStatus === 'SELLER' && qna && qna.sellerId === sessionId">
                                <div class="answer-title">답변 작성</div>
                                <div class="answer-form">
                                    <textarea v-model="newAnswer" placeholder="답변을 입력하세요."></textarea>
                                    <button @click="fnSubmitAnswer">등록하기</button>
                                </div>
                            </div>

                            <a href="/board.do?tab=qna" class="btn-back">목록으로</a>
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
                                    qnaNo: null,
                                    qna: null,
                                    answer: "",
                                    newAnswer: ""
                                };
                            },
                            methods: {
                                // ✅ 상품문의 상세조회
                                fnLoadDetail() {
                                    $.ajax({
                                        url: "/productQnaInfo.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            qnaNo: this.qnaNo
                                        },
                                        success: (res) => {
                                            if (res.result === "success")
                                                console.log(res);
                                            this.qna = res.info;
                                        }
                                    });
                                },

                                // ✅ 답변 조회
                                fnLoadAnswer() {
                                    $.ajax({
                                        url: "/productQnaAnswerInfo.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            qnaNo: this.qnaNo
                                        },
                                        success: (res) => {
                                            if (res.result === "success" && res.info) this.answer = res.info;
                                        }
                                    });
                                },

                                // ✅ 판매자 답변 등록
                                fnSubmitAnswer() {
                                    if (!this.newAnswer.trim()) {
                                        Swal.fire("입력 오류", "답변 내용을 입력하세요.", "warning");
                                        return;
                                    }

                                    $.ajax({
                                        url: "/productQnaAnswerInsert.dox", // ✅ 수정
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            qnaNo: this.qnaNo,
                                            content: this.newAnswer,
                                            sellerId: this.sessionId
                                        },
                                        success: (res) => {
                                            if (res.result === "success") {
                                                Swal.fire("등록 완료", "답변이 등록되었습니다.", "success");
                                                this.fnLoadAnswer();
                                                this.newAnswer = "";
                                            } else if (res.result === "notSeller") {
                                                Swal.fire("권한 없음", "이 문의의 판매자만 답변할 수 있습니다", "error");
                                            } else {
                                                Swal.fire("실패", "등록 중 오류가 발생했습니다.", "error");
                                            }
                                        }
                                    });
                                }
                            },
                            mounted() {
                                const urlParams = new URLSearchParams(window.location.search);
                                this.qnaNo = urlParams.get("qnaNo"); // ✅ 수정
                                this.fnLoadDetail();
                                this.fnLoadAnswer();
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>