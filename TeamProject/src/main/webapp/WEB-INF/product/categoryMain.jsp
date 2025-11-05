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
                                    <div>{{ p.pName }}</div>
                                    <div>{{p.pInfo}}</div>
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
                const SERVER_CATEGORY_NO = '<c:out value="${categoryNo}" default="" />';
                const app = Vue.createApp({
                    data() {
                        return {
                            categoryList: [],
                            productList: [],
                            selectedParent: '',
                            selectedChild: '',
                            selectedSub: '',
                            viewLevel: 'parent',
                            initialCategoryNo: SERVER_CATEGORY_NO
                        };
                    },
                    computed: {
                        parentCategories() {
                            return this.categoryList.filter(c => c.parentCategoryNo === '');
                        },
                        filteredProducts() {
                            return this.productList.filter(p => String(p.categoryNo) === String(this.selectedSub));
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
                        normalize(c) {
                            return {
                                categoryNo: String(c.categoryNo),
                                parentCategoryNo: (c.parentCategoryNo == null || String(c.parentCategoryNo).trim() === '' || String(c.parentCategoryNo) === '0')
                                    ? '' : String(c.parentCategoryNo),
                                categoryName: c.categoryName || '',
                                imageUrl: c.imageUrl || ''
                            };
                        },

                        fnList() {
                            $.ajax({
                                url: "/categoryProductList.dox",
                                dataType: "json",
                                type: "POST",
                                success: (data) => {
                                    this.categoryList = (data.categories || []).map(this.normalize);
                                    this.productList = (data.list || []).map(p => ({ ...p, categoryNo: String(p.categoryNo) }));

                                    // 1) 해시가 있으면 해시로 복원 (쿼리 무시)
                                    if (this.applyFromHash()) return;

                                    // 2) 해시 없으면 쿼리(initialCategoryNo)로 시작
                                    this.applyInitialCategory();
                                    this.writeHash(); // 현재 상태를 URL에 기록 (해시만)
                                }
                            });
                        },

                        writeHash() {
                            const q = new URLSearchParams();
                            if (this.selectedParent) q.set('p', this.selectedParent);
                            if (this.selectedChild) q.set('c', this.selectedChild);
                            if (this.selectedSub) q.set('s', this.selectedSub);
                            q.set('v', this.viewLevel);
                            const newHash = '#' + q.toString();
                            if (location.hash !== newHash) {
                                history.replaceState(null, '', location.pathname + newHash);
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

                            const has = (no) => this.categoryList.some(x => x.categoryNo === String(no));
                            const okP = p && has(p);
                            const okC = c && has(c);
                            const okS = s && has(s);

                            this.selectedParent = okP ? String(p) : '';
                            this.selectedChild = okP && okC ? String(c) : '';
                            this.selectedSub = okP && okC && okS ? String(s) : '';

                            if (okP && okC && okS && (v === 'product' || v === 'sub')) this.viewLevel = 'product';
                            else if (okP && okC && v !== 'parent') this.viewLevel = 'sub';
                            else if (okP) this.viewLevel = 'child';
                            else this.viewLevel = 'parent';

                            return true;
                        },

                        getChildCategories(parentNo) {
                            const pid = String(parentNo || '');
                            return this.categoryList.filter(c => c.parentCategoryNo === pid);
                        },
                        getCategoryName(no) {
                            const cat = this.categoryList.find(c => c.categoryNo === String(no));
                            return cat ? cat.categoryName : '';
                        },

                        toggleParent(no) {
                            const id = String(no);
                            if (this.selectedParent === id) {
                                this.selectedParent = ''; this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'parent';
                            } else {
                                this.selectedParent = id; this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child';
                            }
                            this.writeHash();
                        },
                        toggleChild(no) {
                            const id = String(no);
                            if (this.selectedChild === id) {
                                this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child';
                            } else {
                                this.selectedChild = id; this.selectedSub = ''; this.viewLevel = 'sub';
                            }
                            this.writeHash();
                        },
                        selectSub(no) {
                            this.selectedSub = String(no);
                            this.viewLevel = 'product';
                            this.writeHash();
                        },
                        goToLevel(index) {
                            if (index === 0) { this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child'; }
                            else if (index === 1) { this.selectedSub = ''; this.viewLevel = 'sub'; }
                            this.writeHash();
                        },

                        fnView(productNo) {
                            pageChange("/productInfo.do", { productNo });
                        },

                        applyInitialCategory() {
                            const no = this.initialCategoryNo ? String(this.initialCategoryNo) : '';
                            if (!no) { this.selectedParent = ''; this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'parent'; return; }

                            const target = this.categoryList.find(c => c.categoryNo === no);
                            if (!target) { this.selectedParent = ''; this.viewLevel = 'parent'; return; }

                            if (target.parentCategoryNo === '') {
                                // 대분류
                                this.selectedParent = target.categoryNo;
                                this.viewLevel = 'child';
                            } else {
                                const parent = this.categoryList.find(c => c.categoryNo === target.parentCategoryNo);
                                if (parent && parent.parentCategoryNo === '') {
                                    // 중분류
                                    this.selectedParent = parent.categoryNo;
                                    this.selectedChild = target.categoryNo;
                                    this.viewLevel = 'sub';
                                } else if (parent && parent.parentCategoryNo !== '') {
                                    // 소분류
                                    const top = this.categoryList.find(c => c.categoryNo === parent.parentCategoryNo);
                                    this.selectedParent = top ? top.categoryNo : '';
                                    this.selectedChild = parent.categoryNo;
                                    this.selectedSub = target.categoryNo;
                                    this.viewLevel = 'product';
                                }
                            }
                        },

                        readCategoryNoFromURL() {
                            // 해시 우선 사용하므로 여기서는 보조 수단
                            const qs = new URLSearchParams(location.search);
                            const v = qs.get('categoryNo');
                            if (v) return String(v);
                            const segs = location.pathname.split('/').filter(Boolean);
                            const last = segs[segs.length - 1];
                            if (last && /^\d+$/.test(last)) return String(last);
                            return '';
                        },
                        goToProductRegister() { window.location.href = '/product/add.do'; }
                    },

                    mounted() {
                        if (!this.initialCategoryNo) {
                            this.initialCategoryNo = this.readCategoryNoFromURL();
                        }
                        window.addEventListener('hashchange', () => this.applyFromHash());
                        this.fnList();
                    }
                });
                app.mount("#app");
            </script>