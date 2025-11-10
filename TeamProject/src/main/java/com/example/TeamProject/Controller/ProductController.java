package com.example.TeamProject.Controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.dao.ProductService;
import com.example.TeamProject.dao.ReviewService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;
	
	@Autowired
	ReviewService reviewService;

	@RequestMapping("/product/add.do")
	public String add(Model model) {
		return "product/productAdd";
	}

	@RequestMapping("/productCategory.do")
	public String productCategory(Model model) throws Exception {

		return "product/categoryMain";
	}

	@RequestMapping("/productInfo.do")
	public String info(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map.get("productNo"));
		request.setAttribute("productNo", map.get("productNo"));
		return "product/productInfo";
	}
	
	@RequestMapping("/product/recommendList.do")
	public String recommendList(Model model) {
		return "product/recommendList";
	}
	
	@RequestMapping("/product/newList.do")
	public String newList(Model model) {
		return "product/newList";
	}
	
	@GetMapping("/category/{categoryNo}") // header dropdwon에서 보내온 categoryNo 받기
	public String categoryMain(@PathVariable("categoryNo") int categoryNo, Model model) {
		model.addAttribute("categoryNo", categoryNo);
		return "product/categoryMain"; // categoryMain.jsp 경로 (변경 시 맞게 수정)
	}

	@RequestMapping(value = "/categoryProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String categoryProductList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProductAndCategoryList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/sellerRegions.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerRegions(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		System.out.println(">>> sellerRegions.dox 호출됨");
		resultMap = productService.getSellerRegionsAndCount(map);
		
		System.out.println(">>> sellerRegions called with params: " + resultMap);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/product-view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/recommendList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recommendList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getRecommendList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/newList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String newList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getNewList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/questions.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String questions(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProductQuestions(map);
		return new Gson().toJson(resultMap);
	}

	@PostMapping(value = "/productUpload.dox", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> productUpload(
			@RequestParam(value = "productNo", required = false) Integer productNo,

			// 최초 생성시에만 필요한 값들 (추가 업로드 때는 없어도 됨)
			@RequestParam(value = "sellerId", required = false) String sellerId,
			@RequestParam(value = "categoryNo", required = false) Integer categoryNo,
			@RequestParam(value = "pname", required = false) String pname,
			@RequestParam(value = "pinfo", required = false) String pinfo,
			@RequestParam(value = "price", required = false) Integer price,
			@RequestParam(value = "origin", required = false) String origin,
			@RequestParam(value = "recommend", required = false, defaultValue = "N") String recommend,
			@RequestParam(value = "productStatus", required = false, defaultValue = "SELLING") String productStatus,
			@RequestParam(value = "optionsJson", required = false) String optionsJson,
			
			// 파일 파트
			@RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
			@RequestParam(value = "galleryImages", required = false) List<MultipartFile> galleryImages,
			@RequestParam(value = "detailImages", required = false) List<MultipartFile> detailImages,

			HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String uploadDir = request.getServletContext().getRealPath("/resources/uploads/productImage");
			new File(uploadDir).mkdirs();

			// 1) 신규 생성
			if (productNo == null) {
				// 필수값 검증
				if (sellerId == null || categoryNo == null || pname == null || pinfo == null || price == null || origin == null) {
					res.put("status", "error");
					res.put("message", "필수 파라미터 누락");
					return ResponseEntity.badRequest().body(res);
				}

				HashMap<String, Object> productData = new HashMap<>();
				productData.put("sellerId", sellerId);
				productData.put("categoryNo", categoryNo);
				productData.put("pname", pname);
				productData.put("pinfo", pinfo);
				productData.put("price", price);
				productData.put("origin", origin);
				productData.put("recommend", recommend);
				productData.put("productStatus", productStatus);

				HashMap<String, Object> r = productService.insertProduct(productData);
				Object obj = r.get("productNo");
				productNo = (obj instanceof java.math.BigDecimal) ? ((java.math.BigDecimal) obj).intValue()
						: (obj instanceof Integer) ? (Integer) obj : 0;
				if (productNo == 0) {
					res.put("status", "error");
					res.put("message", "상품 생성 실패");
					return ResponseEntity.internalServerError().body(res);
				}
				
				// optionsJson → List<Map<String,Object>>
				List<Map<String, Object>> options = Collections.emptyList();
				if (optionsJson != null && !optionsJson.isBlank()) {
				    ObjectMapper om = new ObjectMapper();
				    options = om.readValue(optionsJson, new TypeReference<List<Map<String, Object>>>() {});
				}
				
				List<Map<String, Object>> normalized = new ArrayList<>();
				for (Map<String, Object> o : options) {
					Map<String, Object> m = new HashMap<>();				    
				    String unit = String.valueOf(
				    	    o.getOrDefault("optionName", o.getOrDefault("name",""))
				    	).replaceAll("\\s+"," ").trim(); // 공백/케이스 차이 최소화

				    	m.put("unit", unit);
				    m.put("productNo", productNo);         // ✅ 필수				    				    
				    m.put("addPrice", toInt(o.get("addPrice")));
				    m.put("stock",    toInt(o.get("stock")));
				    normalized.add(m);
				}
				
				HashMap<String, Object> productOptions = new HashMap<>();
				productOptions.put("productNo", productNo);  // ✅ 상위에 보관 (foreach에서 #{productNo}로 접근)
				productOptions.put("options", normalized);

				// 서비스로 넘겨서 mapper 호출은 네가 진행
				productService.insertProductOptions(productOptions);
				
			}

			// 2) 이미지 저장 (신규/추가 동일)
			if (thumbnail != null && !thumbnail.isEmpty()) {
				insertProductImage(productNo, saveFile(thumbnail, uploadDir), "Y");
			}
			if (galleryImages != null) {
				for (MultipartFile f : galleryImages) {
					if (f != null && !f.isEmpty()) {
						insertProductImage(productNo, saveFile(f, uploadDir), "A");
					}
				}
			}
			if (detailImages != null) {
				for (MultipartFile f : detailImages) {
					if (f != null && !f.isEmpty()) {
						insertProductImage(productNo, saveFile(f, uploadDir), "N");
					}
				}
			}

			res.put("status", "success");
			res.put("productNo", productNo);
			return ResponseEntity.ok(res);

		} catch (Exception e) {
			e.printStackTrace();
			res.put("status", "error");
			res.put("message", "서버 오류");
			return ResponseEntity.internalServerError().body(res);
		}
	}

	// 파일 저장
	private String saveFile(MultipartFile file, String uploadDir) throws IOException {
		String originalFilename = file.getOriginalFilename();
		String extName = "";
		if (originalFilename != null && originalFilename.contains(".")) {
			extName = originalFilename.substring(originalFilename.lastIndexOf("."));
		}
		String savedFileName = UUID.randomUUID() + extName;
		File serverFile = new File(uploadDir, savedFileName);
		file.transferTo(serverFile);
		return "/resources/uploads/productImage/" + savedFileName;
	}

	// 이미지 DB 저장
	private void insertProductImage(int productNo, String path, String isThumbnail) {
		HashMap<String, Object> imageData = new HashMap<>();
		imageData.put("productNo", productNo);
		imageData.put("imageUrl", path);
		imageData.put("isThumbnail", isThumbnail);
		productService.insertProductImage(imageData);
	}
	
	private static int toInt(Object v) {
	    if (v == null) return 0;
	    if (v instanceof Number) return ((Number) v).intValue();
	    String s = v.toString().trim();
	    return s.isEmpty() ? 0 : Integer.parseInt(s);
	}

}