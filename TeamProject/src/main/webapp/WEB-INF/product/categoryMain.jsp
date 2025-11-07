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
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <style>
                [v-cloak] {
                    display: none !important;
                }

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
                    margin: 30px auto;
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
                    font-weight: bold;
                }

                /* ===== 좌우 구분선 ===== */
                .division-bar {
                    width: 1px;
                    background: linear-gradient(to bottom, #d0d0d0, #e8e8e8);
                    border-radius: 1px;
                    align-self: stretch;
                    height: auto;
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
                    gap: 50px;
                    width: 80%;
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
                    margin-top: 25px;
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
                    align-items: left;
                    padding: 8px;
                }

                .grid-item .info h4 {
                    font-size: 25px;
                    font-weight: 600;
                    margin-top: -10px;
                    color: #333;
                }

                /* ===== 상품 카드 ===== */
                .grid-item.product {
                    aspect-ratio: 3 / 5.5;
                }

                .grid-item.product .info {
                    flex: 1;
                    background: transparent;
                    text-align: center;
                    padding: 6px;
                    margin-top: 10px;
                }

                .grid-item.product .info h4 {
                    font-size: 22px;
                    font-weight: bold;
                    color: blue;
                    margin-bottom: 3px;
                    text-align: left;
                }

                .grid-item.product .info .desc {
                    font-size: 18px;
                    color: black;
                    margin-bottom: 3px;
                    line-height: 1.4;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    text-align: left;
                }

                .grid-item.product .info .price {
                    color: #2e7d32;
                    font-weight: bold;
                    font-size: 22px;
                    text-align: left;
                }

                .grid-item.product .info .review {
                    display: flex;
                    align-items: center;
                    gap: 4px;
                    margin-top: 4px;
                }

                /* 별 평점 */
                .full-star {
                    color: #FFD700;
                }

                .half-star {
                    color: #FFD700;
                }

                .empty-star {
                    color: #ccc;
                }

                .rating-number {
                    margin-left: 4px;
                    font-size: 0.9em;
                    color: #555;
                }

                .grid-item.product .info .date {
                    color: black;
                    font-size: 20px;
                    text-align: left;
                }

                .grid-item.product .info .region {
                    color: cornflowerblue;
                    font-size: 20px;
                    text-align: left;
                }

                .grid-item.product .info .seller {
                    color: green;
                    font-size: 20px;
                    text-align: left;
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

                /* ===== 구분선 ===== */
                .sidebar-divider {
                    width: 80%;
                    height: 1px;
                    background-color: #ddd;
                    margin: 25px 0;
                }

                .topbar-divider {
                    width: 90%;
                    height: 1px;
                    background-color: #ddd;
                    margin-top: -5px;
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

                /* ===== 검색결과 적을 때 ===== */
                .content .grid {
                    justify-content: start;
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    max-width: 1500px;
                    margin: 0 50px;
                    text-align: center;
                }

                @media (min-width: 1200px) {
                    .content .grid:has(.grid-item:nth-child(3)) {
                        max-width: 100%;
                    }
                }

                /* ===== 반응형 ===== */
                @media (max-width: 1400px) {
                    .product-category-page {
                        flex-direction: column;
                        align-items: center;
                        gap: 40px;
                        padding: 0 30px;
                    }

                    .sidebar {
                        width: 100%;
                        max-width: 700px;
                        position: relative;
                        top: 0;
                        text-align: center;
                    }

                    .division-bar {
                        display: none;
                    }

                    .content {
                        width: 100%;
                    }

                    .content .grid {
                        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                        gap: 40px;
                        width: 100%;
                        margin: 0 auto;
                    }

                    .grid-item.product .info h4 {
                        font-size: 21px;
                    }
                }

                @media (max-width: 900px) {
                    .content .grid {
                        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                        gap: 35px;
                        width: 95%;
                    }

                    .grid-item.product .info h4 {
                        font-size: 20px;
                    }

                    .btn-register {
                        width: 100%;
                        font-size: 17px;
                    }
                }

                @media (max-width: 600px) {
                    body {
                        font-size: 16px;
                        line-height: 1.5;
                    }

                    .product-category-page {
                        padding: 0 15px;
                        gap: 30px;
                    }

                    .sidebar h3 {
                        font-size: 20px;
                    }

                    .grid-item.product {
                        aspect-ratio: 3 / 4.5;
                    }

                    .grid-item.product .info {
                        padding: 4px;
                    }

                    .grid-item.product .info h4 {
                        font-size: 18px;
                    }

                    .grid-item.product .info .price {
                        font-size: 20px;
                    }

                    .grid-item.product .info .region,
                    .grid-item.product .info .seller,
                    .grid-item.product .info .date {
                        font-size: 17px;
                    }
                }
            </style>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app" class="product-category-page" data-session-status="<c:out value='${sessionStatus}'/>">
                    <!-- 좌측 트리 -->
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h3>카테고리</h3>
                            <c:if test="${sessionStatus eq 'SELLER' and sellerVerifiedStatus eq 'Y'}">
                                <button class="btn-register" @click="goToProductRegister">상품등록</button>
                            </c:if>
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

                        <span v-if="viewLevel === 'product'">
                            <div class="sidebar-divider"></div>

                            <div class="price-filer">
                                <h3>가격</h3>
                                <ul>
                                    <li v-for="(range, index) in priceRanges" :key="index"
                                        :class="{ active: selectedPriceRange === index }"
                                        @click="selectedPriceRange = index">
                                        {{ range.label }}
                                    </li>
                                </ul>
                            </div>
                        </span>

                    </div>

                    <div class="division-bar"></div>

                    <!-- 우측 콘텐츠 -->
                    <div class="content">
                        <!-- Breadcrumb -->
                        <div class="breadcrumb" v-if="breadcrumb.length > 0">
                            <span v-for="(b, i) in breadcrumb" :key="i" @click="goToLevel(i)">
                                {{ b }}
                                <span v-if="i < breadcrumb.length - 1" class="breadcrumb-sep">></span>
                            </span>
                        </div>

                        <div class="topbar-divider"></div>

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
                                    <div class="image-wrapper">
                                        <img :src="p.filePath || '/resources/img/category/noimage.jpg'" alt="상품 이미지">
                                    </div>
                                    <div class="info">
                                        <h4>{{ p.pName }}</h4>
                                        <div class="desc">{{p.pInfo}}</div>
                                        <div class="price">{{ p.price.toLocaleString() }}원</div>
                                        <div class="review">
                                            <span v-for="i in 5" :key="i">
                                                <i v-if="Number(p.rating) >= i" class="fas fa-star full-star"></i>
                                                <i v-else-if="Number(p.rating) >= i - 0.5"
                                                    class="fas fa-star-half-alt half-star"></i>
                                                <i v-else class="far fa-star empty-star"></i>
                                            </span>
                                            <span class="rating-number">
                                                ({{ p.rating ? Number(p.rating).toFixed(1) : '0.0' }})
                                            </span>
                                        </div>
                                        <div class="date">📅생산일: {{p.cdate}}</div>
                                        <div class="region">🌾원산지: {{p.origin}}</div>
                                        <div class="seller">👨‍🌾Agricola: {{p.userName}}</div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="filteredProducts.length === 0"
                                style="font-size: 50px; text-align: center; color: #2e7d32; padding-top: 30px;">
                                등록된 상품이 없습니다. 곧 다시 뵙겠습니다.
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </body>

        </html>



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
                        selectedPriceRange: null,
                        sessionStatus: ''
                    };
                },
                computed: {
                    parentCategories() {
                        return this.categoryList.filter(c => c.parentCategoryNo === '');
                    },

                    filteredProducts() {
                        let result = this.productList || [];
                        console.log('------ ', this.productList && this.productList[0]);
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
                                if (isNaN(price)) return false; //가격정보 없으면 제외
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
                    },

                    isSeller() {
                        return (this.sessionStatus || '').toUpperCase() === 'SELLER';
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
                                this.writeHash(false); // 현재 상태를 URL에 기록 (해시만)
                            }
                        });
                    },

                    writeHash(push = ture) {
                        const q = new URLSearchParams();

                        if (this.selectedParent) q.set('p', this.selectedParent);
                        if (this.selectedChild) q.set('c', this.selectedChild);
                        if (this.selectedSub) q.set('s', this.selectedSub);
                        q.set('v', this.viewLevel);
                        const newHash = '#' + q.toString();

                        if (location.hash !== newHash) {
                            if (push) {
                                history.pushState(null, '', location.pathname + newHash);
                            } else {
                                history.replaceState(null, '', location.pathname + newHash);
                            }
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
                        this.writeHash(true);
                    },
                    toggleChild(no) {
                        const id = String(no);
                        if (this.selectedChild === id) {
                            this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child';
                        } else {
                            this.selectedChild = id; this.selectedSub = ''; this.viewLevel = 'sub';
                        }
                        this.writeHash(true);
                    },
                    selectSub(no) {
                        this.selectedSub = String(no);
                        this.viewLevel = 'product';
                        this.writeHash(true);
                    },
                    goToLevel(index) {
                        if (index === 0) { this.selectedChild = ''; this.selectedSub = ''; this.viewLevel = 'child'; }
                        else if (index === 1) { this.selectedSub = ''; this.viewLevel = 'sub'; }
                        this.writeHash(true);
                    },

                    fnView(productNo) {
                        pageChange("/productInfo.do", { productNo });
                        console.log('productNo:   ', productNo);
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

                    const root = document.getElementById('app');
                    // 1차: 현재 페이지의 data-session-status
                    let role = root?.dataset?.sessionStatus || '';
                    // 2차 보조: 헤더의 마이페이지 버튼에 data-status가 박혀있다면 활용
                    if (!role) {
                        role = document.querySelector('#btnMyPage')?.dataset?.status || '';
                    }
                    this.sessionStatus = role;
                }
            });
            app.mount("#app");
        </script>