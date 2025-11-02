package com.example.TeamProject.Controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.TeamProject.dao.ProductService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;

	@RequestMapping("/product/add.do")
	public String add(Model model) {
		return "product/productAdd";
	}

	@RequestMapping("/productInfo.do")
	public String info(Model model) {
		return "product/productInfo";
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
			@RequestParam(value = "stock", required = false) Integer stock,
			@RequestParam(value = "unit", required = false) String unit,
			@RequestParam(value = "origin", required = false) String origin,
			@RequestParam(value = "recommend", required = false, defaultValue = "N") String recommend,
			@RequestParam(value = "productStatus", required = false, defaultValue = "SELLING") String productStatus,

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
				if (sellerId == null || categoryNo == null || pname == null || pinfo == null || price == null
						|| stock == null || unit == null || origin == null) {
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
				productData.put("stock", stock);
				productData.put("unit", unit);
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
			}

			// 2) 이미지 저장 (신규/추가 동일)
			if (thumbnail != null && !thumbnail.isEmpty()) {
				insertProductImage(productNo, saveFile(thumbnail, uploadDir), "Y");
			}
			if (galleryImages != null) {
				for (MultipartFile f : galleryImages) {
					if (f != null && !f.isEmpty()) {
						insertProductImage(productNo, saveFile(f, uploadDir), "N");
					}
				}
			}
			if (detailImages != null) {
				for (MultipartFile f : detailImages) {
					if (f != null && !f.isEmpty()) {
						insertProductImage(productNo, saveFile(f, uploadDir), "D");
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
}
