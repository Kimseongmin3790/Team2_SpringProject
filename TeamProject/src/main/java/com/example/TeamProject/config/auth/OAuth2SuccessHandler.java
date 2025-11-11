package com.example.TeamProject.config.auth;

import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component // Spring이 이 클래스를 관리하도록 @Component 어노테이션을 추가합니다.
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줍니다. (Lombok)
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final UserMapper userMapper; // 사용자 정보를 가져오기 위해 UserMapper를 주입받습니다.

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
Authentication authentication)
            throws IOException, ServletException {

        // Spring Security가 만든 인증 객체(Authentication)에서 사용자 정보를 꺼냅니다.
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getAttribute("email"); // 소셜 서비스에서 제공한 이메일

        // DB에서 해당 이메일의 사용자 정보를 다시 조회합니다.
        User user = userMapper.findByEmail(email);

        if (user != null) {
            // ✨ 로그인 성공이 확정된 이 시점에서 세션을 설정합니다.
            HttpSession session = request.getSession();
            session.setAttribute("sessionId", user.getUserId());
      session.setAttribute("sessionStatus", user.getUserRole());
            session.setAttribute("sessionName", user.getName());
            session.setMaxInactiveInterval(3600); // 세션 유효 시간을 1시간으로 설정합니다.

            // 모든 처리가 끝난 후, 사용자를 메인 페이지("/")로 리디렉션합니다.
            String targetUrl = "/";
            getRedirectStrategy().sendRedirect(request, response, targetUrl);
        } else {
            // 만약 DB에 사용자가 없다면 (비정상적인 경우), 에러와 함께 로그인 페이지로 보냅니다.
            getRedirectStrategy().sendRedirect(request, response, "/user/login?error=true");
        }
    }
}