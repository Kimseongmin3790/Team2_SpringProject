package com.example.TeamProject.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.example.TeamProject.dao.CustomOAuth2UserService;
import com.example.TeamProject.config.auth.CustomOAuth2AuthenticationFailureHandler;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    private final CustomOAuth2AuthenticationFailureHandler failureHandler;

    public SecurityConfig(CustomOAuth2UserService customOAuth2UserService,
                          CustomOAuth2AuthenticationFailureHandler failureHandler) {
        this.customOAuth2UserService = customOAuth2UserService;
        this.failureHandler = failureHandler;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // ★ 이 빈 하나만 유지하세요. (기존 filterChain(...) 메서드는 삭제)
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
           .authorizeHttpRequests(auth -> auth
               // 정적 리소스 허용
               .requestMatchers("/img/**", "/css/**", "/js/**", "/webjars/**",
                                "/resources/**", "/uploads/**").permitAll()
               // 나머지는 필요에 따라
               .anyRequest().permitAll()   // ← 필요하면 authenticated()로 변경
           )
           .oauth2Login(oauth2 -> oauth2
               .loginPage("/login.do")
               .defaultSuccessUrl("/main.do", true)
               .failureHandler(failureHandler)
               .userInfoEndpoint(ui -> ui.userService(customOAuth2UserService))
           );
        return http.build();
    }
}