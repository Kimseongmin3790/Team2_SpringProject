<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 작성 - 농수산물 직거래 장터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <style>
        /* 기본 스타일 */
        * { margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        html, body { 
            height: 100%; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,'Helvetica Neue', Arial, sans-serif; 
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
            padding: 2rem 1rem; 
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
        }

        /* 페이지 헤더 */
        .page-header { 
            text-align: center; 
            margin-bottom: 2rem; 
        }
        .page-header h1 { 
            font-size: 1.75rem; 
            font-weight: bold; 
            color: #059669; 
        }

        /* 카드 스타일 */
        .card { 
            background: white; 
            border-radius: 8px; 
            padding: 1.5rem; 
            margin-bottom: 1.5rem; 
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); 
        }

        /* 리뷰 대상 상품 정보 */
        .product-info-card { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
        }
        .product-image { 
            width: 80px; 
            height: 80px; 
            border-radius: 8px; 
            object-fit: cover; 
            background-color:#f3f4f6; 
        }
        .product-details h2 { 
            font-size: 1.25rem; 
            font-weight: 600; 
            margin-bottom: 0.5rem; 
        }
        .product-details p { 
            font-size: 0.875rem; 
            color: #6b7280; 
        }

        /* 별점 평가 */
        .rating-section h3 { font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem; text-align: center; }
        .stars { display: flex; justify-content: center; gap: 0.5rem; margin-bottom: 1rem; }
        .star { width: 40px; height: 40px; cursor: pointer; color: #d1d5db; transition: color 0.2s, transform 0.2s; }
        .star:hover { transform: scale(1.1); }
        .star.hovered, .star.filled { color: #fbbf24; }
        .rating-text { text-align: center; font-weight: 500; color: #6b7280; min-height: 24px; }

        /* 리뷰 내용 입력 */
        .content-section textarea {
            width: 100%;
            min-height: 150px;
            padding: 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 1rem;
            line-height: 1.6;
            resize: vertical;
        }
        .content-section textarea:focus { outline: none; border-color: #059669; box-shadow: 0 0 0 3px rgba(5,
150, 105, 0.1); }

        /* 이미지 업로드 */
        .image-upload-section .upload-btn-wrapper { position: relative; display: inline-block; overflow: hidden;
border: 2px dashed #d1d5db; border-radius: 8px; padding: 2rem; text-align: center; width: 100%; cursor: pointer;
transition: border-color 0.2s; }
        .image-upload-section .upload-btn-wrapper:hover { border-color: #059669; }
        .image-upload-section .upload-btn-wrapper input[type=file] { font-size: 100px; position: absolute; left:
0; top: 0; opacity: 0; cursor: pointer; }
        .upload-btn-wrapper .icon { font-size: 2rem; color: #6b7280; }
        .upload-btn-wrapper .text { margin-top: 0.5rem; color: #6b7280; font-weight: 500; }

        .image-preview { display: flex; gap: 1rem; margin-top: 1rem; overflow-x: auto; padding-bottom: 0.5rem; }
        .preview-item { position: relative; }
        .preview-image { width: 96px; height: 96px; border-radius: 8px; object-fit: cover; }
        .remove-image-btn { position: absolute; top: -5px; right: -5px; width: 24px; height: 24px; background:
rgba(0,0,0,0.6); color: white; border: none; border-radius: 50%; cursor: pointer; font-weight: bold; }

        /* 버튼 */
        .form-actions { display: flex; gap: 1rem; justify-content: center; margin-top: 2rem; }
        .btn { padding: 0.75rem 2rem; border: none; border-radius: 6px; cursor: pointer; font-size: 1rem;
font-weight: 500; transition: all 0.2s; }
        .btn-primary { background-color: #059669; color: white; }
        .btn-primary:hover { background-color: #047857; }
        .btn-secondary { background-color: #e5e7eb; color: #374151; }
        .btn-secondary:hover { background-color: #d1d5db; }
    </style>
</head>
<body>
    <div id="app">
        <!-- 공통 헤더 -->
        <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <main class="content">
            <div class="container">
                <div class="page-header">
                    <h1>리뷰 작성</h1>
                </div>

                <!-- 리뷰 대상 상품 정보 -->
                <div class="card product-info-card">
                    <img :src="product.imageUrl" :alt="product.name" class="product-image">
                    <div class="product-details">
                        <h2>{{ product.name }}</h2>
                        <p>이 상품에 대한 리뷰를 작성해주세요.</p>
                    </div>
                </div>

                <!-- 별점 -->
                <div class="card rating-section">
                    <h3>상품은 만족스러우셨나요?</h3>
                    <div class="stars" @mouseleave="resetStarHover">
                        <svg v-for="n in 5" :key="n"
                             class="star"
                             :class="{ filled: n <= rating, hovered: n <= hoveredRating }"
                             @mouseover="hoverStar(n)"
                             @click="setRating(n)"
                             viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2
9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                    <p class="rating-text">{{ ratingText }}</p>
                </div>

                <!-- 리뷰 내용 -->
                <div class="card content-section">
                    <textarea v-model="content" placeholder="다른 고객님들께 도움이 될 수 있도록 상품에 대한
솔직한 평가를 남겨주세요. (최소 10자 이상)"></textarea>
                </div>

                <!-- 사진 첨부 -->
                <div class="card image-upload-section">
                    <div class="upload-btn-wrapper" @click="$refs.fileInput.click()">
                        <input type="file" ref="fileInput" @change="handleImageUpload" multiple accept="image/*"
style="display: none;">
                        <div class="icon">📷</div>
                        <div class="text">사진 추가하기 (최대 5장)</div>
                    </div>
                    <div v-if="imagePreviews.length > 0" class="image-preview">
                        <div v-for="(image, index) in imagePreviews" :key="index" class="preview-item">
                            <img :src="image.url" class="preview-image">
                            <button class="remove-image-btn" @click="removeImage(index)">×</button>
                        </div>
                    </div>
                </div>

                <!-- 등록/취소 버튼 -->
                <div class="form-actions">
                    <button class="btn btn-secondary" @click="cancel">취소</button>
                    <button class="btn btn-primary" @click="submitReview">등록하기</button>
                </div>
            </div>
        </main>

        <!-- 공통 푸터 -->
        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                // 마이페이지에서 전달받을 파라미터
                productNo: "${param.productNo}",
                orderItemNo: "${param.orderItemNo}",
                // 리뷰 대상 상품 정보 (실제로는 파라미터로 받은 productNo로 조회)
                product: {
                    name: "제주 감귤 5kg",
                    imageUrl: "${pageContext.request.contextPath}/resources/images/fresh-tangerines.jpg"
                },
                rating: 0, // 선택된 별점
                hoveredRating: 0, // 호버된 별점
                content: "", // 리뷰 내용
                imageFiles: [], // 업로드할 이미지 파일 목록
                imagePreviews: [] // 이미지 미리보기 URL 목록
            };
        },
        computed: {
            ratingText() {
                const texts = ["선택하세요", "별로예요", "그냥 그래요", "보통이에요", "좋아요", "최고예요"];
                return texts[this.rating];
            }
        },
        methods: {
            hoverStar(n) {
                this.hoveredRating = n;
            },
            resetStarHover() {
                this.hoveredRating = 0;
            },
            setRating(n) {
                this.rating = n;
            },
            handleImageUpload(event) {
                const files = event.target.files;
                if (!files) return;

                // 최대 5장 제한
                if (this.imageFiles.length + files.length > 5) {
                    alert("이미지는 최대 5장까지 첨부할 수 있습니다.");
                    return;
                }

                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    this.imageFiles.push(file);

                    const reader = new FileReader();
                    reader.onload = (e) => {
                        this.imagePreviews.push({ url: e.target.result, name: file.name });
                    };
                    reader.readAsDataURL(file);
                }
            },
            removeImage(index) {
                this.imageFiles.splice(index, 1);
                this.imagePreviews.splice(index, 1);
            },
            cancel() {
                if (confirm("리뷰 작성을 취소하시겠습니까?")) {
                    // 이전 페이지(마이페이지)로 이동
                    history.back();
                }
            },
            submitReview() {
                // 유효성 검사
                if (this.rating === 0) {
                    alert("별점을 선택해주세요.");
                    return;
                }
                if (this.content.length < 10) {
                    alert("리뷰 내용은 10자 이상 작성해주세요.");
                    return;
                }

                // FormData 객체 생성
                const formData = new FormData();
                formData.append("productNo", this.productNo);
                formData.append("orderItemNo", this.orderItemNo);
                formData.append("rating", this.rating);
                formData.append("content", this.content);

                // 이미지 파일 추가
                this.imageFiles.forEach(file => {
                    formData.append("images", file);
                });

                // AJAX로 서버에 전송
                $.ajax({
                    url: "${pageContext.request.contextPath}/review/write.dox",
                    type: "POST",
                    data: formData,
                    processData: false, // FormData를 사용할 때 필수
                    contentType: false, // FormData를 사용할 때 필수
                    success: function(response) {
                        if (response.result === "success") {
                            alert("리뷰가 성공적으로 등록되었습니다.");
                            // 마이페이지의 리뷰 관리 탭으로 이동
                            location.href = "${pageContext.request.contextPath}/myPage.do?tab=reviews";
                        } else {
                            alert("리뷰 등록에 실패했습니다: " + response.message);
                        }
                    },
                    error: function() {
                        alert("리뷰 등록 중 오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            // 페이지 로드 시, productNo를 이용해 상품 정보를 가져오는 로직을 추가할 수 있습니다.
            // 예: this.fnLoadProductInfo(this.productNo);
        }
    });

    app.mount('#app');
</script>