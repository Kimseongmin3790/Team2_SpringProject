<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGRICOLA - Main page</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const topButton = document.getElementById('scrollToTop');
            const bottomButton = document.getElementById('scrollToBottom');

            // **맨 위로 이동하는 함수**
            topButton.addEventListener('click', function() {
                window.scrollTo({
                    top: 0, /* 스크롤 위치 0 (맨 위) */
                    behavior: 'smooth' /* 부드러운 애니메이션 */
                });
            });

            // **맨 아래로 이동하는 함수**
            bottomButton.addEventListener('click', function() {
                window.scrollTo({
                    top: document.body.scrollHeight, /* 페이지의 전체 높이 (맨 아래) */
                    behavior: 'smooth' /* 부드러운 애니메이션 */
                });
            });
        });
    </script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            color: #333;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            flex: 1;
            padding: 0;
        }
        
        /* 메인 콘텐츠 스타일링 시작 */
        .fresh-section {
            background-color: #f7fff7; /* 이미지 상단 연한 녹색 배경 */
            padding: 80px 20px;
            text-align: center;
        }

        .fresh-section h2 {
            font-size: 2em;
            font-weight: bold;
            color: #2e8b57;
            margin-bottom: 10px;
        }

        .fresh-section p {
            font-size: 1.1em;
            color: #555;
            margin-bottom: 30px;
        }

        .action-buttons button {
            padding: 10px 20px;
            margin: 0 5px;
            border: 1px solid #2e8b57;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        .action-buttons .btn-primary {
            background-color: #388e3c; /* 짙은 녹색 */
            color: white;
            font-weight: bold;
        }

        .action-buttons .btn-secondary {
            background-color: white;
            color: #388e3c;
        }

        /* 혜택 아이콘 섹션 */
        /* ... (기존 CSS 유지) ... */

        /* 혜택 아이콘 섹션 */
        .benefits-section {
            display: flex;
            justify-content: center;
            padding: 50px 20px;
            gap: 80px;
            border-bottom: 1px solid #eee;
        }

        .benefit-item {
            text-align: center;
            width: 200px; /* 아이템 너비 조정 */
        }

        /* 🌟 benefit-icon 클래스 수정: 이미지를 직접 표시하도록 변경 🌟 */
        .benefit-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 10px;
            /* 기존 스타일 제거: border-radius, display: flex 등 */
        }

        /* 🌟 새로 추가: 이미지 태그에 적용될 스타일 🌟 */
        .benefit-icon img {
            width: 100%; /* 부모 div(benefit-icon)에 꽉 차도록 설정 */
            height: 100%;
            object-fit: contain; /* 이미지 비율 유지 */
        }

        .benefit-item p {
            font-size: 0.9em;
            color: #777;
            margin: 5px 0 0;
        }

        .benefit-item strong {
            display: block;
            font-size: 1.1em;
            color: #333;
            margin-top: 5px;
        }

        /* ... (나머지 기존 CSS 유지) ... */

        /* 베스트 상품 섹션 */
        .best-product-section {
            padding: 50px 20px;
            text-align: center;
        }

        .best-product-section h3 {
            font-size: 1.8em;
            margin-bottom: 40px;
            font-weight: normal;
        }

        .product-list {
            display: flex;
            justify-content: center;
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .product-card {
            width: 250px;
            border: 1px solid #ddd;
            padding: 15px;
            text-align: left;
        }

        .product-image-placeholder {
            width: 100%;
            height: 200px;
            background-color: #f0f0f0;
            margin-bottom: 15px;
        }

        .product-category {
            font-size: 0.85em;
            color: #999;
            margin-bottom: 5px;
        }

        .product-name {
            font-size: 1.1em;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .product-price {
            font-size: 1.2em;
            color: #388e3c;
            font-weight: bold;
        }
        /* 메인 콘텐츠 스타일링 끝 */

        .quick-remote {
            position: fixed; /* 👈 화면에 고정 */
            right: 20px; /* 👈 우측에서 20px 떨어진 위치 */
            bottom: 20px; /* 👈 하단에서 20px 떨어진 위치 */
            z-index: 1000; /* 👈 다른 요소 위에 나타나도록 설정 (높은 값) */
            display: flex;
            flex-direction: column;
            gap: 10px; /* 버튼 간 간격 */
        }

        .quick-remote button {
            /* 버튼 스타일 (예시) */
            width: 60px;
            height: 60px;
            background-color: #38a169; /* 녹색 계열 */
            color: white;
            border: none;
            border-radius: 8px; /* 둥근 모서리 */
            cursor: pointer;
            font-size: 12px;
            line-height: 1.2;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s;
        }

        .quick-remote button:hover {
            background-color: #2f855a; /* hover 시 색상 변경 */
        }

        /* 입점 업체 섹션 */
        .producer-section {
            padding: 60px 20px;
            text-align: center;
            background-color: #ffffff;
        }
        .producer-section h3 {
            font-size: 1.8em;
            margin-bottom: 5px;
        }
        .producer-section p {
            color: #777;
            margin-bottom: 40px;
        }
        .producer-list {
            display: flex;
            justify-content: center;
            gap: 40px;
            max-width: 1200px;
            margin: 0 auto;
            flex-wrap: wrap; /* 업체가 많을 경우 줄 바꿈 */
        }
        .producer-card {
            width: 180px;
            text-align: center;
        }
        .producer-logo {
            width: 100px;
            height: 100px;
            border: 1px solid #eee;
            border-radius: 50%;
            margin: 0 auto 15px;
            background-size: cover; /* 로고 이미지가 원 안에 꽉 차도록 */
            background-position: center;
        }
        .producer-card strong {
            display: block;
            font-size: 1.1em;
            margin-bottom: 5px;
        }
        .producer-card p {
            font-size: 0.9em;
            color: #999;
        }
        .main-slider-section {
            width: 100%;
            overflow: hidden; /* 슬라이드 영역 밖의 내용을 숨김 */
            position: relative; /* 화살표 및 인디케이터 배치를 위해 */
            height: 350px; /* 배너 높이 고정 */
        }

        .slider-track {
            display: flex;
            width: 100%; /* 초기 너비 (JS에서 재계산) */
            height: 100%;
            transition: transform 0.5s ease-in-out; /* 부드러운 전환 효과 */
            cursor: grab; /* 드래그 가능한 커서 */
        }

        .slider-track.dragging {
            cursor: grabbing; /* 드래그 중 커서 */
            transition: none; /* 드래그 중에는 애니메이션 제거 */
        }

        .slider-item {
            flex: 0 0 100%; /* 모든 아이템은 컨테이너 너비의 100%를 차지 */
            height: 100%;
            position: relative;
            display: block; /* a 태그가 블록 요소로 전체 영역을 차지하도록 */
        }

        .slider-item img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 이미지가 잘리지 않고 꽉 차도록 */
        }

        .slider-caption {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 1.1em;
        }

        .slider-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.3);
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            z-index: 10;
            font-size: 20px;
            border-radius: 50%;
            transition: background 0.3s;
        }

        .slider-arrow:hover {
            background: rgba(0, 0, 0, 0.6);
        }

        .arrow-prev { left: 20px; }
        .arrow-next { right: 20px; }

        .slider-dots {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
            display: flex;
            gap: 8px;
        }

        .dot {
            width: 10px;
            height: 10px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
        }

        .dot.active {
            background-color: #388e3c; /* 활성화된 점은 녹색 */
            transform: scale(1.2);
        }
        /* 🌟 슬라이더 CSS 추가 끝 🌟 */
        
    </style>
