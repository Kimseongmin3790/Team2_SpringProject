<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <!-- 공통 헤더와 푸터 외부 css파일 링크 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
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
                }
            </style>
        </head>

        <body>
            <div id="app">
                <!-- 공통 헤더 -->
                <%@ include file="/WEB-INF/views/common/header.jsp" %>

                    <main class="content">
                        <h3>신선한 농수산물을 직접 거래하세요!</h3>
                        <p>생산자와 소비자가 1:1로 연결되는 새로운 직거래 플랫폼입니다.</p>
                    </main>

                <!-- 공통 푸터 -->
                <%@ include file="/WEB-INF/views/common/footer.jsp" %>
            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        sessionId: "${sessionId}"
                    };
                }, // 
                methods: {
                    // 함수(메소드) - (key : function())
                    fnList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                            }
                        });
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                }
            });

            app.mount('#app');
        </script>