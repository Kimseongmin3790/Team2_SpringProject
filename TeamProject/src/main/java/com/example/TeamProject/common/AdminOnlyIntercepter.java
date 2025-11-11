package com.example.TeamProject.common;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AdminOnlyIntercepter implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : String.valueOf(session.getAttribute("sessionStatus"));

        if ("ADMIN".equals(role)) {
            return true; // 통과
        }

        // AJAX 요청이면 403 JSON
        String xhr = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xhr)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"ok\":false,\"message\":\"관리자만 접근 가능합니다.\"}");
            return false;
        }

        // 일반 요청이면 403 페이지로
        response.sendRedirect(request.getContextPath() + "/error/403");
        return false;
    }
}
