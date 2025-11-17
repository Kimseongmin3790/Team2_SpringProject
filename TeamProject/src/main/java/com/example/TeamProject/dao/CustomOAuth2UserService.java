package com.example.TeamProject.dao;

import java.util.Collections;
import java.util.HashMap; // ✨ 추가
import java.util.Map;     // ✨ 추가
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

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    @Autowired
    private UserMapper userMapper;


    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2UserService<OAuth2UserRequest, OAuth2User> delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName, oAuth2User.getAttributes());
        User user = saveOrUpdate(attributes);

        Map<String, Object> newAttributes = new HashMap<>(attributes.getAttributes());
        newAttributes.put("userEntity", user);

        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority(user.getUserRole())),
                newAttributes, 
                attributes.getNameAttributeKey());
    }

    private User saveOrUpdate(OAuthAttributes attributes) {
        User user = userMapper.findByEmail(attributes.getEmail());
        if (user != null) {
            if ("WITHDRAWN".equals(user.getStatus())) {
                throw new OAuth2AuthenticationException("WITHDRAWN_ACCOUNT");
            }
            user.setName(attributes.getName());
            userMapper.updateUser(user);
        } else {
            user = attributes.toEntity();
            userMapper.insertSocialUser(user);
        }
        return user;
    }
}