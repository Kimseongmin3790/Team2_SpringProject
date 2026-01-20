<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>내 상품 목록 | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <!-- ✅ SweetAlert2 -->
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                html,
                body {
                    height: 100%;
                    margin: 0
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column
                }

                .content {
                    flex: 1;
                    max-width: 1100px;
                    margin: 24px auto;
                    padding: 0 12px
                }

                h3 {
                    color: #1a5d1a;
                    margin-bottom: 12px
                }

                .toolbar {
                    display: flex;
                    gap: 8px;
                    margin: 12px 0
                }

                .toolbar input,
                .toolbar select {
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 6px
                }

                .btn {
                    padding: 8px 12px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer
                }

                .btn-primary {
                    background: #5dbb63;
                    color: #fff
                }

                .btn-danger {
                    background: #ef4444;
                    color: #fff
                }

                table {
                    width: 100%;
                    border-collapse: collapse
                }

                th,
                td {
                    border: 1px solid #e5e5e5;
                    padding: 10px;
                    text-align: left
                }

                th {
                    background: #fafafa
                }

                .status {
                    padding: 2px 8px;
                    border-radius: 999px;
                    background: #eef6ee;
                    color: #1a5d1a;
                    font-size: 12px
                }

                table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0;
                    table-layout: fixed;
                    background: #fff;
                    border: 1px solid #e6efe6;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(26, 93, 26, 0.05);
                }

                th,
                td {
                    padding: 12px 10px;
                    border-bottom: 1px solid #f1f4f1;
                    vertical-align: middle;
                    word-wrap: break-word;
                }

                th {
                    background: #f4fbf4;
                    color: #1a5d1a;
                    border-bottom: 1px solid #e6efe6;
                }

                tbody td:nth-child(2),
                thead th:nth-child(2) {
                    width: 38%;
                }

                tbody td:nth-child(3),
                thead th:nth-child(3),
                tbody td:nth-child(5),
                thead th:nth-child(5) {
                    text-align: right;
                    white-space: nowrap;
                }

                .prod-cell {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    min-width: 0;
                }

                .prod-thumb {
                    width: 56px;
                    height: 56px;
                    flex: 0 0 56px;
                    object-fit: cover;
                    border-radius: 8px;
                    border: 1px solid #e9eee9;
                    background: #fff;
                }

                .prod-title {
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                    line-height: 1.35;
                    font-weight: 600;
                    color: #1a1a1a;
                }

                .status {
                    padding: 2px 8px;
                    border-radius: 999px;
                    background: #eef6ee;
                    color: #1a5d1a;
                    font-size: 12px;
                    display: inline-block;
                }

                tbody tr:nth-child(odd) {
                    background: #fcfffc;
                }

                tbody tr:hover {
                    background: #f6fff6;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <h3>{{ sessionId }} 상품 목록</h3>

                        <table>
                            <thead>
                                <tr>
                                    <th style="width:10%">번호</th>
                                    <th>상품명</th>
                                    <th style="width:15%">기본가</th>
                                    <th style="width:15%">단위</th>
                                    <th style="width:15%">재고</th>
                                    <th style="width:15%">상태</th>
                                    <th style="width:20%">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="row in list" :key="row.productNo">
                                    <td>{{row.productNo}}</td>
                                    <td>
                                        <div class="prod-cell">
                                            <img class="prod-thumb" :src="row.imageUrl" alt="thumb">
                                            <div class="prod-title">{{ row.pName }}</div>
                                        </div>
                                    </td>
                                    <td>{{ (Number(row.price||0) + Number(row.addPrice||0)).toLocaleString() }}원</td>
                                    <td>{{ row.unit }}</td>
                                    <td>{{ row.stockQty || 0 }}</td>
                                    <td><span class="status">{{row.productStatus}}</span></td>
                                    <td>
                                        <button class="btn btn-primary" @click="goEdit(row.productNo)">수정</button>
                                        <button class="btn btn-danger" @click="del(row.productNo)">삭제</button>
                                    </td>
                                </tr>
                                <tr v-if="!list.length">
                                    <td colspan="7">데이터가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const CP = "${pageContext.request.contextPath}";

                        // ✅ Swal helper: 성공만 초록 버튼
                        const swWarn = (msg) => Swal.fire('⚠️', msg, 'warning');
                        const swError = (msg) => Swal.fire('❌', msg, 'error');
                        const swSuccess = (msg) => Swal.fire({
                            icon: 'success',
                            title: '성공',
                            text: msg,
                            confirmButtonColor: '#5dbb63'
                        });

                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionId}",
                                    list: []
                                };
                            },
                            methods: {
                                load() {
                                    $.ajax({
                                        url: CP + "/myPage/list.dox",
                                        type: "POST",
                                        contentType: "application/json; charset=UTF-8",
                                        dataType: "json",
                                        data: JSON.stringify({ sellerId: this.sessionId }),
                                        success: (data) => {
                                            this.list = data.list || [];
                                        },
                                        error: () => {
                                            swError("오류가 발생했습니다.");
                                        }
                                    });
                                },
                                goEdit(pno) {
                                    location.href = CP + "/sellerProductEdit.do?productNo=" + pno;
                                },
                                del(pno) {
                                    Swal.fire({
                                        title: '⚠️',
                                        text: '정말 삭제할까요? 주문 이력 있으면 숨김 처리될 수 있어요.',
                                        icon: 'warning',
                                        showCancelButton: true,
                                        confirmButtonText: '삭제',
                                        cancelButtonText: '취소',
                                        reverseButtons: true
                                    }).then((result) => {
                                        if (!result.isConfirmed) return;

                                        $.ajax({
                                            url: CP + "/myPage/delete.dox",
                                            type: "POST",
                                            contentType: "application/json; charset=UTF-8",
                                            dataType: "json",
                                            data: JSON.stringify({ productNo: pno }),
                                            success: async (data) => {
                                                await swSuccess("처리되었습니다.");
                                                this.load();
                                            },
                                            error: () => swError("삭제 실패")
                                        });
                                    });
                                }
                            },
                            mounted() {
                                this.load();
                            }
                        });

                        app.mount('#app');
                    </script>
        </body>

        </html>