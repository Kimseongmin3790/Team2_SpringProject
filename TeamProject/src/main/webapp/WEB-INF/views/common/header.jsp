<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        </head>

        <body>
            <div id="app">
                <div class="header" style="background:#e6ffe6;padding:15px;text-align:center;">
                    <h2>농수산물 직거래 사이트</h2>
                    <nav>
                        <a href="${pageContext.request.contextPath}/">홈</a> |
                        <a href="${pageContext.request.contextPath}/about">소개</a> |
                        <a href="#">문의</a>
                    </nav>
                </div>
            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                    };
                },
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