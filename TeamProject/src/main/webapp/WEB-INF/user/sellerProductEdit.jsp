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
                        <title>상품 수정 | AGRICOLA</title>

                        <!-- 외부 라이브러리 -->
                        <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
                        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

                        <!-- 공통 헤더/푸터 CSS -->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

                        <!-- Quill -->
                        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
                        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

                        <style>
                            html,
                            body {
                                height: 100%;
                                margin: 0
                            }

                            #app {
                                min-height: 100vh;
                                display: flex;
                                flex-direction: column
                            }

                            .content {
                                flex: 1;
                                margin: 20px auto;
                                max-width: 1100px;
                                width: 100%
                            }

                            h2 {
                                color: #1a5d1a;
                                text-align: center;
                                margin-bottom: 20px
                            }

                            form label {
                                display: block;
                                margin-top: 10px;
                                font-weight: 600
                            }

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

                            form ::placeholder {
                                color: #9aa4b2
                            }

                            form textarea {
                                min-height: 120px;
                                padding: 12px 14px;
                                resize: vertical
                            }

                            form select {
                                padding-right: 40px;
                                background: #fff;
                                background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 20 20' fill='%231a5d1a' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M5.5 7.5l4.5 4.5 4.5-4.5'/%3E%3C/svg%3E");
                                background-repeat: no-repeat;
                                background-position: right 12px center;
                                background-size: 16px 16px;
                            }

                            form input[type="number"] {
                                height: 44px
                            }

                            form input[type=number]::-webkit-outer-spin-button,
                            form input[type=number]::-webkit-inner-spin-button {
                                -webkit-appearance: none;
                                margin: 0
                            }

                            form input[type=number] {
                                -moz-appearance: textfield
                            }

                            form input[type="file"] {
                                padding: 6px 10px
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
                                border-color: #4caf50
                            }

                            .option-wrap {
                                overflow-x: auto
                            }

                            .option-table {
                                width: 100%;
                                border-collapse: separate;
                                border-spacing: 0;
                                table-layout: fixed;
                                background: #fff;
                                border: 1px solid #e6efe6;
                                border-radius: 12px;
                                overflow: hidden;
                                box-shadow: 0 2px 10px rgba(26, 93, 26, 0.05);
                                margin-top: 8px;
                            }

                            .option-table thead th {
                                background: #f4fbf4;
                                color: #1a5d1a;
                                font-weight: 700;
                                border-bottom: 1px solid #e6efe6;
                                padding: 12px 10px;
                                text-align: left;
                            }

                            .option-table tbody td {
                                border-bottom: 1px solid #f1f4f1;
                                padding: 12px 10px;
                                vertical-align: middle
                            }

                            .option-table tbody tr:nth-child(odd) {
                                background: #fcfffc
                            }

                            .option-table tbody tr:hover {
                                background: #f6fff6
                            }

                            .option-table input[type="text"],
                            .option-table input[type="number"] {
                                height: 42px;
                                padding: 8px 12px;
                                border: 1px solid var(--line);
                                border-radius: 8px;
                                background: #fff;
                                transition: border-color .15s ease, box-shadow .15s ease;
                                width: 100%;
                                box-sizing: border-box;
                            }

                            .option-table input[type="text"]:focus,
                            .option-table input[type="number"]:focus {
                                border-color: var(--green-500);
                                box-shadow: 0 0 0 3px rgba(93, 187, 99, .2);
                            }

                            #editor {
                                width: 1120px;
                                height: 500px;
                            }

                            .ql-toolbar.ql-snow {
                                width: 1120px;
                                border: 1px solid #ccc;
                                border-radius: 6px;
                                box-sizing: border-box;
                                padding: 8px
                            }

                            .ql-editor {
                                box-sizing: border-box;
                                line-height: 1.42;
                                height: 100%;
                                outline: none;
                                overflow-y: auto;
                                margin: -4px 0;
                                padding: 12px 15px;
                                white-space: pre-wrap;
                                word-wrap: break-word
                            }

                            .ql-editor img {
                                max-width: 100%;
                                height: auto;
                                display: block
                            }

                            /* 썸네일/갤러리 미리보기 카드 */
                            .img-grid {
                                display: flex;
                                flex-wrap: wrap;
                                gap: 12px;
                                margin-top: 8px
                            }

                            .img-card {
                                border: 1px solid #e6efe6;
                                padding: 8px;
                                border-radius: 8px;
                                width: 160px;
                                background: #fff
                            }

                            .thumb {
                                width: 120px;
                                height: 120px;
                                object-fit: cover;
                                border: 1px solid #e9eee9;
                                border-radius: 8px;
                                display: block;
                                margin: 0 auto
                            }
                        </style>
                    </head>

                    <body>
                        <%@ include file="/WEB-INF/views/common/header.jsp" %>

                            <!-- 컨텍스트 경로 상수 -->
                            <script>const CP = '<c:out value="${pageContext.request.contextPath}"/>';</script>

                            <div id="app">
                                <main class="content">
                                    <h2>상품 수정</h2>

                                    <form id="productForm" enctype="multipart/form-data">
                                        <!-- 카테고리 -->
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
                                        <input type="text" name="pname" v-model.trim="form.pname"
                                            placeholder="상품명을 입력하세요" required>

                                        <label>상품 설명</label>
                                        <textarea name="pinfo" v-model.trim="form.pinfo" rows="4"
                                            placeholder="상품 상세 설명을 입력하세요" required></textarea>

                                        <label>기본 가격</label>
                                        <input type="number" name="price" v-model.number="basePrice"
                                            placeholder="예) 5000" min="0" required>

                                        <!-- 옵션 빌더 -->
                                        <h4>옵션 (단위/추가금/재고)</h4>
                                        <div class="option-wrap">
                                            <table class="option-table">
                                                <thead>
                                                    <tr>
                                                        <th style="width:30%">옵션명 (예: 500G, 1KG)</th>
                                                        <th style="width:20%">추가금(+원)</th>
                                                        <th style="width:20%">재고(개)</th>
                                                        <th style="width:20%">판매가(미리보기)</th>
                                                        <th style="width:10%">삭제</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="(opt, idx) in options" :key="opt.optionNo || ('n'+idx)">
                                                        <td><input type="text" v-model.trim="opt.label"
                                                                placeholder="예) 500G" required></td>
                                                        <td><input type="number" v-model.number="opt.addPrice" min="0"
                                                                step="100" placeholder="예) 0 또는 5000" required></td>
                                                        <td><input type="number" v-model.number="opt.stock" min="0"
                                                                step="1" placeholder="예) 10" required></td>
                                                        <td>{{ (Number(basePrice||0) +
                                                            Number(opt.addPrice||0)).toLocaleString() }}원</td>
                                                        <td><button type="button"
                                                                @click="removeOption(idx, opt)">삭제</button></td>
                                                    </tr>
                                                    <tr v-if="!options.length">
                                                        <td colspan="5">옵션이 없습니다. 아래 버튼으로 추가하세요.</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <button type="button" @click="addOption" style="margin-top:8px">+ 옵션 추가</button>

                                        <label>원산지</label>
                                        <input type="text" name="origin" v-model.trim="form.origin"
                                            placeholder="원산지를 입력하세요 ex)국산(구룡포)" required>

                                        <h4 style="margin-top:16px">대표 이미지</h4>
                                        <div class="img-grid" v-if="thumb">
                                            <div class="img-card">
                                                <img :src="thumb.imageUrl" class="thumb" alt="thumbnail">
                                                <div style="margin-top:6px;text-align:center">
                                                    <label><input type="checkbox" v-model="deletedImageNos"
                                                            :value="thumb.imageNo"> 삭제</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div style="margin-top:8px">
                                            <input type="file" ref="thumbFile" accept="image/*">
                                            <small>새 파일을 선택하면 기존 썸네일을 대체합니다.</small>
                                        </div>

                                        <h4 style="margin-top:16px">갤러리 이미지</h4>
                                        <div class="img-grid">
                                            <div class="img-card" v-for="g in gallery" :key="g.imageNo">
                                                <img :src="g.imageUrl" class="thumb" alt="gallery">
                                                <div style="margin-top:6px;text-align:center">
                                                    <label><input type="checkbox" v-model="deletedImageNos"
                                                            :value="g.imageNo"> 삭제</label>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="file" ref="galleryFiles" accept="image/*" multiple
                                            style="margin-top:8px">

                                        <h4 style="margin-top:16px">상세 이미지</h4>
                                        <div class="img-grid">
                                            <div class="img-card" v-for="d in details" :key="d.imageNo">
                                                <img :src="d.imageUrl" class="thumb" alt="detail">
                                                <div style="margin-top:6px;text-align:center">
                                                    <label><input type="checkbox" v-model="deletedImageNos"
                                                            :value="d.imageNo"> 삭제</label>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="file" ref="detailFiles" accept="image/*" multiple
                                            style="margin-top:8px">

                                        <button type="submit">저장</button>
                                    </form>
                                </main>
                            </div>

                            <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                                <script>
                                    const PNO = Number(new URLSearchParams(location.search).get('productNo')) || null;

                                    if (!PNO) {
                                        alert('잘못된 접근입니다. 상품 번호가 없습니다.');
                                        location.href = CP + '/seller/products.do';
                                    }

                                    const toArr = (x) => (x ? Array.from(x) : []);

                                    const app = Vue.createApp({
                                        data() {
                                            return {
                                                // 카테고리
                                                topList: [], midList: [], leafList: [],
                                                top: "", mid: "", leaf: "",
                                                // 폼/옵션
                                                form: { pname: "", pinfo: "", origin: "" },
                                                basePrice: 0,
                                                options: [],
                                                deletedOptionNos: [],
                                                // 이미지
                                                thumb: null, gallery: [], details: [],
                                                deletedImageNos: [],
                                                // 에디터 신규 상세이미지 업로드용
                                                detailFiles: []
                                            };
                                        },
                                        methods: {
                                            // 상세 불러오기
                                            loadProduct() {
                                                $.ajax({
                                                    url: CP + "/seller/product/detail.dox",
                                                    type: "POST",
                                                    dataType: "json",
                                                    data: { productNo: PNO },
                                                    success: async (res) => {
                                                        const p = res.product || {};
                                                        this.form.pname = p.pname || "";
                                                        this.form.pinfo = p.pinfo || "";
                                                        this.form.origin = p.origin || "";
                                                        this.basePrice = Number(p.price || 0);

                                                        // 옵션
                                                        const opts = res.options || [];
                                                        this.options = opts.map(o => ({
                                                            optionNo: o.optionNo || null,
                                                            label: o.optionName || "",
                                                            addPrice: Number(o.addPrice || 0),
                                                            stock: Number(o.stock || 0)
                                                        }));

                                                        // 이미지
                                                        const imgs = res.images || [];
                                                        this.thumb = imgs.find(x => x.imageType === 'Y') || null;
                                                        this.gallery = imgs.filter(x => x.imageType === 'A');
                                                        this.details = imgs.filter(x => x.imageType === 'N');

                                                        // 카테고리 경로 (가능하면 path로 세팅)
                                                        const path = res.categoryPath || null;
                                                        if (path && path.leafNo) {
                                                            this.top = String(path.topNo || "");
                                                            await this.fetchMid();
                                                            this.mid = String(path.midNo || "");
                                                            await this.fetchLeaf();
                                                            this.leaf = String(path.leafNo || p.categoryNo || "");
                                                        } else if (p.categoryNo) {
                                                            this.leaf = String(p.categoryNo);
                                                        }
                                                    },
                                                    error: () => alert('상품 정보를 불러오지 못했습니다.')
                                                });
                                            },

                                            // 저장(수정 전용)
                                            async fnSubmit() {
                                                if (!this.leaf) return alert("카테고리를 선택하세요.");
                                                if (!this.form.pname.trim()) return alert("상품명을 입력하세요.");
                                                if (isNaN(this.basePrice) || this.basePrice < 0) return alert("기본 가격을 올바르게 입력하세요.");
                                                if (!this.options.length) return alert("옵션을 1개 이상 추가하세요.");
                                                for (const o of this.options) {
                                                    if (!o.label?.trim()) return alert("옵션명(예: 500G, 1KG)을 입력하세요.");
                                                    if (isNaN(o.addPrice) || o.addPrice < 0) return alert("추가금은 0 이상의 숫자여야 합니다.");
                                                    if (!Number.isInteger(o.stock) || o.stock < 0) return alert("재고는 0 이상의 정수여야 합니다.");
                                                }

                                                const fd = new FormData();
                                                fd.append('productNo', PNO);
                                                fd.append('categoryNo', Number(this.leaf));
                                                fd.append('pname', this.form.pname.trim());
                                                fd.append('pinfo', this.form.pinfo.trim());
                                                fd.append('price', Number(this.basePrice));
                                                fd.append('origin', this.form.origin.trim());
                                                fd.append('productStatus', 'SELLING'); // 필요 시 수정

                                                fd.append('optionsJson', JSON.stringify(this.options.map(o => ({
                                                    optionNo: o.optionNo || null,
                                                    optionName: o.label.trim(),
                                                    addPrice: Number(o.addPrice || 0),
                                                    stock: Number(o.stock || 0)
                                                }))));
                                                fd.append('deletedOptionNosJson', JSON.stringify(this.deletedOptionNos));
                                                fd.append('deletedImageNosJson', JSON.stringify(this.deletedImageNos));

                                                if (this.$refs.thumbFile?.files[0]) fd.append('thumbnail', this.$refs.thumbFile.files[0]);
                                                for (const f of toArr(this.$refs.galleryFiles?.files)) fd.append('galleryImages', f);
                                                for (const f of toArr(this.$refs.detailFiles?.files)) fd.append('detailImages', f);

                                                $.ajax({
                                                    url: CP + "/seller/product/update.dox",
                                                    type: "POST",
                                                    data: fd,
                                                    processData: false,
                                                    contentType: false,
                                                    dataType: "json",
                                                    success: () => { alert("✅ 수정되었습니다."); location.href = CP + "/seller/products.do"; },
                                                    error: () => { alert("❌ 저장 실패"); }
                                                });
                                            },

                                            // 옵션 조작
                                            addOption() { this.options.push({ optionNo: null, label: '', addPrice: 0, stock: 0 }); },
                                            removeOption(idx, opt) { if (opt.optionNo) this.deletedOptionNos.push(opt.optionNo); this.options.splice(idx, 1); },

                                            // 카테고리
                                            fetchTop() {
                                                return $.ajax({
                                                    url: CP + "/CategoryTopList.dox", type: "POST", dataType: "json",
                                                    data: { topNo: this.top },
                                                    success: (data) => { this.topList = data.list || []; }
                                                });
                                            },
                                            fetchMid() {
                                                return $.ajax({
                                                    url: CP + "/CategoryMidList.dox", type: "POST", dataType: "json",
                                                    data: { topNo: this.top, midNo: this.mid },
                                                    success: (data) => { this.midList = data.list || []; this.leaf = ""; }
                                                });
                                            },
                                            fetchLeaf() {
                                                return $.ajax({
                                                    url: CP + "/CategoryLeafList.dox", type: "POST", dataType: "json",
                                                    data: { topNo: this.top, midNo: this.mid, leafNo: this.leaf },
                                                    success: (data) => { this.leafList = data.list || []; }
                                                });
                                            },
                                            fnTopList() { this.fetchTop(); },
                                            fnMidList() { this.fetchMid(); },
                                            fnLeafList() { this.fetchLeaf(); }
                                        },
                                        mounted() {
                                            // 제출 이벤트
                                            $("#productForm").on("submit", (e) => { e.preventDefault(); this.fnSubmit(); });

                                            // 카테고리 로드 후 상세 불러오기
                                            this.fnTopList();
                                            this.loadProduct();

                                            // Quill (상세 이미지 업로드용)
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
                                                e.target.value = '';
                                            });
                                        }
                                    });
                                    app.mount('#app');
                                </script>
                    </body>

                    </html>