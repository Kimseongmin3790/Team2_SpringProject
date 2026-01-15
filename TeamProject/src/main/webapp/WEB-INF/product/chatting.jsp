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
            <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

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

                .chat-wrap {
                    max-width: 720px;
                    margin: 0 auto;
                    display: flex;
                    flex-direction: column;
                    height: 70vh;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                }

                .chat-header {
                    padding: 12px;
                    border-bottom: 1px solid #eee;
                }

                .chat-body {
                    flex: 1;
                    overflow: auto;
                    padding: 12px;
                    background: #fafafa;
                }

                .msg {
                    display: flex;
                    margin: 8px 0;
                }

                .msg.me {
                    justify-content: flex-end;
                }

                .msg.you {
                    justify-content: flex-start;
                }

                .bubble {
                    max-width: 70%;
                    padding: 10px;
                    border-radius: 10px;
                    background: #fff;
                    border: 1px solid #eee;
                }

                .msg.me .bubble {
                    background: #e8f3ff;
                }

                .time {
                    font-size: 12px;
                    color: #777;
                    margin-top: 4px;
                    text-align: right;
                }

                .chat-input {
                    display: flex;
                    gap: 8px;
                    padding: 12px;
                    border-top: 1px solid #eee;
                }

                .chat-input input {
                    flex: 1;
                    padding: 10px;
                }

                .chat-input button {
                    padding: 10px 14px;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <main class="content">
                    <div class="chat-wrap">
                        <div class="chat-header">
                            <h3>주문 채팅</h3>
                            <div class="meta">
                                roomId: {{ roomId }} / orderId: {{ orderId }}
                            </div>
                        </div>

                        <div class="chat-body" ref="chatBody">
                            <div v-for="m in messages" :key="m.messageId"
                                :class="['msg', m.senderId === sessionId ? 'me' : 'you']">
                                <div class="bubble">
                                    <div class="text">{{ m.content }}</div>
                                    <div class="time">{{ m.cdatetime }}</div>
                                </div>
                            </div>
                        </div>

                        <div class="chat-input">
                            <input type="text" v-model="newMsg" @keyup.enter="fnSend" placeholder="메시지 입력..." />
                            <button @click="fnSend">전송</button>
                        </div>
                    </div>
                </main>

            </div>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    const params = new URLSearchParams(location.search);

                    const productNoFromUrl = params.get("productNo");
                    const sellerIdFromUrl = params.get("sellerId");
                    const orderIdFromUrl = params.get("orderId");

                    return {
                        // 세션은 네 프로젝트에 맞춰 sessionScope로 받는게 안전
                        sessionId: "${sessionScope.sessionId}",

                        // ✅ URL에서 먼저 받고, 없으면 JSP값 fallback
                        productNo: productNoFromUrl || "${productNo}",
                        sellerId: sellerIdFromUrl || "",
                        orderId: orderIdFromUrl || "",

                        roomId: null,
                        messages: [],
                        newMsg: "",
                        stompClient: null
                    };
                },

                methods: {
                    // 1) 주문번호로 채팅방 조회
                    fnGetRoom: function () {
                        let self = this;

                        const param = {
                            buyerId: self.sessionId,
                            sellerId: self.sellerId,
                            productNo: self.productNo
                        };

                        // ✅ orderId 있을 때만 추가
                        if (self.orderId && String(self.orderId).trim()) {
                            param.orderId = self.orderId;
                        }

                        $.ajax({
                            url: "/chat/room.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if (data.result === "success") {
                                    self.roomId = data.room ? data.room.roomId : null;

                                    if (self.roomId) {
                                        self.fnLoadMessages();
                                        self.fnConnectWs();
                                    } else {
                                        self.fnCreateRoom();
                                    }
                                } else {
                                    alert("채팅방 조회 실패: " + (data.message || ""));
                                }
                            }
                        });
                    },

                    fnCreateRoom: function () {
                        let self = this;

                        const param = {
                            buyerId: self.sessionId,
                            sellerId: self.sellerId,
                            productNo: self.productNo
                        };

                        // ✅ orderId 있을 때만 추가
                        if (self.orderId && String(self.orderId).trim()) {
                            param.orderId = self.orderId;
                        }

                        $.ajax({
                            url: "/chat/room/create.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if (data.result === "success") {
                                    self.roomId = data.roomId;
                                    self.fnLoadMessages();
                                    self.fnConnectWs();
                                } else {
                                    alert("채팅방 생성 실패: " + (data.message || ""));
                                }
                            }
                        });
                    },
                    // 2) 메시지 리스트 조회
                    fnLoadMessages: function () {
                        let self = this;
                        $.ajax({
                            url: "/chat/message/list.dox",
                            dataType: "json",
                            type: "POST",
                            data: { roomId: self.roomId },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.messages = data.list || [];
                                    self.$nextTick(() => self.fnScrollBottom());
                                } else {
                                    alert("메시지 조회 실패");
                                }
                            }
                        });
                    },

                    // 3) 메시지 전송(저장)
                    fnSend: function () {
                        if (!this.newMsg.trim()) return;

                        const msg = {
                            roomId: this.roomId,
                            senderId: this.sessionId,
                            content: this.newMsg,
                            messageType: "TEXT"
                        };

                        this.stompClient.send("/app/chat/send", {}, JSON.stringify(msg));
                        this.newMsg = "";
                    },


                    fnScrollBottom: function () {
                        const el = this.$refs.chatBody;
                        if (el) el.scrollTop = el.scrollHeight;
                    },

                    fnConnectWs: function () {
                        const self = this;

                        const socket = new SockJS("${pageContext.request.contextPath}/ws");
                        const stomp = Stomp.over(socket);
                        stomp.debug = null;

                        stomp.connect({}, function () {
                            self.stompClient = stomp;

                            stomp.subscribe("/topic/chat/room/" + self.roomId, function (msg) {
                                const m = JSON.parse(msg.body);

                                self.messages.push({
                                    senderId: m.senderId,
                                    content: m.content,
                                    messageType: m.messageType,
                                    cdatetime: new Date().toISOString()
                                });

                                self.$nextTick(() => self.fnScrollBottom());
                            });
                        });
                    },

                },
                mounted() {
                    if (!this.productNo || !String(this.productNo).trim() ||
                        !this.sellerId || !String(this.sellerId).trim()) {
                        alert("채팅에 필요한 값(productNo/sellerId)이 없습니다. 상품 페이지에서 다시 시도해주세요.");
                        return;
                    }
                    // 시작 시 채팅방 조회
                    this.fnGetRoom();
                }
            });

            app.mount('#app');
        </script>