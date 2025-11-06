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

                .btn-back {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 10px 20px;
                    font-size: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                    margin-bottom: 25px;
                }

                .btn-back:hover {
                    background: #4ba954;
                }

                .btn-recommend {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 5px 10px;
                    cursor: pointer;
                    font-size: 13px;
                    transition: 0.3s;
                }

                .btn-recommend:hover {
                    background: #4ba954;
                }

                .btn-recommend.active {
                    background: #c94c4c;
                }

                .btn-recommend.active:hover {
                    background: #a83e3e;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <div id="app">
                    <div class="admin-container">
                        <div class="admin-header">
                            <button class="btn-back" @click="fnGoBack">이전</button>
                            <h2 class="admin-title">상품관리</h2>
                        </div>

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
                                        <th>단위</th>
                                        <th>재고</th>
                                        <th>등록일</th>
                                        <th>상품추천여부</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, idx) in filteredList" :key="item.productNo + '-' + idx">
                                        <td>{{ item.productNo }}</td>
                                        <td>{{ item.sellerId }}</td>
                                        <td>{{ item.pName }}</td>
                                        <td>{{ item.c1 }}</td>
                                        <td>{{ item.price.toLocaleString() }}원</td>
                                        <td>{{ item.unit }}</td>
                                        <td>{{ item.stock }}</td>
                                        <td>{{ item.cdate }}</td>
                                        <td>
                                            <button class="btn-recommend" :class="{ active: item.recommend === 'Y' }"
                                                @click="fnToggleRecommend(item)">
                                                {{ item.recommend === 'Y' ? '추천안하기' : '추천하기' }}
                                            </button>
                                        </td>
                                        <td v-if="item.productStatus === 'SOLDOUT'" style="color: red">{{
                                            item.productStatus }}</td>
                                        <td v-else>{{ item.productStatus }}</td>
                                    </tr>
                                    <tr v-if="filteredList.length === 0">
                                        <td colspan="8" class="no-data">등록된 상품이 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
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
                                        const itemCat = String(item.categoryNo);

                                        // ✅ (1) 카테고리 필터
                                        if (this.selectedSubCategory) {
                                            return itemCat === String(this.selectedSubCategory);
                                        }

                                        if (this.selectedMiddleCategory) {
                                            const subCats = this.categoryList
                                                .filter(c => String(c.parentCategoryNo) === String(this.selectedMiddleCategory))
                                                .map(c => String(c.categoryNo));
                                            subCats.push(String(this.selectedMiddleCategory));
                                            return subCats.includes(itemCat);
                                        }

                                        if (this.selectedParentCategory) {
                                            const middleCats = this.categoryList.filter(
                                                c => String(c.parentCategoryNo) === String(this.selectedParentCategory)
                                            );
                                            const subCats = this.categoryList.filter(c =>
                                                middleCats.some(mid => String(mid.categoryNo) === String(c.parentCategoryNo))
                                            );
                                            const allChildCats = [
                                                ...middleCats.map(c => String(c.categoryNo)),
                                                ...subCats.map(c => String(c.categoryNo)),
                                                String(this.selectedParentCategory)
                                            ];
                                            return allChildCats.includes(itemCat);
                                        }

                                        // ✅ (2) 검색어 필터
                                        if (kw) {
                                            // 부분일치 → 정확일치로 바꾸려면 === 로 변경
                                            return item.pName && item.pName.toLowerCase().includes(kw);
                                        }

                                        return true; // 아무 조건도 없으면 전체 표시
                                    });

                                    // ✅ productNo 기준으로 중복 제거
                                    const seen = new Set();
                                    return filtered.filter(it => {
                                        if (seen.has(it.productNo)) return false;
                                        seen.add(it.productNo);
                                        return true;
                                    });
                                },
                            },
                            methods: {
                                fnGoBack() {
                                    if (document.referrer && document.referrer !== location.href) {
                                        // ✅ 이전 페이지로 이동
                                        history.back();
                                    } else {
                                        // ✅ 이전 페이지 정보가 없으면 관리자 메인으로
                                        location.href = this.path + "/admin/dashboard.do";
                                    }
                                },

                                fnProductList() {
                                    const self = this;
                                    $.ajax({
                                        url: "/productList.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success(data) {
                                            if (data.result === "success") {
                                                console.log(data);
                                                self.productList = [];
                                                self.categoryList = [];

                                                self.productList = data.list;
                                                self.categoryList = data.categories;
                                            } else {
                                                alert("데이터 로딩 실패");
                                            }
                                        },
                                    });
                                },

                                fnSearch() {
                                    this.$forceUpdate();
                                },

                                fnToggleRecommend(item) {
                                    const self = this;
                                    const newStatus = item.recommend === "Y" ? "N" : "Y";

                                    $.ajax({
                                        url: "/updateRecommend.dox",
                                        type: "POST",
                                        data: {
                                            productNo: item.productNo,
                                            recommend: newStatus
                                        },
                                        dataType: "json",
                                        success(res) {
                                            if (res.result === "success") {
                                                item.recommend = newStatus; // ✅ 즉시 화면 반영
                                            } else {
                                                alert("변경 실패");
                                            }
                                        },
                                        error() {
                                            alert("서버 오류로 변경할 수 없습니다.");
                                        },
                                    });
                                }
                            },
                            mounted() {
                                this.fnProductList();
                            },
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>