<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <div>
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
                            <div class="rating-number">{{ averageRating.toFixed(2) }}</div>
                            <div class="stars">
                                <!-- 꽉 찬 별 -->
                                <svg v-for="n in Math.floor(averageRating)" :key="'full-' + n" class="star filled" viewBox="0 0 24 24">
                                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73-1.64 7.03z"/>
                                </svg>
                                <!-- 반쪽 별 -->
                                <svg v-if="averageRating - Math.floor(averageRating) >= 0.5" class="star filled" viewBox="0 0 24 24">
                                    <defs>
                                        <clipPath id="halfStarClip">
                                            <rect x="0" y="0" width="12" height="24" />
                                        </clipPath>
                                    </defs>
                                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73-1.64 7.03z" clip-path="url(#halfStarClip)"/>
                                </svg>
                            </div>
                            <div class="rating-count">{{ totalReviews }}개 리뷰</div>
                        </div>

                        <div class="rating-bars">
                            <div v-for="rating in [5, 4, 3, 2, 1]" :key="rating" class="rating-bar-row">
                                <div class="rating-bar-stars">
                                <svg v-for="n in rating" :key="n" class="star filled" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73-1.64 7.03z"/>
                                </svg>
                                </div>
                                <div class="rating-bar-bg">
                                    <div class="rating-bar-fill" :style="{width: getRatingPercentage(rating) +'%'}"></div>
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
                            <div class="user-info">
                                <div class="user-name-row">
                                    <span class="user-name">{{ review.userId }}</span>
                                </div>
                                <div class="review-meta">
                                    <div class="review-stars">
                                        <svg v-for="n in 5" :key="n"
                                            class="star"
                                            :class="{filled: n <= review.rating, empty: n > review.rating}"
                                            viewBox="0 0 24 24"
                                            fill="currentColor">
                                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73-1.64 7.03z"/>
                                        </svg>
                                    </div>
                                    <span class="review-date">{{ formatDate(review.createdAt) }}</span>
                                </div>
                            </div>
                        </div>

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
                        
                         <!-- 판매자 답글 -->
                        <div v-if="review.comments && review.comments.length > 0" class="seller-reply-container">
                            <div v-for="comment in review.comments" :key="comment.commentNo" class="seller-reply-item">
                                <div class="seller-reply-header">
                                    <p class="seller-reply-author">{{ comment.userId }} (판매자)님의 답글:</p>

                                    <div v-if="userId === comment.userId" class="seller-reply-actions">
                                        <!-- 편집 모드가 아닐 때 -->
                                        <template v-if="editingCommentNo !== comment.commentNo">
                                            <button class="btn btn-info btn-sm" @click="editComment(comment)">수정</button>
                                            <button class="btn btn-danger btn-sm" @click="deleteComment(comment.commentNo)">삭제</button>
                                        </template>
                                        <!-- 편집 모드일 때 -->
                                        <template v-else>
                                            <button class="btn btn-primary btn-sm" @click="saveEditedComment(comment)">저장</button>
                                            <button class="btn btn-secondary btn-sm" @click="cancelEdit()">취소</button>
                                        </template>
                                    </div>
                                </div>

                                <div class="seller-reply-body">
                                    <!-- 편집 모드가 아닐 때 -->
                                    <template v-if="editingCommentNo !== comment.commentNo">
                                        <p class="seller-reply-content">{{ comment.contents }}</p>
                                        <p class="seller-reply-date">작성일: {{ comment.cDatetime }}</p>
                                    </template>
                                    <!-- 편집 모드일 때 -->
                                    <template v-else>
                                        <textarea v-model="comment.contents" class="form-textarea seller-reply-edit-input"></textarea>
                                    </template>
                                </div>
                            </div>
                        </div>

                        <!-- Review Actions -->
                                                <div class="review-actions">
                            <button class="action-btn"
                                    :class="{ active: review.isRecommended }"
                                    @click="toggleRecommend(review)">
                                <svg viewBox="0 0 24 24">
                                    <path d="M14.17 1L7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.51.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32zM1 9h4v12H1V9z" />
                                </svg>
                                도움돼요 {{ review.recommend }}
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Load More -->
                 <div class="load-more" v-if="reviews.length < totalReviewCount">
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
