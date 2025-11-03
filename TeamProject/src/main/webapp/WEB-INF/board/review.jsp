<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 리뷰 - 농수산물 직거래 장터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html,
        body {
            height: 100%;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: #333;
            background-color: #f9fafb;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            flex: 1;
        }

        /* Header */
        .page-header {
            background: white;
            border-bottom: 1px solid #e5e7eb;
            position: sticky;
            top: 0;
            z-index: 10;
            padding: 1rem 0;
        }

        .page-header h1 {
            font-size: 1.5rem;
            font-weight: bold;
            color: #059669;
        }

        .container {
            max-width: 896px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        /* Review Summary Card */
        .summary-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 2rem 0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .summary-content {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .rating-overview {
            text-align: center;
            padding-right: 2rem;
            border-right: 1px solid #e5e7eb;
            min-width: 150px;
        }

        .rating-number {
            font-size: 3rem;
            font-weight: bold;
            color: #059669;
            margin-bottom: 0.5rem;
        }

        .stars {
            display: flex;
            gap: 0.25rem;
            justify-content: center;
            margin-bottom: 0.5rem;
        }

        .star {
            width: 20px;
            height: 20px;
        }

        .star.filled {
            color: #fbbf24;
            fill: #fbbf24;
        }

        .star.empty {
            color: #d1d5db;
            fill: none;
        }

        .rating-count {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .rating-bars {
            flex: 1;
        }

        .rating-bar-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .rating-bar-stars {
            display: flex;
            gap: 0.125rem;
            width: 80px;
        }

        .rating-bar-stars .star {
            width: 12px;
            height: 12px;
        }

        .rating-bar-bg {
            flex: 1;
            height: 8px;
            background: #e5e7eb;
            border-radius: 9999px;
            overflow: hidden;
        }

        .rating-bar-fill {
            height: 100%;
            background: #059669;
            transition: width 0.3s;
        }

        .rating-bar-count {
            font-size: 0.875rem;
            color: #6b7280;
            width: 48px;
            text-align: right;
        }

        /* Filters */
        .filters {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            overflow-x: auto;
            padding-bottom: 0.5rem;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 1px solid #d1d5db;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.875rem;
            white-space: nowrap;
            transition: all 0.2s;
        }

        .filter-btn:hover {
            background: #f3f4f6;
        }

        .filter-btn.active {
            background: #059669;
            color: white;
            border-color: #059669;
        }

        /* Review Card */
        .review-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .review-header {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-info {
            flex: 1;
        }

        .user-name-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.25rem;
        }

        .user-name {
            font-weight: 600;
        }

        .verified-badge {
            background: #e5e7eb;
            color: #374151;
            padding: 0.125rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
        }

        .review-meta {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .review-stars {
            display: flex;
            gap: 0.125rem;
        }

        .review-stars .star {
            width: 16px;
            height: 16px;
        }

        .review-date {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .product-name {
            font-size: 0.875rem;
            color: #059669;
            font-weight: 500;
            margin-bottom: 0.75rem;
        }

        .review-content {
            line-height: 1.6;
            margin-bottom: 1rem;
            color: #374151;
        }

        .review-images {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            overflow-x: auto;
            padding-bottom: 0.5rem;
        }

        .review-image {
            width: 96px;
            height: 96px;
            border-radius: 8px;
            object-fit: cover;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .review-image:hover {
            opacity: 0.8;
        }

        .review-actions {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
        }

        .action-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 0.875rem;
            color: #6b7280;
            border-radius: 6px;
            transition: background 0.2s;
        }

        .action-btn:hover {
            background: #f3f4f6;
        }

        .action-btn svg {
            width: 16px;
            height: 16px;
        }

        /* Load More Button */
        .load-more {
            text-align: center;
            margin: 2rem 0;
        }

        .load-more-btn {
            padding: 0.75rem 2rem;
            border: 1px solid #d1d5db;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
        }

        .load-more-btn:hover {
            background: #f3f4f6;
        }

        /* Image Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            max-width: 90%;
            max-height: 90%;
        }

        .modal-image {
            max-width: 100%;
            max-height: 90vh;
            border-radius: 8px;
        }

        .modal-close {
            position: absolute;
            top: 20px;
            right: 20px;
            background: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.5rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .summary-content {
                flex-direction: column;
            }

            .rating-overview {
                border-right: none;
                border-bottom: 1px solid #e5e7eb;
                padding-right: 0;
                padding-bottom: 1rem;
                width: 100%;
            }

            .filters {
                flex-wrap: nowrap;
            }
        }
    </style>
</head>

<body>
    <!-- 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div id="app">
        <main class="content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="container">
                    <h1>상품 리뷰</h1>
                </div>
            </div>

            <div class="container">
                <!-- Review Summary -->
                <div class="summary-card">
                    <div class="summary-content">
                        <div class="rating-overview">
                            <div class="rating-number">{{ averageRating }}</div>
                            <div class="stars">
                                <svg v-for="n in 5" :key="n" class="star filled" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                </svg>
                            </div>
                            <div class="rating-count">{{ totalReviews }}개 리뷰</div>
                        </div>

                        <div class="rating-bars">
                            <div v-for="rating in [5, 4, 3, 2, 1]" :key="rating" class="rating-bar-row">
                                <div class="rating-bar-stars">
                                    <svg v-for="n in rating" :key="n" class="star filled" viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                    </svg>
                                </div>
                                <div class="rating-bar-bg">
                                    <div class="rating-bar-fill" :style="{width: getRatingPercentage(rating) + '%'}"></div>
                                </div>
                                <div class="rating-bar-count">{{ getRatingCount(rating) }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="filters">
                    <button 
                        class="filter-btn" 
                        :class="{active: currentFilter === 'all'}"
                        @click="currentFilter = 'all'">
                        전체 리뷰
                    </button>
                    <button 
                        class="filter-btn" 
                        :class="{active: currentFilter === 'photo'}"
                        @click="currentFilter = 'photo'">
                        📷 포토 리뷰
                    </button>
                    <button 
                        class="filter-btn" 
                        :class="{active: currentFilter === '5'}"
                        @click="currentFilter = '5'">
                        ⭐ 5점
                    </button>
                    <button 
                        class="filter-btn" 
                        :class="{active: currentFilter === '4'}"
                        @click="currentFilter = '4'">
                        ⭐ 4점
                    </button>
                    <button 
                        class="filter-btn" 
                        :class="{active: currentFilter === 'latest'}"
                        @click="currentFilter = 'latest'">
                        최신순
                    </button>
                </div>

                <!-- Review List -->
                <div class="review-list">
                    <div v-for="review in filteredReviews" :key="review.reviewNo" class="review-card">
                        <!-- Review Header -->
                        <div class="review-header">
                            <img :src="review.userAvatar" :alt="review.userName" class="user-avatar">
                            <div class="user-info">
                                <div class="user-name-row">
                                    <span class="user-name">{{ review.userName }}</span>
                                    <span v-if="review.isVerifiedPurchase" class="verified-badge">구매 인증</span>
                                </div>
                                <div class="review-meta">
                                    <div class="review-stars">
                                        <svg v-for="n in 5" :key="n" 
                                            class="star" 
                                            :class="{filled: n <= review.rating, empty: n > review.rating}"
                                            viewBox="0 0 24 24" 
                                            fill="currentColor">
                                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                        </svg>
                                    </div>
                                    <span class="review-date">{{ review.createdAt }}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Product Name -->
                        <div class="product-name">{{ review.productName }}</div>

                        <!-- Review Content -->
                        <p class="review-content">{{ review.content }}</p>

                        <!-- Review Images -->
                        <div v-if="review.images && review.images.length > 0" class="review-images">
                            <img 
                                v-for="(image, index) in review.images" 
                                :key="index"
                                :src="image" 
                                :alt="'리뷰 이미지 ' + (index + 1)"
                                class="review-image"
                                @click="openImageModal(image)">
                        </div>

                        <!-- Review Actions -->
                        <div class="review-actions">
                            <button class="action-btn" @click="toggleRecommend(review)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/>
                                </svg>
                                도움돼요 {{ review.recommend }}
                            </button>
                            <button class="action-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                                </svg>
                                댓글
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Load More -->
                <div class="load-more">
                    <button class="load-more-btn" @click="loadMore">리뷰 더보기</button>
                </div>
            </div>
        </main>

        <!-- Image Modal -->
        <div class="modal" :class="{active: modalImage}" @click="closeImageModal">
            <button class="modal-close" @click="closeImageModal">×</button>
            <div class="modal-content">
                <img :src="modalImage" alt="리뷰 이미지" class="modal-image">
            </div>
        </div>
    </div>
    
    <!-- 공통 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                currentFilter: 'all',
                modalImage: null,
                averageRating: 4.8,
                totalReviews: 1234,
                ratingDistribution: {
                    5: 925,
                    4: 247,
                    3: 42,
                    2: 15,
                    1: 5
                },
                reviews: [
                    {
                        reviewNo: 1,
                        userId: "user123",
                        userName: "김철수",
                        userAvatar: "${pageContext.request.contextPath}/resources/images/user-avatar.jpg",
                        productNo: 101,
                        productName: "제주 감귤 5kg",
                        rating: 5,
                        recommend: 24,
                        content: "정말 신선하고 맛있어요! 배송도 빠르고 포장도 꼼꼼하게 되어있었습니다. 가족들이 모두 좋아해서 재구매 의사 100%입니다. 감귤이 하나하나 크고 당도도 높아서 아이들이 정말 좋아합니다.",
                        images: [
                            "${pageContext.request.contextPath}/resources/images/fresh-tangerines.jpg",
                            "${pageContext.request.contextPath}/resources/images/tangerine-box.jpg",
                            "${pageContext.request.contextPath}/resources/images/tangerine-close-up.jpg"
                        ],
                        createdAt: "2024-01-15",
                        isVerifiedPurchase: true
                    },
                    {
                        reviewNo: 2,
                        userId: "user456",
                        userName: "이영희",
                        userAvatar: "${pageContext.request.contextPath}/resources/images/user-avatar-2.jpg",
                        productNo: 102,
                        productName: "유기농 쌀 10kg",
                        rating: 4,
                        recommend: 18,
                        content: "쌀알이 윤기나고 밥맛이 좋습니다. 유기농이라 안심하고 먹을 수 있어요. 다만 배송이 조금 늦어진 점은 아쉬웠습니다.",
                        images: [
                            "${pageContext.request.contextPath}/resources/images/organic-rice.jpg"
                        ],
                        createdAt: "2024-01-14",
                        isVerifiedPurchase: true
                    },
                    {
                        reviewNo: 3,
                        userId: "user789",
                        userName: "박민수",
                        userAvatar: "${pageContext.request.contextPath}/resources/images/user-avatar-3.jpg",
                        productNo: 103,
                        productName: "딸기 2kg",
                        rating: 5,
                        recommend: 32,
                        content: "딸기가 정말 크고 달아요! 아이들이 너무 좋아합니다. 다음에도 꼭 주문할게요. 포장도 정말 잘 되어있어서 하나도 상하지 않았습니다.",
                        images: [
                            "${pageContext.request.contextPath}/resources/images/fresh-strawberries.jpg",
                            "${pageContext.request.contextPath}/resources/images/strawberry-basket.jpg"
                        ],
                        createdAt: "2024-01-13",
                        isVerifiedPurchase: true
                    }
                ]
            };
        },
        computed: {
            filteredReviews() {
                let filtered = this.reviews;
                
                if (this.currentFilter === 'photo') {
                    filtered = filtered.filter(r => r.images && r.images.length > 0);
                } else if (this.currentFilter === '5' || this.currentFilter === '4') {
                    filtered = filtered.filter(r => r.rating === parseInt(this.currentFilter));
                }
                
                return filtered;
            }
        },
        methods: {
            getRatingPercentage(rating) {
                return (this.ratingDistribution[rating] / this.totalReviews) * 100;
            },
            getRatingCount(rating) {
                return this.ratingDistribution[rating];
            },
            toggleRecommend(review) {
                review.recommend++;
            },
            openImageModal(image) {
                this.modalImage = image;
            },
            closeImageModal() {
                this.modalImage = null;
            },
            loadMore() {
                alert('더 많은 리뷰를 불러옵니다.');
                // 실제로는 AJAX로 추가 리뷰 데이터를 가져옴
            },
            fnLoadReviews() {
                let self = this;
                let param = {
                    productNo: 101 // 상품 번호
                };
                $.ajax({
                    url: "${pageContext.request.contextPath}/review/list",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.reviews = data.reviews;
                        self.averageRating = data.averageRating;
                        self.totalReviews = data.totalReviews;
                        self.ratingDistribution = data.ratingDistribution;
                    }
                });
            }
        },
        mounted() {
            let self = this;
            // 실제 환경에서는 서버에서 리뷰 데이터를 가져옴
            // self.fnLoadReviews();
        }
    });

    app.mount('#app');
</script>
