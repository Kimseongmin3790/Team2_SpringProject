package com.example.TeamProject.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import com.example.TeamProject.config.auth.CustomOAuth2AuthenticationFailureHandler;
import com.example.TeamProject.dao.CustomOAuth2UserService;
import com.example.TeamProject.model.User; 

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

    @Bean
    public AuthenticationSuccessHandler chatAwareSuccessHandler() {
        return (request, response, authentication) -> {
            HttpSession s = request.getSession();
            Object principal = authentication.getPrincipal();

            if (principal instanceof OAuth2User oAuth2User) {
                // ✨ 위에서 "userEntity" 키로 넣은 User 객체를 꺼냅니다.
                User user = (User) oAuth2User.getAttributes().get("userEntity");

                if (user != null) {
                    // ✨ User 객체에서 직접 정보를 꺼내 세션에 저장합니다.
                    s.setAttribute("sessionId", user.getUserId());
                    s.setAttribute("sessionStatus", user.getUserRole());
                    s.setAttribute("sessionName", user.getName());
                    // 다른 곳에서 userId, userName을 사용한다면 같이 저장
                    s.setAttribute("userId", user.getUserId());
                    s.setAttribute("userName", user.getName());
                }
            }
            s.setMaxInactiveInterval(60 * 60);

            // 아래 리디렉션 로직은 기존 로직 그대로 유지
            String target = request.getParameter("redirect");
            if (target != null && !target.isBlank()) {
                response.sendRedirect(target);
                return;
            }

            var cache = new HttpSessionRequestCache();
            var saved = cache.getRequest(request, response);
            if (saved != null) {
                new SavedRequestAwareAuthenticationSuccessHandler().onAuthenticationSuccess(request, response, authentication);
                return;
            }

            response.sendRedirect("/main.do");
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .sessionManagement(sm -> sm.sessionFixation().migrateSession())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/img/**", "/css/**", "/js/**", "/webjars/**", "/resources/**","/uploads/**").permitAll()
                .requestMatchers("/ws-chat/**", "/chatting.do").permitAll()
                .anyRequest().permitAll())
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login.do")
                .defaultSuccessUrl("/main.do", true)
                .successHandler(chatAwareSuccessHandler())
                .failureHandler(failureHandler)
                .userInfoEndpoint(ui -> ui.userService(customOAuth2UserService)));
        return http.build();
    }
}