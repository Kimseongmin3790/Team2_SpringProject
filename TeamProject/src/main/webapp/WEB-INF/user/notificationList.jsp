<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>알림 타임라인 - FRESH FARM</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
                    padding: 60px 20px;
                    background: #f9fafb;
                }

                .noti-container {
                    max-width: 800px;
                    margin: 0 auto;
                }

                .noti-header {
                    background: white;
                    padding: 30px;
                    margin-bottom: 40px;
                    border-radius: 16px;
                    text-align: center;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                }

                .noti-header h2 {
                    font-size: 28px;
                    color: #111;
                    margin-bottom: 10px;
                    font-weight: 700;
                }

                .date-label {
                    font-size: 15px;
                    font-weight: 700;
                    color: #5dbb63;
                    margin-bottom: 24px;
                    padding-left: 52px;
                    position: relative;
                }

                .timeline {
                    position: relative;
                    padding-left: 52px;
                    margin-bottom: 50px;
                }

                .timeline::before {
                    content: '';
                    position: absolute;
                    left: 21px;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: #e5e7eb;
                }

                .timeline-item {
                    position: relative;
                    background: white;
                    padding: 24px;
                    margin-bottom: 20px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
                    cursor: pointer;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    border: 1px solid transparent;
                }

                .timeline-item:hover {
                    transform: translateY(-2px) translateX(5px);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                    border-color: #5dbb63;
                }

                .timeline-item.unread {
                    background: #f0fdf4;
                    border-left: 4px solid #5dbb63;
                }

                .timeline-dot {
                    position: absolute;
                    left: -38px;
                    top: 28px;
                    width: 14px;
                    height: 14px;
                    border-radius: 50%;
                    background: white;
                    border: 3px solid #d1d5db;
                    z-index: 1;
                    transition: all 0.3s;
                }

                .timeline-item.unread .timeline-dot {
                    background: #5dbb63;
                    border-color: #5dbb63;
                    transform: scale(1.2);
                }

                .timeline-header {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                    margin-bottom: 10px;
                }

                .timeline-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 20px;
                }

                .timeline-icon.ORDER {
                    background: #eff6ff;
                }

                .timeline-icon.CHAT {
                    background: #f5f3ff;
                }

                .timeline-icon.NOTICE {
                    background: #fff7ed;
                }

                .timeline-icon.MARKETING {
                    background: #fdf2f8;
                }

                .timeline-title {
                    flex: 1;
                    font-size: 17px;
                    font-weight: 700;
                    color: #1f2937;
                }

                .timeline-time {
                    font-size: 13px;
                    color: #9ca3af;
                }

                .timeline-message {
                    font-size: 15px;
                    color: #4b5563;
                    line-height: 1.6;
                    word-break: break-all;
                }

                .empty-state {
                    text-align: center;
                    padding: 100px 0;
                    background: white;
                    border-radius: 16px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                }

                .empty-state-icon {
                    font-size: 50px;
                    margin-bottom: 20px;
                    opacity: 0.5;
                }

                /* 페이징 스타일 */
                .pagination {
                    display: flex;
                    justify-content: center;
                    gap: 8px;
                    margin-top: 40px;
                }

                .pagination button {
                    padding: 10px 16px;
                    border: 1px solid #e5e7eb;
                    background: white;
                    border-radius: 8px;
                    cursor: pointer;
                    font-weight: 500;
                    transition: all 0.2s;
                }

                .pagination button.active {
                    background: #5dbb63;
                    color: white;
                    border-color: #5dbb63;
                }

                .pagination button:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }

                .pagination button:hover:not(:disabled):not(.active) {
                    background: #f3f4f6;
                }

                /* 삭제 버튼 스타일 (방법 1: 호버 시 원형 버튼 출현) */
                .delete-btn {
                    position: absolute;
                    top: 15px;
                    right: 15px;
                    background: #f3f4f6;
                    border: none;
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 18px;
                    color: #9ca3af;
                    cursor: pointer;
                    opacity: 0;
                    /* 기본 상태 숨김 */
                    transition: all 0.2s ease;
                    z-index: 2;
                    line-height: 1;
                    padding: 0;
                }

                /* 항목에 마우스를 올리면 삭제 버튼 나타남 */
                .timeline-item:hover .delete-btn {
                    opacity: 1;
                    background: #fee2e2;
                    color: #ef4444;
                }

                .delete-btn:hover {
                    transform: scale(1.15);
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }

                /* 전체 삭제 버튼 영역 */
                .action-bar {
                    display: flex;
                    justify-content: flex-end;
                    margin-bottom: 15px;
                    padding-right: 5px;
                }

                .clear-all-btn {
                    font-size: 13px;
                    color: #9ca3af;
                    background: none;
                    border: none;
                    cursor: pointer;
                    text-decoration: underline;
                    transition: color 0.2s;
                }

                .clear-all-btn:hover {
                    color: #4b5563;
                }

                /* 알림 안내 가이드 */
                .noti-guide {
                    margin-top: 15px;
                    padding: 10px;
                    background: #f8f9fa;
                    border-radius: 8px;
                    font-size: 13px;
                    color: #888;
                }

                /* 하단 알림 아이콘 범례 */
                .noti-legend {
                    margin-top: 30px;
                    border-top: 1px solid #e5e7eb;
                    padding-top: 20px;
                    display: flex;
                    gap: 20px;
                    justify-content: center;
                    font-size: 13px;
                    color: #9ca3af;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <main class="content">
                        <div class="noti-container">
                            <div class="noti-header">
                                <h2>알림 타임라인</h2>
                                <p style="color:#6b7280; font-size:15px;">소중한 농산물의 소식을 실시간으로 확인하세요</p>
                                <div class="noti-guide">
                                    <i class="fa-solid fa-circle-info"></i> 알림은 최근 30일간의 기록만 보관되며, 이후에는 자동으로 삭제됩니다.
                                </div>
                            </div>
                            <div class="action-bar" v-if="list.length > 0">
                                <button class="clear-all-btn" @click="fnReadAll" style="margin-right: 15px;">모든 알림 읽음 처리</button>
                                <button class="clear-all-btn" @click="fnRemoveRead">읽은 알림 모두 삭제</button>
                            </div>

                            <div v-if="list.length > 0">
                                <div v-for="(items, date) in groupedNotis" :key="date">
                                    <div class="date-label">{{ date }}</div>
                                    <div class="timeline">
                                        <div v-for="item in items" :key="item.NOTI_NO"
                                            :class="['timeline-item', { unread: item.IS_READ === 'N' }]"
                                            @click="fnRead(item)">
                                            <button class="delete-btn" @click.stop="fnRemove(item.NOTI_NO)">×</button>
                                            <div class="timeline-dot"></div>
                                            <div class="timeline-header">
                                                <div :class="['timeline-icon', item.TYPE]">
                                                    {{ getIcon(item.TYPE) }}
                                                </div>
                                                <div class="timeline-title">{{ getTitle(item.TYPE) }}</div>
                                                <div class="timeline-time">{{ formatNotiTime(item.CDATETIME) }}</div>
                                            </div>
                                            <div class="timeline-message">{{ item.MESSAGE }}</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 페이징 UI -->
                                <div class="pagination" v-if="totalCount > pageSize">
                                    <button @click="fnList(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                                    <button v-for="n in totalPages" :key="n" @click="fnList(n)"
                                        :class="{ active: currentPage === n }">
                                        {{ n }}
                                    </button>
                                    <button @click="fnList(currentPage + 1)"
                                        :disabled="currentPage === totalPages">다음</button>
                                </div>
                                <div class="noti-legend">
                                    <span>📦 주문/배송</span>
                                    <span>🔔 시스템/재입고</span>
                                    <span>💬 답변/채팅</span>
                                    <span>🎁 혜택/이벤트</span>
                                </div>
                            </div>

                            <div v-else class="empty-state">
                                <div class="empty-state-icon">🔔</div>
                                <p style="color:#6b7280; font-size:16px;">새로운 알림이 없습니다.</p>
                            </div>
                        </div>
                    </main>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    list: [],
                                    userId: "${sessionScope.sessionId}",
                                    currentPage: 1,
                                    pageSize: 10,
                                    totalCount: 0
                                }
                            },
                            computed: {
                                groupedNotis() {
                                    const groups = {};
                                    this.list.forEach(item => {
                                        const fullDate = item.CDATETIME.split(' ')[0];
                                        if (!groups[fullDate]) groups[fullDate] = [];
                                        groups[fullDate].push(item);
                                    });
                                    return groups;
                                },
                                totalPages() {
                                    return Math.ceil(this.totalCount / this.pageSize);
                                }
                            },
                            methods: {
                                fnList(page) {
                                    let self = this;
                                    if (page) self.currentPage = page;

                                    $.ajax({
                                        url: "/notification/list.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {
                                            currentPage: self.currentPage,
                                            pageSize: self.pageSize
                                        },
                                        success: function (data) {
                                            if (data.result === "success") {
                                                self.list = data.list;
                                                self.totalCount = data.totalCount;
                                            }
                                        }
                                    });
                                },
                                fnRead(item) {
                                    let self = this;

                                    $.ajax({
                                        url: "/notification/read.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { notiNo: item.NOTI_NO },
                                        success: function () {

                                            // ✅ CHAT이면: 페이지 이동 X, 팝업으로 열기
                                            if (item.TYPE === "CHAT") {
                                                const url = item.LINK_URL || "/chat.do";
                                                window.open(url, "chatPopup", "width=520,height=720,resizable=yes,scrollbars=yes");
                                                return;
                                            }

                                            if (item.LINK_URL) location.href = item.LINK_URL;
                                            else self.fnList();
                                        }
                                    });
                                },
                                openChatFromNoti(item) {
                                    // 1) link_url에서 roomId/productNo/sellerId/buyerId/pName 뽑기(있으면)
                                    const parsed = this.parseLink(item.LINK_URL);

                                    // 2) chat.do로 넘길 파라미터 구성
                                    const params = new URLSearchParams();

                                    if (parsed.roomId) params.set("roomId", parsed.roomId);
                                    if (parsed.productNo) params.set("productNo", parsed.productNo);
                                    if (parsed.sellerId) params.set("sellerId", parsed.sellerId);
                                    if (parsed.buyerId) params.set("buyerId", parsed.buyerId);
                                    if (parsed.pName) params.set("pName", parsed.pName);

                                    // 👉 roomId만 있더라도 OK (채팅창에서 pName을 조회하게 만들면 됨)
                                    const url = "/chat.do?" + params.toString();

                                    window.open(url, "chatPopup", "width=520,height=720,resizable=yes,scrollbars=yes");
                                },
                                parseLink(linkUrl) {
                                    if (!linkUrl) return {};
                                    try {
                                        const url = new URL(linkUrl, location.origin);
                                        return {
                                            roomId: url.searchParams.get("roomId"),
                                            productNo: url.searchParams.get("productNo"),
                                            sellerId: url.searchParams.get("sellerId"),
                                            buyerId: url.searchParams.get("buyerId"),
                                            pName: url.searchParams.get("pName")
                                        };
                                    } catch (e) {
                                        // 상대경로 대응
                                        const get = (k) => {
                                            const m = linkUrl.match(new RegExp(`[?&]${k}=([^&]+)`));
                                            return m ? decodeURIComponent(m[1]) : null;
                                        };
                                        return {
                                            roomId: get("roomId"),
                                            productNo: get("productNo"),
                                            sellerId: get("sellerId"),
                                            buyerId: get("buyerId"),
                                            pName: get("pName")
                                        };
                                    }
                                },

                                extractRoomId(linkUrl) {
                                    if (!linkUrl) return null;
                                    try {
                                        const url = new URL(linkUrl, location.origin);
                                        return url.searchParams.get("roomId");
                                    } catch (e) {
                                        // linkUrl이 상대경로일 때도 처리
                                        const m = linkUrl.match(/roomId=([^&]+)/);
                                        return m ? m[1] : null;
                                    }
                                },

                                getIcon(type) {
                                    const icons = { 'ORDER': '📦', 'CHAT': '💬', 'NOTICE': '🔔', 'MARKETING': '🎁' };
                                    return icons[type] || '📌';
                                },
                                getTitle(type) {
                                    const titles = { 'ORDER': '주문 소식', 'CHAT': '채팅 메시지', 'NOTICE': '시스템 알림', 'MARKETING': '이벤트 소식' };
                                    return titles[type] || '알림';
                                },
                                fnRemove(notiNo) {
                                    if (!confirm("이 알림을 삭제하시겠습니까?")) return;
                                    let self = this;
                                    $.ajax({
                                        url: "/notification/remove.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: { notiNo: notiNo },
                                        success: function (data) {
                                            if (data.result === "success") {
                                                self.fnList(); // 목록 새로고침
                                            }
                                        }
                                    });
                                },
                                fnRemoveRead() {
                                    if (!confirm("읽은 알림을 모두 삭제하시겠습니까?")) return;
                                    let self = this;
                                    $.ajax({
                                        url: "/notification/removeRead.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success: function (data) {
                                            if (data.result === "success") {
                                                self.fnList(); // 목록 새로고침
                                            }
                                        }
                                    });
                                },

                                formatNotiTime(ts) {
                                    if (!ts) return "";

                                    // "YYYY-MM-DD HH:mm"
                                    if (typeof ts === "string") {
                                        const [datePart, timePart] = ts.split(" ");
                                        if (!datePart || !timePart) return ts;

                                        const [y, m, d] = datePart.split("-").map(Number);
                                        const [hh, mm] = timePart.split(":").map(Number);

                                        // ts가 UTC처럼 들어온다고 가정하고 +9시간 보정
                                        const kst = new Date(Date.UTC(y, m - 1, d, hh, mm, 0));
                                        kst.setHours(kst.getHours());

                                        return kst.toLocaleTimeString("ko-KR", {
                                            timeZone: "Asia/Seoul",
                                            hour: "2-digit",
                                            minute: "2-digit",
                                            hour12: false
                                        });
                                    }

                                    // Date/number fallback
                                    const d = new Date(ts);
                                    if (isNaN(d.getTime())) return "";
                                    return d.toLocaleTimeString("ko-KR", {
                                        timeZone: "Asia/Seoul",
                                        hour: "2-digit",
                                        minute: "2-digit",
                                        hour12: false
                                    });
                                },
                                fnReadAll() {
                                    if (!confirm("모든 알림을 읽음 처리하시겠습니까?")) return;
                                    let self = this;
                                    $.ajax({
                                        url: "/notification/read.dox",
                                        type: "POST",
                                        dataType: "json",
                                        data: {}, 
                                        success: function (data) {
                                            alert("모든 알림이 읽음 처리되었습니다.");
                                            self.fnList(); 
                                            $("#notiBadge").hide().text("0");
                                        }
                                    });
                                }
                            },
                            mounted() {
                                if (!this.userId) {
                                    alert("로그인이 필요한 페이지입니다.");
                                    location.href = "/login.do";
                                    return;
                                }
                                this.fnList();
                            }
                        });
                        app.mount('#app');
                    </script>
        </body>

        </html>