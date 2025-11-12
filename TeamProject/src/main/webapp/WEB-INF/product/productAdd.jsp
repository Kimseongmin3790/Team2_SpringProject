<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <% String sessionId=(String) session.getAttribute("sessionId"); String sessionStatus=(String)
            session.getAttribute("sessionStatus"); if (sessionId==null || sessionId.equals("")) { %>
            <script>
                alert("로그인이 필요합니다.");
                location.href = "<%= request.getContextPath() %>/login.do";
            </script>
            <% return; } else if (sessionStatus==null || !sessionStatus.equals("SELLER")) { %>
                <script>
                    alert("판매자 전용 페이지입니다.");
                    location.href = "<%= request.getContextPath() %>/main.do";
                </script>
                <% return; } %>

                    <!DOCTYPE html>
                    <html lang="ko">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>상품 등록 | AGRICOLA</title>

                        <!-- 외부 라이브러리 -->
                        <script src="https://code.jquery.com/jquery-3.7.1.js"
                            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                            crossorigin="anonymous"></script>
                        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

                        <!-- 공통 헤더/푸터 CSS -->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
                        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
                        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
                        <style>
                            html,
                            body {
                                height: 100%;
                                margin: 0;
                            }

                            #app {
                                min-height: 100vh;
                                display: flex;
                                flex-direction: column;
                            }

                            .content {
                                flex: 1;
                                margin: 20px auto;
                                max-width: 1100px;
                                width: 100%;
                            }

                            h2 {
                                color: #1a5d1a;
                                text-align: center;
                                margin-bottom: 20px;
                            }

                            form label {
                                display: block;
                                margin-top: 10px;
                                font-weight: 600;
                            }

                            /* ========= 폼 컨트롤 공통 ========= */
                            :root {
                                --green-700: #1a5d1a;
                                --green-500: #5dbb63;
                                --line: #e5e8eb;
                            }

                            form input[type="text"],
                            form input[type="number"],
                            form input[type="file"],
                            form select,
                            form textarea {
                                appearance: none;
                                -webkit-appearance: none;
                                -moz-appearance: none;
                                width: 100%;
                                box-sizing: border-box;
                                background: #fff;
                                border: 1px solid var(--line);
                                border-radius: 10px;
                                padding: 10px 14px;
                                font-size: 15px;
                                line-height: 1.4;
                                color: #1f2937;
                                outline: 0;
                                transition: border-color .15s ease, box-shadow .15s ease, background .2s ease;
                            }

                            form input[type="text"]:hover,
                            form input[type="number"]:hover,
                            form input[type="file"]:hover,
                            form select:hover,
                            form textarea:hover {
                                background-color: #fcfcfc;
                                border-color: #ced6db;
                            }

                            form input[type="text"]:focus,
                            form input[type="number"]:focus,
                            form input[type="file"]:focus,
                            form select:focus,
                            form textarea:focus {
                                border-color: var(--green-500);
                                box-shadow: 0 0 0 3px rgba(93, 187, 99, .2);
                            }

                            /* placeholder 톤 다운 */
                            form ::placeholder {
                                color: #9aa4b2;
                            }

                            /* ========= Textarea ========= */
                            form textarea {
                                min-height: 120px;
                                padding: 12px 14px;
                                resize: vertical;
                            }

                            /* ========= Select (드롭다운 화살표 커스텀) ========= */
                            form select {
                                padding-right: 40px;
                                /* 화살표 공간 */
                                background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 20 20' fill='%231a5d1a' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M5.5 7.5l4.5 4.5 4.5-4.5'/%3E%3C/svg%3E");
                                background-repeat: no-repeat;
                                background-position: right 12px center;
                                background-size: 16px 16px;
                            }

                            /* ========= Number (스핀 버튼 제거 & 높이 통일) ========= */
                            form input[type="number"] {
                                height: 44px;
                            }

                            form input[type=number]::-webkit-outer-spin-button,
                            form input[type=number]::-webkit-inner-spin-button {
                                -webkit-appearance: none;
                                margin: 0;
                            }

                            form input[type=number] {
                                -moz-appearance: textfield;
                            }

                            /* ========= File input (버튼만 세련되게) ========= */
                            form input[type="file"] {
                                padding: 6px 10px;
                            }

                            form input[type="file"]::file-selector-button {
                                margin-right: 10px;
                                padding: 8px 12px;
                                border: 1px solid var(--green-500);
                                border-radius: 8px;
                                background: var(--green-500);
                                color: #fff;
                                font-weight: 600;
                                cursor: pointer;
                                transition: filter .2s, background .2s, border-color .2s;
                            }

                            form input[type="file"]::file-selector-button:hover {
                                background: #4caf50;
                                border-color: #4caf50;
                            }

                            /* ========= 옵션 테이블 안 인풋도 동일 스타일 적용 ========= */
                            .option-table input[type="text"],
                            .option-table input[type="number"] {
                                height: 42px;
                                padding: 8px 12px;
                                border: 1px solid var(--line);
                                border-radius: 8px;
                                background: #fff;
                                transition: border-color .15s ease, box-shadow .15s ease;
                            }

                            .option-table input[type="text"]:focus,
                            .option-table input[type="number"]:focus {
                                border-color: var(--green-500);
                                box-shadow: 0 0 0 3px rgba(93, 187, 99, .2);
                            }

                            /* ========= 비활성/읽기전용 ========= */
                            form input[disabled],
                            form select[disabled],
                            form textarea[disabled],
                            form input[readonly],
                            form textarea[readonly] {
                                background: #f5f7f8 !important;
                                color: #8b95a1;
                                cursor: not-allowed;
                            }

                            /* (선택) 필수값 미입력 시 약한 하이라이트 – 기본 HTML5 검증 시점에만 표시 */
                            form input:invalid,
                            form select:invalid,
                            form textarea:invalid {
                                border-color: #f0b429;
                            }

                            form select {
                                background-color: #fff;
                                /* 단축 속성 대신 명시 */
                                background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 20 20' fill='%231a5d1a' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M5.5 7.5l4.5 4.5 4.5-4.5'/%3E%3C/svg%3E");
                                background-repeat: no-repeat;
                                background-position: right 12px center;
                                background-size: 16px 16px;
                                padding-right: 40px;
                            }

                            button {
                                background-color: #5dbb63;
                                color: #fff;
                                padding: 10px 20px;
                                border: none;
                                border-radius: 6px;
                                margin-top: 20px;
                                cursor: pointer;
                            }

                            button:hover {
                                background-color: #4caf50;
                            }

                            h4 {
                                margin-top: 20px;
                                color: #1a5d1a;
                            }

                            #editor {
                                width: 1120px;
                                height: 500px;
                            }

                            .ql-snow .ql-formats {
                                display: inline-block;
                                vertical-align: baseline;
                            }

                            .ql-toolbar.ql-snow {
                                width: 1120px;
                                border: 1px solid #ccc;
                                border-radius: 6px;
                                box-sizing: border-box;
                                font-family: 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
                                padding: 8px;
                            }

                            .ql-editor {
                                box-sizing: border-box;
                                line-height: 1.42;
                                height: 100%;
                                outline: none;
                                overflow-y: auto;
                                margin: -4px 0px;
                                padding: 12px 15px;
                                tab-size: 4;
                                -moz-tab-size: 4;
                                text-align: left;
                                white-space: pre-wrap;
                                word-wrap: break-word;
                            }

                            /* 넣어두면 보기 좋아요 */
                            .ql-editor img {
                                max-width: 100%;
                                height: auto;
                                display: block;
                            }

                            .option-table {
                                width: 100%;
                                border-collapse: collapse;
                                margin-top: 8px;
                            }

                            .option-table th,
                            .option-table td {
                                border: 1px solid #e5e5e5;
                                padding: 8px;
                                text-align: left;
                            }

                            .option-table input[type="text"],
                            .option-table input[type="number"] {
                                width: 100%;
                                box-sizing: border-box;
                            }
                        </style>
                    </head>

                    <body>
                        <!-- 공통 헤더 -->
                        <%@ include file="/WEB-INF/views/common/header.jsp" %>

                            <div id="app">
                                <main class="content">
                                    <h2>상품 등록</h2>

                                    <form id="productForm" enctype="multipart/form-data">
                                        <input type="hidden" name="sellerId" value="${sessionScope.sessionId}">

                                        <select v-model="top" @change="fnMidList">
                                            <option value="">대분류</option>
                                            <option :value="item.categoryNo" v-for="item in topList">
                                                {{item.categoryName}}</option>
                                        </select>
                                        <select v-model="mid" @change="fnLeafList">
                                            <option value="">중분류</option>
                                            <option :value="item.categoryNo" v-for="item in midList">
                                                {{item.categoryName}}</option>
                                        </select>
                                        <select v-model="leaf" name="categoryNo">
                                            <option value="">소분류</option>
                                            <option :value="item.categoryNo" v-for="item in leafList">
                                                {{item.categoryName}}</option>
                                        </select>
                                        <label>상품명</label>
                                        <input type="text" name="pname" placeholder="상품명을 입력하세요" required>

                                        <label>상품 설명</label>
                                        <textarea name="pinfo" rows="4" placeholder="상품 상세 설명을 입력하세요"
                                            required></textarea>

                                        <!-- ✅ 기본 가격 -->
                                        <label>기본 가격</label>
                                        <input type="number" name="price" v-model.number="basePrice"
                                            placeholder="예) 5000" min="0" required>

                                        <!-- ✅ 옵션 빌더 -->
                                        <h4>옵션 (단위/추가금/재고)</h4>
                                        <table class="option-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 30%">옵션명 (예: 500G, 1KG)</th>
                                                    <th style="width: 20%">추가금(+원)</th>
                                                    <th style="width: 20%">재고(개)</th>
                                                    <th style="width: 20%">판매가(미리보기)</th>
                                                    <th style="width: 10%">삭제</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="(opt, idx) in options" :key="idx">
                                                    <td>
                                                        <input type="text" v-model.trim="opt.label"
                                                            placeholder="예) 500G" required>
                                                    </td>
                                                    <td>
                                                        <input type="number" v-model.number="opt.addPrice" min="0"
                                                            step="100" placeholder="예) 0 또는 5000" required>
                                                    </td>
                                                    <td>
                                                        <input type="number" v-model.number="opt.stock" min="0" step="1"
                                                            placeholder="예) 10" required>
                                                    </td>
                                                    <td>
                                                        <div>{{ (Number(basePrice||0) +
                                                            Number(opt.addPrice||0)).toLocaleString() }}원</div>
                                                    </td>
                                                    <td>
                                                        <button type="button" @click="removeOption(idx)">삭제</button>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <button type="button" @click="addOption" style="margin-top:8px">+ 옵션 추가</button>
                                        <p style="margin-top:6px;color:#777">예시) 기본가격 5,000원, 500G(추가금 0원), 1KG(추가금
                                            5,000원)</p>

                                        <label>원산지</label>
                                        <input type="text" name="origin" placeholder="원산지를 입력하세요 ex)국산(구룡포)" required>

                                        <h4>대표 이미지</h4>
                                        <input type="file" name="thumbnail" accept="image/*" required>

                                        <h4>상품 이미지 (여러 장 가능)</h4>
                                        <input type="file" name="galleryImages" accept="image/*" multiple>

                                        <h4>상세 이미지 (여러 장 가능)</h4>
                                        <!-- <input type="file" name="detailImages" accept="image/*" multiple> -->
                                        <div id="editor"></div>
                                        <input id="detailPicker" type="file" accept="image/*" multiple hidden>

                                        <button type="submit">상품 등록하기</button>
                                    </form>
                                </main>
                            </div>

                            <!-- 공통 푸터 -->
                            <%@ include file="/WEB-INF/views/common/footer.jsp" %>
                    </body>

                    </html>

                    <script>
                        // 유틸: FileList/배열/undefined 모두 배열로 변환
                        const toArr = (x) => (x ? Array.from(x) : []);

                        // 배치 업로드
                        async function uploadInBatches(productMeta, thumbs, galleryFiles, detailFiles) {
                            const fd = new FormData();
                            Object.entries(productMeta).forEach(([k, v]) => fd.append(k, v));

                            const thumbsArr = toArr(thumbs);
                            const galleryArr = toArr(galleryFiles);
                            const detailArr = toArr(detailFiles);

                            if (thumbsArr.length) fd.append("thumbnail", thumbsArr[0]);
                            galleryArr.slice(0, 10).forEach(f => fd.append("galleryImages", f));

                            const firstRes = await $.ajax({
                                url: "/productUpload.dox",
                                type: "POST",
                                data: fd,
                                processData: false,
                                contentType: false,
                                dataType: "json"
                            });
                            const productNo = firstRes.productNo;
                            if (!productNo) throw new Error("productNo 없음 (첫 요청 응답 확인)");

                            // 30장씩 청크
                            const chunk = (arr, n) => {
                                const out = [];
                                for (let i = 0; i < arr.length; i += n) out.push(arr.slice(i, i + n));
                                return out;
                            };

                            for (const pack of chunk(detailArr, 30)) {
                                const f2 = new FormData();
                                f2.append("productNo", productNo);
                                pack.forEach(f => f2.append("detailImages", f));
                                await $.ajax({
                                    url: "/productUpload.dox",
                                    type: "POST",
                                    data: f2,
                                    processData: false,
                                    contentType: false,
                                    dataType: "json"
                                });
                            }

                            return productNo;
                        }

                        const app = Vue.createApp({
                            data() {
                                return {
                                    sessionId: "${sessionScope.sessionId}",
                                    topList: [], midList: [], leafList: [],
                                    productList: [],

                                    basePrice: 0,
                                    options: [
                                        { label: '500G', addPrice: 0, stock: 10 },
                                        { label: '1KG', addPrice: 5000, stock: 20 }
                                    ],
                                    // 에디터 이미지
                                    detailFiles: [],
                                    // 카테고리
                                    top: "", mid: "", leaf: ""
                                };
                            },
                            methods: {
                                // ★ async로 변경, 단 한 번만 호출
                                async fnSubmit() {
                                    if (!this.leaf) return alert("카테고리를 선택하세요.");

                                    if (!this.options.length) return alert("옵션을 1개 이상 추가하세요.");
                                    for (const o of this.options) {
                                        if (!o.label?.trim()) return alert("옵션명(예: 500G, 1KG)을 입력하세요.");
                                        if (isNaN(o.addPrice) || o.addPrice < 0) return alert("추가금은 0 이상의 숫자여야 합니다.");
                                        if (!Number.isInteger(o.stock) || o.stock < 0) return alert("재고는 0 이상의 정수여야 합니다.");
                                    }
                                    if (isNaN(this.basePrice) || this.basePrice < 0) return alert("기본 가격을 올바르게 입력하세요.");

                                    const productMeta = {
                                        sellerId: this.sessionId,
                                        categoryNo: Number(this.leaf),
                                        pname: $('input[name="pname"]').val().trim(),
                                        pinfo: $('textarea[name="pinfo"]').val().trim(),
                                        price: Number(this.basePrice),
                                        origin: $('input[name="origin"]').val().trim(),
                                        recommend: "N",
                                        productStatus: "SELLING",

                                        optionsJson: JSON.stringify(this.options.map(o => ({
                                            optionName: o.label.trim(),                  // 예: "500G", "1KG"
                                            addPrice: Number(o.addPrice || 0),           // 예: 0, 5000
                                            stock: Number(o.stock || 0)                  // 예: 10, 20
                                        })))
                                    };

                                    const thumbs = ($('input[name="thumbnail"]')[0]?.files) || [];
                                    const gallery = ($('input[name="galleryImages"]')[0]?.files) || [];
                                    const details = this.detailFiles || [];

                                    try {
                                        const pno = await uploadInBatches(productMeta, thumbs, gallery, details);
                                        alert("✅ 등록 완료! productNo = " + pno);
                                        document.getElementById('productForm').reset();
                                        this.detailFiles = [];
                                        this.basePrice = 0;
                                        this.options = [{ label: '500G', addPrice: 0, stock: 0 }];
                                        location.href = "<%= request.getContextPath() %>/main.do";
                                    } catch (e) {
                                        console.error(e);
                                        alert("❌ 업로드 실패");
                                    }
                                },

                                fnProductList() {
                                    $.ajax({
                                        url: "/productList.dox",
                                        dataType: "json",
                                        type: "POST",
                                        success: (data) => {
                                            this.productList = data.list || [];
                                            const uniq = [];
                                            for (const p of this.productList) {
                                                const u = (p.unit || "").trim();
                                                if (u && !uniq.includes(u)) uniq.push(u);
                                            }
                                            uniq.sort();
                                            this.units = uniq;
                                        }
                                    });
                                },

                                fnTopList() {
                                    $.ajax({
                                        url: "/CategoryTopList.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: { topNo: this.top },
                                        success: (data) => { this.topList = data.list || []; }
                                    });
                                },

                                fnMidList() {
                                    $.ajax({
                                        url: "/CategoryMidList.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: { topNo: this.top, midNo: this.mid },
                                        success: (data) => {
                                            this.mid = ""; this.leaf = "";
                                            this.midList = data.list || [];
                                        }
                                    });
                                },

                                fnLeafList() {
                                    $.ajax({
                                        url: "/CategoryLeafList.dox",
                                        dataType: "json",
                                        type: "POST",
                                        data: { topNo: this.top, midNo: this.mid, leafNo: this.leaf },
                                        success: (data) => { this.leafList = data.list || []; }
                                    });
                                },

                                addOption() {
                                    this.options.push({ label: '', addPrice: 0, stock: 0 });
                                },
                                removeOption(idx) {
                                    this.options.splice(idx, 1);
                                },
                            },
                            mounted() {
                                // 제출 이벤트
                                $("#productForm").on("submit", (e) => {
                                    e.preventDefault();
                                    this.fnSubmit();
                                });

                                this.fnProductList();
                                this.fnTopList();

                                // Quill 설정
                                const quill = new Quill('#editor', {
                                    theme: 'snow',
                                    modules: { toolbar: [['bold', 'italic', 'underline'], [{ list: 'ordered' }, { list: 'bullet' }], ['link', 'image']] }
                                });
                                this._quill = quill;

                                const toolbar = quill.getModule('toolbar');
                                toolbar.addHandler('image', () => $('#detailPicker').click());

                                $('#detailPicker').on('change', (e) => {
                                    const files = e.target.files || [];
                                    for (let i = 0; i < files.length; i++) {
                                        const f = files[i];
                                        if (!f.type?.startsWith('image/')) { alert('이미지 파일만 올릴 수 있어요.'); continue; }
                                        const reader = new FileReader();
                                        reader.onload = (evt) => {
                                            const dataUrl = evt.target.result;
                                            const range = quill.getSelection(true) || { index: quill.getLength() };
                                            quill.insertEmbed(range.index, 'image', dataUrl, 'user');
                                            quill.setSelection(range.index + 1);
                                        };
                                        reader.readAsDataURL(f);
                                        this.detailFiles.push(f);
                                    }
                                    e.target.value = ''; // 같은 파일 재선택 허용
                                });
                            }
                        });

                        app.mount('#app');
                    </script>