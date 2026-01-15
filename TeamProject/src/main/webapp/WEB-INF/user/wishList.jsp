<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 찜 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/resources/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        .wish-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
            min-height: 600px;
        }
        
        .wish-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }
        
        .wish-title-box h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .wish-title-box p {
            font-size: 14px;
            color: #666;
        }
        
        .wish-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-select-all,
        .btn-delete-selected {
            padding: 8px 16px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: #fff;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-select-all:hover {
            background: #f8f8f8;
        }
        
        .btn-delete-selected {
            border-color: #ff4444;
            color: #ff4444;
        }
        
        .btn-delete-selected:hover {
            background: #fff5f5;
        }
        
        .wish-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .wish-item {
            display: flex;
            gap: 16px;
            padding: 20px;
            background: #fff;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .wish-item:last-child {
            border-bottom: none;
        }
        
        .wish-checkbox {
            display: flex;
            align-items: center;
            margin-right: 10px;
        }
        
        .wish-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #5dbb63;
        }
        
        .wish-image {
            width: 120px;
            height: 120px;
            flex-shrink: 0;
            background: #f8f8f8;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
        }
        
        .wish-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .wish-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        
        .wish-seller {
            font-size: 13px;
            color: #888;
        }
        
        .wish-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .wish-name:hover {
            color: #5dbb63;
        }
        
        .wish-price {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-top: 4px;
        }
        
        .wish-buttons {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 140px;
        }
        
        .btn-detail,
        .btn-remove {
            width: 100%;
            padding: 10px 0;
            font-size: 14px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }
        
        .btn-detail {
            background: #333;
            color: #fff;
            border: 1px solid #333;
        }
        
        .btn-detail:hover {
            background: #444;
        }
        
        .btn-remove {
            background: #fff;
            border: 1px solid #ddd;
            color: #666;
        }
        
        .btn-remove:hover {
            background: #f8f8f8;
            color: #ff4444;
            border-color: #ff4444;
        }
        
        .empty-wish {
            text-align: center;
            padding: 120px 0;
            color: #888;
            background: #f9f9f9;
            border-radius: 12px;
        }
        
        .empty-wish p {
            font-size: 18px;
            margin-bottom: 24px;
        }
        
        .btn-go-shop {
            display: inline-block;
            padding: 14px 40px;
            background: #5dbb63;
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
        }
        
        .btn-go-shop:hover {
            background: #4da554;
        }
        /* 품절/숨김 상태 스타일 */
        .wish-item.soldout {
            background-color: #f9f9f9;
        }
        .wish-item.soldout .wish-image img {
            filter: grayscale(100%);
            opacity: 0.6;
        }
        .wish-item.soldout .wish-name {
            color: #999;
            text-decoration: line-through;
        }

        /* 상태 배지 (이미지 위) */
        .status-badge {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: bold;
            font-size: 16px;
            z-index: 2;
        }
        .wish-image {
            position: relative; 
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <div id="app">
        <div class="wish-container">
            <div class="wish-header">
                <div class="wish-title-box">
                    <h2>찜한 상품</h2>
                    <p>마음에 드는 상품을 한눈에 모아보세요.</p>
                </div>
                <div class="wish-actions" v-if="list.length > 0">
                    <button class="btn-select-all" @click="fnToggleAll">
                        {{ allSelected ? '전체해제' : '전체선택' }}
                    </button>
                    <button class="btn-delete-selected" @click="fnDeleteSelected">선택삭제</button>
                </div>
            </div>
            
            <div v-if="list.length > 0">
                <div class="wish-list">
                    <div v-for="item in list" :key="item.productNo"
                        class="wish-item"
                        :class="{ 'soldout': item.productStatus !== 'SELLING' }">

                        <div class="wish-checkbox">
                            <input type="checkbox" :value="item.productNo" v-model="selectedItems">
                        </div>

                        <div class="wish-image" @click="fnDetail(item.productNo)">
                            <img :src="item.imagePath || '/resources/img/no-image.png'" alt="상품이미지"
                                @error="item.imagePath='/resources/img/no-image.png'">

                            <div v-if="item.productStatus === 'SOLDOUT'" class="status-badge">품절</div>
                            <div v-if="item.productStatus === 'HIDDEN'" class="status-badge">판매중지</div>
                        </div>

                        <div class="wish-info">
                            <div class="wish-seller">{{ item.sellerName || '판매자 정보 없음' }}</div>
                            <div class="wish-name" @click="fnDetail(item.productNo)">{{ item.pName }}</div>
                            <div class="wish-price">{{ Number(item.price).toLocaleString() }}원</div>
                        </div>

                        <div class="wish-buttons">
                            <button class="btn-detail" @click="fnDetail(item.productNo)"
                                    :disabled="item.productStatus !== 'SELLING'">
                                {{ item.productStatus === 'SELLING' ? '상세보기' : '구매불가' }}
                            </button>
                            <button class="btn-remove" @click="fnRemove(item.productNo)">삭제</button>
                        </div>
                    </div>
                </div>
            </div>

            <div v-else class="empty-wish">
                <p>아직 찜한 상품이 없어요.</p>
                <a href="/main.do" class="btn-go-shop">상품 구경하러 가기</a>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    selectedItems: [],
                    userId: "${sessionScope.sessionId}"
                }
            },
            computed: {
                allSelected() {
                    return this.list.length > 0 && this.selectedItems.length === this.list.length;
                }
            },
            methods: {
                // 찜 목록 조회
                fnList() {
                    let self = this;
                    $.ajax({
                        url: "/wishlist/list.dox",
                        type: "POST",
                        dataType: "json",
                        success: function(data) {
                            if(data.result === "success") {
                                self.list = data.list;
                            }
                        }
                    });
                },
                fnToggleAll() {
                    if(this.allSelected) {
                        this.selectedItems = [];
                    } else {
                        this.selectedItems = this.list.map(item => item.productNo);
                    }
                },
                fnDeleteSelected() {
                    if(this.selectedItems.length === 0) {
                        alert("삭제할 상품을 선택해주세요.");
                        return;
                    }
                    if(!confirm(this.selectedItems.length + "개의 상품을 찜 목록에서 삭제하시겠습니까?")) return;

                    let self = this;
                    $.ajax({
                        url: "/wishlist/deleteMulti.dox", 
                        type: "POST",
                        dataType: "json",
                        data: {
                            selectItem: JSON.stringify(self.selectedItems)
                        },
                        success: function(data) {
                            if(data.result === "success") {
                                alert("선택한 상품이 삭제되었습니다.");
                                self.list = self.list.filter(item => !self.selectedItems.includes(item.productNo));
                                self.selectedItems = [];
                            } else {
                                alert("삭제 처리 중 오류가 발생했습니다: " + data.message);
                            }
                        }
                    });
                },
                // 상세 페이지 이동
                fnDetail(productNo) {
                    location.href = "/productInfo.do?productNo=" + productNo;
                },
                // 개별 삭제
                fnRemove(productNo) {
                    if(!confirm("이 상품을 찜 목록에서 삭제하시겠습니까?")) return;
                    let self = this;
                    $.ajax({
                        url: "/wishlist/toggle.dox",
                        type: "POST",
                        dataType: "json",
                        data: { productNo: productNo },
                        success: function(data) {
                            if(data.result === "success") {
                                self.list = self.list.filter(item => item.productNo !== productNo);
                                self.selectedItems = self.selectedItems.filter(no => no !== productNo);
                            }
                        }
                    });
                }
            },
            mounted() {
                if(!this.userId) {
                    alert("로그인이 필요한 페이지입니다.");
                    location.href = "/login.do";
                    return;
                }
                this.fnList();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>