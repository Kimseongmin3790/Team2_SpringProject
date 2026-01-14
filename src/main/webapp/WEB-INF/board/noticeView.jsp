<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 | AGRICOLA</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        html,
        body {
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
            background: #faf8f0;
        }

        #app {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            width: 100%;
            box-sizing: border-box;
            padding: 0 120px;
        }

        .page-container {
            flex: 1;
            background: #fff;
            padding: 60px 80px; 
            box-sizing: border-box;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        h1.title {
            text-align: center;
            color: #1a5d1a;
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 40px;
        }

        .notice-detail-container {
            width: 100%;
        }

        .notice-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 25px;
        }

        .notice-header h2 {
            font-size: 26px;
            font-weight: 700;
            color: #333;
            margin: 0 0 10px 0;
        }

        .notice-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: #777;
        }

        .notice-meta .writer {
            font-weight: 500;
        }

        .notice-content {
            padding: 20px 10px;
            min-height: 250px;
            font-size: 16px;
            line-height: 1.8;
            color: #444;
            border-bottom: 1px solid #f0f0f0;
            margin-bottom: 30px;
        }

        .notice-actions {
            text-align: center;
        }

        .btn-list {
            background: #5dbb63;
            border: none;
            color: white;
            padding: 10px 25px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-list:hover {
            background: #4ba954;
        }

        @media (max-width: 1024px) {
            #app {
                padding: 0 60px;
            }
            .page-container {
                padding: 40px;
            }
        }

        @media (max-width: 768px) {
            #app {
                padding: 0 20px;
            }
            .page-container {
                padding: 30px 20px;
            }
            .notice-header h2 {
                font-size: 22px;
            }
            .notice-content {
                font-size: 15px;
            }
        }

        .notice-actions {
            text-align: center;
            margin-top: 20px; 
        }

        .notice-actions button {
            border: none;
            color: white;
            padding: 10px 25px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin: 0 5px; 
        }

        .btn-list {
            background: #5dbb63;
        }

        .btn-list:hover {
            background: #4ba954;
        }

        .btn-delete {
            background: #e74c3c; 
        }

        .btn-delete:hover {
            background: #c0392b; 
        }
        .btn-edit {
            background: #3498db; 
        }

        .btn-edit:hover {
            background: #2980b9; 
        }

        .comment-section {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }
        .comment-section h4 {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .comment-count {
            font-size: 16px;
            color: #5dbb63;
            margin-left: 8px;
        }
        .comment-form {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }
        .comment-form.reply-form {
            margin-top: 15px;
            margin-bottom: 0;
        }
        .comment-form textarea {
            flex: 1;
            min-height: 60px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            font-size: 15px;
        }
        .comment-form button {
            background: #5dbb63;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 0 25px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .comment-form button:hover {
            background: #4ba954;
        }
        .comment-item {
            padding: 15px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .comment-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }
        .comment-author {
            font-weight: 600;
            font-size: 15px;
        }
        .comment-date {
            font-size: 13px;
            color: #999;
        }
        .comment-content {
            font-size: 15px;
            color: #444;
            line-height: 1.7;
            padding-left: 5px;
        }
        .comment-actions {
            text-align: right;
            margin-top: 10px;
        }
        .comment-actions button {
            background: none;
            border: 1px solid #ccc;
            color: #555;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 15px;
            cursor: pointer;
            margin-left: 5px; 
        }
        .comment-actions button:hover {
            background: #eee;
        }
        .comment-actions button:nth-of-type(2) { 
            border-color: #3498db;
            color: #3498db;
        }
        .comment-actions button:nth-of-type(3) { 
            border-color: #e74c3c;
            color: #e74c3c;
        }
        .no-comments {
            text-align: center;
            padding: 50px 0;
            color: #888;
            border-bottom: 1px solid #f5f5f5;
        }

        .comment-edit-form {
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .comment-edit-form textarea {
            width: 100%;
            min-height: 80px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            font-size: 15px;
        }
        .comment-edit-actions {
            text-align: right;
            margin-top: 10px;
        }
        .comment-edit-actions button {
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 5px 15px;
            font-size: 13px;
            cursor: pointer;
            transition: 0.3s;
            margin-left: 5px;
        }
        .comment-edit-actions button:hover {
            background: #2980b9;
        }
        .comment-edit-actions button:nth-child(2) {
            background: #7f8c8d;
        }
        .comment-edit-actions button:nth-child(2):hover {
            background: #6c7a7b;
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div id="app">
        <h1 class="title">공지사항</h1>

        <div class="page-container">
            <div class="notice-detail-container">

                <div class="notice-header">
                    <h2>{{ notice.title }}</h2>
                    <div class="notice-meta">
                        <span class="writer">작성자: {{ notice.userId }}</span>
                        <span class="date">작성일: {{ notice.regDate }}</span>
                    </div>
                </div>

                 <div class="notice-content"  v-html="notice.contents">
                    {{ notice.contents }}
                </div>

                <div class="notice-actions">
                    <button class="btn-list" onclick="location.href='/board.do?tab=notice'">목록</button>
                        <button v-if="sessionId === notice.userId || userRole === 'ADMIN'" class="btn-edit" @click= "fnEditNotice(notice.noticeNo)">수정</button>
                    <button v-if="sessionId === notice.userId || userRole === 'ADMIN'" class="btn-delete" @click= "fnDeleteNotice(notice.noticeNo)">삭제</button>
                </div>
            
                <div class="comment-section">
                    <h4>댓글 <span class="comment-count">({{ comments.length }})</span></h4>

                    <div class="comment-form" v-if="sessionId">
                        <textarea v-model="newCommentContent" placeholder="따뜻한 댓글을 남겨주세요..."></textarea>
                        <button @click="fnSaveComment(null)">등록</button> 
                    </div>

                    <div class="comment-list">
                        <div v-if="comments.length === 0" class="no-comments">
                            등록된 댓글이 없습니다. 첫 댓글을 남겨보세요!
                        </div>

                    
                        <div v-for="comment in comments" :key="comment.commentNo" class="comment-item" :style="{marginLeft: (comment.level - 1) * 40 + 'px'}">
                            <div class="comment-header">
                                <span class="comment-author">{{ comment.userId }}</span>
                                <span class="comment-date">{{ comment.cdatetime }}</span>
                            </div>
                            <div v-if="editingCommentNo === comment.commentNo" class="comment-edit-form">
                                <textarea v-model="editedCommentContent"></textarea>
                                <div class="comment-edit-actions">
                                    <button @click="fnUpdateComment(comment.commentNo)">저장</button>
                                    <button @click="fnCancelEdit()">취소</button>
                                </div>
                            </div>
                            <div class="comment-content" v-html="comment.contents"></div> 
               
                            <div class="comment-actions">
                                <button v-if="sessionId" @click="fnShowReplyForm(comment.commentNo)">답글</button>
                                <button v-if="sessionId === comment.userId" @click= "fnEditComment(comment.commentNo)">수정</button>
                                <button v-if="sessionId === comment.userId || userRole === 'ADMIN'" @click="fnDeleteComment(comment.commentNo)">삭제</button>
                            </div>

                            <div v-if="sessionId && replyFormTarget === comment.commentNo" class="comment-form reply-form">
                                <textarea v-model="newReplyContent" placeholder="답글을 입력하세요..."></textarea>
                                <button @click="fnSaveComment(comment.commentNo)">등록</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionScope.sessionId}",
                userRole: "${sessionScope.sessionStatus}",  
                notice: {},
                comments: [],         
                newCommentContent: '',       
                replyFormTarget: null,     
                newReplyContent: '',
                editingCommentNo: null, 
                editedCommentContent: '' 

            };
        },
        methods: {
            fnShowReplyForm: function(commentNo) {
                        let self = this;
                        
                        if (self.replyFormTarget === commentNo) {
                            self.replyFormTarget = null;
                            self.newReplyContent = ''; 
                        } else {
                            self.replyFormTarget = commentNo;
                            self.newReplyContent = ''; 
                        }
            },
            fnGetNoticeInfo() {
                let self = this;

                const urlParams = new URLSearchParams(window.location.search);
                const noticeNo = urlParams.get('noticeNo');
    
                $.ajax({
                    url: "/noticeInfo.dox",
                    dataType: "json",
                    type: "POST",
                    data: { noticeNo: noticeNo },
                    success: function (data) {
                        if(data.result === 'success') {
                            self.notice = data.info;
                        } else {
                            alert("공지사항을 불러오는 데 실패했습니다.");
                        }
                    }
                });
            },
        
            fnDeleteNotice: function (noticeNo) {
                if (confirm("정말로 이 공지사항을 삭제하시겠습니까?")) {
                    location.href = "/notice/delete.do?noticeNo=" + noticeNo;
                }
            },
            fnEditNotice: function (noticeNo) {
                location.href = "/notice/edit.do?noticeNo=" + noticeNo;
            },
            fnLoadComments: function() {
                let self = this;
                const noticeNo = new URLSearchParams(window.location.search).get('noticeNo');

                $.ajax({
                    url: "/notice/comments.dox",
                    type: "GET", 
                    dataType: "json",
                    data: { noticeNo: noticeNo },
                    success: function(res) {
                        if (res.result === "success") {
                            self.comments = res.list; 
                        } else {
                            alert("댓글을 불러오는 데 실패했습니다: " + res.message);
                        }
                    },
                    error: function() {
                        alert("서버와의 통신 중 오류가 발생했습니다.");
                    }
                });
            },
            fnSaveComment: function(parentCommentNo) {
               let self = this;
               const noticeNo = new URLSearchParams(window.location.search).get('noticeNo');
               let commentContent = '';

               if (parentCommentNo === null) {
                   commentContent = self.newCommentContent;
               } else {
                   commentContent = self.newReplyContent;
               }

               if (!commentContent.trim()) {
                   alert("댓글 내용을 입력해주세요.");
                   return;
               }

               const commentData = {
                   noticeNo: parseInt(noticeNo),
                   contents: commentContent,
                   parentCommentNo: parentCommentNo 
               };

               $.ajax({
                   url: "/notice/comments/save.dox",
                   type: "POST",
                   contentType: "application/json; charset=UTF-8",
                   data: JSON.stringify(commentData),
                   dataType: "json",
                   success: function(res) {
                       if (res.result === "success") {
                           alert("댓글이 등록되었습니다.");
                          
                           self.newCommentContent = '';
                           self.newReplyContent = '';
                           self.replyFormTarget = null; 
                           self.fnLoadComments(); 
                       } else {
                           alert("댓글 등록 실패: " + res.message);
                       }
                   },
                   
                   error: function() {
                       alert("서버와의 통신 중 오류가 발생했습니다.");
                   }
               });
           },
           fnEditComment: function(commentNo) {
                let self = this;
                self.editingCommentNo = commentNo;

                const commentToEdit = self.comments.find(c => c.commentNo === commentNo);
                if (commentToEdit) {
                    self.editedCommentContent = commentToEdit.contents;
                }
            },

            fnCancelEdit: function() {
                let self = this;
                self.editingCommentNo = null;
                self.editedCommentContent = '';
            },

            fnUpdateComment: function(commentNo) {
                let self = this;
                if (!self.editedCommentContent.trim()) {
                    alert("수정할 내용을 입력해주세요.");
                    return;
                }
                if (!confirm("댓글을 수정하시겠습니까?")) {
                    return;
                }

                const commentData = {
                    commentNo: commentNo,
                    contents: self.editedCommentContent
                };

                $.ajax({
                    url: "/notice/comments/update.dox",
                    type: "POST",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(commentData),
                    dataType: "json",
                    success: function(res) {
                        if (res.result === "success") {
                            alert("댓글이 수정되었습니다.");
                            self.fnLoadComments();
                            self.fnCancelEdit(); 
                        } else {
                            alert("댓글 수정 실패: " + res.message);
                        }
                    },
                    error: function() {
                        alert("서버와의 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnDeleteComment: function(commentNo) {
                let self = this;
                if (!confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/notice/comments/delete.dox",
                    type: "POST",
                    dataType: "json",
                    data: { commentNo: commentNo }, 
                    success: function(res) {
                        if (res.result === "success") {
                            alert("댓글이 삭제되었습니다.");
                            self.fnLoadComments(); 
                        } else {
                            alert("댓글 삭제 실패: " + res.message);
                        }
                    },
                    error: function() {
                        alert("서버와의 통신 중 오류가 발생했습니다.");
                    }
                });
            },


        },
        mounted() {
            let self = this;
            self.fnGetNoticeInfo();
            self.fnLoadComments();
        }
    });

    app.mount('#app');
</script>