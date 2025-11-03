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

                            input,
                            textarea {
                                width: 100%;
                                padding: 8px;
                                margin-top: 5px;
                                border: 1px solid #ccc;
                                border-radius: 6px;
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

                                        <label>가격</label>
                                        <input type="number" name="price" placeholder="가격을 입력하세요" required>

                                        <label>재고 수량</label>
                                        <input type="number" name="stock" placeholder="재고 수량을 입력하세요" required>

                                        <label>단위</label>
                                        <input type="text">
                                        <select name="unit" v-model="unit">
                                            <option value="">단위 선택</option>
                                            <option v-for="it in units" :value="it">{{it}}</option>
                                        </select>

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
                                    productList: [], units: [],
                                    unit: "", top: "", mid: "", leaf: "",
                                    detailFiles: []  // 에디터로 추가한 파일들
                                };
                            },
                            methods: {
                                // ★ async로 변경, 단 한 번만 호출
                                async fnSubmit() {
                                    if (!this.leaf) return alert("카테고리를 선택하세요.");
                                    if (!this.unit) return alert("단위를 선택하세요.");

                                    const productMeta = {
                                        sellerId: this.sessionId,
                                        categoryNo: Number(this.leaf),
                                        pname: $('input[name="pname"]').val().trim(),
                                        pinfo: "사진만 등록",
                                        price: $('input[name="price"]').val(),
                                        stock: $('input[name="stock"]').val(),
                                        unit: this.unit,
                                        origin: $('input[name="origin"]').val().trim(),
                                        recommend: "N",
                                        productStatus: "SELLING"
                                    };

                                    const thumbs = ($('input[name="thumbnail"]')[0]?.files) || [];
                                    const gallery = ($('input[name="galleryImages"]')[0]?.files) || [];
                                    const details = this.detailFiles || [];

                                    try {
                                        const pno = await uploadInBatches(productMeta, thumbs, gallery, details);
                                        alert("✅ 등록 완료! productNo = " + pno);
                                        document.getElementById('productForm').reset();
                                        this.detailFiles = [];
                                        location.href="<%= request.getContextPath() %>/main.do";
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
                                }
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