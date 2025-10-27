<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>농수산물 직거래 장터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        /* 기본 레이아웃 */
        html, body { 
            margin:0; 
            height:100%; 
            font-family: 'Noto Sans', sans-serif; 
        }
        #app { 
            min-height:100vh; 
            display:flex; 
            flex-direction:column; 
        }
        main.content { 
            flex:1; 
            padding:2rem; 
        }
        /* 사용자 배너 */
        .user-banner { 
            padding:1.5rem; 
            margin-bottom:2rem; 
            border-radius:0.5rem; 
            background:linear-gradient(to right, #ecfdf5, #d1fae5); 
            display:flex; 
            gap:1rem; 
            align-items:center; 
        }
        .user-initial { 
            width:4rem; 
            height:4rem; 
            background:#10b981; 
            border-radius:9999px; 
            display:flex; 
            align-items:center; 
            justify-content:center; 
            color:white; 
            font-size:1.5rem; 
            font-weight:bold; 
        }
        .user-info h2 { 
            font-size:1.25rem; 
            font-weight:bold; 
        }
        .user-info p { 
            font-size:0.875rem; 
            color:#6b7280; 
        }

        /* 카드 */
        .card { 
            padding:1rem; 
            border-radius:0.5rem; 
            border:1px solid #e5e7eb; 
            background:white; 
        }
        .card + .card { 
            margin-top:1rem; 
        }

        /* 버튼 */
        .btn { 
            padding:0.5rem 1rem; 
            border-radius:0.375rem; 
            cursor:pointer; 
        }
        .btn-outline { 
            border:1px solid #d1d5db; 
            background:white; 
        }
        .btn-destructive { 
            background:#ef4444; 
            color:white; 
        }
        .btn-green { 
            background:#10b981; 
            color:white; 
        }

        /* 탭 */
        .tabs-list { 
            display:grid; 
            grid-template-columns:repeat(4,1fr); 
            border-bottom:1px solid #e5e7eb; 
            margin-bottom:2rem; 
        }
        .tabs-list button { 
            padding:0.5rem 1rem; 
            background:none; 
            border:none; 
            cursor:pointer; 
            font-weight:500; 
        }
        .tabs-list button.active { 
            border-bottom:2px solid #10b981; 
            font-weight:bold; 
        }
    </style>
</head>
<body>
<div id="app">
    <%@ include file="/WEB-INF/views/common/header.jsp" %> <!-- 헤더 -->
    <main class="content container mx-auto">
        <!-- 사용자 배너 -->
        <div class="user-banner" v-if="user">
            <div class="user-initial">{{ user.initial }}</div>
            <div class="user-info">
                <h2>{{ user.name }}님</h2>
                <p>{{ user.email }}</p>
            </div>
        </div>

        <!-- Tabs -->
        <div>
            <div class="tabs-list">
                <button :class="{active: activeTab==='cart'}" @click="activeTab='cart'">장바구니</button>
                <button :class="{active: activeTab==='orders'}" @click="activeTab='orders'">주문내역</button>
                <button :class="{active: activeTab==='reviews'}" @click="activeTab='reviews'">리뷰 관리</button>
                <button :class="{active: activeTab==='profile'}" @click="activeTab='profile'">회원정보</button>
            </div>

            <!-- 장바구니 -->
            <div v-if="activeTab==='cart'" class="space-y-4">
                <div v-for="item in cartItems" :key="item.id" class="card flex items-center gap-4">
                    <div class="w-20 h-20 bg-gray-200 rounded"></div>
                    <div class="flex-1">
                        <h3 class="font-semibold">{{ item.name }}</h3>
                        <p class="text-sm text-gray-500">{{ item.desc }}</p>
                        <p class="font-bold mt-2">{{ item.price }}원</p>
                    </div>
                    <div class="flex items-center gap-2">
                        <button @click="decreaseQty(item)" class="btn btn-outline">-</button>
                        <span class="w-8 text-center">{{ item.qty }}</span>
                        <button @click="increaseQty(item)" class="btn btn-outline">+</button>
                    </div>
                    <button @click="removeItem(item)" class="btn btn-destructive">삭제</button>
                </div>

                <div class="flex justify-end mt-6">
                    <div class="card w-80 space-y-2">
                        <div class="flex justify-between"><span>상품금액</span><span>{{ totalPrice }}원</span></div>
                        <div class="flex justify-between"><span>배송비</span><span>3,000원</span></div>
                        <div class="border-t pt-2 flex justify-between font-bold text-lg">
                            <span>총 결제금액</span>
                            <span class="text-green-500">{{ totalPrice + 3000 }}원</span>
                        </div>
                        <button class="btn btn-green w-full mt-4">주문하기</button>
                    </div>
                </div>
            </div>

            <!-- 주문내역 -->
            <div v-if="activeTab==='orders'" class="space-y-4">
                <div v-for="order in orders" :key="order.id" class="card">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-sm text-gray-500">{{ order.date }}</p>
                            <p class="font-semibold">주문번호: {{ order.number }}</p>
                        </div>
                        <span class="px-2 py-1 bg-green-100 text-green-600 rounded">{{ order.status }}</span>
                    </div>
                    <div class="flex gap-4">
                        <div class="w-20 h-20 bg-gray-200 rounded"></div>
                        <div class="flex-1">
                            <h3 class="font-semibold">{{ order.itemName }}</h3>
                            <p class="text-sm text-gray-500">수량: {{ order.qty }}개</p>
                            <p class="font-bold mt-2">{{ order.price }}원</p>
                        </div>
                        <div class="flex flex-col gap-2">
                            <button class="btn btn-outline">배송조회</button>
                            <button class="btn btn-outline">리뷰작성</button>
                            <button class="btn btn-outline text-red-500">환불신청</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 리뷰관리 -->
            <div v-if="activeTab==='reviews'" class="space-y-4">
                <div v-for="review in reviews" :key="review.id" class="card flex gap-4">
                    <div class="w-20 h-20 bg-gray-200 rounded"></div>
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-2">
                            <h3 class="font-semibold">{{ review.itemName }}</h3>
                            <div class="flex text-yellow-500">
                                <span v-for="s in review.stars" :key="s">★</span>
                            </div>
                        </div>
                        <p class="text-sm text-gray-500 mb-2">{{ review.date }}</p>
                        <p class="text-sm">{{ review.content }}</p>
                    </div>
                    <div class="flex flex-col gap-2">
                        <button class="btn btn-outline">수정</button>
                        <button class="btn btn-outline text-red-500">삭제</button>
                    </div>
                </div>
            </div>

            <!-- 회원정보 -->
            <div v-if="activeTab==='profile'" class="card max-w-2xl mx-auto space-y-4">
                <div v-for="field in profileFields" :key="field.label" class="space-y-2">
                    <label class="font-semibold">{{ field.label }}</label>
                    <input v-model="field.value" :type="field.type" class="w-full border rounded p-2" :placeholder="field.placeholder"/>
                </div>
                <div class="flex gap-2">
                    <button class="btn btn-green flex-1">저장하기</button>
                    <button class="btn btn-outline flex-1">취소</button>
                </div>
            </div>

        </div>
    </main>

    <!-- Footer -->
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %> <!-- 푸터 -->
    
</div>
</body>
</html>
<script>
const app = Vue.createApp({
    data() {
        return {
            activeTab: 'cart',
            user: { name: '홍길동', email: 'hong@example.com', initial: '홍' },
            cartItems: [
                { id: 1, name: '제주 감귤 5kg', desc: '신선한 제주 감귤', price: 25000, qty: 1 },
                { id: 2, name: '사과 3kg', desc: '달콤한 사과', price: 18000, qty: 1 },
                { id: 3, name: '배 5kg', desc: '신선한 배', price: 20000, qty: 1 },
            ],
            orders: [
                { id: 1, date:'2024.01.15', number:'20240115-001', status:'배송완료', itemName:'제주 감귤 5kg', qty:1, price:25000 },
                { id: 2, date:'2024.01.16', number:'20240116-002', status:'배송중', itemName:'사과 3kg', qty:2, price:36000 },
            ],
            reviews: [
                { id:1, itemName:'제주 감귤 5kg', stars: [1,2,3,4,5], date:'2024.01.20', content:'정말 신선하고 맛있어요! 다음에도 구매할게요.' },
                { id:2, itemName:'사과 3kg', stars: [1,2,3,4], date:'2024.01.22', content:'맛있지만 조금 시네요.' },
            ],
            profileFields: [
                { label:'이름', value:'홍길동', type:'text' },
                { label:'이메일', value:'hong@example.com', type:'email' },
                { label:'전화번호', value:'010-1234-5678', type:'text' },
                { label:'주소', value:'서울시 강남구 테헤란로 123', type:'text' },
                { label:'비밀번호 변경', value:'', type:'password', placeholder:'새 비밀번호' },
                { label:'비밀번호 확인', value:'', type:'password', placeholder:'새 비밀번호 확인' },
            ]
        }
    },
    computed: {
        totalPrice() { return this.cartItems.reduce((sum,item)=>sum + item.price*item.qty, 0); }
    },
    methods: {
        increaseQty(item){ item.qty++ },
        decreaseQty(item){ if(item.qty>1) item.qty-- },
        removeItem(item){ this.cartItems = this.cartItems.filter(i=>i.id!==item.id) }
    }
});
app.mount('#app');
</script>
