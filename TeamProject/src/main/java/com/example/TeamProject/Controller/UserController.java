package com.example.TeamProject.Controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.TeamProject.dao.OrderService;
import com.example.TeamProject.dao.SellerService;
import com.example.TeamProject.dao.UserService;
import com.example.TeamProject.mapper.UserMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

	@Autowired
	UserService userService;

	@Autowired
	OrderService orderService;

	@Autowired
	private SellerService sellerService;
	
	@RequestMapping("/login.do")
	public String login(Model model) throws Exception {

		return "user/login";
	}

	@RequestMapping("/chooseJoin.do")
	public String chooseJoin(Model model) throws Exception {

		return "user/chooseJoin";
	}

	@RequestMapping("/userJoin.do")
	public String join(Model model) throws Exception {

		return "user/userJoin";
	}

	@RequestMapping("/sellerJoin.do")
	public String sellerJoin(Model model) throws Exception {

		return "user/sellerJoin";
	}

	@RequestMapping("/findId.do")
	public String findId(Model model) throws Exception {

		return "user/findId";
	}

	@RequestMapping("/findPwd.do")
	public String findPwd(Model model) throws Exception {

		return "user/findPwd";
	}

	@RequestMapping("/addr.do")
	public String addr(Model model) throws Exception {

		return "jusoPopup";
	}

	@RequestMapping("/buyerMyPage.do")
	public String buyerMyPage(Model model,
			@RequestParam(value = "tab", required = false, defaultValue = "cart") String tab) throws Exception {
		model.addAttribute("activeTab", tab);
		return "user/buyerMypage";
	}

    @RequestMapping("/sellerMyPage.do")
    public String sellerMyPage(Model model, HttpSession session, RedirectAttributes redirectAttributes)
    throws Exception {
        String userId = (String) session.getAttribute("sessionId");

        // userId가 null인지 먼저 확인
        if (userId == null || userId.isEmpty()) {
            redirectAttributes.addFlashAttribute("redirectMessage", "로그인이 필요합니다.");
            return "redirect:/login.do"; // 로그인 페이지로 리다이렉트
        }

        HashMap<String, Object> serviceResult = sellerService.getSellerInfoForMyPage(userId);
        String resultStatus = (String) serviceResult.get("result");
        String message = (String) serviceResult.get("message");

        if ("success".equals(resultStatus)) {
            String loginType = (String) session.getAttribute("loginType");
            if (loginType == null) { // 혹시 세션에 없는 경우를 대비한 기본값
                loginType = "NORMAL"; // 또는 "UNKNOWN" 등 적절한 기본값
            }
            model.addAttribute("loginType", loginType); // 모델에 loginType 추가

            return "user/sellerMyPage";
        } else {
            redirectAttributes.addFlashAttribute("redirectMessage", message);
            return "redirect:/main.do";
        }
    }

	@RequestMapping("/cart.do")
	public String cart(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map.get("productNo"));
		request.setAttribute("productNo", map.get("productNo"));

		return "user/cart";
	}
	
	@RequestMapping("/sellerProductList.do")
	public String sellerProductList(Model model) throws Exception {

		return "user/sellerProductList";
	}
	
	@RequestMapping("/sellerProductEdit.do")
	public String sellerProductEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("productNo", map.get("productNo"));
		
		return "user/sellerProductEdit";
	}

	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		// 주소 → 좌표 변환
		String addr = (String) map.get("userAddr");
		double[] coords = userService.getCoordinatesFromAddress(addr);
		double lat = coords[0];
		double lng = coords[1];

		map.put("lat", lat);
		map.put("lng", lng);

		resultMap = userService.addUser(map);

		return new Gson().toJson(resultMap);
	}

	// 장바구니 추가
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {

	    HashMap<String, Object> res = new HashMap<>();

	    try {
	        // 세션 사용자 우선 사용 (보안)
	        String sessionUser = (String) session.getAttribute("sessionId");
	        String userId = (sessionUser != null && !sessionUser.isBlank())
	                ? sessionUser
	                : String.valueOf(map.get("userId"));

	        if (userId == null || userId.isBlank()) {
	            res.put("result", "fail");
	            res.put("message", "로그인이 필요합니다.");
	            return new com.google.gson.Gson().toJson(res);
	        }

	        // 숫자/문자 정규화
	        Integer productNo  = toInt(map.get("productNo"), null);
	        Integer optionNo   = toInt(map.get("optionNo"), null);   // CART.OPTION_NO 존재 가정 (nullable)
	        Integer quantity   = Math.max(1, toInt(map.get("quantity"), 1));

	        // 수령 방법 & 배송비는 서버에서 결정 (클라 shippingFee 무시)
	        String fulfillment = String.valueOf(map.getOrDefault("fulfillment", "delivery"));
	        fulfillment = "pickup".equalsIgnoreCase(fulfillment) ? "pickup" : "delivery";
	        int shippingFee = "delivery".equals(fulfillment) ? 3000 : 0;

	        // 필수값 검증
	        if (productNo == null) {
	            res.put("result", "fail");
	            res.put("message", "productNo가 없습니다.");
	            return new com.google.gson.Gson().toJson(res);
	        }

	        // 서비스에 넘길 '클린 파라미터' 구성 (불신 필드 제거: unitPrice/totalPrice/optionUnit 등)
	        HashMap<String, Object> clean = new HashMap<>();
	        clean.put("userId", userId);
	        clean.put("productNo", productNo);
	        clean.put("optionNo", optionNo);
	        clean.put("quantity", quantity);
	        clean.put("fulfillment", fulfillment);
	        clean.put("shippingFee", shippingFee);

	        // 장바구니 저장 (MERGE or INSERT) -> cartNo 반환 기대
	        HashMap<String, Object> resultMap = userService.addCart(clean);

	        // cartNo 세션 보조 저장 (선택)
	        Long cartNo = toLong(resultMap.get("cartNo"));
	        if (cartNo != null) {
	            @SuppressWarnings("unchecked")
	            Map<Long, String> fMap = (Map<Long, String>) session.getAttribute("cartFulfillment");
	            if (fMap == null) {
	                fMap = new HashMap<>();
	                session.setAttribute("cartFulfillment", fMap);
	            }
	            fMap.put(cartNo, fulfillment);
	        }

	        // 응답
	        if (!resultMap.containsKey("result")) {
	            resultMap.put("result", "success");
	        }
	        return new com.google.gson.Gson().toJson(resultMap);

	    } catch (Exception e) {
	        e.printStackTrace();
	        res.put("result", "fail");
	        res.put("message", e.getMessage());
	        return new com.google.gson.Gson().toJson(res);
	    }
	}

	// 장바구니 목록
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.getCartList(map);

		return new Gson().toJson(resultMap);
	}

	// 수량 변경
	@RequestMapping(value = "/cart/qty.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartQty(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.updateQty(map);
		return new Gson().toJson(resultMap);
	}

	// 항목 삭제
	@RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.removeItem(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/Allremove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartAllRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String json = map.get("selectItem").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {
		});
		map.put("list", list);
		System.out.println(map);
		resultMap = userService.allRemoveItem(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/sellerJoin.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> sellerJoin(
	    @RequestParam("farmName") String farmName,
	    @RequestParam("bizNo") String bizNo,
	    @RequestParam("bankName") String bankName,
	    @RequestParam("account") String account,
	    @RequestParam("userAddr") String userAddr,
	    @RequestParam("bizLicense") MultipartFile bizLicense,
	    @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
	    @RequestParam("userId") String userId,
	    HttpServletRequest request) {

	    Map<String, Object> response = new HashMap<>();

	    // 파일 업로드 처리
	    String fileWebPath = null;
	    if (bizLicense != null && !bizLicense.isEmpty()) {
	        try {
	            String uploadDir = request.getServletContext().getRealPath("/resources/uploads/licenses");
	            File dir = new File(uploadDir);
	            if (!dir.exists()) dir.mkdirs();

	            String originalFilename = bizLicense.getOriginalFilename();
	            String extName = originalFilename.substring(originalFilename.lastIndexOf("."));
	            String savedFileName = genSaveFileName(extName);

	            File serverFile = new File(uploadDir, savedFileName);
	            bizLicense.transferTo(serverFile);

	            fileWebPath = "/resources/uploads/licenses/" + savedFileName;
	        } catch (Exception e) {
	            System.out.println("파일 업로드 중 오류 발생: " + e.getMessage());
	            response.put("status", "error");
	            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
	            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	        }
	    } else {
	        response.put("status", "fail");
	        response.put("message", "사업자 등록증 파일이 필요합니다.");
	        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
	    }
	    
	    // 프로필사진 업로드 처리 (선택사항)
	    String profileWebPath = null;
	    if (profileImage != null && !profileImage.isEmpty()) {
	        try {
	            String uploadDir = request.getServletContext().getRealPath("/resources/uploads/profile");
	            File dir = new File(uploadDir);
	            if (!dir.exists()) dir.mkdirs();

	            String originalFilename = profileImage.getOriginalFilename();
	            String extName = originalFilename.substring(originalFilename.lastIndexOf("."));
	            String savedFileName = "profile_" + userId + "_" + genSaveFileName(extName);

	            File serverFile = new File(uploadDir, savedFileName);
	            profileImage.transferTo(serverFile);

	            profileWebPath = "/resources/uploads/profile/" + savedFileName;
	        } catch (Exception e) {
	            System.out.println("프로필사진 업로드 오류: " + e.getMessage());
	            // 프로필 업로드 실패해도 회원가입은 진행되게끔 처리
	        }
	    }

	    try {
	        // 주소 -> 좌표 변환
	        double[] coords = userService.getCoordinatesFromAddress(userAddr);
	        double lat = coords[0];
	        double lng = coords[1];

	        // DB 저장용 데이터 구성
	        HashMap<String, Object> sellerData = new HashMap<>();
	        sellerData.put("userId", userId);
	        sellerData.put("businessName", farmName);
	        sellerData.put("businessNumber", bizNo);
	        sellerData.put("bankName", bankName);
	        sellerData.put("account", account);
	        sellerData.put("userAddr", userAddr);
	        sellerData.put("lat", lat);
	        sellerData.put("lng", lng);
	        sellerData.put("businessLi", fileWebPath);
	        sellerData.put("profileImg", profileWebPath);
	        sellerData.put("verified", "N");

	        // DB insert 실행
	        userService.addSeller(sellerData);

	        response.put("status", "success");
	        response.put("message", "판매자 회원가입이 완료되었습니다!");
	        return new ResponseEntity<>(response, HttpStatus.OK);

	    } catch (Exception e) {
	        System.out.println("DB 저장 중 오류 발생: " + e.getMessage());
	        response.put("status", "error");
	        response.put("message", "데이터 저장 중 오류가 발생했습니다.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	// 파일명 생성 메서드
	private String genSaveFileName(String extName) {
		Calendar calendar = Calendar.getInstance();
		return calendar.get(Calendar.YEAR) + String.valueOf(calendar.get(Calendar.MONTH) + 1)
				+ calendar.get(Calendar.DATE) + calendar.get(Calendar.HOUR) + calendar.get(Calendar.MINUTE)
				+ calendar.get(Calendar.SECOND) + calendar.get(Calendar.MILLISECOND) + extName;
	}

	@RequestMapping(value = "/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.idCheck(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.login(map, session);
		if ("success".equals(String.valueOf(resultMap.get("result")))) {
			String uId = (String) session.getAttribute("sessionId"); // Service가 넣은 userId
			String uName = (String) session.getAttribute("sessionName"); // Service가 넣은 userName
				if (uId != null && !uId.isEmpty()) {
					session.setAttribute("userId", uId); // 채팅 아이디으로 사용할 값
					session.setAttribute("userName", uName); // 채팅 이름으로 사용할 값
			}
		}
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    HashMap<String, Object> resultMap = userService.logout(map, session);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.findId(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/findIdByPhone.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findIdByPhone(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.findIdByPhone(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/findPwdSendCode.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findPwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = userService.findPwd(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/findPwdReset.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findPwdReset(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = userService.resetPwd(map);

		return new Gson().toJson(resultMap);
	}

	// 로그인 유저 정보 가져오기
	@RequestMapping(value = "/userInfo.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getUserProfile(HttpSession session) throws Exception {
		String userId = (String) session.getAttribute("sessionId");
		HashMap<String, Object> resultMap = userService.getUserProfile(userId);

		return new Gson().toJson(resultMap);
	}

	// 회원 정보 수정
	@RequestMapping(value = "/updateProfile.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProfile(@RequestBody HashMap<String, Object> map, HttpSession session) throws Exception {
		String userId = (String) session.getAttribute("sessionId");
		map.put("userId", userId);
		HashMap<String, Object> resultMap = userService.updateProfile(map);

		return new Gson().toJson(resultMap);
	}

	// 회원 탈퇴 로직
	@RequestMapping(value = "/user/withdrawal.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String withdrawUser(@RequestBody HashMap<String, Object> map, HttpSession session) throws Exception {

		HashMap<String, Object> resultMap = userService.withdrawUser(map, session);

		return new Gson().toJson(resultMap);
	}

	// 계정 복구
	@RequestMapping(value = "/user/recover.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recoverUser(@RequestBody HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.recoverUser(map);
		return new Gson().toJson(resultMap);
	}

	// 주문목록 가져오기
	@RequestMapping(value = "/myPage/orders.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOrderHistory(HttpSession session) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		HashMap<String, Object> resultMap = orderService.getOrderHistory(userId);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/myPage/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSellerProductList(@RequestBody HashMap<String, Object> map) throws Exception {
		
		HashMap<String, Object> resultMap = userService.getSellerProductList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/myPage/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String hiddenSellerProduct(@RequestBody HashMap<String, Object> map) throws Exception {
		
		HashMap<String, Object> resultMap = userService.hiddenSellerProduct(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/seller/product/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerProductDetail(@RequestBody HashMap<String, Object> map) throws Exception {
		
		HashMap<String, Object> resultMap = userService.getSellerProductDetail(map);

		return new Gson().toJson(resultMap);
	}
	
	@PostMapping(
	  value = "/seller/product/update.dox",
	  consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
	  produces = MediaType.APPLICATION_JSON_VALUE
	)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> updateProduct(
	    @RequestParam Integer productNo,
	    @RequestParam Integer categoryNo,
	    @RequestParam String pname,
	    @RequestParam String pinfo,
	    @RequestParam Integer price,
	    @RequestParam String origin,
	    @RequestParam(defaultValue = "SELLING") String productStatus,

	    @RequestParam(required = false) String optionsJson,
	    @RequestParam(required = false) String deletedOptionNosJson,
	    @RequestParam(required = false) String deletedImageNosJson,

	    @RequestParam(required = false) MultipartFile thumbnail,
	    @RequestParam(required = false) List<MultipartFile> galleryImages,
	    @RequestParam(required = false) List<MultipartFile> detailImages,

	    HttpServletRequest request
	) throws Exception {

	    String uploadDir = request.getServletContext()
	                    .getRealPath("/resources/uploads/productImage");

	    Map<String,Object> res = userService.updateProductAll(
	        productNo, categoryNo, pname, pinfo, price, origin, productStatus,
	        optionsJson, deletedOptionNosJson, deletedImageNosJson,
	        thumbnail, galleryImages, detailImages,
	        uploadDir
	    );
	    return ResponseEntity.ok(res);
	}


	// ---- 유틸 ----
	private String saveFile(MultipartFile mf, String dir) throws Exception {
	  String ext = "";
	  String name = mf.getOriginalFilename();
	  if (name != null && name.lastIndexOf(".") > -1) ext = name.substring(name.lastIndexOf("."));
	  String saved = java.util.UUID.randomUUID().toString() + ext;
	  mf.transferTo(new File(dir, saved));
	  return "/resources/uploads/productImage/" + saved;
	}

	private Map<String,Object> mapImg(int productNo, String url, String type){
	  Map<String,Object> m = new HashMap<>();
	  m.put("productNo", productNo);
	  m.put("imageUrl", url);
	  m.put("imageType", type); // 'Y','A','N'
	  return m;
	}
	
	/* ===== 유틸 ===== */
	private Integer toInt(Object v, Integer def) {
	    if (v == null) return def;
	    if (v instanceof Number) return ((Number) v).intValue();
	    try {
	        String s = v.toString().trim();
	        if (s.isEmpty() || "null".equalsIgnoreCase(s) || "undefined".equalsIgnoreCase(s)) return def;
	        s = s.replaceAll(",", "");
	        return new java.math.BigDecimal(s).intValue();
	    } catch (Exception e) {
	        return def;
	    }
	}

	private Long toLong(Object v) {
	    if (v == null) return null;
	    if (v instanceof Number) return ((Number) v).longValue();
	    try { return new java.math.BigDecimal(v.toString().trim()).longValue(); }
	    catch (Exception e) { return null; }
	}

}