</head>

<body>
    <div id="app">
        <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <main class="content">
            
           <section class="main-slider-section">
                <div v-if="loadingBanner" style="text-align: center; line-height: 350px;">
                    <p>배너 로딩 중...</p>
                </div>
                <div v-else-if="errorBanner" style="text-align: center; line-height: 350px;">
                    <p style="color: red;">{{ errorBanner }}</p>
                </div>
                
                <div v-else class="slider-container" 
                    @mousedown="startDrag" 
                    @mousemove="dragging" 
                    @mouseup="endDrag" 
                    @mouseleave="endDrag"
                    @touchstart="startDrag"
                    @touchmove="dragging"
                    @touchend="endDrag"
                    >
                                        <div class="slider-track" ref="sliderTrack">
                        <a :href="item.linkUrl" class="slider-item" v-for="item in mainBanners" :key="item.id">
                            <img :src="path + item.imageUrl" :alt="item.title" draggable="false">                             <div class="slider-caption">{{ item.title }}</div>
                        </a>
                    </div>

                                        <button class="slider-arrow arrow-prev" @click.stop.prevent="prevSlide">
                        &lt;
                    </button>
                    <button class="slider-arrow arrow-next" @click.stop.prevent="nextSlide">
                        &gt;
                    </button>

                                        <div class="slider-dots">
                        <div class="dot" v-for="(dot, index) in mainBanners.length" :key="index"
                            :class="{ active: index === currentSlideIndex }" @click="goToSlide(index)">
                        </div>
                    </div>

                </div>
            </section>
            
            <section class="fresh-section">
                <h2>농부와 직접 이야기하고 구매하세요. 품질은 높이고 가격은 낮춘 직거래 마켓</h2>
                <p>궁금하면 농부에게 직접 물어보세요! 실시간 소통 직거래 마켓</p> <!-- 사이트 설명 -->
                <div class="action-buttons">
                    <button class="btn-primary" onclick="location.href='product/list'">쇼핑 시작하기</button>
                    <button class="btn-secondary" onclick="location.href='#'">소통 시작하기</button> <!-- 실시간 채팅 주소 이동     -->
                </div>
            </section>
            
            <section class="benefits-section">
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <!-- <img :src="path + '/img/delivery.png'" alt="당일 배송 아이콘"> -->
                        <img :src="path + '/resources/img/main/delivery.png'" alt="당일 배송 아이콘">
                    </div>
                    <strong>당일 배송</strong>
                    <p>오전 주문 시 당일 배송</p>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <!-- <img :src="path + '/img/fresh.png'" alt="신선 보장 아이콘"> -->
                        <img :src="path + '/resources/img/main/fresh.png'" alt="신선 보장 아이콘">
                    </div>
                    <strong>신선 보장</strong>
                    <p>100% 신선도 보장</p>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <!-- <img :src="path + '/img/deal.png'" alt="직거래 아이콘"> -->
                        <img :src="path + '/resources/img/main/deal.png'" alt="직거래 아이콘">
                    </div>
                    <strong>직거래</strong>
                    <p>생산자 직거래 시스템</p>
                </div>
            </section>

            <section class="producer-section">
                <h3>아그리콜라 입점업체</h3>
                <p>당신과 바로 이어지는 아그리콜라 입점 업체를 소개합니다.</p>
                
                <div v-if="loadingProducers">
                    <p>입점 업체 목록을 불러오는 중입니다...</p>
                </div>
                <div v-else-if="errorProducers">
                    <p style="color: red;">{{ errorProducers }}</p>
                </div>

                <div v-else class="producer-list">
                    <div class="producer-card" v-for="producer in producers" :key="producer.id" @click="location.href=producer.linkUrl" style="cursor:pointer;">
                        <div class="producer-logo" :style="{ backgroundImage: 'url(' + path + producer.logoUrl + ')' }">
                            </div>
                        <strong>{{ producer.name }}</strong>
                        <p>{{ producer.description }}</p>
                    </div>
                    
                    <div v-if="producers.length === 0">
                        <p>등록된 입점 업체가 없습니다.</p>
                    </div>
                </div>
            </section>

            <section class="best-product-section">
                <h3>이번 주 베스트</h3>
                
                <div v-if="loadingBest">
                    <p>베스트 상품 정보를 불러오는 중입니다...</p>
                </div>
                
                <div v-else-if="errorBest">
                    <p style="color: red;">{{ errorBest }}</p>
                </div>

                <div v-else class="product-list">
                    <div class="product-card" v-for="item in bestProducts" :key="item.id" @click="fnGoProductDetail(item.id)" style="cursor:pointer;">
                        <div class="product-image-placeholder"></div>
                        <p class="product-category">{{ item.category }}</p>
                        <p class="product-name">{{ item.name }}</p>
                        <p class="product-price">{{ item.price.toLocaleString() }}원</p>
                    </div>
                    
                    <div v-if="bestProducts.length === 0">
                        <p>이번 주 베스트 상품이 아직 등록되지 않았습니다.</p>
                    </div>
                </div>
            </section>

            <div class="quick-remote">
                <button id="scrollToTop">
                    🔝<br>맨 위로
                </button>
                <button id="scrollToBottom">
                    맨 아래로<br>⬇️
                </button>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 이미지에 보이는 베스트 상품 데이터 (임시 데이터)
                bestProducts : [],
                path : "${pageContext.request.contextPath}", // Context Path를 Vue 데이터로 가져옴
                
                mainBanners: [], // 배너 데이터를 담을 배열
                loadingBanner: true, // 배너 로딩 상태
                errorBanner: null, // 배너 오류 메시지

                // 🌟 슬라이더 관련 데이터 추가 시작 🌟
                currentSlideIndex: 0, // 현재 활성화된 슬라이드 인덱스
                autoSlideInterval: null, // 자동 슬라이드 인터벌 ID
                isDragging: false, // 드래그 중인지 여부
                dragStartX: 0, // 드래그 시작 X 좌표
                dragDeltaX: 0, // 드래그 이동 거리
                itemWidth: 0, // 슬라이드 하나의 너비 (드래그 계산용)
                // 🌟 슬라이더 관련 데이터 추가 끝 🌟

                loadingBest: true, // 베스트 상품 로딩 상태
                errorBest: null,   // 베스트 상품 오류 메시지

                // 🌟 입점 업체 데이터 변수 추가 🌟
                producers: [], // 입점 업체(생산자) 데이터를 담을 배열
                loadingProducers: true, // 입점 업체 로딩 상태
                errorProducers: null,  // 입점 업체 오류 메시지

                sessionId : "${sessionId}",
                status : "${sessionStatus}"
            };
        },
        methods: {  
            // 상품 목록을 AJAX로 불러오는 로직이 여기에 추가될 수 있습니다.
            fnGoProductDetail: function (productNo) {
                let self = this;
                if (!productNo){
                    console.error("상품 번호가 없습니다");
                    return;
                }
                //상품 상세 페이지 URL로 이동 (예시: /product/detail?productNo=101)
            location.href = self.path + "/product/detail?productNo=" + productNo;
            },
            
            // 🌟 슬라이더 초기화 및 자동 재생 설정 함수 🌟
            initializeSlider: function() {
                if (this.mainBanners.length > 0) {
                    this.$nextTick(() => {
                    setTimeout(() => { // 💡 DOM이 완전히 그려진 뒤 실행
                        const track = this.$refs.sliderTrack;
                        const container = track.parentElement;
                        this.itemWidth = container ? container.clientWidth : 0;

                        if (this.itemWidth > 0) {
                        track.style.width = `${this.mainBanners.length * this.itemWidth}px`;
                        this.startAutoSlide(4000);
                        this.updateSliderPosition(0, false);
                        } else {
                        console.error("❌ 슬라이더 너비를 계산할 수 없습니다.");
                        }
                    }, 100); // 약간의 딜레이
                    });
                }
                },

            // 🌟 슬라이드 위치 업데이트 함수 (핵심) 🌟
            updateSliderPosition: function(index, smooth = true) {
                if (this.mainBanners.length === 0) return;
                
                // 인덱스 보정 (무한 루프 방지)
                const maxIndex = this.mainBanners.length - 1;
                if (index > maxIndex) index = 0;
                if (index < 0) index = maxIndex;

                this.currentSlideIndex = index;

                const track = this.$refs.sliderTrack;
                if (track) {
                    track.style.transition = smooth ? 'transform 0.5s ease-in-out' : 'none';
                    track.style.transform = `translateX(-${index * 100}%)`;
                }
            },

            // 🌟 다음 슬라이드로 이동 🌟
            nextSlide: function() {
                this.stopAutoSlide(); // 수동 조작 시 자동 슬라이드 일시 정지
                let nextIndex = this.currentSlideIndex + 1;
                this.updateSliderPosition(nextIndex);
                this.startAutoSlide(4000); // 일정 시간 후 자동 슬라이드 재시작
            },

            // 🌟 이전 슬라이드로 이동 🌟
            prevSlide: function() {
                this.stopAutoSlide(); 
                let prevIndex = this.currentSlideIndex - 1;
                this.updateSliderPosition(prevIndex);
                this.startAutoSlide(4000); 
            },

            // 🌟 특정 슬라이드로 이동 (닷 클릭 시) 🌟
            goToSlide: function(index) {
                this.stopAutoSlide();
                this.updateSliderPosition(index);
                this.startAutoSlide(4000);
            },

            // 🌟 자동 슬라이드 시작/재시작 🌟
            startAutoSlide: function(duration) {
                this.stopAutoSlide(); // 기존 인터벌 정리
                if (this.mainBanners.length > 1) {
                    this.autoSlideInterval = setInterval(() => {
                        this.updateSliderPosition(this.currentSlideIndex + 1);
                    }, duration);
                }
            },

            // 🌟 자동 슬라이드 중지 🌟
            stopAutoSlide: function() {
                if (this.autoSlideInterval) {
                    clearInterval(this.autoSlideInterval);
                    this.autoSlideInterval = null;
                }
            },

            // ---------------- 드래그 이벤트 핸들러 ----------------
            // 🌟 드래그 시작 🌟
            startDrag: function(e) {
                if (this.mainBanners.length <= 1) return;
                
                this.stopAutoSlide();
                this.isDragging = true;
                this.dragStartX = e.clientX || e.touches[0].clientX;
                this.dragDeltaX = 0;
                
                const track = this.$refs.sliderTrack;
                if (track) {
                    track.classList.add('dragging'); // CSS 전환 효과 제거
                }
            },

            // 🌟 드래그 중 🌟
            dragging: function(e) {
                if (!this.isDragging) return;
                e.preventDefault();
                
                const currentX = e.clientX || e.touches[0].clientX;
                this.dragDeltaX = currentX - this.dragStartX;

                // 현재 위치 + 드래그 이동 거리를 적용
                const offset = -(this.currentSlideIndex * this.itemWidth) + this.dragDeltaX;
                
                const track = this.$refs.sliderTrack;
                if (track) {
                    track.style.transform = `translateX(${offset}px)`;
                }
            },

            // 🌟 드래그 종료 🌟
            endDrag: function(e) {
                if (!this.isDragging) return;
                
                this.isDragging = false;
                
                const track = this.$refs.sliderTrack;
                if (track) {
                    track.classList.remove('dragging');
                }

                // 이동 임계값 (슬라이드 너비의 10%)
                const threshold = this.itemWidth * 0.1; 

                if (this.dragDeltaX < -threshold) {
                    // 왼쪽으로 드래그 (다음 슬라이드)
                    this.updateSliderPosition(this.currentSlideIndex + 1);
                } else if (this.dragDeltaX > threshold) {
                    // 오른쪽으로 드래그 (이전 슬라이드)
                    this.updateSliderPosition(this.currentSlideIndex - 1);
                } else {
                    // 임계값 미만: 제자리로 복귀
                    this.updateSliderPosition(this.currentSlideIndex);
                }
                
                this.dragDeltaX = 0; // 드래그 상태 초기화
                this.startAutoSlide(4000); // 자동 슬라이드 재시작
            },

            // 🌟 새롭게 추가: 슬라이더 배너 데이터를 불러오는 함수 🌟
            fnGetMainBanners: function() {
                let self = this;
                self.loadingBanner = true;
                self.errorBanner = null;

                $.ajax({
                    url: self.path + "/main/data/banners",
                    dataType: "json",
                    type: "GET",
                    success: function (data) {
                        console.log("✅ 배너 데이터:", data);
                        self.mainBanners = data; 
                        
                        // 💡 핵심 수정: 데이터 로딩 완료 후 슬라이더 초기화 호출
                        self.initializeSlider(); 
                    },
                    error: function(xhr, status, error) {
                        console.error("배너 로드 중 오류 발생:", status, error);
                        self.errorBanner = "배너 정보를 불러오는 데 실패했습니다.";
                    },
                    complete: function() {
                        self.loadingBanner = false;
                    }
                });
            },

            fnGetBestProducts: function(){
                let self = this;
                self.loadingBest = true; // 로딩 시작
                self.errorBest = null;

                $.ajax({
                    // 💡 Spring Boot에서 베스트 상품을 조회하는 API 주소 (예시: /api/main/best)
                    url: self.path + "/main/data/best", 
                    dataType: "json",
                    type: "GET", // 조회는 GET 방식을 사용하는 것이 일반적입니다.
                    // data: {}, // 베스트 상품은 보통 별도의 파라미터가 필요 없습니다.
                    
                    success: function (data) {
                        // 2. 성공 시: 받은 데이터를 bestProducts에 저장하여 화면을 업데이트합니다.
                        self.bestProducts = data; 
                        console.log("베스트 상품 로드 완료:", data);
                    },
                    error: function(xhr, status, error) {
                        // 3. 실패 시: 오류 처리
                        console.error("베스트 상품 로드 중 오류 발생:", status, error);
                        self.errorBest = "상품 정보를 불러오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.";
                    },
                    complete: function() {
                        // 4. 완료 시: 로딩 상태 해제
                        self.loadingBest = false;   
                    }
                });
            },

            // 🌟 새로 추가: 입점 업체 데이터를 불러오는 함수 🌟
            fnGetProducers: function() {
                let self = this;
                self.loadingProducers = true;
                self.errorProducers = null;

                $.ajax({
                    // API 주소: /api/main/producers (예시)
                    url: self.path + "/main/data/producers", 
                    dataType: "json",
                    type: "GET",
                    success: function (data) {
                        self.producers = data; 
                        console.log("입점 업체 로드 완료:", data);
                    },
                    error: function(xhr, status, error) {
                        console.error("입점 업체 로드 중 오류 발생:", status, error);
                        self.errorProducers = "입점 업체 정보를 불러오는 데 실패했습니다.";
                    },
                    complete: function() {
                        self.loadingProducers = false;
                    }
                });
            }
            
            

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            
            // 🌟 Vue 앱이 마운트된 직후, 입점 업체 API 호출 함수 추가 🌟
            this.fnGetProducers();

            // 🌟 배너 API 호출 함수 추가 🌟
            this.fnGetMainBanners();
            
            // 🌟 Vue 앱이 마운트된 직후, 베스트 상품 API 호출 함수 실행 🌟
            this.fnGetBestProducts();
        
        },
        // 🌟 슬라이드 배너를 위한 unmounted 훅 추가 🌟
        unmounted() {
            // 컴포넌트가 파괴될 때 자동 슬라이드 인터벌을 정리합니다.
            this.stopAutoSlide();
            
        }
    });

    app.mount('#app');
</script>