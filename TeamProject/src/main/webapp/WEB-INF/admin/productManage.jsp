<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>상품관리</title>

            <!-- Vue & jQuery -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>

            <!-- 공통 스타일 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css" />

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background-color: #f9f9f9;
                }

                .admin-container {
                    max-width: 1200px;
                    margin: 60px auto;
                    padding: 0 15px 60px;
                    box-sizing: border-box;
                }

                .admin-title {
                    font-size: 1.8rem;
                    color: #2e5d2e;
                    font-weight: 700;
                    margin-bottom: 30px;
                    text-align: center;
                }

                /* 검색 및 필터 */
                .product-filter {
                    display: flex;
                    justify-content: flex-start;
                    align-items: center;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-bottom: 20px;
                }

                .filter-left {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                }

                .admin-container select,
                .admin-container input[type="text"] {
                    padding: 6px 10px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 14px;
                    background-color: white;
                    box-sizing: border-box;
                }

                .filter-right button {
                    background: #5dbb63;
                    border: none;
                    color: white;
                    padding: 6px 12px;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: 0.2s;
                }

                .filter-right button:hover {
                    background: #4aa954;
                }

                /* 테이블 */
                .table-wrap {
                    width: 100%;
                    overflow-x: auto;
                    margin: 0 auto;
                }

                .product-table {
                    width: 100%;
                    min-width: 1000px;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                }

                .product-table th {
                    background: #4caf50;
                    color: white;
                    padding: 12px;
                    font-weight: 600;
                    text-align: center;
                    white-space: nowrap;
                }

                .product-table td {
                    padding: 10px;
                    text-align: center;
                    border-bottom: 1px solid #eee;
                    vertical-align: middle;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .product-table tr:hover {
                    background-color: #f9f9f9;
                }

                .btn-action {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    padding: 5px 10px;
                    border-radius: 6px;
                    font-size: 13px;
                    cursor: pointer;
                    transition: 0.2s;
                    margin: 0 3px;
                }

                .btn-action.off {
                    background: #c94c4c;
                }

                .btn-action:hover {
                    opacity: 0.9;
                }

                .no-data {
                    text-align: center;
                    padding: 20px;
                    color: #777;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <div class="admin-container">
                        <h2 class="admin-title">상품관리</h2>

                        <!-- 검색 & 필터 -->
                        <div class="product-filter">
                            <div class="filter-left">
                                <select v-model="selectedParentCategory">
                                    <option value="">대분류 선택</option>
                                    <option v-for="cat in parentCategories" :key="cat.categoryNo"
                                        :value="cat.categoryNo">
                                        {{ cat.categoryName }}
                                    </option>
                                </select>

                                <select v-model="selectedMiddleCategory" :disabled="!selectedParentCategory">
                                    <option value="">중분류 선택</option>
                                    <option v-for="mid in middleCategories" :key="mid.categoryNo"
                                        :value="mid.categoryNo">
                                        {{ mid.categoryName }}
                                    </option>
                                </select>

                                <select v-model="selectedSubCategory" :disabled="!selectedMiddleCategory">
                                    <option value="">소분류 선택</option>
                                    <option v-for="sub in subCategories" :key="sub.categoryNo" :value="sub.categoryNo">
                                        {{ sub.categoryName }}
                                    </option>
                                </select>

                                <input type="text" v-model="keyword" placeholder="상품명 검색" />
                                <button @click="fnSearch">검색</button>
                            </div>
                        </div>

                        <!-- 상품 목록 테이블 -->
                        <div class="table-wrap">
                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th>상품ID</th>
                                        <th>판매자ID</th>
                                        <th>상품명</th>
                                        <th>카테고리</th>
                                        <th>가격</th>
                                        <th>재고</th>
                                        <th>등록일</th>
                                        <th>상태</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in filteredList" :key="item.productNo">
                                        <td>{{ item.productNo }}</td>
                                        <td>{{ item.sellerId }}</td>
                                        <td>{{ item.pname }}</td>
                                        <td>{{ item.c1 }}</td>
                                        <td>{{ item.price.toLocaleString() }}원</td>
                                        <td>{{ item.stock }}</td>
                                        <td>{{ item.cdate }}</td>
                                        <td>
                                            <span v-if="item.active === 'Y'"
                                                style="color:#4caf50;font-weight:600;">활성</span>
                                            <span v-else style="color:#c94c4c;font-weight:600;">비활성</span>
                                        </td>
                                        <td>
                                            <button v-if="item.active === 'Y'" class="btn-action off"
                                                @click="fnUpdateStatus(item.productNo, 'N')">비활성화</button>
                                            <button v-else class="btn-action"
                                                @click="fnUpdateStatus(item.productNo, 'Y')">활성화</button>
                                        </td>
                                    </tr>
                                    <tr v-if="filteredList.length === 0">
                                        <td colspan="8" class="no-data">등록된 상품이 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>

            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            keyword: "",
                            selectedCategory: "",
                            categoryList: [],
                            selectedParentCategory: "",
                            selectedMiddleCategory: "",
                            selectedSubCategory: "",
                            productList: [],
                        };
                    },
                    computed: {
                        parentCategories() {
                            return this.categoryList.filter(c => !c.parentCategoryNo);
                        },
                        middleCategories() {
                            if (!this.selectedParentCategory) return [];
                            return this.categoryList.filter(
                                c => c.parentCategoryNo === this.selectedParentCategory
                            );
                        },
                        subCategories() {
                            if (!this.selectedMiddleCategory) return [];
                            return this.categoryList.filter(
                                c => c.parentCategoryNo === this.selectedMiddleCategory
                            );
                        },
                        filteredList() {
                            const kw = (this.keyword || "").trim().toLowerCase();

                            return this.productList.filter(item => {
                                const itemCat = String(item.categoryNo); // 🔹 문자열로 통일

                                // (1) 소분류 선택 시: 해당 categoryNo만
                                if (this.selectedSubCategory) {
                                    return itemCat === String(this.selectedSubCategory);
                                }

                                // (2) 중분류만 선택된 경우: 해당 중분류의 모든 하위 소분류 포함
                                if (this.selectedMiddleCategory) {
                                    const subCats = this.categoryList
                                        .filter(c => String(c.parentCategoryNo) === String(this.selectedMiddleCategory))
                                        .map(c => String(c.categoryNo));
                                    subCats.push(String(this.selectedMiddleCategory)); // 중분류 자체도 포함
                                    return subCats.includes(itemCat);
                                }

                                // (3) 대분류만 선택된 경우: 중분류/소분류 전체 포함
                                if (this.selectedParentCategory) {
                                    // 3-1) 중분류 목록
                                    const middleCats = this.categoryList.filter(
                                        c => String(c.parentCategoryNo) === String(this.selectedParentCategory)
                                    );

                                    // 3-2) 해당 중분류들의 하위 소분류 목록
                                    const subCats = this.categoryList.filter(c =>
                                        middleCats.some(mid => String(mid.categoryNo) === String(c.parentCategoryNo))
                                    );

                                    // 3-3) 모든 하위 카테고리 번호 합치기
                                    const allChildCats = [
                                        ...middleCats.map(c => String(c.categoryNo)),
                                        ...subCats.map(c => String(c.categoryNo)),
                                    ];

                                    // 대분류 자체 카테고리에 상품이 있을 가능성도 포함
                                    allChildCats.push(String(this.selectedParentCategory));

                                    return allChildCats.includes(itemCat);
                                }

                                // (4) 상품명 검색
                                return !kw || (item.pname && item.pname.toLowerCase().includes(kw));
                            }).filter(item => {
                                // 🔹 5️⃣ 검색어 필터
                                const kw = this.keyword.trim().toLowerCase();
                                return !kw || (item.pname && item.pname.toLowerCase().includes(kw));
                            });
                        },
                    },
                    methods: {
                        fnProductList() {
                            const self = this;
                            $.ajax({
                                url: "/productList.dox",
                                type: "POST",
                                dataType: "json",
                                success(data) {
                                    if (data.result === "success") {
                                        self.productList = data.list;
                                        self.categoryList = data.categories;
                                    } else {
                                        alert("데이터 로딩 실패");
                                    }
                                },
                            });
                        },
                        fnSearch() {
                            // computed 자동 반영
                        },
                    },
                    mounted() {
                        this.fnProductList();
                    },
                });
                app.mount("#app");
            </script>
        </body>

        </html>