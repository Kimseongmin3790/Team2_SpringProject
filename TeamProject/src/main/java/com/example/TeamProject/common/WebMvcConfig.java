package com.example.TeamProject.common;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AdminOnlyIntercepter())
                // ✅ 관리자 URL 전부 보호
                .addPathPatterns("/admin/**", "/dashboard.do")
                // ✅ 공개해야 하는 것들은 제외
                .excludePathPatterns(
                        "/admin/login", "/admin/login.do",
                        "/resources/**", "/static/**", "/img/**", "/css/**", "/js/**", "/webjars/**", "/uploads/**"
                );
    }
}