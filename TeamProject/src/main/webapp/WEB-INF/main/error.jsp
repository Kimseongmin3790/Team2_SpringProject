<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <title>오류 발생</title>
    <style>
        
        body, h1, h2, h3, p { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        body { 
            font-family: sans-serif; 
        }

        /* 전체 레이아웃 */
        .wrapper {
            min-height: 100vh;
            background-color: #f0fdf4; 
        }

        /* 헤더 & 푸터 */
        .header, .footer {
            border-color: #e5e7eb; 
            background-color: #ffffff;
        }
        .header { 
            border-bottom-width: 1px; 
        }
        .footer { 
            border-top-width: 1px; 
            margin-top: 4rem; 
        }

        /* 공통 컨테이너 */
        .container {
            width: 100%;
            max-width: 1280px;
            margin-left: auto;
            margin-right: auto;
            padding: 1rem 1rem;
        }
        .header .container { 
            padding-top: 1rem; 
            padding-bottom: 1rem; 
        }
        .main-content { 
            padding-top: 4rem; 
            padding-bottom: 4rem; 
        }
        .footer .container { 
            padding: 2rem 1rem; 
            text-align: center; 
            font-size: 0.875rem; 
            color: #4b5563;
        }

        /* 컨텐츠 영역 */
        .content-wrapper {
            max-width: 42rem; 
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }

        /* 아이콘 */
        .icon-wrapper {
            margin-bottom: 2rem;
        }
        .icon-circle {
            width: 12rem; 
            height: 12rem;
            margin-left: auto;
            margin-right: auto;
            background-color: #dcfce7; 
            border-radius: 9999px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .icon-svg {
            width: 6rem;
            height: 6rem;
            color: #16a34a;
        }

        /* 메시지 */
        .error-title {
            font-size: 2.25rem; 
            font-weight: 700; 
            color: #1f2937;
            margin-bottom: 1rem;
        }
        .error-description {
            font-size: 1.125rem; 
            color: #4b5563; 
            margin-bottom: 2rem;
        }

        /* 오류 정보 박스 */
        .error-details {
            background-color: #f9fafb; 
            border-radius: 0.5rem; 
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }
        .error-details h3 {
            font-weight: 600; 
            color: #1f2937; 
            margin-bottom: 0.5rem;
        }
        .error-details p {
            font-size: 0.875rem; 
            color: #4b5563;
            margin-bottom: 0.25rem;
        }

        /* 버튼 */
        .button-group {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            justify-content: center;
        }
        @media (min-width: 640px) { 
            .button-group { flex-direction: row; }
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem; 
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-primary {
            background-color: #16a34a; 
            color: white;
        }
        .btn-primary:hover { 
            background-color: #15803d; 
        } 

        .btn-secondary {
            border: 1px solid #d1d5db; 
            color: #374151; 
        }
        .btn-secondary:hover { 
            background-color: #f9fafb; 
        } 

        /* 도움말 */
        .help-text {
            font-size: 0.875rem; 
            color: #6b7280; 
            margin-top: 2rem;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- Header -->
        <header class="header">
            <div class="container">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: #15803d;">AGRICOLA</h1>
            </div>
        </header>

        <!-- Error Content -->
        <main class="container main-content">
            <div class="content-wrapper">
                <!-- Error Icon -->
                <div class="icon-wrapper">
                    <div class="icon-circle">
                        <svg class="icon-svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.3416c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                    </div>
                </div>

                <!-- Error Message -->
                <h2 class="error-title">앗! 문제가 발생했어요</h2>
                <p class="error-description">
                    일시적인 오류가 발생했습니다.
                    <br />
                    잠시 후 다시 시도해주세요.
                </p>

                <!-- Error Details -->
                <div class="error-details">
                    <h3>오류 정보</h3>
                    <p class="text-sm text-gray-600">오류 내용: ${errorMessage}</p>
                </div>

                <!-- Action Buttons -->
                <div class="button-group">
                    <button class="btn btn-primary" onclick="location.href='/main.do'"> <!-- 추후 메인 페이지 추가-->
                        홈으로 돌아가기
                    </button>
                    <button class="btn btn-secondary" onclick="history.back()">
                        이전 페이지로
                    </button>
                    <button class="btn btn-secondary" onclick="location.href='/customerService.do'">
                        고객센터 문의
                    </button>
                </div>

                <!-- Help Text -->
                <p class="help-text">문제가 계속되면 고객센터(1234-5678)로 문의해주세요.</p>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <p>© 2025 AGRICOLA. All rights reserved.</p>
            </div>
        </footer>
    </div>
</body>
</html>