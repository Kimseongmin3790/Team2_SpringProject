<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가까운 판매자 | AGRICOLA</title>

    <!-- ✅ 외부 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=여기에 자바스크립트키 입력&libraries=services"></script>

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
            max-width: 1000px;
            margin: 40px auto;
            font-family: "Noto Sans KR", sans-serif;
        }

        .section {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        h1 {
            color: #1a5d1a;
            text-align: center;
            margin-bottom: 25px;
        }

        h2 {
            color: #1a5d1a;
            margin-bottom: 15px;
        }

        #map {
            width: 100%;
            height: 400px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .seller-list {
            margin-top: 20px;
        }

        .seller-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
            transition: 0.2s;
        }

        .seller-card:hover {
            background: #f8f8f8;
            cursor: pointer;
        }

        .distance {
            color: #555;
            font-size: 14px;
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <div id="app">
        <main class="content">
            <h1>가까운 판매자</h1>

            <div class="section">
                <h2>📍 내 위치 기준 가까운 판매자 3곳</h2>
                <button @click="fnFindNearest" style="background:#5dbb63;color:white;border:none;padding:8px 16px;border-radius:6px;cursor:pointer;">판매자 조회</button>

                <div id="map"></div>

                <div class="seller-list" v-if="sellers.length > 0">
                    <div class="seller-card" v-for="s in sellers" @click="fnFocusMarker(s)">
                        <strong>{{ s.businessName }}</strong>
                        <div class="distance">거리: {{ s.distance.toFixed(2) }} km</div>
                    </div>
                </div>
                <p v-else style="margin-top:15px;">주변 판매자 정보를 불러오세요 🚜</p>
            </div>
        </main>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            sessionId: "${sessionId}",
            sessionLat: parseFloat("${sessionLat}"),
            sessionLng: parseFloat("${sessionLng}"),
            sellers: [],
            map: null,
            markers: []
        };
    },
    methods: {
        // ✅ 지도 초기화
        fnInitMap(lat, lng) {
            const container = document.getElementById("map");
            const options = { center: new kakao.maps.LatLng(lat, lng), level: 6 };
            this.map = new kakao.maps.Map(container, options);

            // 내 위치 마커 표시
            const myMarker = new kakao.maps.Marker({
                map: this.map,
                position: new kakao.maps.LatLng(lat, lng),
                title: "내 위치"
            });
        },

        // ✅ 가까운 판매자 조회
        fnFindNearest() {
            const self = this;
            if (!self.sessionLat || !self.sessionLng) {
                alert("위치 정보가 없습니다. 다시 로그인해주세요.");
                return;
            }

            self.fnInitMap(self.sessionLat, self.sessionLng);

            $.ajax({
                url: "/nearestSellers.dox",
                type: "POST",
                dataType: "json",
                data: {
                    userLat: self.sessionLat,
                    userLng: self.sessionLng
                },
                success: function (res) {
                    if (res.list && res.list.length > 0) {
                        self.sellers = res.list;
                        self.fnDrawMarkers();
                    } else {
                        alert("주변 판매자를 찾을 수 없습니다.");
                    }
                },
                error: function (xhr, status, err) {
                    console.error("에러:", err);
                }
            });
        },

        // ✅ 판매자 마커 표시
        fnDrawMarkers() {
            const self = this;
            self.markers.forEach(m => m.setMap(null));
            self.markers = [];

            self.sellers.forEach((s, idx) => {
                const pos = new kakao.maps.LatLng(s.lat, s.lng);
                const marker = new kakao.maps.Marker({
                    position: pos,
                    map: self.map
                });

                const info = new kakao.maps.InfoWindow({
                    content: `<div style="padding:5px;">${s.businessName}<br>${s.distance.toFixed(2)} km</div>`
                });

                kakao.maps.event.addListener(marker, 'click', function () {
                    info.open(self.map, marker);
                });

                self.markers.push(marker);
            });
        },

        // ✅ 판매자 리스트 클릭 시 해당 마커로 이동
        fnFocusMarker(seller) {
            const move = new kakao.maps.LatLng(seller.lat, seller.lng);
            this.map.panTo(move);
        }
    },
    mounted() {        
        // 페이지 로드 시 지도 먼저 표시
        if (this.sessionLat && this.sessionLng) {
            this.fnInitMap(this.sessionLat, this.sessionLng);
        }
    }
});

app.mount('#app');
</script>
