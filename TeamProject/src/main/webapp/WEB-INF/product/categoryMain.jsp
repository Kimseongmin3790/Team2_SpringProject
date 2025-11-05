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
                    background: #f9f9f9;
                    margin: 0;
                    font-size: 18px;
                    line-height: 1.6;
                }

                /* ===== 전체 레이아웃 ===== */
                .product-category-page {
                    display: flex;
                    flex-direction: row;
                    align-items: flex-start;
                    justify-content: space-between;
                    max-width: 1900px;
                    margin: 60px auto;
                    padding: 0 60px;
                    gap: 60px;
                }

                /* ===== 좌측 카테고리 ===== */
                .product-category-page .sidebar {
                    flex: 0 0 320px;
                    background: transparent;
                    padding: 10px 0;
                    border: none;
                    box-shadow: none;
                    position: sticky;
                    top: 100px;
                    align-self: flex-start;
                }

                .sidebar-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                }

                .btn-register {
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 12px 20px;
                    font-size: 18px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: background-color 0.2s, transform 0.1s;
                }

                .btn-register:hover {
                    background-color: #3d8c40;
                    transform: scale(1.05);
                }

                .sidebar h3 {
                    color: #1a5d1a;
                    font-size: 24px;
                    margin-bottom: 15px;
                    font-weight: bold;
                }

                .sidebar ul {
                    list-style: none;
                    padding-left: 10px;
                }

                .sidebar li {
                    cursor: pointer;
                    padding: 10px 12px;
                    border-radius: 8px;
                    transition: background-color 0.2s, transform 0.1s;
                    font-size: 19px;
                }

                .sidebar li:hover {
                    background: #e8f5e9;
                    transform: translateX(3px);
                }

                .active {
                    /* background: #c8e6c9; */
                    font-weight: bold;
                    /* border-left: 5px solid #388e3c; */
                }

                /* ===== 우측 콘텐츠 ===== */
                .content {
                    flex: 3;
                    background: transparent;
                    padding: 0;
                    border: none;
                    box-shadow: none;
                }

                /* ===== 그림 Grid ===== */
                .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 35px;
                    width: 100%;
                }

                /* ===== 카드 공통 ===== */
                .grid-item {
                    display: flex;
                    flex-direction: column;
                    justify-content: flex-start;
                    background: transparent;
                    border-radius: 0;
                    aspect-ratio: 3 / 5.5;
                    overflow: hidden;
                    cursor: pointer;
                    transition: transform 0.25s ease;
                    box-shadow: none;
                }

                .grid-item:hover {
                    transform: translateY(-6px);
                }

                .grid-item .image-wrapper {
                    flex: 5;
                    overflow: hidden;
                    position: relative;
                    border-radius: 5px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                .grid-item .image-wrapper img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    object-position: center;
                    display: block;
                    transition: transform 0.3s ease;
                    border-radius: 5px;
                }

                .grid-item:hover .image-wrapper img {
                    transform: scale(1.05);
                }

                .grid-item .info {
                    flex: 1;
                    background: transparent;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    padding: 8px;
                    text-align: center;
                }

                .grid-item .info h4 {
                    font-size: 19px;
                    font-weight: 600;
                    margin: 0;
                    color: #333;
                }

                /* ===== 상품 카드 ===== */
                .grid-item.product {
                    aspect-ratio: 3 / 5.5;
                }

                .grid-item.product .image-wrapper {
                    flex: 6;
                }

                .grid-item.product .info {
                    flex: 1;
                    background: transparent;
                    text-align: center;
                    padding: 6px;
                }

                .grid-item.product .info h4 {
                    font-size: 17px;
                    font-weight: 600;
                    color: #222222;
                    margin-bottom: 3px;
                }

                .grid-item.product .info .desc {
                    font-size: 16px;
                    color: #3925ee;
                    margin-bottom: 6px;
                    line-height: 1.4;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                }

                .grid-item.product .info .price {
                    color: #2e7d32;
                    font-weight: bold;
                    font-size: 18px;
                }

                /* ===== 가격 필터 ===== */
                .price-filter {
                    margin-top: 40px;
                }

                .price-filter h3 {
                    color: #1a5d1a;
                    font-size: 22px;
                    margin-bottom: 15px;
                    font-weight: bold;
                }

                .price-filter ul {
                    list-style: none;
                    padding-left: 10px;
                }

                .price-filter li {
                    cursor: pointer;
                    padding: 10px 12px;
                    border-radius: 8px;
                    transition: background-color 0.2s, transform 0.1s;
                    font-size: 18px;
                }

                .price-filter li:hover {
                    background: #e8f5e9;
                    transform: translateX(3px);
                }

                .price-filter li.active {
                    background: #c8e6c9;
                    font-weight: bold;
                    border-left: 5px solid #388e3c;
                }

                /* ===== 구분선 (Category / Price) ===== */
                .sidebar-divider {
                    width: 80%;
                    height: 1px;
                    background-color: #ddd;
                    margin: 25px 0;
                }

                /* ===== breadcrumb ===== */
                .breadcrumb {
                    font-size: 18px;
                    margin-bottom: 25px;
                    color: #555;
                }

                .breadcrumb span {
                    color: #2e7d32;
                    font-weight: bold;
                    cursor: pointer;
                }

                .breadcrumb-sep {
                    margin: 0 8px;
                    color: #aaa;
                }

                /* ===== 모바일 대응 ===== */
                @media (max-width: 1000px) {
                    .product-category-page {
                        flex-direction: column;
                        padding: 0 20px;
                    }

                    .sidebar {
                        position: static;
                        flex: 1;
                        margin-bottom: 30px;
                    }

                    .grid-item {
                        aspect-ratio: 1 / 1;
                    }

                    body {
                        font-size: 17px;
                    }
                }
            </style>

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

                        <div class="sidebar-divider"></div>

                        <div class="price-filer">
                            <h3>가격</h3>
                            <ul>
                                <li v-for="(range, index) in priceRanges" :key="index"
                                    :class="{ active: selectedPriceRange === index }" @click="selectedPriceRange = index">
                                    {{ range.label }}
                                </li>
                            </ul>
                        </div>

                    </div>

                    <!-- 우측 콘텐츠 -->
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
                            <div class="grid">
                                <div class="grid-item" v-for="p in parentCategories" :key="p.categoryNo"
                                    @click="toggleParent(p.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="p.imageUrl || '/resources/img/category/noimage.png'" alt="대분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ p.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 중분류 -->
                        <div v-else-if="viewLevel === 'child'">
                            <div class="grid">
                                <div class="grid-item" v-for="m in getChildCategories(selectedParent)"
                                    :key="m.categoryNo" @click="toggleChild(m.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="m.imageUrl || '/resources/img/category/noimage.png'" alt="중분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ m.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 소분류 -->
                        <div v-else-if="viewLevel === 'sub'">
                            <div class="grid">
                                <div class="grid-item" v-for="s in getChildCategories(selectedChild)"
                                    :key="s.categoryNo" @click="selectSub(s.categoryNo)">
                                    <div class="image-wrapper">
                                        <img :src="s.imageUrl || '/resources/img/category/noimage.png'" alt="소분류 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ s.categoryName }}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 상품 -->
                        <div v-else-if="viewLevel === 'product'">
                            <div class="grid">
                                <div class="grid-item product" v-for="p in filteredProducts" :key="p.productNo"
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
                            // 서버가 넘겨주는 초기 진입 카테고리(없으면 빈 문자열)
                            initialCategoryNo: '${categoryNo}',

                            priceRanges: [
                                { label: '5,000원 미만', min: 0, max: 5000 },
                                { label: '5,000원 ~ 10,000원', min: 5000, max: 10000 },
                                { label: '10,000원 ~ 20,000원', min: 10000, max: 20000 },
                                { label: '20,000원 ~ 30,000원', min: 20000, max: 30000 },
                                { label: '30,000원 이상', min: 30000, max: Infinity }
                            ],
                            selectedPriceRange: null
                        };
                    },
                    computed: {
                        parentCategories() {
                            return this.categoryList.filter(c => c.parentCategoryNo === '');
                        },

                        filteredProducts() {
                            let result = this.productList || [];
                            console.log('------ ',this.productList && this.productList[0]);
                            console.log('현재 선택된 가격범위 index:', this.selectedPriceRange);
                            console.log('현재 선택된 가격범위 값:', this.priceRanges[this.selectedPriceRange]);

                            //기존 카테고리
                            if (this.selectedSub) {
                                result = result.filter(
                                    (p) => Number(p.categoryNo) === Number(this.selectedSub));
                            }

                            //가격 필터 추가
                            if (this.selectedPriceRange !== null && this.selectedPriceRange !== undefined) {
                                const range = this.priceRanges[this.selectedPriceRange];
                                result = result.filter((p) => {
                                    const price = Number(p.price);
                                    if(isNaN(price)) return false; //가격정보 없으면 제외
                                    return price >= range.min && price < range.max;
                                });
                            }

                            console.log('필터 적용 후 상품 수:', result.length);
                            return result;
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