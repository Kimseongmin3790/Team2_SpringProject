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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;

import com.example.TeamProject.config.auth.CustomOAuth2AuthenticationFailureHandler;
import com.example.TeamProject.dao.CustomOAuth2UserService;

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
			Object p = authentication.getPrincipal();
			if (p instanceof OAuth2User o) {
				String uid = o.getName(); // provider가 주는 식별자
				String name = String.valueOf(o.getAttributes().getOrDefault("name", uid));
				s.setAttribute("sessionId", uid);
				s.setAttribute("sessionName", name);
				s.setAttribute("userId", uid); // 채팅 코드가 참조하는 키도 함께
				s.setAttribute("userName", name);
			}
			s.setMaxInactiveInterval(60 * 60); // 선택: 1시간

			// 1) redirect 파라미터가 있으면 거기로
			String target = request.getParameter("redirect");
			if (target != null && !target.isBlank()) {
				response.sendRedirect(target);
				return;
			}

			// 2) SavedRequest 있으면 거기로
			var cache = new HttpSessionRequestCache();
			var saved = cache.getRequest(request, response);
			if (saved != null) {
				new SavedRequestAwareAuthenticationSuccessHandler().onAuthenticationSuccess(request, response,
						authentication);
				return;
			}

			// 3) 기본
			response.sendRedirect("/main.do");
		};
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http.csrf(csrf -> csrf.disable()).sessionManagement(sm -> sm.sessionFixation().migrateSession()) 
				.authorizeHttpRequests(auth -> auth
						.requestMatchers("/img/**", "/css/**", "/js/**", "/webjars/**", "/resources/**", "/uploads/**")
						.permitAll().requestMatchers("/ws-chat/**", "/chatting.do").permitAll().anyRequest()
						.permitAll())
				.oauth2Login(oauth2 -> oauth2.loginPage("/login.do").defaultSuccessUrl("/main.do", true)
						.successHandler(chatAwareSuccessHandler())
						.failureHandler(failureHandler)
						.userInfoEndpoint(ui -> ui.userService(customOAuth2UserService)));
		return http.build();
	}
}