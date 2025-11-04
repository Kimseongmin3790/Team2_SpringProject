package com.example.TeamProject.Controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.dao.OrderService;
import com.example.TeamProject.dao.UserService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	OrderService orderService;
	
	@RequestMapping("/login.do") 
    public String login(Model model) throws Exception{

        return "user/login"; 
    }
	
	@RequestMapping("/chooseJoin.do") 
    public String chooseJoin(Model model) throws Exception{

        return "user/chooseJoin"; 
    }
	
	@RequestMapping("/userJoin.do") 
    public String join(Model model) throws Exception{

        return "user/userJoin"; 
    }
	
	@RequestMapping("/sellerJoin.do") 
    public String sellerJoin(Model model) throws Exception{

        return "user/sellerJoin"; 
    }
	
	@RequestMapping("/findId.do") 
    public String findId(Model model) throws Exception{

        return "user/findId"; 
    }
	
	@RequestMapping("/findPwd.do") 
    public String findPwd(Model model) throws Exception{

        return "user/findPwd"; 
    }
	
	@RequestMapping("/addr.do") 
    public String addr(Model model) throws Exception{

        return "jusoPopup";
    }
	
	 @RequestMapping("/buyerMyPage.do")
	 public String buyerMyPage(Model model, @RequestParam(value = "tab", required = false, defaultValue ="cart") String tab) throws Exception{
	     model.addAttribute("activeTab", tab);
	     return "user/buyerMypage";
	 }
	
	@RequestMapping("/sellerMyPage.do") 
    public String sellerMyPage(Model model) throws Exception{

        return "user/sellerMyPage";
    }
	
	@RequestMapping("/cart.do") 
    public String cart(Model model) throws Exception{

        return "user/cart";
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
	
	@RequestMapping("sellerJoin.dox")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> sellerJoin(
	    @RequestParam("farmName") String farmName,
	    @RequestParam("bizNo") String bizNo,
	    @RequestParam("bankName") String bankName,
	    @RequestParam("account") String account,
	    @RequestParam("userAddr") String userAddr,
	    @RequestParam("bizLicense") MultipartFile bizLicense,
	    @RequestParam("userId") String userId,
	    HttpServletRequest request) {

	    Map<String, Object> response = new HashMap<>();

	    // ✅ 파일 업로드 처리
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

	    try {
	        // ✅ 주소 → 좌표 변환
	        double[] coords = userService.getCoordinatesFromAddress(userAddr);
	        double lat = coords[0];
	        double lng = coords[1];

	        // ✅ DB 저장용 데이터 구성
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
	        sellerData.put("verified", "N");

	        // ✅ DB insert 실행
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
	    return calendar.get(Calendar.YEAR)
	        + String.valueOf(calendar.get(Calendar.MONTH) + 1)
	        + calendar.get(Calendar.DATE)
	        + calendar.get(Calendar.HOUR)
	        + calendar.get(Calendar.MINUTE)
	        + calendar.get(Calendar.SECOND)
	        + calendar.get(Calendar.MILLISECOND)
	        + extName;
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
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.login(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = userService.logout(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.findId(map);
		
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
    @RequestMapping(value = "/myPage/orders.dox", method = RequestMethod.GET, produces ="application/json;charset=UTF-8")
    @ResponseBody
    public String getOrderHistory(HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("sessionId");

        HashMap<String, Object> resultMap = orderService.getOrderHistory(userId);

        return new Gson().toJson(resultMap);
    }
	
}