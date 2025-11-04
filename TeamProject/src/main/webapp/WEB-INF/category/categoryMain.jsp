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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>

        body { font-family: "Noto Sans KR", sans-serif; background: #fafafa; margin: 0; }
        .product-category-page {
            display: flex; 
            flex-direction: row;
            align-items: flex-start;
            justify-content: space-between;
            max-width: 1400px; 
            margin: 40px auto; 
            padding: 0 20px;
            gap: 30px; }

        /* ---- 좌측 트리 ---- */
        .product-category-page .sidebar {
            flex: 0 0 250px;
            background: white;
            padding: 20px; 
            border-radius: 15px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
            background-color: #4CAF50; /* 녹색 */
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 12px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-register:hover {
            background-color: #45a049; /* hover 시 조금 진하게 */
        }

        .sidebar h3{
            color:#1a5d1a;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .sidebar ul { list-style: none; padding-left: 12px; }
        .sidebar li { cursor: pointer; padding: 6px 8px; border-radius: 6px; transition: 0.2s; }
        .sidebar li:hover { background: #e8f5e9; }
        .active { background: #c8e6c9; font-weight: bold; }

        /* ---- 우측 Grid ---- */
        .content { flex: 3; background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .section-title { font-size: 16px; font-weight: bold; margin-bottom: 15px; color: #2e7d32; border-bottom: 2px solid #2e7d32; padding-bottom: 5px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; }

        /* ---- 카드 ---- */
        .grid-item { text-align: center; padding: 20px; border: 1px solid #ddd; border-radius: 10px; transition: 0.2s; cursor: pointer; background: #fafafa; }
        .grid-item:hover { background: #f1f8e9; transform: translateY(-3px); }
        .grid-item img { width: 140px; height: 140px; object-fit: cover; border-radius: 8px; margin-bottom: 8px; }

        /* ---- breadcrumb ---- */
        .breadcrumb { font-size: 16px; margin-bottom: 10px; color: #666; }
        .breadcrumb span { color: #2e7d32; font-weight: bold; cursor: pointer; }
        .breadcrumb-sep { margin: 0 6px; color: #aaa; }

        .price { color: #388e3c; font-weight: bold; }
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
                <div @click="toggleParent(p.categoryNo)" :class="{ active: selectedParent === p.categoryNo }">
                    {{ p.categoryName }}
                </div>
                <ul v-if="selectedParent === p.categoryNo">
                    <li v-for="m in getChildCategories(p.categoryNo)" :key="m.categoryNo">
                        <div @click.stop="toggleChild(m.categoryNo)" :class="{ active: selectedChild === m.categoryNo }">
                            {{ m.categoryName }}
                        </div>
                        <ul v-if="selectedChild === m.categoryNo">
                            <li v-for="s in getChildCategories(m.categoryNo)" :key="s.categoryNo"
                                @click.stop="selectSub(s.categoryNo)" :class="{ active: selectedSub === s.categoryNo }">
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
                <div class="grid-item" v-for="m in getChildCategories(selectedParent)" :key="m.categoryNo"
                     @click="toggleChild(m.categoryNo)">
                    <img :src="m.imageUrl || '/resources/img/category/noimage.png'" alt="중분류 이미지">
                    {{ m.categoryName }}
                </div>
            </div>
        </div>

        <!-- 소분류 {{ getCategoryName(selectedChild) }} -->
        <div v-else-if="viewLevel === 'sub'">
            <div class="section-title"></div>
            <div class="grid">
                <div class="grid-item" v-for="s in getChildCategories(selectedChild)" :key="s.categoryNo"
                     @click="selectSub(s.categoryNo)">
                    <img :src="s.imageUrl || '/resources/img/category/noimage.png'" alt="소분류 이미지">
                    {{ s.categoryName }}
                </div>
            </div>
        </div>

        <!-- 상품 {{ getCategoryName(selectedSub) }}-->
        <div v-else-if="viewLevel === 'product'">
            <div class="section-title"></div>
            <div class="grid">
                <a class="grid-item" v-for="p in filteredProducts" :key="p.productNo"
                   :href="'/productInfo.do?productNo=' + p.productNo">
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
            initialCategoryNo: '${categoryNo}' // URL로부터 전달받은 값
        }
    },
    computed: {
        parentCategories() {
            return this.categoryList.filter(c => !c.parentCategoryNo);
        },
        filteredProducts() {
            return this.productList.filter(p => Number(p.categoryNo) === Number(this.selectedSub));
        },
        breadcrumb() {
            const result = [];
            if (this.selectedParent) result.push(this.getCategoryName(this.selectedParent));                
            if (this.selectedChild) result.push(this.getCategoryName(this.selectedChild));
            if (this.selectedSub) result.push(this.getCategoryName(this.selectedSub));
            return result;
        }
    },
    methods: {
        fnLoad() {
            $.post("/categoryProductList.dox", {}, data => {
                if (data.result === "success") {
                    this.categoryList = data.categories;
                    this.productList = data.list;
                    console.log("카테고리 리스트:", this.categoryList[0]?.imageUrl);

                    // 카테고리 데이터 로드 후 URL 값 적용
                    this.applyInitialCategory();
                }
            }, "json");
        },
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
                this.viewLevel = 'parent';
            } else {
                this.selectedParent = no;
                this.selectedChild = '';
                this.selectedSub = '';
                this.viewLevel = 'child';
            }
        },
        toggleChild(no) {
            if (this.selectedChild === no) {
                this.selectedChild = '';
                this.viewLevel = 'child';
            } else {
                this.selectedChild = no;
                this.selectedSub = '';
                this.viewLevel = 'sub';
            }
        },
        selectSub(no) {
            this.selectedSub = no;
            this.viewLevel = 'product';
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
        },

        // URL에서 categoryNo 추출
        getCategoryFromURL() {
            const path = window.location.pathname;
            const match = path.match(/\/category\/(\d+)/);
            return match ? match[1] : '';
        },

        // URL에 맞게 초기 상태 설정
        applyInitialCategory() {
            const no = Number(this.initialCategoryNo);
            if (!no) return;

            const target = this.categoryList.find(c => Number(c.categoryNo) === no);
            if (!target) return;

            // target의 부모 트리 찾아서 레벨 세팅
            if (!target.parentCategoryNo) {
                // 대분류
                this.selectedParent = no;
                this.viewLevel = 'child';
            } else {
                const parent = this.categoryList.find(c => c.categoryNo === target.parentCategoryNo);
                if (parent && !parent.parentCategoryNo) {
                    // 중분류
                    this.selectedParent = parent.categoryNo;
                    this.selectedChild = no;
                    this.viewLevel = 'sub';
                } else if (parent && parent.parentCategoryNo) {
                    // 소분류
                    const top = this.categoryList.find(c => c.categoryNo === parent.parentCategoryNo);
                    this.selectedParent = top ? top.categoryNo : '';
                    this.selectedChild = parent.categoryNo;
                    this.selectedSub = no;
                    this.viewLevel = 'product';
                }
            }
        },

        goToProductRegister() {
        window.location.href = '/product/add.do';
        }
    },
    mounted() {

        if (this.initialCategoryNo) {
            console.log("받은 categoryNo:", this.initialCategoryNo);
        }
        this.fnLoad(); // 카테고리 로드 후 자동 적용
    }
});
app.mount("#app");
</script>
</body>
</html>