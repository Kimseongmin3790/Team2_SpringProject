package com.example.TeamProject.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.mapper.UserMapper;
import com.example.TeamProject.model.Cart;
import com.example.TeamProject.model.Product;
import com.example.TeamProject.model.SellerVO;
import com.example.TeamProject.model.User;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

	@Value("${kakao.api.key}")
	private String kakaoApiKey;

	@Autowired
	UserMapper userMapper;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	JavaMailSender mailSender;

	@Autowired
	MailService mailService;
	
	@Autowired 
	SellerService sellerService;
	
	@Autowired
    private ObjectMapper objectMapper;

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

	public HashMap<String, Object> login(HashMap<String, Object> map, HttpSession session) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        User user = userMapper.loginUser(map);
	        String message = "";
	        String result = "";

	        if (user != null) {
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

	                // 판매자 상태 확인
	                if ("SELLER".equals(user.getUserRole())) {
	                    HashMap<String, Object> sellerResult = sellerService.getSellerInfoForMyPage(user.getUserId());
	                    String verifiedStatus = "N";
	                    if ("success".equals(sellerResult.get("result"))) {
	                        SellerVO sellerVO = (SellerVO) sellerResult.get("sellerInfo");
	                        if (sellerVO != null && sellerVO.getVerified() != null) {
	                            verifiedStatus = sellerVO.getVerified();
	                        }
	                    }
	                    session.setAttribute("sellerVerifiedStatus", verifiedStatus);
	                } else {
	                    session.removeAttribute("sellerVerifiedStatus");
	                }
	            } else {
	                message = "비밀번호가 일치하지 않습니다.";
	                result = "fail";
	            }
	        } else {
	            message = "아이디가 존재하지 않습니다.";
	            result = "fail";
	        }
	        resultMap.put("msg", message);
	        resultMap.put("result", result);
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}

	public HashMap<String, Object> logout(HashMap<String, Object> map, HttpSession session) {
	    HashMap<String, Object> resultMap = new HashMap<>();
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
	
	public HashMap<String, Object> findIdByPhone(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			User user = userMapper.findIdByPhone(map);
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

	public HashMap<String, Object> addCart(HashMap<String, Object> in) {
	    HashMap<String, Object> out = new HashMap<>();
	    try {
	        // 1) 파라미터 정규화
	        String userId     = safeStr(in.get("userId"));
	        Integer productNo = toInt(in.get("productNo"), null);
	        Integer optionNo  = toInt(in.get("optionNo"), null); // nullable
	        Integer qty       = Math.max(1, toInt(in.get("quantity"), 1));
	        String fulfillment= normalizeFulfillment(safeStrOrDefault(in.get("fulfillment"), "delivery"));
	        Integer shippingFee = "delivery".equals(fulfillment) ? 3000 : 0; // 서버에서 확정

	        if (userId == null || userId.isBlank() || productNo == null) {
	            out.put("result", "fail");
	            out.put("message", "필수값 누락(userId/productNo)");
	            return out;
	        }

	        // 2) 동일 라인(cart key) 존재 여부
	        Map<String,Object> key = new HashMap<>();
	        key.put("userId", userId);
	        key.put("productNo", productNo);
	        key.put("optionNo", optionNo);
	        key.put("fulfillment", fulfillment);

	        Long cartNo = userMapper.selectCartNoByKey(key);

	        if (cartNo != null) {
	            // 3-A) 있으면 수량 누적 + 배송비 최신화
	            Map<String,Object> upd = new HashMap<>(key);
	            upd.put("quantity", qty);
	            upd.put("shippingFee", shippingFee);
	            int updated = userMapper.updateCartQtyByKey(upd); // WHERE key
	            if (updated <= 0) throw new IllegalStateException("장바구니 수량 업데이트 실패");
	        } else {
	            // 3-B) 없으면 신규 INSERT (시퀀스로 cartNo 생성)
	            Map<String,Object> ins = new HashMap<>(key);
	            ins.put("quantity", qty);
	            ins.put("shippingFee", shippingFee);
	            userMapper.insertCarts(ins); // selectKey로 cartNo 세팅
	            cartNo = toLong(ins.get("cartNo"));
	            if (cartNo == null) {
	                // Oracle MERGE/INSERT 환경에 따라 selectKey가 안 잡히면 재조회
	                cartNo = userMapper.selectCartNoByKey(key);
	            }
	            if (cartNo == null) throw new IllegalStateException("장바구니 행 생성 실패");
	        }

	        out.put("result", "success");
	        out.put("cartNo", cartNo);
	        out.put("quantity", qty);
	        out.put("fulfillment", fulfillment);
	        out.put("shippingFee", shippingFee);
	        return out;

	    } catch (Exception e) {
	        e.printStackTrace();
	        out.put("result", "fail");
	        out.put("message", e.getMessage());
	        return out;
	    }
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

	public HashMap<String, Object> allRemoveItem(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int cnt = userMapper.allDelete(map);
			resultMap.put("result", "sucess");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getSellerProductList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = userMapper.getSellerProductList(map);
			resultMap.put("list", list);
			resultMap.put("result", "sucess");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> hiddenSellerProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			userMapper.hiddenSellerProduct(map);
			resultMap.put("result", "sucess");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getSellerProductDetail(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product detail = userMapper.getsellerProductDetail(map);
			List<Product> option = userMapper.getsellerProductOption(map);
			List<Product> image = userMapper.getsellerProductImage(map);
			Product category = userMapper.getsellerProductCategory(toInt(detail.getCategoryNo(), null));
			
			resultMap.put("detail", detail);
			resultMap.put("option", option);
			resultMap.put("image", image);
			resultMap.put("category", category);
			
			resultMap.put("result", "sucess");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	@Transactional
    public Map<String, Object> updateProductAll(
            Integer productNo,
            Integer categoryNo,
            String pname,
            String pinfo,
            Integer price,
            String origin,
            String productStatus,
            // JSON 문자열
            String optionsJson,              // [{optionNo, optionName, addPrice, stock}]
            String deletedOptionNosJson,     // [101,102,...]
            String deletedImageNosJson,      // [201,202,...]
            // 파일
            MultipartFile thumbnail,
            List<MultipartFile> galleryImages,
            List<MultipartFile> detailImages,
            // 파일 저장 경로
            String uploadDir
    ) throws Exception {

        Map<String, Object> out = new HashMap<>();

        /* 1) 기본 상품 업데이트 */
        Map<String, Object> base = new HashMap<>();
        base.put("productNo", productNo);
        base.put("categoryNo", categoryNo);
        base.put("pname", pname);
        base.put("pinfo", pinfo);
        base.put("price", price);
        base.put("origin", origin);
        base.put("productStatus", productStatus); // SELLING / SOLDOUT / HIDDEN

        userMapper.updateProduct(base);

        /* 2) 삭제 옵션 처리 */
        List<Integer> deletedOptionNos = parseIntList(deletedOptionNosJson);
        if (!deletedOptionNos.isEmpty()) {
            Map<String, Object> delParam = new HashMap<>();
            delParam.put("productNo", productNo);
            delParam.put("optionNos", deletedOptionNos);
            userMapper.deleteOptions(delParam);
        }

        /* 3) 옵션 upsert (optionNo 있으면 update, 없으면 insert) */
        List<Map<String, Object>> options = parseOptionList(optionsJson);
        for (Map<String, Object> op0 : options) {
            Integer optionNo = toInt(op0.get("optionNo"), null);
            String optionName = String.valueOf(op0.getOrDefault("optionName", "")).trim(); // → UNIT
            Integer addPriceV = toInt(op0.get("addPrice"), 0);
            Integer stockV = toInt(op0.get("stock"), 0);                                   // → STOCK_QTY

            Map<String, Object> op = new HashMap<>();
            op.put("productNo", productNo);
            op.put("unit", optionName);
            op.put("addPrice", addPriceV);
            op.put("stockQty", stockV);

            if (optionNo != null) {
                op.put("optionNo", optionNo);
                userMapper.updateOption(op);
            } else {
            	userMapper.insertOption(op); // 시퀀스/AI는 XML에서 처리
            }
        }

        /* 4) 삭제 이미지 처리 */
        List<Integer> deletedImageNos = parseIntList(deletedImageNosJson);
        if (!deletedImageNos.isEmpty()) {
            Map<String, Object> delParam = new HashMap<>();
            delParam.put("productNo", productNo);
            delParam.put("imageNos", deletedImageNos);
            userMapper.deleteImages(delParam);
        }

        /* 5) 썸네일 / 갤러리 / 상세 이미지 저장 */
        new File(uploadDir).mkdirs();

        // 썸네일 새로 올라오면 기존 썸네일 해제 + 신규 저장
        if (thumbnail != null && !thumbnail.isEmpty()) {
        	userMapper.clearThumbnail(productNo); // 기존 'Y' → 'N' 처리
            String url = saveFile(thumbnail, uploadDir);
            Map<String, Object> img = new HashMap<>();
            img.put("productNo", productNo);
            img.put("imageUrl", url);
            img.put("imageType", "Y"); // 썸네일
            userMapper.insertImage(img);
        }

        if (galleryImages != null) {
            for (MultipartFile f : galleryImages) {
                if (f != null && !f.isEmpty()) {
                    String url = saveFile(f, uploadDir);
                    Map<String, Object> img = new HashMap<>();
                    img.put("productNo", productNo);
                    img.put("imageUrl", url);
                    img.put("imageType", "A"); // 갤러리
                    userMapper.insertImage(img);
                }
            }
        }

        if (detailImages != null) {
            for (MultipartFile f : detailImages) {
                if (f != null && !f.isEmpty()) {
                    String url = saveFile(f, uploadDir);
                    Map<String, Object> img = new HashMap<>();
                    img.put("productNo", productNo);
                    img.put("imageUrl", url);
                    img.put("imageType", "N"); // 상세
                    userMapper.insertImage(img);
                }
            }
        }

        out.put("result", "success");
        out.put("productNo", productNo);
        return out;
    }
	
	/* ===== 유틸 ===== */
	private String safeStr(Object v){ return v==null? null : String.valueOf(v); }
	private String safeStrOrDefault(Object v, String def){
	    String s = safeStr(v);
	    return (s==null || s.isBlank() || "null".equalsIgnoreCase(s) || "undefined".equalsIgnoreCase(s)) ? def : s;
	}
	private Integer toInt(Object v, Integer def){
	    if (v == null) return def;
	    if (v instanceof Number) return ((Number)v).intValue();
	    try {
	        String s = v.toString().trim().replaceAll(",", "");
	        if (s.isEmpty() || "null".equalsIgnoreCase(s) || "undefined".equalsIgnoreCase(s)) return def;
	        return new java.math.BigDecimal(s).intValue();
	    } catch (Exception e){ return def; }
	}
	private Long toLong(Object v){
	    if (v == null) return null;
	    if (v instanceof Number) return ((Number)v).longValue();
	    try { return new java.math.BigDecimal(v.toString().trim()).longValue(); }
	    catch(Exception e){ return null; }
	}
	private String normalizeFulfillment(String f){
	    return "pickup".equalsIgnoreCase(f) ? "pickup" : "delivery";
	}
	private List<Integer> parseIntList(String json) {
        try {
            if (json == null || json.isBlank()) return List.of();
            return objectMapper.readValue(json, new TypeReference<List<Integer>>() {});
        } catch (Exception e) {
            return List.of();
        }
    }

    private List<Map<String, Object>> parseOptionList(String json) {
        try {
            if (json == null || json.isBlank()) return List.of();
            return objectMapper.readValue(json, new TypeReference<List<Map<String, Object>>>() {});
        } catch (Exception e) {
            return List.of();
        }
    }
    private String saveFile(MultipartFile file, String uploadDir) throws IOException {
        String ext = "";
        String name = file.getOriginalFilename();
        if (name != null && name.lastIndexOf('.') >= 0) {
            ext = name.substring(name.lastIndexOf('.'));
        }
        String saved = java.util.UUID.randomUUID() + ext;
        File dest = new File(uploadDir, saved);
        file.transferTo(dest);
        // 웹경로는 프로젝트 구조에 맞게 매핑
        return "/resources/uploads/productImage/" + saved;
    }

}