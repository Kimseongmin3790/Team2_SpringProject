<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" contents="width=device-width, initial-scale=1.0" />
        <!-- Security (있으면 사용) -->
        <meta name="_csrf" contents="${_csrf.token}" />
        <meta name="_csrf_header" contents="${_csrf.headerName}" />

        <title>실시간 채팅</title>

        <!-- Libs -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

        <style>
            body {
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
                background: #fafafa;
            }

            #chat {
                max-width: 720px;
                margin: 24px auto;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, .06);
                overflow: hidden;
            }

            .topbar {
                padding: 12px 16px;
                display: flex;
                align-items: center;
                gap: 8px;
                border-bottom: 1px solid #eee;
                background: #f8fafc;
            }

            .topbar .grow {
                flex: 1;
                color: #334155;
                font-weight: 700;
            }

            #win {
                height: 360px;
                overflow-y: auto;
                padding: 12px 16px;
                background: #fff;
            }

            .sys {
                color: #6b7280;
                font-style: italic;
            }

            .row {
                margin: 6px 0;
            }

            .me {
                text-align: right;
            }

            .me .bubble {
                display: inline-block;
                background: #059669;
                color: #fff;
                padding: 8px 10px;
                border-radius: 12px 12px 4px 12px;
            }

            .other .bubble {
                display: inline-block;
                background: #f3f4f6;
                color: #111827;
                padding: 8px 10px;
                border-radius: 12px 12px 12px 4px;
            }

            .foot {
                padding: 12px 16px;
                display: flex;
                gap: 8px;
                border-top: 1px solid #eee;
                background: #f8fafc;
            }

            .foot input {
                flex: 1;
                height: 40px;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                padding: 0 12px;
            }

            .foot button {
                height: 40px;
                border: 1px solid #059669;
                background: #059669;
                color: #fff;
                border-radius: 10px;
                padding: 0 14px;
                font-weight: 700;
            }

            .foot button:disabled {
                opacity: .5;
            }
        </style>
    </head>

    <body>
        <!-- 세션값 주입 (네 프로젝트 관례) -->
        <input type="hidden" id="sessionId" value="${sessionScope.sessionId}">
        <input type="hidden" id="sessionName" value="${sessionScope.sessionName}">
        <!-- 이거 하나만 -->
        <input type="hidden" id="initRoomNo" value="${param.roomNo != null ? param.roomNo : roomNo}">
        <!-- 상품 상세에서 넘어올 수도 있는 값 (선택) -->
        <input type="hidden" id="productNo" value="${param.productNo}">
        <input type="hidden" id="title" value="${param.title}">

        <div id="app">
            <div id="chat">
                <div class="topbar">
                    <div class="grow">채팅방 · {{ title || ('ROOM ' + roomNo) }}</div>
                    <span>사용자: <b>{{ username }}</b></span>
                    <button @click="connect" :disabled="connected" style="margin-left:8px">연결</button>
                    <button @click="disconnect" :disabled="!connected">끊기</button>
                </div>

                <div id="win">
                    <div v-for="(m,i) in messages" :key="i" class="row" :class="m.cls">
                        <template v-if="m.type==='SYSTEM'">
                            <span class="sys">{{ m.time }} · {{ m.contents }}</span>
                        </template>
                        <template v-else>
                            <div class="bubble">
                                <small v-if="m.sender && m.cls!=='me'" style="opacity:.7">{{m.sender}}</small>
                                <div>{{ m.contents }}</div>
                                <small style="opacity:.6">{{ m.time }}</small>
                            </div>
                        </template>
                    </div>
                </div>

                <div class="foot">
                    <input type="text" v-model.trim="draft" @keyup.enter="send" placeholder="메시지를 입력하세요" />
                    <button @click="send" :disabled="!connected || !draft">전송</button>
                </div>
            </div>
        </div>

        <script>
            // CSRF (있을 때 자동 세팅)
            (function () {
                const token = document.querySelector('meta[name="_csrf"]').getAttribute('contents');
                const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('contents');
                if (token && header) {
                    $.ajaxSetup({ beforeSend: function (xhr) { xhr.setRequestHeader(header, token); } });
                }
            })();

            const app = Vue.createApp({
                data() {
                    return {
                        stomp: null,
                        connected: false,
                        userId: '',
                        username: '',
                        roomNo: '',
                        title: '',
                        draft: '',
                        messages: [],
                        // 구독 채널(백엔드가 room별 토픽을 안 쓰고 /topic/public만 쓰면 그대로 두고, 클라이언트에서 roomNo로 필터)
                        topicPublic: '/topic/public',
                        clientId: crypto.randomUUID?.() || String(Math.random())
                    }
                },
                methods: {
                    // 0) 초기화 (세션/초기 roomNo)
                    initContext() {
                        const sid = document.getElementById('sessionId')?.value || '';
                        const sname = document.getElementById('sessionName')?.value || '';
                        const rid = document.getElementById('initRoomNo')?.value || '';
                        const pno = document.getElementById('productNo')?.value || '';
                        const ttl = document.getElementById('title')?.value || '';
                        this.userId = sid;
                        this.username = sname || sid || 'guest';
                        this.roomNo = rid || '';
                        this.title = ttl || '';
                        return { pno };
                    },

                    // A) 방이 없으면 생성 → 참가 업서트 → 히스토리 → 웹소켓 구독/입장 방송
                    connect() {
                        if (this.connected) return;
                        if (!this.userId) { alert('로그인이 필요합니다.'); location.href = '/login.do'; return; }
                        this.messages = [];

                        const { pno } = this.initContext();

                        const ensureRoom = () => new Promise((resolve) => {
                            if (this.roomNo) { resolve(this.roomNo); return; }
                            const payload = { title: this.title || ('상품문의 ' + (pno || '')), productNo: pno, ownerId: this.userId, isPrivate: 'Y' };
                            $.ajax({ url: '/chat/room/create.dox', type: 'POST', dataType: 'json', data: payload })
                                .done((r) => { if (r && r.roomNo) { this.roomNo = String(r.roomNo); } resolve(this.roomNo); })
                                .fail(() => resolve(this.roomNo)); // 실패해도 진행 (공용룸 같은 정책일 수 있음)
                        });

                        const upsertMe = () => new Promise((resolve) => {
                            $.ajax({ url: '/chat/join.dox', type: 'POST', dataType: 'json', data: { roomNo: this.roomNo, userId: this.userId, role: 'USER' } })
                                .always(() => resolve());
                        });

                        const loadHistory = () => new Promise((resolve) => {
                            $.ajax({ url: '/chat/history.dox', type: 'POST', dataType: 'json', data: { roomNo: this.roomNo, page: 0, pageSize: 100 } })
                                .done((res) => {
                                    if (res && res.result === 'success' && Array.isArray(res.list)) {
                                        res.list.forEach(r => {
                                            const t = String(r.type || '').toUpperCase();
                                            if (t === 'JOIN' || t === 'LEAVE') {
                                                this.messages.push({ type: 'SYSTEM', contents: r.contents, time: r.cdate, cls: '' });
                                            } else {
                                                this.messages.push({ type: 'CHAT', sender: r.userId, contents: r.contents, time: r.cdate, cls: (r.userId === this.userId ? 'me' : 'other') });
                                            }
                                        });
                                    }
                                })
                                .always(() => { this.scrollBottom(); resolve(); });
                        });

                        const connectSocket = () => new Promise((resolve) => {
                            const sock = new SockJS('/ws-chat');
                            this.stomp = Stomp.over(sock);
                            this.stomp.connect({}, () => {
                                this.connected = true;
                                // 공용 토픽 구독 후 roomNo 필터
                                this.stomp.subscribe(this.topicPublic, (payload) => {
                                    try {
                                        const msg = JSON.parse(payload.body);
                                        if (String(msg.roomNo || '') === String(this.roomNo || '')) {
                                            this.renderIncoming(msg);
                                        }
                                    } catch (e) { console.warn('payload parse err', e); }
                                });
                                resolve();
                            });
                        });

                        const announceJoin = () => new Promise((resolve) => {
                            const joinMsg = { type: 'JOIN', roomNo: this.roomNo, sender: this.username, userId: this.userId, contents: this.username + ' 님 입장' };
                            try { this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(joinMsg)); } catch (_) { }
                            $.ajax({ url: '/chat/save.dox', type: 'POST', dataType: 'json', data: joinMsg }).always(() => resolve());
                        });

                        // 실행 순서
                        ensureRoom()
                            .then(upsertMe)
                            .then(loadHistory)
                            .then(connectSocket)
                            .then(announceJoin);
                    },

                    disconnect() {
                        if (!this.connected) return;
                        const leaveMsg = { type: 'LEAVE', roomNo: this.roomNo, sender: this.username, userId: this.userId, contents: this.username + ' 님 퇴장' };
                        try { this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(leaveMsg)); } catch (_) { }
                        $.ajax({ url: '/chat/leave.dox', type: 'POST', dataType: 'json', data: { roomNo: this.roomNo, userId: this.userId } });
                        $.ajax({ url: '/chat/save.dox', type: 'POST', dataType: 'json', data: leaveMsg });
                        try { this.stomp.disconnect(); } catch (_) { }
                        this.connected = false;
                        this.messages.push({ type: 'SYSTEM', contents: this.username + ' 님 퇴장', time: this.timeNow(), cls: '' });
                        this.scrollBottom();
                    },

                    send() {
                        if (!this.connected || !this.draft) return;
                        const chat = { type: 'CHAT', roomNo: this.roomNo, sender: this.username, userId: this.userId, contents: this.draft, clientId: this.clientId };
                        try { this.stomp.send('/app/chat.sendMessage', {}, JSON.stringify(chat)); } catch { }
                        $.post('/chat/save.dox', chat);

                        // 로컬 즉시 표시
                        this.messages.push({ type: 'CHAT', sender: this.username, contents: this.draft, time: this.timeNow(), cls: 'me' });
                        this.draft = ''; this.scrollBottom();
                    },

                    renderIncoming(msg) {
                        const t = String(msg.type || '').toUpperCase();
                        const time = msg.cdate || msg.time || this.timeNow();

                        // 내가 보낸 걸 브로커가 에코한 것이라면 무시
                        if (msg.clientId && msg.clientId === this.clientId) return;

                        if (t === 'JOIN' || t === 'LEAVE') {
                            this.messages.push({ type: 'SYSTEM', contents: msg.contents, time, cls: '' });
                        } else {
                            const cls = (String(msg.userId || '') === String(this.userId)) ? 'me' : 'other';
                            this.messages.push({ type: 'CHAT', sender: msg.sender || msg.userId, contents: msg.contents, time, cls });
                        }
                        this.scrollBottom();
                    },

                    scrollBottom() { this.$nextTick(() => { const box = document.getElementById('win'); if (box) box.scrollTop = box.scrollHeight; }); },
                    timeNow() { const d = new Date(); return d.toLocaleTimeString(); }
                },
                mounted() {
                    const hid = document.getElementById('sessionId');
                    console.log('[debug] hidden#sessionId =', hid && hid.value);
                    console.log('[debug] data.userId(before)=', this.userId);
                    this.userId = (hid && hid.value) || this.userId || '';
                    console.log('[debug] data.userId(after)=', this.userId);
                    // 자동 연결 (원하면 버튼으로만 하도록 주석)
                    // 1) 세션/초기값 먼저 주입
                    this.initContext();

                    // 2) 로그인 체크
                    if (!this.userId) {
                        alert('로그인이 필요합니다.');
                        location.href = '/login.do?redirect=' + encodeURIComponent('/chatting.do');
                        return;
                    }

                    // 3) 이제 연결 시작
                    this.connect();

                    window.addEventListener('beforeunload', () => {
                        if (this.connected) this.disconnect();
                    });

                    if (location.hash) {
                        history.replaceState(null, '', location.pathname + location.search);
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>