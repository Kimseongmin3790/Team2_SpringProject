<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>상품 목록 | AGRICOLA</title>

            <!-- 외부 라이브러리 -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            <!-- 공통 헤더 / 푸터 CSS -->
            <link rel="stylesheet" href="${path}/resources/css/header.css">
            <link rel="stylesheet" href="${path}/resources/css/footer.css">

            <style>
                .product-page {
                    display: flex;
                    flex-direction: row;
                    align-items: flex-start;
                    justify-content: space-between;
                    gap: 30px;
                    max-width: 1400px;
                    margin: 40px auto;
                    padding: 0 20px;
                    box-sizing: border-box;
                }

                /* 왼쪽 카테고리 필터 */
                .product-page .filter-sidebar {
                    flex: 0 0 250px;
                    background: #fff;
                    border-radius: 15px;
                    padding: 20px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    position: sticky;
                    top: 120px;
                    align-self: flex-start;
                }

                .filter-sidebar h3 {
                    color: #1a5d1a;
                    font-size: 18px;
                    margin-bottom: 10px;
                }

                .filter-group {
                    margin-bottom: 15px;
                }

                .filter-group label {
                    display: block;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 5px;
                }

                .filter-group select {
                    width: 100%;
                    padding: 6px 8px;
                    border-radius: 5px;
                    border: 1px solid #ccc;
                    font-size: 14px;
                }

                .price-filter {
                    list-style: none;
                    padding: 0;
                    margin: 10px 0 20px 0;
                }

                .price-filter li {
                    font-size: 15px;
                    margin-bottom: 6px;
                }

                .filter-sidebar button {
                    width: 100%;
                    background-color: #5dbb63;
                    color: #fff;
                    border: none;
                    border-radius: 8px;
                    padding: 10px;
                    font-size: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .filter-sidebar button:hover {
                    background-color: #1a5d1a;
                }

                /* 오른쪽 상품 목록 */
                .product-page .product-list {
                    flex: 1;
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
                    gap: 25px;
                }

                .product-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                    transition: 0.25s ease;
                    cursor: pointer;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                }

                .product-card:hover {
                    transform: translateY(-6px);
                    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
                }

                .product-card img {
                    width: 100%;
                    height: 280px;
                    /* 🔹 기존 180px → 280px 로 변경 */
                    object-fit: cover;
                    /* 비율 유지하면서 꽉 채움 */
                    object-position: center;
                    /* 중앙 정렬 */
                    transition: transform 0.3s ease;
                }

                /* hover 시 약간 확대 효과 */
                .product-card:hover img {
                    transform: scale(1.05);
                }

                .product-info {
                    padding: 15px 14px 18px;
                    text-align: left;
                    flex-grow: 1;
                }

                .product-info h4 {
                    font-size: 17px;
                    color: #1a5d1a;
                    font-weight: 600;
                    margin-bottom: 8px;
                }

                .product-info .price {
                    color: #5dbb63;
                    font-size: 16px;
                    font-weight: bold;
                    margin-bottom: 4px;
                }

                .product-info .seller {
                    font-size: 14px;
                    color: #777;
                }

                @media (max-width: 1024px) {
                    .product-page {
                        flex-direction: column;
                    }

                    .product-page .filter-sidebar {
                        position: static;
                        width: 100%;
                    }
                }

                @media (max-width: 768px) {
                    .product-card img {
                        height: 200px;
                        /* 🔹 모바일에서는 살짝 줄임 */
                    }

                    .product-info h4 {
                        font-size: 15px;
                    }

                    .product-info .price {
                        font-size: 14px;
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="product-page">
                        <!-- ✅ 왼쪽 필터 -->
                        <aside class="filter-sidebar">
                            <h3>카테고리 선택</h3>

                            <!-- 대분류 -->
                            <div class="filter-group">
                                <label for="mainCategory">대분류</label>
                                <select id="mainCategory" v-model="selectedMain" @change="fnLoadSub">
                                    <option value="">-- 선택 --</option>
                                    <option v-for="c in mainCategories" :value="c.categoryNo">{{ c.categoryName }}
                                    </option>
                                </select>
                            </div>

                            <!-- 중분류 -->
                            <div class="filter-group" v-if="subCategories.length > 0">
                                <label for="subCategory">중분류</label>
                                <select id="subCategory" v-model="selectedSub" @change="fnLoadDetail">
                                    <option value="">-- 선택 --</option>
                                    <option v-for="s in subCategories" :value="s.categoryNo">{{ s.categoryName }}
                                    </option>
                                </select>
                            </div>

                            <!-- 소분류 -->
                            <div class="filter-group" v-if="detailCategories.length > 0">
                                <label for="detailCategory">소분류</label>
                                <select id="detailCategory" v-model="selectedDetail">
                                    <option value="">-- 선택 --</option>
                                    <option v-for="d in detailCategories" :value="d.categoryNo">{{ d.categoryName }}
                                    </option>
                                </select>
                            </div>

                            <!-- 가격대 -->
                            <h3>가격대</h3>
                            <ul class="price-filter">
                                <li><input type="radio" name="price" value="5000" v-model="selectedPrice"> 5,000원 이하
                                </li>
                                <li><input type="radio" name="price" value="10000" v-model="selectedPrice"> 1만원 이하</li>
                                <li><input type="radio" name="price" value="30000" v-model="selectedPrice"> 3만원 이하</li>
                                <li><input type="radio" name="price" value="30001" v-model="selectedPrice"> 3만원 이상</li>
                            </ul>

                            <button class="btn-filter" @click="fnFilter">필터 적용</button>
                        </aside>

                        <!-- ✅ 오른쪽 상품 목록 -->
                        <section class="product-list">
                            <div class="product-card" v-for="p in productList" :key="p.productNo">
                                <img :src="p.imagePath" :alt="p.pname">
                                <div class="product-info">
                                    <h4>{{ p.pname }}</h4>
                                    <p class="price">{{ p.price }}원</p>
                                    <p class="seller">판매자: {{ p.sellerId }}</p>
                                </div>
                            </div>
                        </section>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    path: "${path}",
                                    productList: [],

                                    mainCategories: [],
                                    subCategories: [],
                                    detailCategories: [],

                                    selectedMain: "",
                                    selectedSub: "",
                                    selectedDetail: "",
                                    selectedPrice: null,
                                };
                            },
                            methods: {
                                fnList() {
                                    const self = this;
                                    $.ajax({
                                        url: "/productAllList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success(data) {
                                            if (data.result === "success") {
                                                self.productList = data.list;
                                            } else {
                                                alert("데이터 로딩 실패");
                                            }
                                        }
                                    });
                                },
                                // ✅ 대분류 가져오기
                                fnLoadMain() {
                                    const self = this;
                                    $.ajax({
                                        url: "/productAllCategoryList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {},
                                        success(res) {
                                            if (res.result === "success") {
                                                self.mainCategories = res.list;
                                            }
                                        },
                                        error() {
                                            console.error("대분류 로드 실패");
                                        }
                                    });
                                },
                                // ✅ 중분류 로드
                                fnLoadSub() {
                                    const self = this;
                                    self.subCategories = [];
                                    self.detailCategories = [];
                                    self.selectedSub = "";
                                    self.selectedDetail = "";

                                    $.ajax({
                                        url: "/productAllCategoryList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { parent: self.selectedMain },
                                        success(res) {
                                            if (res.result === "success") {
                                                self.subCategories = res.list;
                                            }
                                        },
                                        error() {
                                            console.error("중분류 로드 실패");
                                        }
                                    });
                                },
                                // ✅ 소분류 로드
                                fnLoadDetail() {
                                    const self = this;
                                    self.detailCategories = [];
                                    self.selectedDetail = "";

                                    $.ajax({
                                        url: "/productAllCategoryList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { parent: self.selectedSub },
                                        success(res) {
                                            if (res.result === "success") {
                                                self.detailCategories = res.list;
                                            }
                                        },
                                        error() {
                                            console.error("소분류 로드 실패");
                                        }
                                    });
                                },
                                // ✅ 필터 적용
                                fnFilter() {
                                    const self = this;
                                    $.ajax({
                                        url: "/productFilter.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            main: self.selectedMain,
                                            sub: self.selectedSub,
                                            detail: self.selectedDetail,
                                            priceRange: self.selectedPrice
                                        },
                                        success(res) {
                                            if (res.result === "success") {
                                                self.productList = res.list;
                                            } else {
                                                alert("상품 필터 조회 실패");
                                            }
                                        },
                                        error() {
                                            console.error("필터 요청 실패");
                                        }
                                    });
                                }
                            },
                            mounted() {
                                this.fnLoadMain();
                                this.fnList();
                            }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>