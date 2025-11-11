package com.example.TeamProject.config.auth;

import com.example.TeamProject.model.User;
import java.util.Map;

public class OAuthAttributes {
    private Map<String, Object> attributes;
    private String nameAttributeKey;
    private String name;
    private String email;
    private String phone;

    public OAuthAttributes(Map<String, Object> attributes, String nameAttributeKey, String name, String email, String phone) {
        this.attributes = attributes;
        this.nameAttributeKey = nameAttributeKey;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    // 각 소셜 타입별로 데이터를 가져오는 로직
    public static OAuthAttributes of(String registrationId, String userNameAttributeName, Map<String, Object> attributes) {
        if ("naver".equals(registrationId)) {
            return ofNaver(userNameAttributeName, attributes);
        }
        if ("kakao".equals(registrationId)) {
            return ofKakao("id", attributes);
        }
        return ofGoogle(userNameAttributeName, attributes);
    }

    private static OAuthAttributes ofGoogle(String userNameAttributeName, Map<String, Object> attributes) {
        return new OAuthAttributes(attributes, userNameAttributeName,
                (String) attributes.get("name"),
                (String) attributes.get("email"),
                null);
    }

    private static OAuthAttributes ofNaver(String userNameAttributeName, Map<String, Object> attributes) {
        Map<String, Object> response = (Map<String, Object>) attributes.get("response");
        return new OAuthAttributes(
                response,       
                "id",             
                (String) response.get("name"),
                (String) response.get("email"),
                (String) response.get("mobile")
        );
    }



    private static OAuthAttributes ofKakao(String userNameAttributeName, Map<String, Object> attributes) {
        Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
        Map<String, Object> kakaoProfile = (Map<String, Object>) kakaoAccount.get("profile");
        // 이메일 동의를 받지 않았으므로, 카카오의 고유 ID를 사용하여 임시 이메일 주소를 생성
        String tempEmail = "kakao_" + attributes.get("id").toString() + "@social.local";
        
        return new OAuthAttributes(attributes, userNameAttributeName,
                (String) kakaoProfile.get("nickname"),
                tempEmail,
                null);
    }

    // User 엔티티(모델) 생성
   	public User toEntity() {
	    User user = new User();
	    user.setUserId(email); // USER_ID 필드에 이메일을 설정
	    user.setName(name);
	    user.setEmail(email);
	    user.setPhone(phone);
	    user.setUserRole("BUYER"); // 소셜 로그인 시 기본 권한
	    // 소셜 로그인 사용자는 일반 비밀번호가 없으므로 password 필드는 null로 둡니다.
	    return user;
	}

    // Getter
    public Map<String, Object> getAttributes() { return attributes; }
    public String getNameAttributeKey() { return nameAttributeKey; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
}