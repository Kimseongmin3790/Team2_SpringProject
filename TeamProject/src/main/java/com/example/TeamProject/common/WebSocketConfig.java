package com.example.TeamProject.common;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

//이 클래스는 “웹소켓 + STOMP”를 쓰기 위한 스프링 설정입니다.
@Configuration // 스프링 설정 클래스임을 알림 (자바 기반 설정)
@EnableWebSocketMessageBroker // STOMP 메시지 브로커 기능 활성화
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	// 클라이언트가 연결할 엔드포인트: /ws-chat
	// 브라우저에서 new SockJS('/ws-chat')로 접속할 때 매칭
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/ws-chat").setAllowedOriginPatterns("*") // 필요시 도메인으로 제한
				.addInterceptors(new HttpSessionHandshakeInterceptor()).withSockJS();
	}

	// /app/* 으로 들어온 메시지를 @MessageMapping 으로 라우팅
	// 서버가 /topic/...으로 publish 한 메시지는 해당 경로를 구독한 모든 클라에 전송
	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.setApplicationDestinationPrefixes("/app"); // 클라이언트→서버 보낼 때 prefix
		config.enableSimpleBroker("/topic"); // 서버→클라이언트 broadcast prefix
	}

}