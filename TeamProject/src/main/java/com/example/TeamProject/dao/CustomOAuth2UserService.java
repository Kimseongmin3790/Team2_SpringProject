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
        httpSession.setAttribute("userName", user.getName());

        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority(user.getUserRole())),
                attributes.getAttributes(),
                attributes.getNameAttributeKey());
    }

    private User saveOrUpdate(OAuthAttributes attributes) {
        User user = userMapper.findByEmail(attributes.getEmail());

        if (user != null) {
            // 이미 가입된 회원이면 정보만 업데이트
            user.setName(attributes.getName());
            user.setPhone(attributes.getPhone());
            userMapper.updateUser(user);
        } else {
            // 처음 가입하는 회원이면 DB에 저장
            user = attributes.toEntity();
            userMapper.insertSocialUser(user);
        }
        // DB에 저장되거나 업데이트된 최신 사용자 정보를 다시 조회하여 반환
        return userMapper.findByEmail(attributes.getEmail());
    }
}