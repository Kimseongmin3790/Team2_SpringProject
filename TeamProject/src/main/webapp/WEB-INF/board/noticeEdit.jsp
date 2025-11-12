<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 수정 | AGRICOLA</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
            background: #faf8f0;
        }
        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1;
            background: #fff;
            padding: 60px 80px;
            box-sizing: border-box;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 40px auto;
        }
        h1.title {
            text-align: center;
            color: #1a5d1a;
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 40px;
        }

        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .form-group input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
            box-sizing: border-box;
            font-family: "Noto Sans KR", sans-serif;
        }

        #editor {
            width: 100%;
            height: 300px; /
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
        }
        .form-actions button {
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin: 0 8px;
        }
        .btn-save {
            background: #3498db;
        }
        .btn-save:hover {
            background: #2980b9;
        }
        .btn-cancel {
            background: #7f8c8d;
        }
        .btn-cancel:hover {
            background: #6c7a7b;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div id="app">
        <main class="content">
            <h1 class="title">공지사항 수정</h1>

            <div class="edit-form-container">
                <form id="editForm">
                    <input type="hidden" name="noticeNo" v-model="noticeNo">

                    <div class="form-group">
                        <label for="title">제목</label>
                        <input type="text" id="title" name="title" v-model="title" required>
                    </div>

                    <div class="form-group">
                        <label for="contents">내용</label>
                        <div id="editor"></div> 
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-save" @click="fnUpdateNotice">저장</button>
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    noticeNo: '${notice.noticeNo}',
                    title: '', 
                    contents: '',
                    quillEditor: null 
                }
            },
            methods: {
                fnUpdateNotice() {
                    if (!confirm("수정된 내용을 저장하시겠습니까?")) {
                        return;
                    }

                    const noticeData = {
                        noticeNo: this.noticeNo,
                        title: this.title,
                        contents: this.quillEditor.root.innerHTML
                    };

                    $.ajax({
                        url: "/notice/update.do",
                        type: "POST",
                        contentType: "application/json; charset=UTF-8",
                        data: JSON.stringify(noticeData),
                        dataType: "json",
                        success: function(res) {
                            if (res.result === "success") {
                                alert("수정이 완료되었습니다.");
                                location.href = "/noticeView.do?noticeNo=" + noticeData.noticeNo;
                            } else {
                                alert("수정 중 오류가 발생했습니다: " + res.message);
                            }
                        },
                        error: function() {
                            alert("서버와의 통신 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnInfo: function () {
                    let self = this;
                    let param = {
                        noticeNo : self.noticeNo
                    };
                    $.ajax({
                        url: "/noticeInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data);
                            if(data.result == "success"){
                                self.title = data.info.title;
                                self.contents = data.info.contents;
                                if (self.quillEditor) {
                                    self.quillEditor.root.innerHTML = self.contents;
                                }
                            } else {
                                alert("오류가 발생했습니다!");
                            }
                        }
                    });
                },
                

            },
            mounted() {
                let self = this;
                self.quillEditor = new Quill('#editor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                            ['bold', 'italic', 'underline'],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['link', 'image'],
                            ['clean']
                        ]
                    }
                });

                self.fnInfo();

                self.quillEditor.on('text-change', function() {
                    self.contents = self.quillEditor.root.innerHTML;
                });
            }
        });

        app.mount('#app'); 
    </script>
</body>
</html>