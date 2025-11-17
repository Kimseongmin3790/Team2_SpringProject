<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>카테고리 관리 | ADMIN</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background: #f9f9f9;
                }

                .page-wrap {
                    max-width: 1200px;
                    margin: 60px auto;
                    padding: 0 30px 80px;
                    box-sizing: border-box;
                }

                .title {
                    font-size: 1.8rem;
                    font-weight: 800;
                    color: #1a5d1a;
                    margin: 0 0 22px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .toolbar {
                    background: #fff;
                    border-radius: 12px;
                    padding: 16px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, .06);
                    display: flex;
                    flex-wrap: wrap;
                    gap: 12px;
                    align-items: center;
                    margin-bottom: 16px;
                }

                .toolbar select,
                .toolbar input,
                .toolbar button {
                    height: 38px;
                    padding: 0 12px;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    outline: none;
                    background: #fff;
                    font-size: .95rem;
                }

                .toolbar button {
                    border: none;
                    background: #4caf50;
                    color: #fff;
                    font-weight: 700;
                    cursor: pointer;
                }

                .toolbar button.secondary {
                    background: #e6d5b2;
                    color: #333;
                }

                .grid {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, .06);
                    overflow: hidden;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                }

                thead th {
                    background: #f3ebd3;
                    color: #1a5d1a;
                    font-weight: 700;
                    text-align: left;
                    padding: 12px;
                    border-bottom: 1px solid #eee;
                    font-size: .95rem;
                }

                tbody td {
                    padding: 12px;
                    border-bottom: 1px solid #f0f0f0;
                    font-size: .95rem;
                }

                tbody tr:hover {
                    background: #faf8f0;
                }

                .actions button {
                    height: 32px;
                    padding: 0 10px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    margin-right: 6px;
                }

                .btn-edit {
                    background: #5dbb63;
                    color: #fff;
                }

                .btn-del {
                    background: #e57373;
                    color: #fff;
                }

                .muted {
                    color: #777;
                    font-size: .9rem;
                }

                .badge {
                    display: inline-block;
                    padding: 2px 8px;
                    border-radius: 999px;
                    font-size: .8rem;
                }

                .badge.Y {
                    background: #e8f5e9;
                    color: #2e7d32;
                }

                .badge.N {
                    background: #ffebee;
                    color: #c62828;
                }

                .section-title {
                    margin: 26px 0 10px;
                    font-weight: 700;
                    color: #2e5d2e;
                }

                .bottom-space {
                    height: 40px;
                }

                .btn-back {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 10px 20px;
                    font-size: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                    margin-bottom: 25px;
                }

                .btn-back:hover {
                    background: #4ba954;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <div class="page-wrap">
                        <button class="btn-back" @click="goBack">이전</button>
                        <h2 class="title"><i class="fa-solid fa-tags"></i> 카테고리 관리</h2>

                        <div class="toolbar">
                            <select v-model="filterParent" @change="applyFilter">
                                <option value="">상위 전체</option>
                                <option value="__ROOT__">최상위(대분류)</option>
                                <option v-for="p in parentCandidates" :key="'p-'+p.CATEGORYNO" :value="p.CATEGORYNO">
                                    {{ p.CATEGORYNO }} - {{ p.CATEGORYNAME }}
                                </option>
                            </select>

                            <input v-model="searchText" type="text" placeholder="카테고리명 검색" @keyup.enter="applyFilter" />
                            <button @click="applyFilter"><i class="fa-solid fa-magnifying-glass"></i> 검색</button>
                            <button class="secondary" @click="resetFilter"><i class="fa-solid fa-rotate"></i>
                                초기화</button>

                            <span class="muted" style="margin-left:auto">총 {{ filtered.length }}건</span>
                        </div>

                        <div class="grid">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width:100px">번호</th>
                                        <th>명칭</th>
                                        <th style="width:180px">상위</th>
                                        <th style="width:180px">작업</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="c in filtered" :key="c.CATEGORYNO">
                                        <td>{{ c.CATEGORYNO }}</td>
                                        <td>
                                            <span v-if="!c._edit">{{ c.CATEGORYNAME }}</span>
                                            <input v-else v-model="c._name" type="text"
                                                style="width:100%; height:34px; padding:0 8px;" />
                                        </td>
                                        <td>
                                            <span v-if="!c._edit">
                                                {{ (c.PARENTNO == null || Number(c.PARENTNO) === 0) ? '없음(대분류)' :
                                                (c.PARENTNO + ' - ' + c.PARENTNAME) }}
                                            </span>
                                            <select v-else v-model="c._parent" style="width:100%; height:34px;">
                                                <option :value="null">없음(대분류)</option>
                                                <option v-for="p in parentOptionsForEdit(c)" :key="'sp-'+p.CATEGORYNO"
                                                    :value="p.CATEGORYNO">
                                                    {{ p.CATEGORYNO }} - {{ p.CATEGORYNAME }}
                                                </option>
                                            </select>
                                        </td>
                                        <td class="actions">
                                            <template v-if="!c._edit">
                                                <button class="btn-edit" @click="startEdit(c)"><i
                                                        class="fa-solid fa-pen"></i> 수정</button>
                                                <button class="btn-del" @click="remove(c)"><i
                                                        class="fa-solid fa-trash"></i> 삭제</button>
                                            </template>
                                            <template v-else>
                                                <button class="btn-edit" @click="save(c)"><i
                                                        class="fa-solid fa-check"></i> 저장</button>
                                                <button class="btn-del" @click="cancelEdit(c)"><i
                                                        class="fa-solid fa-xmark"></i> 취소</button>
                                            </template>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h3 class="section-title">카테고리 추가</h3>
                        <div class="toolbar">
                            <input v-model.number="form.no" type="number" placeholder="카테고리 번호(예: 4000)"
                                style="width:180px;" />
                            <input v-model="form.name" type="text" placeholder="카테고리명" style="min-width:220px;" />
                            <select v-model="form.parent">
                                <option :value="null">없음(대분류)</option>
                                <option v-for="p in parentOptions" :key="'ap-'+p.CATEGORYNO" :value="p.CATEGORYNO">
                                    {{ p.CATEGORYNO }} - {{ p.CATEGORYNAME }}
                                </option>
                            </select>
                            <button @click="add"><i class="fa-solid fa-plus"></i> 추가</button>
                            <span class="muted">허용: {{ allowedRangeText }}</span>
                        </div>

                        <div class="bottom-space"></div>
                    </div>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    list: [],       
                                    filtered: [],
                                    parentCandidates: [],
                                    filterParent: "",
                                    searchText: "",
                                    form: { no: null, name: "", parent: null }
                                }
                            },
                            computed: {
                                parentOptions() {
                                    const no = this.form.no;
                                    if (no == null || no === '') return this.list; 
                                    const needDigits = String(no).length - 1;
                                    if (needDigits <= 0) return [];             
                                    return this.list.filter(v => String(v.CATEGORYNO).length === needDigits);
                                },
                                allowedRangeText() {
                                    const p = this.form.parent;
                                    if (p == null) return "대분류 10~99 (10단위)";
                                    const base = Number(p) * 10;
                                    return `${base} ~ ${base + 99} (10단위)`;
                                }
                            },
                            methods: {
                                goBack() {
                                    location.href = "${pageContext.request.contextPath}" + "/dashboard.do";
                                },

                                path() { return "${pageContext.request.contextPath}"; },

                                load() {
                                    const self = this;
                                    $.ajax({
                                        url: this.path() + "/admin/category/list.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success(res) {
                                            self.list = (res.list || []).map(x => ({
                                                ...x,
                                                CATEGORYNO: x.CATEGORYNO != null ? Number(x.CATEGORYNO) : null,
                                                PARENTCATEGORYNO: x.PARENTCATEGORYNO != null ? Number(x.PARENTCATEGORYNO) : null,
                                                PARENTNO: x.PARENTNO != null ? Number(x.PARENTNO) : null,
                                                _edit: false
                                            }));
                                            self.parentCandidates = self.list.filter(v => v.PARENTCATEGORYNO == null);
                                            self.applyFilter();
                                        }
                                    });
                                },

                                applyFilter() {
                                    let parent;
                                    if (this.filterParent === "") parent = undefined;
                                    else if (this.filterParent === "__ROOT__") parent = null;
                                    else parent = Number(this.filterParent);

                                    const key = (this.searchText || "").trim().toLowerCase();
                                    this.filtered = this.list.filter(x => {
                                        const okParent = (this.filterParent === "")
                                            ? true
                                            : (parent === null ? (x.PARENTCATEGORYNO == null)
                                                : (Number(x.PARENTCATEGORYNO) === parent));
                                        const okText = !key ? true : (x.CATEGORYNAME || "").toLowerCase().includes(key);
                                        return okParent && okText;
                                    });
                                },

                                resetFilter() { this.filterParent = ""; this.searchText = ""; this.applyFilter(); },

                                parentOptionsForEdit(c) {
                                    const needDigits = String(c.CATEGORYNO).length - 1;
                                    return this.list.filter(v =>
                                        String(v.CATEGORYNO).length === needDigits && Number(v.CATEGORYNO) !== Number(c.CATEGORYNO)
                                    );
                                },

                                startEdit(c) {
                                    c._edit = true;
                                    c._name = c.CATEGORYNAME;
                                    c._parent = c.PARENTCATEGORYNO ?? null;
                                },
                                cancelEdit(c) { c._edit = false; },

                                save(c) {
                                    const self = this;
                                    $.ajax({
                                        url: this.path() + "/admin/category/update.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            categoryNo: c.CATEGORYNO,
                                            categoryName: c._name,
                                            parentCategoryNo: (c._parent == null || c._parent === "" || Number(c._parent) === 0)
                                                ? null : Number(c._parent)
                                        },
                                        success(res) {
                                            if (res && res.result === "fail") { alert(res.message || "저장 실패"); return; }
                                            self.load();
                                        }
                                    });
                                },

                                remove(c) {
                                    if (!confirm("삭제하시겠습니까? 하위 카테고리가 있으면 삭제가 제한될 수 있습니다.")) return;
                                    const self = this;
                                    $.ajax({
                                        url: this.path() + "/admin/category/delete.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { categoryNo: c.CATEGORYNO },
                                        success(res) {
                                            if (res && res.result === "fail") { alert(res.message || "삭제 실패"); return; }
                                            self.load();
                                        }
                                    });
                                },

                                validateLocal(no, parent) {
                                    if (no == null) { alert("카테고리 번호를 입력하세요."); return false; }
                                    if (!Number.isInteger(no)) { alert("카테고리 번호는 정수여야 합니다."); return false; }

                                    if (parent == null) {
                                        if (no < 10 || no > 99 || no % 10 !== 0) {
                                            alert("대분류 번호는 10~99 사이 10단위 숫자여야 합니다.");
                                            return false;
                                        }
                                        return true;
                                    }

                                    const parentDigits = String(parent).length;
                                    const childDigits = String(no).length;
                                    if (childDigits !== parentDigits + 1) {
                                        alert("자식 번호는 부모 자리수보다 1자리 많아야 합니다.");
                                        return false;
                                    }
                                    const base = parent * 10;
                                    if (no < base || no > base + 99 || no % 10 !== 0) {
                                        alert(`허용 범위: ${base} ~ ${base + 99} (10단위)`);
                                        return false;
                                    }
                                    return true;
                                },

                                add() {
                                    let no = this.form.no == null ? null : Number(this.form.no);
                                    let parent = (this.form.parent == null || this.form.parent === "" || Number(this.form.parent) === 0)
                                        ? null : Number(this.form.parent);

                                    if (!this.form.name.trim()) { alert("카테고리명을 입력하세요."); return; }

                                    if (parent == null && no != null && String(no).length > 2) {
                                        const guess = Number(String(no).slice(0, -1));
                                        const exists = this.list.some(v => Number(v.CATEGORYNO) === guess);
                                        if (exists) parent = guess;
                                    }

                                    if (!this.validateLocal(no, parent)) return;

                                    const self = this;
                                    $.ajax({
                                        url: this.path() + "/admin/category/insert.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            categoryNo: no,
                                            categoryName: this.form.name,
                                            parentCategoryNo: parent
                                        },
                                        success(res) {
                                            if (res.result !== "success") {
                                                alert(res.message || "등록 실패");
                                                return;
                                            }
                                            self.form = { no: null, name: "", parent: null };
                                            self.load();
                                        }
                                    });
                                }
                            },
                            mounted() { this.load(); }
                        });
                        app.mount("#app");
                    </script>
        </body>

        </html>