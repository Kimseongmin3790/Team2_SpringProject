<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 타임라인 - FRESH FARM</title>
    <!-- 라이브러리 (default.jsp 방식 준수) -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    
    <style>
        html, body { height: 100%; margin: 0; }
        #app { min-height: 100vh; display: flex; flex-direction: column; }
        
        .content { 
            flex: 1; 
            padding: 60px 20px; 
            background: #f9fafb; 
        }
        
        .noti-container { max-width: 800px; margin: 0 auto; }
        
        .noti-header { 
            background: white; 
            padding: 30px; 
            margin-bottom: 40px; 
            border-radius: 16px; 
            text-align: center; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
        }
        
        .noti-header h2 { font-size: 28px; color: #111; margin-bottom: 10px; font-weight: 700; }
        
        .date-label { 
            font-size: 15px; 
            font-weight: 700; 
            color: #5dbb63; 
            margin-bottom: 24px; 
            padding-left: 52px; 
            position: relative;
        }
        
        .timeline { position: relative; padding-left: 52px; margin-bottom: 50px; }
        
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.04); 
            cursor: pointer; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            border: 1px solid transparent;
        }
        
        .timeline-item:hover { 
            transform: translateY(-2px) translateX(5px); 
            box-shadow: 0 10px 25px rgba(0,0,0,0.08); 
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
        
        .timeline-header { display: flex; align-items: center; gap: 14px; margin-bottom: 10px; }
        
        .timeline-icon { 
            width: 40px; 
            height: 40px; 
            border-radius: 10px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 20px; 
        }
        
        .timeline-icon.ORDER { background: #eff6ff; }
        .timeline-icon.CHAT { background: #f5f3ff; }
        .timeline-icon.NOTICE { background: #fff7ed; }
        .timeline-icon.MARKETING { background: #fdf2f8; }
        
        .timeline-title { flex: 1; font-size: 17px; font-weight: 700; color: #1f2937; }
        .timeline-time { font-size: 13px; color: #9ca3af; }
        
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
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        
        .empty-state-icon { font-size: 50px; margin-bottom: 20px; opacity: 0.5; }

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
                </div>

                <div v-if="list.length > 0">
                    <div v-for="(items, date) in groupedNotis" :key="date">
                        <div class="date-label">{{ date }}</div>
                        <div class="timeline">
                            <div v-for="item in items" :key="item.NOTI_NO" 
                                 :class="['timeline-item', { unread: item.IS_READ === 'N' }]"
                                 @click="fnRead(item)">
                                <div class="timeline-dot"></div>
                                <div class="timeline-header">
                                    <div :class="['timeline-icon', item.TYPE]">
                                        {{ getIcon(item.TYPE) }}
                                    </div>
                                    <div class="timeline-title">{{ getTitle(item.TYPE) }}</div>
                                    <div class="timeline-time">{{ item.CDATETIME.split(' ')[1] }}</div>
                                </div>
                                <div class="timeline-message">{{ item.MESSAGE }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 페이징 UI -->
                    <div class="pagination" v-if="totalCount > pageSize">
                        <button @click="fnList(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                        <button v-for="n in totalPages" 
                                :key="n" 
                                @click="fnList(n)"
                                :class="{ active: currentPage === n }">
                            {{ n }}
                        </button>
                        <button @click="fnList(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
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
                // 날짜별 그룹화
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
                    if(page) self.currentPage = page;
                    
                    $.ajax({
                        url: "/notification/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: { 
                            currentPage: self.currentPage,
                            pageSize: self.pageSize
                        },
                        success: function(data) {
                            if(data.result === "success") {
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
                        success: function() {
                            if(item.LINK_URL) {
                                location.href = item.LINK_URL;
                            } else {
                                self.fnList();
                            }
                        }
                    });
                },
                getIcon(type) {
                    const icons = { 'ORDER': '📦', 'CHAT': '💬', 'NOTICE': '🔔', 'MARKETING': '🎁' };
                    return icons[type] || '📌';
                },
                getTitle(type) {
                    const titles = { 'ORDER': '주문 소식', 'CHAT': '채팅 메시지', 'NOTICE': '시스템 알림', 'MARKETING': '이벤트 소식' };
                    return titles[type] || '알림';
                }
            },
            mounted() {
                if(!this.userId) {
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