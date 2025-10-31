package com.example.TeamProject.dao;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.TeamProject.config.auth.OAuthAttributes;
import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private HttpSession httpSession;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2UserService<OAuth2UserRequest, OAuth2User> delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName =
userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName,oAuth2User.getAttributes());

        User user = saveOrUpdate(attributes);

        httpSession.setAttribute("sessionId", user.getUserId());
        httpSession.setAttribute("sessionStatus", user.getUserRole());
        httpSession.setAttribute("sessionName", user.getName());

        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority(user.getUserRole())),
                attributes.getAttributes(),
                attributes.getNameAttributeKey());
    }

    private User saveOrUpdate(OAuthAttributes attributes) {
        User user = userMapper.findByEmail(attributes.getEmail());

        if (user != null) {
            // 1. 사용자 상태 확인
            if ("WITHDRAWN".equals(user.getStatus())) {
                // 탈퇴된 계정은 로그인 방지
                // 예외 메시지를 HttpSession에 저장하여 CustomOAuth2AuthenticationFailureHandler에서 사용
                httpSession.setAttribute("oauth2ErrorMessage", "탈퇴 처리된 계정입니다. 계정 복구를 시면 관리자에게 문의해주세요.");
                throw new OAuth2AuthenticationException("WITHDRAWN_ACCOUNT"); // 고유한 코드만 던집니다.
            }

            // 이미 가입된 회원이면 정보만 업데이트
            user.setName(attributes.getName());
            userMapper.updateUser(user);
        } else {
            // 처음 가입하는 회원이면 DB에 저장
            user = attributes.toEntity();
            userMapper.insertSocialUser(user);
        }
        return userMapper.findByEmail(attributes.getEmail());
    }
    
}