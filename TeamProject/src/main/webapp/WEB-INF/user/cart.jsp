<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>장바구니 | AGRICOLA</title>

            <!-- ✅ 외부 라이브러리 -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <!-- ✅ 공통 헤더/푸터 스타일 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <!-- ✅ 장바구니 전용 스타일 -->
            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #faf8f0;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main.content {
                    flex: 1;
                    padding: 60px 80px;
                    background: #faf8f0;
                }

                .cart-container {
                    max-width: 1100px;
                    margin: 0 auto;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                    padding: 30px 40px;
                }

                .cart-title {
                    font-size: 26px;
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 30px;
                    text-align: center;
                }

                table.cart-table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: center;
                }

                table.cart-table th {
                    background-color: #f3ebd3;
                    color: #1a5d1a;
                    padding: 14px 10px;
                    font-weight: 600;
                    border-bottom: 2px solid #ddd;
                }

                table.cart-table td {
                    padding: 16px 10px;
                    border-bottom: 1px solid #eee;
                    vertical-align: middle;
                }

                table.cart-table img {
                    width: 70px;
                    height: 70px;
                    border-radius: 8px;
                    object-fit: cover;
                }

                .quantity-control {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 6px;
                }

                .quantity-control button {
                    background-color: #5dbb63;
                    border: none;
                    color: white;
                    width: 26px;
                    height: 26px;
                    border-radius: 5px;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .quantity-control button:hover {
                    background-color: #4ba954;
                }

                .cart-summary {
                    text-align: right;
                    margin-top: 25px;
                    font-size: 18px;
                    font-weight: 600;
                }

                .cart-actions {
                    display: flex;
                    justify-content: flex-end;
                    gap: 15px;
                    margin-top: 25px;
                }

                .btn-order {
                    background: linear-gradient(90deg, #4caf50, #5dbb63);
                    border: none;
                    color: #fff;
                    padding: 12px 30px;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-order:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 10px rgba(93, 187, 99, 0.3);
                }

                .btn-clear {
                    background: #ccc;
                    border: none;
                    color: #333;
                    padding: 12px 25px;
                    border-radius: 8px;
                    font-size: 15px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-clear:hover {
                    background: #aaa;
                }
            </style>
        </head>

        <body>
            <!-- ✅ 공통 헤더 -->
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">

                    <!-- ✅ 장바구니 메인 영역 -->
                    <main class="content">
                        <div class="cart-container">
                            <h2 class="cart-title">장바구니</h2>

                            <table class="cart-table">
                                <thead>
                                    <tr>
                                        <th>선택</th>
                                        <th>상품이미지</th>
                                        <th>상품명</th>
                                        <th>가격</th>
                                        <th>수량</th>
                                        <th>합계</th>
                                        <th>삭제</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, idx) in cartList" :key="idx">
                                        <td><input type="checkbox" v-model="item.checked"></td>
                                        <td><img :src="item.image" alt="상품 이미지"></td>
                                        <td>{{ item.name }}</td>
                                        <td>{{ item.price.toLocaleString() }}원</td>
                                        <td>
                                            <div class="quantity-control">
                                                <button @click="fnDecrease(idx)">-</button>
                                                <span>{{ item.qty }}</span>
                                                <button @click="fnIncrease(idx)">+</button>
                                            </div>
                                        </td>
                                        <td>{{ (item.price * item.qty).toLocaleString() }}원</td>
                                        <td><button class="btn-clear" @click="fnRemove(idx)">X</button></td>
                                    </tr>
                                    <tr v-if="cartList.length === 0">
                                        <td colspan="7">장바구니에 담긴 상품이 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="cart-summary">
                                총 결제금액: {{ totalPrice.toLocaleString() }}원
                            </div>

                            <div class="cart-actions">
                                <button class="btn-clear" @click="fnClear">전체삭제</button>
                                <button class="btn-order" @click="fnOrder">주문하기</button>
                            </div>
                        </div>
                    </main>

                </div>

                <!-- ✅ 공통 푸터 -->
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </body>

        </html>

        <!-- ✅ Vue 로직 -->
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        cartList: [
                            // 샘플 데이터 (추후 AJAX 대체)
                            { name: "사과 3kg", price: 15000, qty: 1, image: "/resources/img/sample1.jpg", checked: true },
                            { name: "감귤 5kg", price: 22000, qty: 2, image: "/resources/img/sample2.jpg", checked: false },
                        ],
                        productNo: "${productNo}"
                    };
                },
                computed: {
                    totalPrice() {
                        return this.cartList.reduce((sum, item) => sum + (item.price * item.qty), 0);
                    }
                },
                methods: {
                    fnInfo: function () {
                        let self = this;
                        const param = {
                            productNo: self.productNo
                        };

                        $.ajax({
                            url: "product-view.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                self.info = data.info;
                            }
                        });
                    },

                    fnIncrease(idx) {
                        this.cartList[idx].qty++;
                    },
                    fnDecrease(idx) {
                        if (this.cartList[idx].qty > 1) this.cartList[idx].qty--;
                    },
                    fnRemove(idx) {
                        if (confirm("상품을 삭제하시겠습니까?")) {
                            this.cartList.splice(idx, 1);
                        }
                    },
                    fnClear() {
                        if (confirm("장바구니를 비우시겠습니까?")) {
                            this.cartList = [];
                        }
                    },
                    fnOrder() {
                        const selected = this.cartList.filter(item => item.checked);
                        if (selected.length === 0) {
                            alert("주문할 상품을 선택하세요!");
                            return;
                        }
                        alert("주문 페이지로 이동합니다 (TODO: 연동 예정)");
                    }
                },
                mounted() {
                    let self = this;
                    self.fnInfo();
                }

            });
            app.mount("#app");
        </script>