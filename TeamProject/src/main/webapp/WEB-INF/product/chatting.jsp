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
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                    overflow: hidden;
                }

                #app {
                    min-height: 100vh;
                }

                .content {
                    min-height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: stretch;
                    padding: 0;
                }

                .chat-wrap {
                    width: 100%;
                    height: 100vh;
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
                    margin: 14px 0;
                    gap: 10px;
                    align-items: flex-end;
                    /* 아바타/말풍선 아래 맞춤 */
                }

                .msg.you {
                    justify-content: flex-start;
                }

                .msg.me {
                    justify-content: flex-end;
                }

                .msg-col {
                    display: flex;
                    flex-direction: column;
                    max-width: min(72%, 560px);
                }

                .msg.me .msg-col {
                    align-items: flex-end;
                }

                /* 이름(상대만) - 좀 더 또렷하게 */
                .name {
                    font-size: 12px;
                    font-weight: 700;
                    color: #3f5a3f;
                    margin: 0 0 6px 6px;
                }

                /* 아바타 - 확실하게 보이게 */
                .avatar {
                    width: 44px;
                    height: 44px;
                    border-radius: 999px;
                    display: grid;
                    place-items: center;

                    font-weight: 900;
                    font-size: 12px;
                    letter-spacing: .2px;
                    color: #fff;

                    background: #1a5d1a;
                    /* 기본 진한색 */
                    border: 2px solid #ffffff;
                    /* 흰 테두리 */
                    box-shadow: 0 10px 22px rgba(0, 0, 0, .22);
                    /* 그림자 더 진하게 */
                }


                /* 상대/나 아바타 위치 살짝 조정 */
                .msg.you .avatar {
                    margin-left: 2px;
                }

                .msg.me .avatar {
                    margin-right: 2px;
                }

                /* 말풍선 - 더 도톰하게 + 대비 */
                .bubble {
                    background: #fff;
                    border: 1px solid #e7eee7;
                    border-radius: 18px;
                    padding: 10px 12px;
                    box-shadow: 0 6px 16px rgba(0, 0, 0, .06);
                }

                .msg.me .bubble {
                    background: #e8f5e9;
                    border-color: #d5ead5;
                }

                /* 말풍선 꼬리 느낌(아주 약하게) */
                .msg.you .bubble {
                    border-top-left-radius: 10px;
                    position: relative;
                }

                .msg.you .bubble::before {
                    content: "";
                    position: absolute;
                    left: -6px;
                    bottom: 10px;
                    width: 12px;
                    height: 12px;
                    background: #fff;
                    border-left: 1px solid #e7eee7;
                    border-bottom: 1px solid #e7eee7;
                    transform: rotate(45deg);
                    border-bottom-left-radius: 3px;
                }

                .msg.me .bubble {
                    border-top-right-radius: 10px;
                    position: relative;
                }

                .msg.me .bubble::before {
                    content: "";
                    position: absolute;
                    right: -6px;
                    bottom: 10px;
                    width: 12px;
                    height: 12px;
                    background: #e8f5e9;
                    border-right: 1px solid #d5ead5;
                    border-bottom: 1px solid #d5ead5;
                    transform: rotate(-45deg);
                    border-bottom-right-radius: 3px;
                }

                /* 시간 - 더 작고 깔끔하게 */
                .time {
                    margin-top: 6px;
                    font-size: 11px;
                    color: #7a8a7a;
                }

                .msg.you .time {
                    text-align: left;
                    margin-left: 6px;
                }

                .msg.me .time {
                    text-align: right;
                    margin-right: 6px;
                }

                /* 모바일 */
                @media (max-width: 520px) {
                    .msg-col {
                        max-width: 80%;
                    }
                }

                /* 입력 영역 복구 */
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
                    font-weight: 800;
                    cursor: pointer;
                    box-shadow: var(--shadow-sm);
                }

                .chat-input button:hover {
                    background: #4ba954;
                }

                .chat-input button:active {
                    transform: translateY(1px);
                }

                .avatar-img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    border-radius: 999px;
                    display: block;
                }
            </style>
        </head>

        <body>
            <div id="app">
                <main class="content">
                    <div class="chat-wrap">
                        <div class="chat-header">
                            <h3>주문 채팅</h3>
                            <div class="product-chip" :title="pName">
                                <div class="product-text">
                                    <div class="product-name">제품명 : {{ pName || '상품 정보 없음' }}</div>
                                </div>
                            </div>


                        </div>

                        <div class="chat-body" ref="chatBody">
                            <div v-for="m in messages" :key="m.messageId"
                                :class="['msg', m.senderId === sessionId ? 'me' : 'you']">

                                <!-- 상대(you): 아바타 -> 컨텐츠 -->
                                <template v-if="m.senderId !== sessionId">
                                    <!-- 상대(you): 아바타 -->
                                    <div class="avatar">
                                        <img v-if="profileUrl(m.senderId)" class="avatar-img"
                                            :src="profileUrl(m.senderId)" alt="" />
                                        <span v-else>{{ avatarText(m.senderId) }}</span>
                                    </div>

                                    <div class="msg-col">
                                        <div class="name">{{ m.senderId }}</div>
                                        <div class="bubble">
                                            <div class="text">{{ m.content }}</div>
                                        </div>
                                        <div class="time">{{ formatChatTime(m.cdatetime) }}</div>
                                    </div>
                                </template>

                                <!-- 나(me): 컨텐츠 -> 아바타(옵션) -->
                                <template v-else>
                                    <div class="msg-col me-col">
                                        <div class="bubble">
                                            <div class="text">{{ m.content }}</div>
                                        </div>
                                        <div class="time">{{ formatChatTime(m.cdatetime) }}</div>
                                    </div>

                                    <!-- 내 아바타도 쓰고 싶으면 주석 해제 -->

                                    <!-- <div class="avatar me-avatar" :style="avatarStyle(m.senderId)">
                                        {{ avatarText(m.senderId) }}
                                    </div> -->

                                </template>

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

                    const roomIdFromUrl = params.get("roomId");    // 추가
                    const productNoFromUrl = params.get("productNo");
                    const sellerIdFromUrl = params.get("sellerId");
                    const orderIdFromUrl = params.get("orderId");
                    const pNameFromUrl = params.get("pName");

                    return {
                        sessionId: "${sessionScope.sessionId}",

                        // 1) roomId로 들어오는 케이스 (판매자 채팅함)
                        roomId: roomIdFromUrl ? Number(roomIdFromUrl) : null,

                        // 2) 상품상세에서 들어오는 케이스
                        productNo: productNoFromUrl || "${productNo}",
                        sellerId: sellerIdFromUrl || "",
                        orderId: orderIdFromUrl || "",

                        messages: [],
                        newMsg: "",
                        stompClient: null,
                        pName: pNameFromUrl ? decodeURIComponent(pNameFromUrl) : "",
                        sellerProfileUrl: "",
                    };
                },

                methods: {
                    // roomId가 있을 때: 방 조회/생성 스킵하고 바로 로드
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
                                    self.pName = data.room?.pName || "";
                                    self.sellerProfileUrl = data.room?.sellerProfileImg || "";

                                    if (self.roomId) {
                                        self.fnLoadMessages();
                                        self.fnConnectWs();
                                    } else {
                                        self.fnCreateRoom();
                                    }
                                } else {
                                    Swal.fire('❌', "채팅방 조회 실패: " + (data.message || ""), 'error');
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
                                    Swal.fire('❌', "채팅방 생성 실패: " + (data.message || ""), 'error');
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
                                    Swal.fire('❌', '메시지 조회 실패', 'error');
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
                            const mm = Number(timePartRaw.slice(3, 5));

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
                    },

                    avatarText(id) {
                        if (!id) return "?";
                        // 영문/숫자면 앞 2글자, 한글이면 1글자
                        const s = String(id).trim();
                        const isKorean = /[가-힣]/.test(s);
                        return isKorean ? s.slice(0, 1) : s.slice(0, 2).toUpperCase();
                    },

                    avatarStyle(id) {
                        const colors = ["#1a5d1a", "#1565C0", "#6A1B9A", "#C62828", "#EF6C00", "#00838F"];

                        const s = String(id || "");
                        let hash = 0;
                        for (let i = 0; i < s.length; i++) hash = (hash * 31 + s.charCodeAt(i)) >>> 0;

                        return { background: colors[hash % colors.length] };
                    },
                    fnFetchRoomByRoomId() {
                        const self = this;
                        $.ajax({
                            url: "/chat/room/byRoomId.dox",
                            dataType: "json",
                            type: "POST",
                            data: { roomId: self.roomId },
                            success(data) {
                                if (data.result === "success") {
                                    self.sellerId = data.room?.sellerId || self.sellerId;
                                    self.pName = data.room?.pName || self.pName;
                                    self.sellerProfileUrl = data.room?.sellerProfileImg || "";
                                    self.fnLoadMessages();
                                    self.fnConnectWs();
                                }
                            }
                        });
                    },

                    profileUrl(senderId) {
                        if (senderId === this.sellerId && this.sellerProfileUrl) return this.sellerProfileUrl;
                        return "";
                    }

                },

                mounted() {
                    if (!this.sessionId || !String(this.sessionId).trim()) {
                        Swal.fire('⚠️', '로그인 후 이용 가능합니다.', 'warning');
                        location.href = "/login.do";
                        return;
                    }

                    // roomId로 들어오면: room header 조회 + 메시지로드 + ws
                    if (this.roomId) {
                        this.fnFetchRoomByRoomId();
                        return;
                    }

                    // productNo/sellerId로 들어오면: 방 조회/생성 -> roomId 확정 후 ws
                    if (!this.productNo || !String(this.productNo).trim() ||
                        !this.sellerId || !String(this.sellerId).trim()) {
                        Swal.fire('⚠️', '채팅에 필요한 값(roomId 또는 productNo/sellerId)이 없습니다.', 'warning');
                        return;
                    }

                    this.fnGetRoom(); // 성공 콜백에서 roomId 확정 후 connect 하니까 OK
                }

            });

            app.mount('#app');
        </script>