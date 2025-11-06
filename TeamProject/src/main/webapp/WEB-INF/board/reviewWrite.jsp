<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 작성 - AGRICOLA</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            background-color: #f9fafb;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            flex: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1rem;
            width: 100%;
        }

        /* Product Info Card */
        .product-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .product-info {
            display: flex;
            gap: 1rem;
        }

        .product-image {
            width: 80px;
            height: 80px;
            background-color: #e5e7eb;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            color: #9ca3af;
            flex-shrink: 0;
        }

        .product-details h3 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 0.25rem 0;
        }

        .product-details p {
            margin: 0;
            font-size: 0.875rem;
            color: #6b7280;
        }

        /* Review Form Card */
        .review-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: #111827;
        }

        /* Rating Stars */
        .rating-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .star-button {
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            transition: transform 0.2s;
        }

        .star-button:hover {
            transform: scale(1.1);
        }

        .star-icon {
            width: 40px;
            height: 40px;
            color: #d1d5db;
            transition: color 0.2s;
        }

        .star-icon.filled {
            color: #fbbf24;
            fill: #fbbf24;
        }

        .rating-score {
            margin-left: 0.5rem;
            font-size: 1.125rem;
            font-weight: 600;
            color: #374151;
        }

        /* Textarea */
        .review-textarea {
            width: 100%;
            min-height: 200px;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.875rem;
            resize: none;
            font-family: inherit;
        }

        .review-textarea:focus {
            outline: none;
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .textarea-info {
            display: flex;
            justify-content: space-between;
            margin-top: 0.5rem;
            font-size: 0.75rem;
            color: #6b7280;
        }

        /* Image Upload */
        .image-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 0.75rem;
        }

        .image-item {
            position: relative;
            aspect-ratio: 1;
        }

        .image-preview {
            width: 100%;
            height: 100%;
            background-color: #e5e7eb;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            color: #9ca3af;
        }

        .image-remove {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #1f2937;
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .image-remove:hover {
            background-color: #111827;
        }

        .image-upload-label {
            aspect-ratio: 1;
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .image-upload-label:hover {
            border-color: #10b981;
            background-color: #f0fdf4;
        }

        .upload-icon {
            width: 24px;
            height: 24px;
            color: #9ca3af;
            margin-bottom: 0.25rem;
        }

        .upload-count {
            font-size: 0.75rem;
            color: #6b7280;
        }

        .image-upload-input {
            display: none;
        }

        /* Guidelines */
        .guidelines {
            background-color: #f9fafb;
            border-radius: 8px;
            padding: 1rem;
        }

        .guidelines h4 {
            font-size: 0.875rem;
            font-weight: 600;
            margin: 0 0 0.5rem 0;
        }

        .guidelines ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .guidelines li {
            font-size: 0.75rem;
            color: #6b7280;
            margin-bottom: 0.25rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .btn {
            flex: 1;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-cancel {
            background-color: white;
            color: #374151;
            border: 1px solid #d1d5db;
        }

        .btn-cancel:hover {
            background-color: #f9fafb;
        }

        .btn-submit {
            background-color: #16a34a;
            color: white;
        }

        .btn-submit:hover {
            background-color: #15803d;
        }

        .btn-submit:disabled {
            background-color: #d1d5db;
            cursor: not-allowed;
        }

        /* Responsive */
        @media (max-width: 640px) {
            .content {
                padding: 1rem;
            }

            .image-grid {
                grid-template-columns: repeat(3, 1fr);
            }

            .star-icon {
                width: 32px;
                height: 32px;
            }
        }
        .product-purchase-date {
            color: #9ca3af;
            margin-top: 0.25rem;
        }
        .image-upload-info {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 0.5rem;
        }
    </style>
</head>

<body>
    <!-- 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div id="app">                     
        <main class="content">
            <!-- Product Info -->
            <div class="product-card">
                <div class="product-info">
                    <img :src="product.imageUrl" class="product-image" alt="상품 이미지" v-if="product.imageUrl">
                    <div class="product-image" v-else>
                        이미지 없음
                    </div>
                    <div class="product-details">
                        <h3>{{ product.name }}</h3>
                        <p>{{ product.sellerName }}</p>
                        <p class="product-purchase-date">{{ product.purchaseDate }} 구매</p>
                    </div>
                </div>
            </div>

            <!-- Review Form -->
            <div class="review-card">
                <!-- Rating -->
                <div class="form-section">
                    <label class="form-label">상품은 어떠셨나요?</label>
                    <div class="rating-container">
                        <button 
                            v-for="star in 5" 
                            :key="star"
                            class="star-button"
                            @click="rating = star"
                            @mouseenter="hoverRating = star"
                            @mouseleave="hoverRating = 0"
                        >
                            <svg 
                                class="star-icon" 
                                :class="{ filled: star <= (hoverRating || rating) }"
                                fill="none" 
                                stroke="currentColor" 
                                viewBox="0 0 24 24"
                            >
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                            </svg>
                        </button>
                        <span v-if="rating > 0" class="rating-score">{{ rating }}.0</span>
                    </div>
                </div>

                <!-- Content -->
                <div class="form-section">
                    <label class="form-label">리뷰 내용</label>
                    <textarea 
                        v-model="content"
                        class="review-textarea"
                        placeholder="상품에 대한 솔직한 리뷰를 작성해주세요. (최소 10자 이상)"
                        maxlength="500"
                    ></textarea>
                    <div class="textarea-info">
                        <span>최소 10자 이상 작성해주세요</span>
                        <span>{{ content.length }} / 500</span>
                    </div>
                </div>

                <!-- Image Upload -->
                <div class="form-section">
                    <label class="form-label">사진 첨부 (선택)</label>
                    <div class="image-grid">
                        <div v-for="(image, index) in images" :key="index" class="image-item">
                            <img :src="image.preview" class="image-preview" style="width:100%; height:100%; object-fit:cover;">
                            <button class="image-remove" @click="removeImage(index)">×</button>
                        </div>
                        <label v-if="images.length < 5" class="image-upload-label">
                            <svg class="upload-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                    d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" 
                                />
                            </svg>
                            <span class="upload-count">{{ images.length }}/5</span>
                            <input 
                                type="file" 
                                class="image-upload-input"
                                accept="image/*"
                                multiple
                                @change="handleImageUpload"
                            />
                        </label>
                    </div>
                    <p class="image-upload-info">최대 5장까지 첨부 가능합니다 </p>
                </div>

                <!-- Guidelines -->
                <div class="form-section">
                    <div class="guidelines">
                        <h4>리뷰 작성 가이드</h4>
                        <ul>
                            <li>• 상품과 무관한 내용은 삭제될 수 있습니다</li>
                            <li>• 욕설, 비방 등 부적절한 표현은 제재 대상입니다</li>
                            <li>• 사진 리뷰 작성 시 추가 포인트가 지급됩니다</li>
                        </ul>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button class="btn btn-cancel" @click="cancel">취소</button>
                    <button 
                        class="btn btn-submit" 
                        :disabled="!canSubmit"
                        @click="submitReview"
                    >
                        리뷰 등록
                    </button>
                </div>
            </div>
        </main>                
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
                productNo: "${param.productNo}",
                orderItemNo: "${param.orderItemNo}",
                product: { 
                    name: '',
                    sellerName: '',
                    imageUrl: '',
                    purchaseDate: ''
                },
                rating: 0,
                hoverRating: 0,
                content: "",
                images: []
            };
        },
        computed: {
            canSubmit() {
                let self = this;
                return self.rating > 0 && self.content.length >= 10;
            }
        },
        methods: {
            handleImageUpload(event) {
                let self = this;
                const files = event.target.files;
                if (files) {
                    const remainingSlots = 5 - self.images.length;
                    const filesToAdd = Math.min(files.length, remainingSlots);
                    
                    for (let i = 0; i < filesToAdd; i++) {
                        let self = this;
                        // 실제 구현에서는 파일을 서버에 업로드하고 URL을 받아와야 합니다
                        self.images.push({
                            file: files[i],
                            preview: URL.createObjectURL(files[i])
                        });
                    }
                }
                // 파일 입력 초기화
                event.target.value = '';
            },
            removeImage(index) {
                let self = this;
                self.images.splice(index, 1);
            },
            cancel() {
                if (confirm('작성 중인 리뷰가 삭제됩니다. 취소하시겠습니까?')) {
                    // 리뷰 목록 페이지로 이동
                    window.location.href = '${pageContext.request.contextPath}/buyerMyPage.do?tab=orders';
                }
            },
            fetchReviewData() {
                const self = this;
                $.ajax({
                    url: "${pageContext.request.contextPath}/review/data.dox",
                    type: "GET",
                    data: {
                        productNo: self.productNo,
                        orderItemNo: self.orderItemNo
                    },
                    dataType: "json",
                    success: function(response) {
                        if (response.result === "success") {
                            self.product.name = response.data.pname; 
                            self.product.sellerName = response.data.sellerName; 
                            self.product.imageUrl = response.data.imageUrl; 
                            self.product.purchaseDate = response.data.orderdate; 
                        } else {
                            alert("상품 정보를 불러오는 데 실패했습니다.");
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("상품 정보 조회 중 오류가 발생했습니다.");
                        console.error("Error:", error);
                    }
                });
            },
            submitReview() {
                let self = this;
                if (!self.canSubmit) {
                    return;
                }

                const formData = new FormData();
                formData.append('productNo', self.productNo); 
                formData.append('orderItemNo', self.orderItemNo); 
                formData.append('rating', self.rating);
                formData.append('content', self.content);
                
                // 이미지 파일 추가
                self.images.forEach((image, index) => {
                    formData.append('images', image.file);
                });

                $.ajax({
                    url: "${pageContext.request.contextPath}/review/write.dox",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(data) {
                        alert('리뷰가 등록되었습니다.');
                        window.location.href = '${pageContext.request.contextPath}/buyerMyPage.do?tab=reviews';
                    },
                    error: function(xhr, status, error) {
                        alert('리뷰 등록에 실패했습니다. 다시 시도해주세요.');
                        console.error('Error:', error);
                    }
                });
            },
            
        },
        mounted() {
            let self = this;
            self.fetchReviewData();
        }
    });

    app.mount('#app');
</script>