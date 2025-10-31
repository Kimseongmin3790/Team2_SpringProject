package com.example.TeamProject.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler; 

import com.example.TeamProject.dao.CustomOAuth2UserService;
import com.example.TeamProject.config.auth.CustomOAuth2AuthenticationFailureHandler;
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Autowired 
    private CustomOAuth2AuthenticationFailureHandler customOAuth2AuthenticationFailureHandler;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/**").permitAll()
                .anyRequest().authenticated()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login.do") // 인증이 필요할 때 보낼 기본 페이지
                .defaultSuccessUrl("/main.do", true) // 로그인 성공 시 리다이렉트할 페이지
                .failureHandler(customOAuth2AuthenticationFailureHandler) // 커스텀 핸들러 사용
                .userInfoEndpoint(userInfo -> userInfo
                    .userService(customOAuth2UserService) // 로그인 성공 후 사용자 정보를 처리할 서비스 지정
                )
            );

        return http.build();
    }
}