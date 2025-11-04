<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>{{ seller.businessName }} | AGRICOLA</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                body {
                    background: #faf8f0;
                    font-family: "Noto Sans KR", sans-serif;
                }

                .seller-container {
                    max-width: 1200px;
                    margin: 60px auto;
                    background: white;
                    border-radius: 12px;
                    padding: 40px;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                }

                .seller-header {
                    display: flex;
                    align-items: center;
                    gap: 30px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 20px;
                    margin-bottom: 30px;
                }

                .seller-profile {
                    width: 120px;
                    height: 120px;
                    border-radius: 50%;
                    background-size: cover;
                    background-position: center;
                    border: 1px solid #ccc;
                }

                .seller-info h2 {
                    color: #1a5d1a;
                    margin: 0 0 8px 0;
                    font-size: 1.5rem;
                }

                .seller-info p {
                    margin: 3px 0;
                    color: #555;
                    font-size: 0.95rem;
                }

                .seller-stats {
                    display: flex;
                    gap: 20px;
                    margin-top: 10px;
                    font-size: 15px;
                    color: #333;
                }

                .seller-stats .rating {
                    color: #fbc02d;
                    font-weight: bold;
                }

                /* ✅ 상품 리스트 */
                .product-list {
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 25px;
                }

                .product-card {
                    background: #fff;
                    border: 1px solid #eee;
                    border-radius: 10px;
                    width: 250px;
                    overflow: hidden;
                    transition: transform 0.3s;
                    cursor: pointer;
                }

                .product-card:hover {
                    transform: translateY(-4px);
                }

                .product-card img {
                    width: 100%;
                    height: 200px;
                    object-fit: cover;
                    display: block;
                }

                .product-info {
                    padding: 12px;
                    text-align: left;
                }

                .product-info h4 {
                    font-size: 1rem;
                    margin: 0 0 5px;
                    color: #333;
                    font-weight: 600;
                }

                .product-price {
                    font-weight: bold;
                    color: #388e3c;
                }

                .product-stock {
                    font-size: 0.9rem;
                    color: #555;
                    margin-top: 4px;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app" class="seller-container">
                    <!-- ✅ 판매자 기본 정보 -->
                    <div class="seller-header">
                        <div class="seller-profile"
                            :style="{ backgroundImage: 'url(' + fullUrl(seller.profileImg) + ')' }"></div>
                        <div class="seller-info">
                            <h2>{{ seller.businessName }}</h2>
                            <p>{{ seller.addrDo }} {{ seller.addrCity }}</p>

                            <div class="seller-stats">
                                <div>🛒 판매 상품 수: {{ seller.productCnt || 0 }}</div>
                                <div class="rating">⭐ 평균 별점: {{ seller.avgRating ? seller.avgRating.toFixed(1) : '0.0'
                                    }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- ✅ 판매중인 상품 목록 -->
                    <h3 style="color:#1a5d1a;margin-bottom:20px;">판매 중인 상품</h3>
                    <div v-if="products.length === 0" style="text-align:center;color:#888;margin-top:30px;">
                        현재 등록된 상품이 없습니다.
                    </div>

                    <div class="product-list" v-else>
                        <div class="product-card" v-for="p in products" :key="p.productNo"
                            @click="goProduct(p.productNo)">
                            <img :src="fullUrl(p.imageUrl)" alt="">
                            <div class="product-info">
                                <h4>{{ p.pname }}</h4>
                                <span class="product-price">{{ p.price.toLocaleString() }}원</span>
                                <p class="product-stock">재고 : {{ p.stock }}개</p>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${pageContext.request.contextPath}",
                                    sellerId: "${param.sellerId}",  // URL 파라미터
                                    seller: {},
                                    products: []
                                };
                            },
                            methods: {
                                fullUrl(u) {
                                    if (!u) return this.path + "/resources/img/default-profile.png";
                                    if (/^https?:\/\//i.test(u)) return u;
                                    return this.path + (u.startsWith("/") ? u : "/" + u);
                                },
                                loadSeller() {
                                    const self = this;
                                    $.ajax({
                                        url: "/seller/detailData.dox",
                                        type: "POST",
                                        data: { sellerId: self.sellerId },
                                        dataType: "json",
                                        success(res) {
                                            self.seller = res.seller || {};
                                            self.products = res.products || [];
                                            document.title = `\${self.seller.businessName} | AGRICOLA`;
                                        },
                                        error(xhr, status, err) {
                                            console.error("❌ 판매자 정보 로드 실패:", err);
                                        }
                                    });
                                },
                                goProduct(productNo) {
                                    location.href = this.path + "/productInfo.do?productNo=" + productNo;
                                }
                            },
                            mounted() {
                                this.loadSeller();
                            }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>