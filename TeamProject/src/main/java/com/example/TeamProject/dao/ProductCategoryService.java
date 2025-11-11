package com.example.TeamProject.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.TeamProject.mapper.ProductCategoryMapper;

@Service
public class ProductCategoryService {

    @Autowired
    ProductCategoryMapper productCategoryMapper;

    /** 카테고리 전체 목록 */
    public HashMap<String, Object> getCategoryList(HashMap<String, Object> param) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = productCategoryMapper.selectCategoryList(param);
            res.put("list", list);
            res.put("result", "success");
        } catch (Exception e) {
            res.put("result", "fail");
            res.put("message", e.getMessage());
        }
        return res;
    }

 // 번호 규칙 검증
    private void validateNumberRule(Integer categoryNo, Integer parentNo) {
        if (categoryNo == null) throw new IllegalArgumentException("카테고리 번호를 입력하세요.");

        if (parentNo == null) {
            // 대분류: 10..99, 10단위
            if (categoryNo < 10 || categoryNo > 99 || categoryNo % 10 != 0)
                throw new IllegalArgumentException("대분류 번호는 10~99 사이 10단위 숫자여야 합니다. 예) 10, 20, 30");
            return;
        }

        // 부모가 존재하는지 확인
        HashMap<String,Object> chk = new HashMap<>();
        chk.put("parentCategoryNo", parentNo);
        if (productCategoryMapper.parentExists(chk) == 0)
            throw new IllegalArgumentException("부모 카테고리가 존재하지 않습니다: " + parentNo);

        // 자식: 자리수 = 부모 자리수 + 1, 범위 parent*10 ~ parent*10+99, 10단위
        int parentDigits = String.valueOf(parentNo).length();
        int childDigits  = String.valueOf(categoryNo).length();
        if (childDigits != parentDigits + 1)
            throw new IllegalArgumentException("자식 번호는 부모 자리수보다 1자리 많아야 합니다.");

        int base = parentNo * 10;
        if (categoryNo < base || categoryNo > base + 99 || categoryNo % 10 != 0)
            throw new IllegalArgumentException("허용 범위: " + base + " ~ " + (base + 99) + " (10단위)");
    }

    @Transactional
    public HashMap<String,Object> insertCategory(HashMap<String,Object> param) {
        HashMap<String,Object> res = new HashMap<>();
        try {
            // 입력 정규화
            Integer categoryNo = param.get("categoryNo") == null ? null
                : Integer.valueOf(String.valueOf(param.get("categoryNo")));
            Integer parentNo = null;
            if (param.get("parentCategoryNo") != null && !"".equals(param.get("parentCategoryNo"))) {
                // 0은 루트로 취급
                int v = Integer.parseInt(String.valueOf(param.get("parentCategoryNo")));
                parentNo = (v == 0) ? null : v;
            }
            String name = (String) param.get("categoryName");

            if (name == null || name.isBlank())
                throw new IllegalArgumentException("카테고리명을 입력하세요.");

            // 규칙 검증
            validateNumberRule(categoryNo, parentNo);

            // 중복 번호 체크
            HashMap<String,Object> dup = new HashMap<>();
            dup.put("categoryNo", categoryNo);
            if (productCategoryMapper.existsByNo(dup) > 0)
                throw new IllegalStateException("이미 존재하는 카테고리 번호입니다: " + categoryNo);

            // (선택) 동일 부모 내 중복명 체크
            HashMap<String,Object> dupName = new HashMap<>();
            dupName.put("categoryName", name);
            dupName.put("parentCategoryNo", parentNo);
            if (productCategoryMapper.existsNameUnderParent(dupName) > 0)
                throw new IllegalStateException("같은 부모 아래 동일 이름이 이미 존재합니다.");

            // INSERT (직접 번호 사용)
            HashMap<String,Object> in = new HashMap<>();
            in.put("categoryNo", categoryNo);
            in.put("categoryName", name);
            in.put("parentCategoryNo", parentNo);
            productCategoryMapper.insertCategory(in);

            res.put("result","success");
        } catch (Exception e) {
            res.put("result","fail");
            res.put("message", e.getMessage());
        }
        return res;
    }

    /** 카테고리 수정 */
    @Transactional
    public HashMap<String, Object> updateCategory(HashMap<String, Object> param) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            Integer categoryNo = Integer.valueOf(String.valueOf(param.get("categoryNo")));
            String categoryName = (String) param.get("categoryName");

            Object parentObj = param.get("parentCategoryNo");
            Integer parentCategoryNo = null;
            if (parentObj != null && !"".equals(parentObj)) {
                parentCategoryNo = Integer.valueOf(String.valueOf(parentObj));
            }
            param.put("parentCategoryNo", parentCategoryNo);

            if (categoryName == null || categoryName.trim().isEmpty()) {
                throw new IllegalArgumentException("카테고리명을 입력해주세요.");
            }
            if (parentCategoryNo != null && categoryNo.equals(parentCategoryNo)) {
                throw new IllegalArgumentException("부모 카테고리를 자기 자신으로 지정할 수 없습니다.");
            }

            // (선택) 중복명 방지
            param.put("exceptCategoryNo", categoryNo);
            int dup = productCategoryMapper.existsNameUnderParent(param);
            if (dup > 0) {
                throw new IllegalStateException("같은 부모 아래에 동일한 이름이 이미 존재합니다.");
            }

            int cnt = productCategoryMapper.updateCategory(param);
            if (cnt <= 0) throw new IllegalStateException("수정 대상이 없거나 수정에 실패했습니다.");

            res.put("result", "success");
        } catch (Exception e) {
            res.put("result", "fail");
            res.put("message", e.getMessage());
        }
        return res;
    }

    /** 카테고리 삭제 (하위 있으면 금지) */
    @Transactional
    public HashMap<String, Object> deleteCategory(HashMap<String, Object> param) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            Integer categoryNo = Integer.valueOf(String.valueOf(param.get("categoryNo")));

            // 자식 존재 여부 확인
            int childCnt = productCategoryMapper.countChildren(param); // param에 categoryNo 포함
            if (childCnt > 0) {
                throw new IllegalStateException("하위 카테고리가 있어 삭제할 수 없습니다.");
            }

            int cnt = productCategoryMapper.deleteCategory(param);
            if (cnt <= 0) throw new IllegalStateException("삭제 대상이 없거나 삭제에 실패했습니다.");

            res.put("result", "success");
        } catch (Exception e) {
            res.put("result", "fail");
            res.put("message", e.getMessage());
        }
        return res;
    }
}