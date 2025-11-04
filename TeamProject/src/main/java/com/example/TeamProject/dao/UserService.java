package com.example.TeamProject.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.Cart;
import com.example.TeamProject.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

	@Value("${kakao.api.key}")
	private String kakaoApiKey;

	@Autowired
	UserMapper userMapper;

	@Autowired
	HttpSession session;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	JavaMailSender mailSender;

	@Autowired
	MailService mailService;

	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("userPwd"));
			map.put("hashPwd", hashPwd);
			userMapper.insertUser(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> addSeller(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			userMapper.insertSeller(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> idCheck(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.idCheck(map);
			if (user != null) {
				resultMap.put("result", "N");
			} else {
				resultMap.put("result", "Y");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> login(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.loginUser(map);
			String message = "";
			String result = "";

			if (user != null) {

				// 탈퇴 여부 확인
				if ("WITHDRAWN".equals(user.getStatus())) {
					message = "탈퇴 처리된 계정입니다. 계정을 복구하시겠습니까?";
					result = "WITHDRAWN_CAN_RECOVER";
					resultMap.put("msg", message);
					resultMap.put("result", result);
					return resultMap;
				}

				boolean loginFlg = passwordEncoder.matches((String) map.get("userPwd"), user.getPassword());
				if (loginFlg) {
					message = "로그인 성공";
					result = "success";
					session.setAttribute("sessionId", user.getUserId());
					session.setAttribute("sessionStatus", user.getUserRole());
					session.setAttribute("sessionName", user.getName());
					session.setAttribute("sessionLat", user.getLat());
					session.setAttribute("sessionLng", user.getLng());
				} else {
					message = "비밀번호가 일치하지 않습니다";
					result = "fail";
				}
			} else {
				message = "아이디가 존재하지 않습니다.";
				result = "fail";
			}
			resultMap.put("msg", message);
			resultMap.put("result", result);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> logout(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		session.invalidate();
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> findId(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.findId(map);
			if (user != null) {
				resultMap.put("user", user);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}

		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> findPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.findPwd(map);
			if (user != null) {
				String autoCode = String.valueOf((int) (Math.random() * 900000) + 100000);
				mailService.saveAuthCode(user.getEmail(), autoCode);
				sendAuthCode(user.getEmail(), autoCode);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public void sendAuthCode(String toEmail, String code) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(toEmail);
		message.setSubject("[AGRICOLA] 비밀번호 재설정 인증코드 안내");
		message.setText("안녕하세요 AGRICOLA입니다.\n\n" + "요청하신 인증코드는 아래와 같습니다.\n\n" + "인증코드: " + code + "\n\n"
				+ "본인이 요청하지 않았다면 본 메일을 무시해주세요.\n\n감사합니다.");
		message.setFrom("sungmin3790@gmail.com"); // Gmail 계정과 동일하게
		mailSender.send(message);
	}

	public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String email = (String) map.get("userEmail");
		String authCode = (String) map.get("authCode");

		try {
			boolean isValid = mailService.verifyAuthCode(email, authCode);
			if (isValid) {
				String hashPwd = passwordEncoder.encode((String) map.get("newPwd"));
				map.put("hashPwd", hashPwd);
				userMapper.resetPwd(map);
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "invalid"); // 인증 실패
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 프로필 유저 정보 가져오기
	public HashMap<String, Object> getUserProfile(String userId) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			if (userId == null || userId.isEmpty()) {
				resultMap.put("status", "error");
				resultMap.put("message", "Not logged in");
				return resultMap;
			}

			HashMap<String, Object> paramMap = new HashMap<>();
			paramMap.put("userId", userId);
			User userProfile = userMapper.loginUser(paramMap);

			if (userProfile == null) {
				resultMap.put("status", "error");
				resultMap.put("message", "User not found");
				return resultMap;
			}

			// 비밀번호 값으로 로그인 유형 결정
			String password = userProfile.getPassword();
			String loginType = (password == null || password.equals("social_user_password")) ? "SOCIAL" : "NORMAL";

			// 프론트엔드로 보낼 최종 데이터 조립
			resultMap.put("name", userProfile.getName());
			resultMap.put("email", userProfile.getEmail());
			resultMap.put("phone", userProfile.getPhone());
			resultMap.put("address", userProfile.getAddress());
			resultMap.put("loginType", loginType);

		} catch (Exception e) {
			resultMap.put("status", "error");
			resultMap.put("message", "사용자 정보 조회 중 오류가 발생했습니다.");
			e.printStackTrace();
		}

		return resultMap;
	}

	// 프로필 정보 수정
	public HashMap<String, Object> updateProfile(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. 전화번호 유효성 검사 및 하이픈 제거
			if (map.containsKey("phone")) {
				String phone = (String) map.get("phone");
				String rawPhone = phone.replaceAll("-", ""); // 하이픈 제거

				// 정규식: 10~11자리의 숫자
				if (!rawPhone.matches("^\\d{10,11}$")) {
					resultMap.put("result", "fail");
					resultMap.put("message", "올바른 전화번호 형식이 아닙니다. (예: 01012345678)");
					return resultMap;
				}
				map.put("phone", rawPhone); // 정제된 데이터로 교체
			}

			// 2. 비밀번호 유효성 검사 및 암호화
			if (map.containsKey("password") && map.get("password") != null
					&& !((String) map.get("password")).isEmpty()) {
				String password = (String) map.get("password");

				String pwdRegex = "^(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_=+\\[\\]{};:'\\\",.<>\\/?\\\\|`~])(?!.*\\s).{8,16}$";
				if (!password.matches(pwdRegex)) {
					resultMap.put("result", "fail");
					resultMap.put("message", "비밀번호는 소문자, 숫자, 특수문자를 포함하여 8~16자 이내여야 합니다.");
					return resultMap;
				}

				String hashPwd = passwordEncoder.encode(password);
				map.put("hashPwd", hashPwd);
			}

			userMapper.updateProfile(map);
			resultMap.put("result", "success");

		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "회원정보 수정 중 오류가 발생했습니다.");
			e.printStackTrace();
		}

		return resultMap;
	}

	// ✅ 주소를 좌표로 변환
	public double[] getCoordinatesFromAddress(String address) {
		double[] result = new double[2]; // [lat, lng]
		try {
			String query = URLEncoder.encode(address, "UTF-8");
			String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + query;

			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + kakaoApiKey);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null)
				sb.append(line);
			br.close();

			JSONObject json = new JSONObject(sb.toString());
			if (json.getJSONArray("documents").length() > 0) {
				JSONObject addr = json.getJSONArray("documents").getJSONObject(0);
				JSONObject addressObj = addr.getJSONObject("address");
				result[0] = addressObj.getDouble("y"); // lat
				result[1] = addressObj.getDouble("x"); // lng
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 회원 탈퇴
	public HashMap<String, Object> withdrawUser(HashMap<String, Object> map, HttpSession session) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			if (userId == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}
			map.put("userId", userId);

			// 1. 사용자 정보 조회 (비밀번호 및 로그인 타입 확인용)
			HashMap<String, Object> paramMap = new HashMap<>();
			paramMap.put("userId", userId);
			User userProfile = userMapper.loginUser(paramMap);

			if (userProfile == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "사용자 정보를 찾을 수 없습니다.");
				return resultMap;
			}

			String loginType = (userProfile.getPassword() == null
					|| "social_user_password".equals(userProfile.getPassword())) ? "SOCIAL" : "NORMAL";

			// 2. 로그인 타입에 따른 비밀번호 확인
			if (loginType.equals("NORMAL")) {
				String inputPassword = (String) map.get("password");
				if (inputPassword == null || inputPassword.isEmpty()) {
					resultMap.put("result", "fail");
					resultMap.put("message", "비밀번호를 입력해주세요.");
					return resultMap;
				}
				if (!passwordEncoder.matches(inputPassword, userProfile.getPassword())) {
					resultMap.put("result", "fail");
					resultMap.put("message", "비밀번호가 일치하지 않습니다.");
					return resultMap;
				}
			}
			// 소셜 로그인 사용자는 비밀번호 확인을 건너뜁니다.

			// 3. 사용자 정보 변경
			userMapper.updateUserStatus(userId, "WITHDRAWN");

			// 4. 세션 무효화
			session.invalidate();

			resultMap.put("result", "success");
			resultMap.put("message", "회원 탈퇴가 성공적으로 처리되었습니다.");

		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "회원 탈퇴 중 오류가 발생했습니다.");
			e.printStackTrace();
		}

		return resultMap;
	}

	// 계정 복구
	public HashMap<String, Object> recoverUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) map.get("userId");
			if (userId == null || userId.isEmpty()) {
				resultMap.put("result", "fail");
				resultMap.put("message", "사용자 ID가 누락되었습니다.");
				return resultMap;
			}

			// 사용자 상태를 'ACTIVE'로 업데이트
			int updatedRows = userMapper.updateUserStatus(userId, "ACTIVE");

			if (updatedRows > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "계정이 성공적으로 복구되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "계정 복구에 실패했습니다. 사용자 ID를 확인해주세요.");
			}

		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "계정 복구 중 오류가 발생했습니다.");
			e.printStackTrace();
		}

		return resultMap;
	}

	public HashMap<String, Object> addCart(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			if (map.get("quantity") == null || String.valueOf(map.get("quantity")).trim().equals("")) {
				map.put("quantity", 1);
			}
			// 1) 같은 상품이 이미 있으면 수량만 증가
			int cnt = userMapper.updateCartQty(map);
			// 2) 없으면 새로 추가
			if (cnt == 0) {
				userMapper.insertCart(map);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}

		return resultMap;
	}

	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Cart> list = userMapper.selectCartList(map);
			int total = userMapper.selectCartTotal(map); // 합계(상품합)
			resultMap.put("list", list);
			resultMap.put("total", total);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> updateQty(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt  = userMapper.updateQty(map);
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> removeItem(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = userMapper.deleteCartItem(map); 
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

}