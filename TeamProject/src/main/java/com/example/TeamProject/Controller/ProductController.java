package com.example.TeamProject.Controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
    public String login(Model model) throws Exception{

        return "product/productAdd"; 
    }
	
	@RequestMapping("/productInfo.do")
    public String home(Model model) throws Exception{

        return "product/productInfo";
    }
	
	@RequestMapping("productUpload.dox")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> productUpload(
	    @RequestParam("sellerId") String sellerId,
	    @RequestParam("categoryNo") int categoryNo,
	    @RequestParam("pname") String pname,
	    @RequestParam("pinfo") String pinfo,
	    @RequestParam("price") int price,
	    @RequestParam("stock") int stock,
	    @RequestParam("unit") String unit,
	    @RequestParam("origin") String origin,
	    @RequestParam(value="recommend", defaultValue="N") String recommend,
	    @RequestParam(value="productStatus", defaultValue="SELLING") String productStatus,

	    // ✅ 이미지 파일
	    @RequestParam(value="thumbnail", required=false) MultipartFile thumbnail,
	    @RequestParam(value="galleryImages", required=false) List<MultipartFile> galleryImages,
	    @RequestParam(value="detailImages", required=false) List<MultipartFile> detailImages,

	    HttpServletRequest request
	) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        // ✅ 업로드 경로 설정
	        String uploadDir = request.getServletContext().getRealPath("/resources/uploads/productImage");
	        File dir = new File(uploadDir);
	        if (!dir.exists()) dir.mkdirs();

	        // ✅ 1️⃣ 상품 정보 저장
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
	        
	        HashMap<String, Object> map = productService.insertProduct(productData);
	        
	        Object obj = map.get("productNo");
	        int productNo = 0;
	        
	        if (obj instanceof BigDecimal) {
	            productNo = ((BigDecimal) obj).intValue(); // ✅ 안전하게 변환
	        } else if (obj instanceof Integer) {
	            productNo = (Integer) obj;
	        }

	        System.out.println("등록된 productNo = " + productNo);

	        // ✅ 2️⃣ 이미지 저장
	        // 대표 이미지
	        if (thumbnail != null && !thumbnail.isEmpty()) {
	            String filePath = saveFile(thumbnail, uploadDir);
	            insertProductImage(productNo, filePath, "Y");
	        }

	        // 상품 이미지
	        if (galleryImages != null) {
	            for (MultipartFile file : galleryImages) {
	                if (!file.isEmpty()) {
	                    String filePath = saveFile(file, uploadDir);
	                    insertProductImage(productNo, filePath, "N");
	                }
	            }
	        }

	        // 상세 이미지
	        if (detailImages != null) {
	            for (MultipartFile file : detailImages) {
	                if (!file.isEmpty()) {
	                    String filePath = saveFile(file, uploadDir);
	                    insertProductImage(productNo, filePath, "N");
	                }
	            }
	        }

	        response.put("status", "success");
	        response.put("message", "상품이 성공적으로 등록되었습니다.");
	        return new ResponseEntity<>(response, HttpStatus.OK);

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "상품 등록 중 오류가 발생했습니다.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	// ✅ 이미지 저장 헬퍼
	private String saveFile(MultipartFile file, String uploadDir) throws IOException {
	    String originalFilename = file.getOriginalFilename();
	    String extName = originalFilename.substring(originalFilename.lastIndexOf("."));
	    String savedFileName = UUID.randomUUID().toString() + extName;

	    File serverFile = new File(uploadDir, savedFileName);
	    file.transferTo(serverFile);

	    return "/resources/uploads/productImage/" + savedFileName;
	}

	// ✅ 이미지 DB 저장 헬퍼
	private void insertProductImage(int productNo, String path, String isThumbnail) {
	    HashMap<String, Object> imageData = new HashMap<>();
	    imageData.put("productNo", productNo);
	    imageData.put("imageUrl", path);
	    imageData.put("isThumbnail", isThumbnail);
	    productService.insertProductImage(imageData);
	}

}
