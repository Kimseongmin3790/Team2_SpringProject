package com.example.TeamProject.common;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AdminOnlyIntercepter())
                .addPathPatterns("/admin/**", "/dashboard.do")
                .excludePathPatterns(
                        "/admin/login", "/admin/login.do",
                        "/resources/**", "/static/**", "/img/**", "/css/**", "/js/**", "/webjars/**", "/uploads/**"
                );
    }
}