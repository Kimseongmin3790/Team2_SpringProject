package com.example.TeamProject.config.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class CustomOAuth2AuthenticationFailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException,
ServletException {
        String errorMessage = "소셜 로그인 중 알 수 없는 오류가 발생했습니다."; // 기본 에러 메시지
        HttpSession session = request.getSession(false); // 세션 가져오기 (없으면 생성하지 않음)

        if (session != null && session.getAttribute("oauth2ErrorMessage") != null) {
            // HttpSession에서 저장된 메시지 가져오기
            errorMessage = (String) session.getAttribute("oauth2ErrorMessage");
            session.removeAttribute("oauth2ErrorMessage"); // 메시지 사용 후 세션에서 제거
        } else if (exception != null) {
            // HttpSession에 메시지가 없으면, 예외 메시지에서 추출 시도 (기존 로직)
            if (exception instanceof OAuth2AuthenticationException) {
                errorMessage = exception.getMessage();
            } else if (exception.getCause() != null && exception.getCause().getMessage() != null) {
                errorMessage = exception.getCause().getMessage();
            } else if (exception.getMessage() != null) {
                errorMessage = exception.getMessage();
            }
        }

        // 에러 메시지를 URL 파라미터로 인코딩하여 로그인 페이지로 리다이렉트
        String encodedErrorMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
        response.sendRedirect("/login.do?error=true&message=" + encodedErrorMessage);
    }
}