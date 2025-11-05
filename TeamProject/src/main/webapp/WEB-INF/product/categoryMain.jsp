<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>카테고리</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/resources/js/page-change.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                body {
                    font-family: "Noto Sans KR", sans-serif;
                    background: #fafafa;
                    margin: 0;
                }

                .product-category-page {
                    display: flex;
                    flex-direction: row;
                    align-items: flex-start;
                    justify-content: space-between;
                    max-width: 1400px;
                    margin: 40px auto;
                    padding: 0 20px;
                    gap: 30px;
                }

                /* ---- 좌측 트리 ---- */
                .product-category-page .sidebar {
                    flex: 0 0 250px;
                    background: white;
                    padding: 20px;
                    border-radius: 15px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    position: sticky;
                    top: 120px;
                    align-self: flex-start;
                }


                .sidebar-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                }

                .btn-register {
                    background-color: #4CAF50;
                    /* 녹색 */
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 6px 12px;
                    font-size: 14px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .btn-register:hover {
                    background-color: #45a049;
                    /* hover 시 조금 진하게 */
                }

                .sidebar h3 {
                    color: #1a5d1a;
                    font-size: 18px;
                    margin-bottom: 10px;
                }

                .sidebar ul {
                    list-style: none;
                    padding-left: 12px;
                }

                .sidebar li {
                    cursor: pointer;
                    padding: 6px 8px;
                    border-radius: 6px;
                    transition: 0.2s;
                }

                .sidebar li:hover {
                    background: #e8f5e9;
                }

                .active {
                    background: #c8e6c9;
                    font-weight: bold;
                }

                /* ---- 우측 Grid ---- */
                .content {
                    flex: 3;
                    background: white;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }

                .section-title {
                    font-size: 16px;
                    font-weight: bold;
                    margin-bottom: 15px;
                    color: #2e7d32;
                    border-bottom: 2px solid #2e7d32;
                    padding-bottom: 5px;
                }

                .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                    gap: 16px;
                }

                /* ---- 카드 ---- */
                .grid-item {
                    text-align: center;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    transition: 0.2s;
                    cursor: pointer;
                    background: #fafafa;
                }

                .grid-item:hover {
                    background: #f1f8e9;
                    transform: translateY(-3px);
                }

                .grid-item img {
                    width: 140px;
                    height: 140px;
                    object-fit: cover;
                    border-radius: 8px;
                    margin-bottom: 8px;
                }

                /* ---- breadcrumb ---- */
                .breadcrumb {
                    font-size: 16px;
                    margin-bottom: 10px;
                    color: #666;
                }

                .breadcrumb span {
                    color: #2e7d32;
                    font-weight: bold;
                    cursor: pointer;
                }

                .breadcrumb-sep {
                    margin: 0 6px;
                    color: #aaa;
                }

                .price {
                    color: #388e3c;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app" class="product-category-page">
                    <!-- 좌측 트리 -->


                    <div class="sidebar">

                        <div class="sidebar-header">
                            <h3>카테고리</h3>
                            <button class="btn-register" @click="goToProductRegister">상품등록</button>
                        </div>

                        <ul>
                            <li v-for="p in parentCategories" :key="p.categoryNo">
                                <div @click="toggleParent(p.categoryNo)"
                                    :class="{ active: selectedParent === p.categoryNo }">
                                    {{ p.categoryName }}
                                </div>
                                <ul v-if="selectedParent === p.categoryNo">
                                    <li v-for="m in getChildCategories(p.categoryNo)" :key="m.categoryNo">
                                        <div @click.stop="toggleChild(m.categoryNo)"
                                            :class="{ active: selectedChild === m.categoryNo }">
                                            {{ m.categoryName }}
                                        </div>
                                        <ul v-if="selectedChild === m.categoryNo">
                                            <li v-for="s in getChildCategories(m.categoryNo)" :key="s.categoryNo"
                                                @click.stop="selectSub(s.categoryNo)"
                                                :class="{ active: selectedSub === s.categoryNo }">
                                                {{ s.categoryName }}
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- 우측 표시 영역 -->
                    <div class="content">
                        <!-- Breadcrumb -->
                        <div class="breadcrumb" v-if="breadcrumb.length > 0">
                            <span v-for="(b, i) in breadcrumb" :key="i" @click="goToLevel(i)">
                                {{ b }}
                                <span v-if="i < breadcrumb.length - 1" class="breadcrumb-sep">></span>
                            </span>
                        </div>

                        <!-- 대분류 -->
                        <div v-if="viewLevel === 'parent'">
                            <div class="section-title"></div>
                            <div class="grid">
                                <div class="grid-item" v-for="p in parentCategories" :key="p.categoryNo"
                                    @click="toggleParent(p.categoryNo)">
                                    <img :src="p.imageUrl || '/resources/img/category/noimage.png'" alt="대분류 이미지">
                                    {{ p.categoryName }}
                                </div>
                            </div>
                        </div>

                        <!-- 중분류 {{ getCategoryName(selectedParent) }}-->
                        <div v-else-if="viewLevel === 'child'">
                            <div class="section-title"></div>
                            <div class="grid">
                                <div class="grid-item" v-for="m in getChildCategories(selectedParent)"
                                    :key="m.categoryNo" @click="toggleChild(m.categoryNo)">
                                    <img :src="m.imageUrl || '/resources/img/category/noimage.png'" alt="중분류 이미지">
                                    {{ m.categoryName }}
                                </div>
                            </div>
                        </div>

                        <!-- 소분류 {{ getCategoryName(selectedChild) }} -->
                        <div v-else-if="viewLevel === 'sub'">
                            <div class="section-title"></div>
                            <div class="grid">
                                <div class="grid-item" v-for="s in getChildCategories(selectedChild)"
                                    :key="s.categoryNo" @click="selectSub(s.categoryNo)">
                                    <img :src="s.imageUrl || '/resources/img/category/noimage.png'" alt="소분류 이미지">
                                    {{ s.categoryName }}
                                </div>
                            </div>
                        </div>

                        <!-- 상품 {{ getCategoryName(selectedSub) }}-->
                        <div v-else-if="viewLevel == 'product'">
                            <div class="section-title"></div>
                            <div class="grid">
                                <a class="grid-item" v-for="p in filteredProducts" href="javascript:;"
                                    @click="fnView(p.productNo)">
                                    <img :src="p.filePath || '/resources/img/category/noimage.jpg'" alt="상품 이미지">
                                    <div>{{ p.pname }}</div>
                                    <div>{{p.pinfo}}</div>
                                    <div class="price">{{ p.price.toLocaleString() }}원</div>
                                </a>
                            </div>
                            <div v-if="filteredProducts.length === 0">등록된 상품이 없습니다.</div>
                        </div>
                    </div>

                </div>
        </body>

        </html>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>

            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            categoryList: [],
                            productList: [],
                            selectedParent: '',
                            selectedChild: '',
                            selectedSub: '',
                            viewLevel: 'parent',
                            // 서버가 넘겨주는 초기 진입 카테고리(없으면 빈 문자열)
                            initialCategoryNo: '${categoryNo}'
                        };
                    },
                    computed: {
                        parentCategories() {
                            return this.categoryList.filter(c => !c.parentCategoryNo);
                        },
                        filteredProducts() {
                            return this.productList.filter(p => Number(p.categoryNo) === Number(this.selectedSub));
                        },
                        breadcrumb() {
                            const r = [];
                            if (this.selectedParent) r.push(this.getCategoryName(this.selectedParent));
                            if (this.selectedChild) r.push(this.getCategoryName(this.selectedChild));
                            if (this.selectedSub) r.push(this.getCategoryName(this.selectedSub));
                            return r;
                        }
                    },
                    methods: {
                        // ---- 서버 데이터 로드 ----
                        fnList : function() {
                            let self = this;
                            $.ajax({
                                url: "/categoryProductList.dox",
                                dataType: "json",
                                type: "POST",
                                success: (data) => {
                                    self.categoryList = data.categories;
                                    self.productList = data.list;

                                    // 1) 해시에 상태가 있으면 그걸로 복원
                                    if (self.applyFromHash()) return;

                                    // 2) 해시 없으면 서버가 준 initialCategoryNo로 세팅 (없으면 대분류)
                                    self.applyInitialCategory();
                                    self.writeHash(); // 현재 상태를 해시에 기록
                                }
                            });
                        },

                        // ---- 해시 <-> 상태 동기화 ----
                        writeHash: function() {
                            const q = new URLSearchParams();
                            if (this.selectedParent) q.set('p', this.selectedParent);
                            if (this.selectedChild) q.set('c', this.selectedChild);
                            if (this.selectedSub) q.set('s', this.selectedSub);
                            q.set('v', this.viewLevel); // parent | child | sub | product
                            const newHash = '#' + q.toString();
                            if (location.hash !== newHash) {
                                history.replaceState(null, '', location.pathname + location.search + newHash);
                            }
                        },
                        applyFromHash() {
                            const raw = (location.hash || '').replace(/^#/, '');
                            if (!raw) return false;

                            const qs = new URLSearchParams(raw);
                            const p = qs.get('p') || '';
                            const c = qs.get('c') || '';
                            const s = qs.get('s') || '';
                            const v = qs.get('v') || 'parent';

                            // 값이 실제 목록에 존재하는지 간단 검증
                            const has = (no) => this.categoryList.some(x => String(x.categoryNo) === String(no));
                            const okP = p && has(p);
                            const okC = c && has(c);
                            const okS = s && has(s);

                            // 불일치 최소화: 순서대로 가능한 것만 반영
                            this.selectedParent = okP ? p : '';
                            this.selectedChild = okP && okC ? c : '';
                            this.selectedSub = okP && okC && okS ? s : '';

                            // viewLevel은 가능한 최대로 보정
                            if (okP && okC && okS && (v === 'product' || v === 'sub')) {
                                this.viewLevel = 'product';
                            } else if (okP && okC && v !== 'parent') {
                                this.viewLevel = 'sub';
                            } else if (okP) {
                                this.viewLevel = 'child';
                            } else {
                                this.viewLevel = 'parent';
                            }
                            return true;
                        },

                        // ---- 트리 조작 ----
                        getChildCategories(parentNo) {
                            return this.categoryList.filter(c => c.parentCategoryNo === parentNo);
                        },
                        getCategoryName(no) {
                            const cat = this.categoryList.find(c => c.categoryNo === no);
                            return cat ? cat.categoryName : '';
                        },

                        toggleParent(no) {
                            if (this.selectedParent === no) {
                                this.selectedParent = '';
                                this.selectedChild = '';
                                this.selectedSub = '';
                                this.viewLevel = 'parent';
                            } else {
                                this.selectedParent = no;
                                this.selectedChild = '';
                                this.selectedSub = '';
                                this.viewLevel = 'child';
                            }
                            this.writeHash();
                        },
                        toggleChild(no) {
                            if (this.selectedChild === no) {
                                this.selectedChild = '';
                                this.selectedSub = '';
                                this.viewLevel = 'child';
                            } else {
                                this.selectedChild = no;
                                this.selectedSub = '';
                                this.viewLevel = 'sub';
                            }
                            this.writeHash();
                        },
                        selectSub(no) {
                            this.selectedSub = no;
                            this.viewLevel = 'product';
                            this.writeHash();
                        },
                        goToLevel(index) {
                            if (index === 0) {
                                this.selectedChild = '';
                                this.selectedSub = '';
                                this.viewLevel = 'child';
                            } else if (index === 1) {
                                this.selectedSub = '';
                                this.viewLevel = 'sub';
                            }
                            this.writeHash();
                        },

                        // ---- 상세 진입 ----
                        fnView(productNo) {
                            pageChange("/productInfo.do", { productNo });
                        },

                        // ---- 초기 진입 ----
                        applyInitialCategory() {
                            const no = Number(this.initialCategoryNo);
                            if (!no) { // 대분류부터
                                this.selectedParent = '';
                                this.selectedChild = '';
                                this.selectedSub = '';
                                this.viewLevel = 'parent';
                                return;
                            }
                            const target = this.categoryList.find(c => Number(c.categoryNo) === no);
                            if (!target) {
                                this.selectedParent = '';
                                this.viewLevel = 'parent';
                                return;
                            }
                            if (!target.parentCategoryNo) {
                                // 대분류
                                this.selectedParent = String(no);
                                this.viewLevel = 'child';
                            } else {
                                const parent = this.categoryList.find(c => c.categoryNo === target.parentCategoryNo);
                                if (parent && !parent.parentCategoryNo) {
                                    // 중분류
                                    this.selectedParent = String(parent.categoryNo);
                                    this.selectedChild = String(no);
                                    this.viewLevel = 'sub';
                                } else if (parent && parent.parentCategoryNo) {
                                    // 소분류
                                    const top = this.categoryList.find(c => c.categoryNo === parent.parentCategoryNo);
                                    this.selectedParent = top ? String(top.categoryNo) : '';
                                    this.selectedChild = String(parent.categoryNo);
                                    this.selectedSub = String(no);
                                    this.viewLevel = 'product';
                                }
                            }
                        },

                        goToProductRegister() { window.location.href = '/product/add.do'; }
                    },

                    mounted() {
                        let self = this;
                        // 해시 변경으로 뒤/앞 이동 시 상태 자동 반영
                        window.addEventListener('hashchange', () => {
                            if (self.applyFromHash() === true) {
                                // 해시에서 복원되면 화면만 갱신하면 됨
                            }
                        });
                        // 데이터 로드 후 해시/초기값 적용
                        self.fnList();
                    }
                });
                app.mount("#app");
            </script>