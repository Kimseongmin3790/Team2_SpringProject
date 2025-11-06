<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="_csrf" content="${_csrf.token}" />
        <meta name="_csrf_header" content="${_csrf.headerName}" />
        <title>Chat</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/webjars/sockjs-client/sockjs.min.js"></script>
        <script src="/webjars/stomp-websocket/stomp.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
        <style>
            #chat {
                max-width: 720px;
                margin: 20px auto;
            }

            #win {
                height: 320px;
                overflow-y: auto;
                border: 1px solid #ccc;
                padding: 10px;
            }

            .sys {
                color: #666;
                font-style: italic;
            }
        </style>
    </head>

    <body>
        <!-- 세션에서 사용자명/아이디 심어서 사용 -->
        <input type="hidden" id="defaultUsername" value="${sessionName}">
        <input type="hidden" id="defaultUserId" value="${sessionId}">

        <div id="app">
            <div id="chat">
                <div>
                    사용자: {{username}} &nbsp;
                    <button @click="connect" :disabled="connected">연결</button>
                    <button @click="disconnect" :disabled="!connected">끊기</button>
                </div>

                <div id="win">
                    <div v-for="(m,i) in messages" :key="i" :class="m.type==='SYSTEM'?'sys':''">
                        <template v-if="m.type==='SYSTEM'">{{m.time}} {{m.content}}</template>
                        <template v-else>[{{m.time}}] <b>{{m.sender}}</b> : {{m.content}}</template>
                    </div>
                </div>

                <div style="margin-top:8px">
                    <input type="text" v-model.trim="draft" @keyup.enter="send" placeholder="메시지 입력" style="width:70%">
                    <button @click="send" :disabled="!connected || !draft">전송</button>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        stomp: null,
                        connected: false,
                        username: "",
                        userId: "",
                        roomId: "1",
                        draft: "",
                        messages: []
                    }
                },
                methods: {
                    connect() {
                        if (this.connected) return;
                        const name = document.getElementById('defaultUsername')?.value || '';
                        const id = document.getElementById('defaultUserId')?.value || '';
                        if (!id) { alert('로그인이 필요합니다.'); location.href = '/login.do'; return; }
                        this.username = name || id;
                        this.userId = id;

                        this.messages = [];

                        const sock = new SockJS('/ws-chat');
                        this.stomp = Stomp.over(sock);

                        this.stomp.connect({}, () => {
                            this.connected = true;

                            // 1) 과거 히스토리 로드
                            this.loadHistory(() => {
                                // 2) 실시간 구독
                                this.stomp.subscribe('/topic/public', (payload) => {
                                    const msg = JSON.parse(payload.body);
                                    this.renderIncoming(msg);
                                });

                                // 3) 입장 알림 + DB 저장
                                const joinMsg = { type: 'JOIN', roomId: this.roomId, sender: this.username, userId: this.userId, content: this.username + ' 님 입장' };
                                this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(joinMsg));
                                this.saveChatAjax(joinMsg);
                            });
                        });
                    },
                    disconnect() {
                        if (!this.connected) return;
                        const leaveMsg = { type: 'LEAVE', roomId: this.roomId, sender: this.username, userId: this.userId, content: this.username + ' 님 퇴장' };
                        try { this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(leaveMsg)); } catch (_) { }
                        this.saveChatAjax(leaveMsg);
                        try { this.stomp.disconnect(); } catch (_) { }
                        this.connected = false;
                        this.messages.push({ type: 'SYSTEM', content: this.username + ' 님 퇴장', time: new Date().toLocaleTimeString() }); // ✅
                    },
                    send() {
                        if (!this.connected || !this.draft) return;
                        const chat = { type: 'CHAT', roomId: this.roomId, sender: this.username, userId: this.userId, content: this.draft };
                        this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(chat));
                        this.saveChatAjax(chat);
                        this.draft = "";
                    },
                    renderIncoming(msg) {
                        const t = (msg.type || '').toUpperCase();
                        const time = msg.cdate || msg.time || '';
                        if (t === 'JOIN' || t === 'LEAVE') {
                            this.messages.push({ type: 'SYSTEM', content: msg.content, time });
                        } else {
                            this.messages.push({ type: 'CHAT', sender: msg.sender || msg.userId, content: msg.content, time });
                        }
                        this.$nextTick(() => {
                            const box = document.getElementById('win');
                            box.scrollTop = box.scrollHeight;
                        });
                    },
                    saveChatAjax(payload) {
                        $.ajax({ url: '/chat/save.dox', type: 'POST', dataType: 'json', data: payload });
                    },
                    loadHistory(done) {
                        $.ajax({
                            url: '/chat/history.dox',
                            type: 'POST',
                            dataType: 'json',
                            data: { roomId: this.roomId, page: 0, pageSize: 50 },
                            success: (res) => {
                                if (res.result === 'success') {
                                    res.list.forEach(r => {
                                        const t = (r.type || '').toUpperCase();
                                        if (t === 'JOIN' || t === 'LEAVE') {
                                            this.messages.push({ type: 'SYSTEM', content: r.content, time: r.cdate });
                                        } else {
                                            this.messages.push({ type: 'CHAT', sender: r.userId, content: r.content, time: r.cdate });
                                        }
                                    });
                                    this.$nextTick(() => {
                                        const box = document.getElementById('win');
                                        box.scrollTop = box.scrollHeight;
                                    });
                                } else {
                                    console.warn('history result != success', res);
                                }
                            },
                            error: (xhr) => { console.error('history error', xhr?.status, xhr?.responseText); },
                            complete: () => { if (typeof done === 'function') done(); }   // ✅ 성공/실패 상관없이 구독/입장 진행
                        });
                    }

                },
                mounted() {
                    // 페이지 들어오면 자동 연결(원하면 수동으로 바꿔도 됨)
                    this.connect();
                    window.addEventListener('beforeunload', () => {
                        if (this.connected) {
                            const leaveMsg = { type: 'LEAVE', roomId: this.roomId, sender: this.username, userId: this.userId, content: this.username + ' 님 퇴장' };
                            try { this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(leaveMsg)); } catch (_) { }
                            this.saveChatAjax(leaveMsg);
                        }
                    });
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>