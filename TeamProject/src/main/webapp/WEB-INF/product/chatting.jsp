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
                /* ===== Agricola Chat UI ===== */
                :root {
                    --bg: #faf8f0;
                    --card: #ffffff;
                    --mint-bg: #f7fff7;
                    --line: #e1f0e1;
                    --text: #1f2a1f;

                    --green-700: #1a5d1a;
                    --green-600: #2e7d32;
                    --green-500: #4caf50;
                    --green-400: #5dbb63;

                    --shadow: 0 10px 24px rgba(0, 0, 0, .08);
                    --shadow-sm: 0 2px 6px rgba(0, 0, 0, .08);
                    --radius: 14px;
                }

                * {
                    box-sizing: border-box;
                }

                html,
                body {
                    height: 100%;
                    margin: 0;
                    font-family: system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", Arial, sans-serif;
                    color: var(--text);
                    background: var(--bg);
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .content {
                    padding-bottom: 0 !important;
                    /* 아래 여백 완전 제거 */
                    padding-top: 0;
                    padding-left: 0;
                    padding-right: 0;
                }

                /* 카드(채팅 전체) */
                .chat-wrap {
                    width: 100%;
                    max-width: 820px;
                    height: min(76vh, 760px);
                    background: var(--card);
                    border: 1px solid var(--line);
                    border-radius: var(--radius);
                    box-shadow: var(--shadow);
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                }

                /* 헤더 */
                .chat-header {
                    padding: 16px 18px;
                    background: linear-gradient(180deg, #f7fff7 0%, #ffffff 100%);
                    border-bottom: 1px solid var(--line);
                }

                .chat-header h3 {
                    margin: 0;
                    font-size: 18px;
                    font-weight: 800;
                    color: var(--green-700);
                    letter-spacing: -0.2px;
                }

                .chat-header .meta {
                    margin-top: 6px;
                    font-size: 13px;
                    color: #567;
                    background: #e8f5e9;
                    border: 1px solid #d9edd9;
                    display: inline-flex;
                    gap: 6px;
                    align-items: center;
                    padding: 6px 10px;
                    border-radius: 999px;
                }

                /* 바디 */
                .chat-body {
                    flex: 1;
                    overflow: auto;
                    padding: 14px 14px 10px;
                    background:
                        radial-gradient(1200px 300px at 50% 0%, rgba(93, 187, 99, .10), transparent 60%),
                        #fafafa;
                    scroll-behavior: smooth;
                }

                /* 스크롤바(크롬) */
                .chat-body::-webkit-scrollbar {
                    width: 10px;
                }

                .chat-body::-webkit-scrollbar-thumb {
                    background: #c8e6c9;
                    border-radius: 999px;
                    border: 3px solid rgba(0, 0, 0, 0);
                    background-clip: padding-box;
                }

                .chat-body::-webkit-scrollbar-thumb:hover {
                    background: #81c784;
                    background-clip: padding-box;
                }

                /* 메시지 */
                .msg {
                    display: flex;
                    margin: 10px 0;
                    align-items: flex-end;
                    gap: 10px;
                }

                .msg.me {
                    justify-content: flex-end;
                }

                .msg.you {
                    justify-content: flex-start;
                }

                /* 말풍선 */
                .bubble {
                    max-width: min(72%, 560px);
                    padding: 10px 12px;
                    border-radius: 16px;
                    border: 1px solid #eee;
                    background: #fff;
                    box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
                }

                .bubble .text {
                    font-size: 14px;
                    line-height: 1.5;
                    white-space: pre-wrap;
                    word-break: break-word;
                }

                .msg.you .bubble {
                    background: #ffffff;
                    border-color: #eef2ee;
                    border-top-left-radius: 6px;
                }

                .msg.me .bubble {
                    background: #e8f5e9;
                    border-color: #d9edd9;
                    border-top-right-radius: 6px;
                }

                /* 시간 */
                .time {
                    margin-top: 6px;
                    font-size: 12px;
                    color: #7a8a7a;
                    text-align: right;
                }

                /* 입력 영역 */
                .chat-input {
                    display: flex;
                    gap: 10px;
                    padding: 12px;
                    border-top: 1px solid var(--line);
                    background: #fff;
                }

                .chat-input input {
                    flex: 1;
                    height: 44px;
                    padding: 0 14px;
                    border-radius: 12px;
                    border: 1px solid #dfe7df;
                    background: #fff;
                    outline: none;
                    font-size: 14px;
                    transition: box-shadow .2s, border-color .2s;
                }

                .chat-input input::placeholder {
                    color: #9aa79a;
                }

                .chat-input input:focus {
                    border-color: rgba(93, 187, 99, .85);
                    box-shadow: 0 0 0 4px rgba(93, 187, 99, .18);
                }

                .chat-input button {
                    height: 44px;
                    padding: 0 16px;
                    border: none;
                    border-radius: 12px;
                    background: var(--green-400);
                    color: #fff;
                    font-weight: 700;
                    cursor: pointer;
                    transition: transform .06s ease, background .2s ease, box-shadow .2s ease;
                    box-shadow: var(--shadow-sm);
                }

                .chat-input button:hover {
                    background: #4ba954;
                }

                .chat-input button:active {
                    transform: translateY(1px);
                }

                .chat-input button:focus {
                    outline: none;
                    box-shadow: 0 0 0 4px rgba(93, 187, 99, .18), var(--shadow-sm);
                }

                /* 반응형 */
                @media (max-width: 520px) {
                    .content {
                        padding: 18px 12px 60px;
                    }

                    .chat-wrap {
                        margin: 0 auto;
                        height: calc(100vh - 60px);
                        /* 헤더가 있다면 보정 */
                        border-radius: 0;
                        /* 아래 모서리 둥근 거 제거 */
                    }

                    .bubble {
                        max-width: 86%;
                    }
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
                                제품명 : {{ pName }}
                            </div>
                        </div>

                        <div class="chat-body" ref="chatBody">
                            <div v-for="m in messages" :key="m.messageId"
                                :class="['msg', m.senderId === sessionId ? 'me' : 'you']">
                                <div class="bubble">
                                    <div>{{ m.senderId }}</div>
                                    <div class="text">{{ m.content }}</div>
                                    <div class="time">{{ formatChatTime(m.cdatetime) }}</div>
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

                    const roomIdFromUrl = params.get("roomId");    // ✅ 추가
                    const productNoFromUrl = params.get("productNo");
                    const sellerIdFromUrl = params.get("sellerId");
                    const orderIdFromUrl = params.get("orderId");
                    const pNameFromUrl = params.get("pName");

                    return {
                        sessionId: "${sessionScope.sessionId}",

                        // ✅ 1) roomId로 들어오는 케이스 (판매자 채팅함)
                        roomId: roomIdFromUrl ? Number(roomIdFromUrl) : null,

                        // ✅ 2) 상품상세에서 들어오는 케이스
                        productNo: productNoFromUrl || "${productNo}",
                        sellerId: sellerIdFromUrl || "",
                        orderId: orderIdFromUrl || "",

                        messages: [],
                        newMsg: "",
                        stompClient: null,
                        pName: pNameFromUrl ? decodeURIComponent(pNameFromUrl) : "",
                    };
                },

                methods: {
                    // ✅ roomId가 있을 때: 방 조회/생성 스킵하고 바로 로드
                    fnStartByRoomId() {
                        if (!this.roomId) return;
                        this.fnLoadMessages();
                        this.fnConnectWs();
                    },

                    // 1) (상품상세 진입) 채팅방 조회
                    fnGetRoom() {
                        const self = this;

                        const param = {
                            buyerId: self.sessionId,
                            sellerId: self.sellerId,
                            productNo: self.productNo
                        };

                        if (self.orderId && String(self.orderId).trim()) {
                            param.orderId = self.orderId;
                        }

                        $.ajax({
                            url: "/chat/room.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success(data) {
                                if (data.result === "success") {
                                    self.roomId = data.room ? data.room.roomId : null;
                                    self.pName = (data.room && data.room.pName) ? data.room.pName : "";

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

                    // 2) (상품상세 진입) 방 생성
                    fnCreateRoom() {
                        const self = this;

                        const param = {
                            buyerId: self.sessionId,
                            sellerId: self.sellerId,
                            productNo: self.productNo
                        };

                        if (self.orderId && String(self.orderId).trim()) {
                            param.orderId = self.orderId;
                        }

                        $.ajax({
                            url: "/chat/room/create.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success(data) {
                                if (data.result === "success") {
                                    self.roomId = Number(data.roomId);
                                    self.fnLoadMessages();
                                    self.fnConnectWs();
                                } else {
                                    alert("채팅방 생성 실패: " + (data.message || ""));
                                }
                            }
                        });
                    },

                    // 3) 메시지 리스트
                    fnLoadMessages() {
                        const self = this;
                        $.ajax({
                            url: "/chat/message/list.dox",
                            dataType: "json",
                            type: "POST",
                            data: { roomId: self.roomId },
                            success(data) {
                                if (data.result === "success") {
                                    self.messages = data.list || [];
                                    self.$nextTick(() => self.fnScrollBottom());
                                    console.log("first message:", self.messages[0]);
                                } else {
                                    alert("메시지 조회 실패");
                                }
                            }
                        });
                    },

                    // 4) 메시지 전송
                    fnSend() {
                        if (!this.newMsg.trim()) return;
                        if (!this.stompClient || !this.roomId) return;

                        const msg = {
                            roomId: this.roomId,
                            senderId: this.sessionId,
                            content: this.newMsg,
                            messageType: "TEXT"
                        };

                        this.stompClient.send("/app/chat/send", {}, JSON.stringify(msg));
                        this.newMsg = "";
                    },

                    fnScrollBottom() {
                        const el = this.$refs.chatBody;
                        if (el) el.scrollTop = el.scrollHeight;
                    },

                    fnConnectWs() {
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

                    formatChatTime(ts) {
                        if (!ts) return "";

                        // 1) 문자열 ISO: "YYYY-MM-DDTHH:mm:ss"
                        if (typeof ts === "string" && ts.includes("T")) {
                            const [datePart, timePartRaw] = ts.split("T");
                            const hh = Number(timePartRaw.slice(0, 2));
                            const mm = timePartRaw.slice(3, 5);

                            // KST 보정
                            const d = new Date(Date.UTC(
                                Number(datePart.slice(0, 4)),
                                Number(datePart.slice(5, 7)) - 1,
                                Number(datePart.slice(8, 10)),
                                hh, Number(mm), 0
                            ));
                            d.setHours(d.getHours());

                            const todayKst = new Date();
                            // todayKst도 KST 기준으로 비교하려고 날짜 문자열로 비교
                            const todayStr = todayKst.toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" }); // YYYY-MM-DD
                            const dateStr = d.toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" });

                            if (dateStr === todayStr) {
                                return d.toLocaleTimeString("ko-KR", { timeZone: "Asia/Seoul", hour: "2-digit", minute: "2-digit", hour12: false });
                            }
                            return dateStr; // 오늘 아니면 날짜만
                        }

                        // 2) 그 외는 그냥 Date로 처리
                        const d = new Date(ts);
                        if (isNaN(d.getTime())) return "";

                        const todayStr = new Date().toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" });
                        const dateStr = d.toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" });

                        if (dateStr === todayStr) {
                            return d.toLocaleTimeString("ko-KR", { timeZone: "Asia/Seoul", hour: "2-digit", minute: "2-digit", hour12: false });
                        }
                        return dateStr;
                    }

                },

                mounted() {
                    if (!this.sessionId || !String(this.sessionId).trim()) {
                        alert("로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    }

                    // roomId로 들어오면: room header 조회 + 메시지로드 + ws
                    if (this.roomId) {
                        this.fnLoadMessages();
                        this.fnConnectWs();
                        return;
                    }

                    // productNo/sellerId로 들어오면: 방 조회/생성 -> roomId 확정 후 ws
                    if (!this.productNo || !String(this.productNo).trim() ||
                        !this.sellerId || !String(this.sellerId).trim()) {
                        alert("채팅에 필요한 값(roomId 또는 productNo/sellerId)이 없습니다.");
                        return;
                    }

                    this.fnGetRoom(); // 성공 콜백에서 roomId 확정 후 connect 하니까 OK
                }

            });

            app.mount('#app');
        </script>