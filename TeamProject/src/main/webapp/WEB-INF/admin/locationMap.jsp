<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AGRICOLA 지역 기반 매장검색</title>

  <!-- ✅ 외부 라이브러리 -->
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=78c3fbd5be4327cf3319a04cf0a379c4&libraries=services"></script>

  <!-- ✅ 간단한 스타일 -->
  <style>
    body { margin: 0; font-family: 'Noto Sans KR', sans-serif; }
    #app { display: flex; flex-direction: column; align-items: center; padding: 20px; }
    #map { width: 100%; max-width: 900px; height: 450px; border-radius: 10px; }
    .filter-box { display: flex; gap: 10px; margin-bottom: 10px; }
    .store-list { width: 100%; max-width: 900px; margin-top: 15px; border-collapse: collapse; }
    .store-list th, .store-list td {
      border: 1px solid #ddd;
      padding: 8px 10px;
      text-align: center;
    }
    .store-list th { background-color: #f3ebd3; color: #1a5d1a; }
    .store-list tr:hover { background-color: #f7f7f7; cursor: pointer; }
  </style>
</head>

<body>
<div id="app">
  <h2 style="color:#1a5d1a;">📍 지역 기반 농가 매장 검색</h2>

  <!-- ✅ 지역 / 거리 필터 -->
  <div class="filter-box">
    <select v-model="selectedRegion" @change="fnMoveRegion">
      <option value="">지역 선택</option>
      <option v-for="region in regionList" :value="region">{{ region }}</option>
    </select>
    <select v-model="distanceFilter" @change="fnFilterByDistance">
      <option value="">거리 필터</option>
      <option value="5">5km 이내</option>
      <option value="10">10km 이내</option>
      <option value="20">20km 이내</option>
    </select>
    <button @click="fnSortByDistance">거리순 정렬</button>
  </div>

  <!-- ✅ 지도 -->
  <div id="map"></div>

  <!-- ✅ 매장 리스트 -->
  <table class="store-list" v-if="filteredStores.length > 0">
    <thead>
      <tr><th>매장명</th><th>주소</th><th>거리(km)</th></tr>
    </thead>
    <tbody>
      <tr v-for="store in filteredStores" @click="fnFocusMarker(store)">
        <td>{{ store.name }}</td>
        <td>{{ store.addr }}</td>
        <td>{{ store.distance.toFixed(2) }}</td>
      </tr>
    </tbody>
  </table>
  <div v-else style="margin-top:20px; color:#666;">검색된 매장이 없습니다.</div>
</div>

<script>
const app = Vue.createApp({
  data() {
    return {
      map: null,
      userMarker: null,
      userPos: null,
      markers: [],
      geocoder: null,
      selectedRegion: "",
      distanceFilter: "",
      regionList: ["서울 강남구", "서울 종로구", "부산 해운대구", "대전 중구"],
      stores: [
        { name: "강남농가", lat: 37.498, lng: 127.028, addr: "서울 강남구 테헤란로 123" },
        { name: "종로한우", lat: 37.573, lng: 126.978, addr: "서울 종로구 세종로 50" },
        { name: "부산수산", lat: 35.160, lng: 129.162, addr: "부산 해운대구 우동 123" },
        { name: "대전청과", lat: 36.327, lng: 127.423, addr: "대전 중구 문화동 45" },
      ],
      filteredStores: [],
    };
  },
  methods: {
    // ✅ 1. 지도 초기화
    fnInitMap() {
      const container = document.getElementById("map");
      const options = { center: new kakao.maps.LatLng(37.5665, 126.9780), level: 5 };
      this.map = new kakao.maps.Map(container, options);
      this.geocoder = new kakao.maps.services.Geocoder();

      // ✅ 사용자 위치 표시
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pos => {
          const lat = pos.coords.latitude;
          const lng = pos.coords.longitude;
          this.userPos = new kakao.maps.LatLng(lat, lng);
          this.map.setCenter(this.userPos);

          this.userMarker = new kakao.maps.Marker({
            position: this.userPos,
            map: this.map,
            title: "현재 위치"
          });

          this.fnDrawMarkers();
        });
      } else {
        alert("현재 위치를 불러올 수 없습니다.");
        this.fnDrawMarkers();
      }
    },

    // ✅ 2. 매장 마커 표시
    fnDrawMarkers() {
      // 기존 마커 제거
      this.markers.forEach(m => m.setMap(null));
      this.markers = [];

      this.stores.forEach(store => {
        const marker = new kakao.maps.Marker({
          map: this.map,
          position: new kakao.maps.LatLng(store.lat, store.lng),
          title: store.name
        });

        const infowindow = new kakao.maps.InfoWindow({
          content: `<div style="padding:5px;">${store.name}<br>${store.addr}</div>`
        });

        kakao.maps.event.addListener(marker, 'click', () => {
          infowindow.open(this.map, marker);
        });

        this.markers.push(marker);
      });

      this.fnCalculateDistances();
    },

    // ✅ 3. 거리 계산 (Haversine)
    fnCalculateDistances() {
      if (!this.userPos) return;
      const userLat = this.userPos.getLat();
      const userLng = this.userPos.getLng();

      this.stores.forEach(s => {
        s.distance = this.fnGetDistance(userLat, userLng, s.lat, s.lng);
      });
      this.filteredStores = [...this.stores];
    },

    fnGetDistance(lat1, lon1, lat2, lon2) {
      const R = 6371; // km
      const dLat = (lat2 - lat1) * Math.PI / 180;
      const dLon = (lon2 - lon1) * Math.PI / 180;
      const a = Math.sin(dLat/2)**2 +
        Math.cos(lat1 * Math.PI/180) * Math.cos(lat2 * Math.PI/180) *
        Math.sin(dLon/2)**2;
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c;
    },

    // ✅ 4. 지역 이동
    fnMoveRegion() {
      if (!this.selectedRegion) return;
      this.geocoder.addressSearch(this.selectedRegion, (result, status) => {
        if (status === kakao.maps.services.Status.OK) {
          const center = new kakao.maps.LatLng(result[0].y, result[0].x);
          this.map.setCenter(center);
        }
      });
    },

    // ✅ 5. 거리 필터
    fnFilterByDistance() {
      if (!this.distanceFilter) {
        this.filteredStores = [...this.stores];
        return;
      }
      const limit = parseFloat(this.distanceFilter);
      this.filteredStores = this.stores.filter(s => s.distance <= limit);
    },

    // ✅ 6. 거리순 정렬
    fnSortByDistance() {
      this.filteredStores.sort((a, b) => a.distance - b.distance);
    },

    // ✅ 7. 리스트 클릭 시 해당 마커 포커스
    fnFocusMarker(store) {
      const moveLatLon = new kakao.maps.LatLng(store.lat, store.lng);
      this.map.panTo(moveLatLon);
    },
  },
  mounted() {
    this.fnInitMap();
  }
});

app.mount("#app");
</script>
</body>
</html>
