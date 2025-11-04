<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>AGRICOLA 메인</title>

      <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
      <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
      <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=78c3fbd5be4327cf3319a04cf0a379c4&libraries=services"></script>

      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

      <style>
        #app {
          min-height: 100vh;
          display: flex;
          flex-direction: column;
        }

        .content {
          flex: 1;
          background: #faf8f0;
          padding-bottom: 80px;
        }

        /* 🌿 슬라이더 (이전 코드 그대로 유지) */
        .main-slider {
          width: 100%;
          max-width: 1200px;
          margin: 0 auto;
          position: relative;
          overflow: hidden;
          border-radius: 12px;
          background: #f7fff7;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .slider-track {
          display: flex;
          transition: transform 0.6s ease-in-out;
        }

        .slider-item {
          flex-shrink: 0;
          width: 100%;
          position: relative;
        }

        .slider-item img {
          width: 100%;
          height: 400px;
          object-fit: cover;
          display: block;
        }

        .slider-caption {
          position: absolute;
          bottom: 15px;
          left: 50%;
          transform: translateX(-50%);
          background: rgba(0, 0, 0, 0.5);
          color: #fff;
          padding: 8px 15px;
          border-radius: 6px;
          font-size: 1rem;
        }

        .slider-arrow {
          position: absolute;
          top: 50%;
          transform: translateY(-50%);
          border: none;
          border-radius: 50%;
          background: rgba(0, 0, 0, 0.3);
          color: #fff;
          width: 40px;
          height: 40px;
          cursor: pointer;
          font-size: 20px;
          z-index: 5;
          transition: background 0.3s;
        }

        .slider-arrow:hover {
          background: rgba(0, 0, 0, 0.6);
        }

        .arrow-prev {
          left: 15px;
        }

        .arrow-next {
          right: 15px;
        }

        .slider-dots {
          position: absolute;
          bottom: 12px;
          left: 50%;
          transform: translateX(-50%);
          display: flex;
          gap: 8px;
          z-index: 10;
        }

        .slider-dot {
          width: 10px;
          height: 10px;
          border-radius: 50%;
          background: rgba(255, 255, 255, 0.6);
          cursor: pointer;
          transition: background 0.3s;
        }

        .slider-dot.active {
          background: #4caf50;
        }

        /* 🌱 섹션 공통 */
        section.main-section {
          max-width: 1200px;
          margin: 80px auto 0;
          text-align: center;
          padding: 0 20px;
        }

        .main-section h2 {
          font-size: 1.8rem;
          font-weight: 700;
          color: #1a5d1a;
          margin-bottom: 20px;
        }

        .main-section p.section-desc {
          color: #666;
          font-size: 1rem;
          margin-bottom: 40px;
        }

        /* 🌾 상품 카드 */
        .product-grid {
          display: flex;
          flex-wrap: wrap;
          justify-content: center;
          gap: 25px;
        }

        .product-card {
          background: #fff;
          border: 1px solid #eee;
          border-radius: 10px;
          width: 250px;
          overflow: hidden;
          transition: transform 0.3s;
          cursor: pointer;
        }

        .product-card:hover {
          transform: translateY(-4px);
        }

        .product-card img {
          width: 100%;
          height: 200px;
          object-fit: cover;
          display: block;
        }

        .product-info {
          padding: 12px;
          text-align: left;
        }

        .product-info h4 {
          font-size: 1rem;
          margin: 0 0 5px;
          color: #333;
          font-weight: 600;
        }

        .product-info p {
          font-size: 0.9rem;
          color: #777;
          margin: 0 0 8px;
        }

        .product-price {
          font-weight: bold;
          color: #388e3c;
        }

        /* 🧑‍🌾 입점업체 */
        .producer-list {
          display: flex;
          flex-wrap: nowrap;
          /* ✅ 줄바꿈 금지 */
          overflow-x: auto;
          /* ✅ 가로 스크롤 활성화 */
          gap: 40px;
          padding: 10px 0;
          scroll-behavior: smooth;
          /* ✅ 부드러운 스크롤 */
          scroll-snap-type: x mandatory;
          /* ✅ 스냅 효과 */
        }

        .producer-list::-webkit-scrollbar {
          height: 8px;
          /* 스크롤바 높이 */
        }

        .producer-list::-webkit-scrollbar-thumb {
          background: #c8e6c9;
          /* 연한 초록색 스크롤바 */
          border-radius: 4px;
        }

        .producer-list::-webkit-scrollbar-thumb:hover {
          background: #81c784;
        }

        .producer-card {
          flex: 0 0 auto;
          /* ✅ 카드 너비 고정 (스크롤용) */
          width: 180px;
          text-align: center;
          scroll-snap-align: start;
          /* ✅ 카드 기준으로 스냅 */
          cursor: pointer;
          transition: transform 0.3s;
        }

        .producer-card:hover {
          transform: translateY(-3px);
        }

        .producer-logo {
          width: 100px;
          height: 100px;
          margin: 0 auto 10px;
          border-radius: 50%;
          background-size: cover;
          background-position: center;
          border: 1px solid #ddd;
        }

        /* 🔝 맨위/맨아래 리모컨 */
        .quick-remote {
          position: fixed;
          right: 20px;
          bottom: 20px;
          display: flex;
          flex-direction: column;
          gap: 10px;
          z-index: 1000;
        }

        .quick-remote button {
          width: 60px;
          height: 60px;
          background: #4caf50;
          color: #fff;
          border: none;
          border-radius: 10px;
          font-size: 13px;
          line-height: 1.3;
          cursor: pointer;
          transition: background 0.3s;
        }

        .quick-remote button:hover {
          background: #2e7d32;
        }

        @media (max-width: 768px) {
          .slider-item img {
            height: 250px;
          }

          .product-card {
            width: 45%;
          }
        }

        .section-header {
          position: relative;
          display: flex;
          align-items: center;
          justify-content: flex-end;
          /* 버튼만 오른쪽으로 정렬 */
          margin-bottom: 15px;
        }

        /* 제목만 중앙 배치 */
        .section-header h2 {
          position: absolute;
          left: 50%;
          transform: translateX(-50%);
          margin: 0;
          font-size: 1.8rem;
          font-weight: 700;
          color: #1a5d1a;
          text-align: center;
          white-space: nowrap;
        }

        .btn-more {
          background-color: #5dbb63;
          color: white;
          border: none;
          border-radius: 20px;
          padding: 6px 14px;
          font-size: 14px;
          cursor: pointer;
          transition: 0.3s;
        }

        .btn-more:hover {
          background-color: #4ba954;
        }

        .btn-map-detail {
          margin-top: 5px;
          padding: 5px 10px;
          border: none;
          background: #5dbb63;
          color: white;
          border-radius: 6px;
          cursor: pointer;
          font-size: 12px;
          transition: background 0.3s;
        }

        .btn-map-detail:hover {
          background: #4ba954;
        }
      </style>
    </head>

    <body>
      <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <div id="app">
          <main class="content">
            <!-- 🌿 슬라이더 -->
            <section class="main-slider">
              <div v-if="loading" style="text-align:center; line-height:400px;">배너 로딩 중...</div>
              <div v-else-if="error" style="text-align:center; line-height:400px; color:red;">{{ error }}</div>

              <div v-show="!loading && !error" @mousedown="startDrag" @mousemove="dragging" @mouseup="endDrag"
                @mouseleave="endDrag" @touchstart="startDrag" @touchmove="dragging" @touchend="endDrag">
                <div class="slider-track" ref="track">
                  <a v-for="(banner, i) in banners" :key="i" class="slider-item" :href="banner.linkUrl || '#'"
                    @click.prevent="openBanner(banner)">
                    <img :src="fullUrl(banner.imageUrl)" :alt="banner.title || '배너'+i" draggable="false">
                    <div class="slider-caption" v-if="banner.title">{{ banner.title }}</div>
                  </a>
                </div>
                <button v-if="banners.length>1" class="slider-arrow arrow-prev" @click="prev">‹</button>
                <button v-if="banners.length>1" class="slider-arrow arrow-next" @click="next">›</button>
                <div v-if="banners.length>1" class="slider-dots">
                  <div v-for="(d,idx) in banners.length" :key="idx" :class="['slider-dot',{active:idx===index}]"
                    @click="go(idx)"></div>
                </div>
              </div>
            </section>

            <!-- 🧑‍🌾 입점업체 -->
            <section class="main-section">
              <h2>내 주변 농부</h2>
              <p class="section-desc">가장 가까운 생산자를 찾아보세요. ※ 위치 권한 없으면 기본으로 서울시청으로 지정됩니다</p>
              <div id="map" style="width:100%;height:400px;border-radius:12px;margin-bottom:40px;"></div>

              <div class="producer-list">
                <div class="producer-card" v-for="p in producers" :key="p.userId" @click="goSeller(p.userId)">
                  <div class="producer-logo" :style="{ backgroundImage: 'url(' + p.profileImg + ')' }"></div>
                  <strong>{{ p.businessName }}</strong>
                  <p>{{ p.addrDo }} {{ p.addrCity }}</p>
                  <p v-if="p.distance">📍 {{ p.distance }}km</p>
                </div>
              </div>
            </section>

            <!-- 🌾 추천 섹션 -->
            <section class="main-section">
              <div class="section-header">
                <h2>AGRICOLA 추천 상품</h2>
                <button class="btn-more" @click="fnGoRecommendList">＋</button>
              </div>
              <p class="section-desc">아그리콜라가 엄선한 인기 상품을 만나보세요.</p>

              <div class="product-grid">
                <div class="product-card" v-for="p in recommend" :key="p.productNo">
                  <img :src="p.imageUrl" alt="">
                  <div class="product-info">
                    <h4>{{ p.pname }}</h4>
                    <p>{{ p.pinfo }}</p>
                    <span class="product-price">{{ p.price.toLocaleString() }}원</span>
                  </div>
                </div>
              </div>
            </section>

            <!-- 🆕 신상품 -->
            <section class="main-section">
              <div class="section-header">
                <h2>AGRICOLA 신상품</h2>
                <button class="btn-more" @click="fnGoNewList">＋</button>
              </div>
              <p class="section-desc">지금 막 수확된 신선한 농산물을 만나보세요.</p>

              <div class="product-grid">
                <div class="product-card" v-for="p in newProducts" :key="p.productNo">
                  <img :src="p.imageUrl" alt="">
                  <div class="product-info">
                    <h4>{{ p.pname }}</h4>
                    <p>{{ p.pinfo }}</p>
                    <span class="product-price">{{ p.price.toLocaleString() }}원</span>
                  </div>
                </div>
              </div>
            </section>

            <!-- 🔝 맨위/아래 리모컨 -->
            <div class="quick-remote">
              <button @click="scrollTop">🔝<br>맨 위로</button>
              <button @click="scrollBottom">⬇️<br>맨 아래로</button>
            </div>
          </main>
        </div>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>

          <script>
            const app = Vue.createApp({
              data() {
                return {
                  path: "${pageContext.request.contextPath}",
                  banners: [],
                  best: [],
                  recommend: [],
                  newProducts: [],
                  producers: [],
                  loading: true,
                  error: null,
                  index: 0,
                  auto: null,
                  dragging: false,
                  startX: 0,
                  deltaX: 0,
                  width: 0,
                  topFarmers: []
                };
              },
              methods: {
                fullUrl(u) {
                  if (!u) return "";
                  if (/^https?:\/\//i.test(u)) return u;
                  return this.path + (u.startsWith("/") ? u : "/" + u);
                },

                /* ------------ AJAX ------------ */
                loadAll() {
                  this.loadBanners();
                  this.loadRecommend();
                  this.loadNew();
                  this.loadProducers();
                },

                loadBanners() {
                  const self = this;
                  $.ajax({
                    url: self.path + "/main/data/banners",
                    type: "GET",
                    dataType: "json",
                    success(res) {
                      self.banners = Array.isArray(res) ? res : [];
                      self.$nextTick(() => { self.measure(); self.move(0, false); self.startAuto(); });
                    },
                    error() { self.error = "배너 로딩 실패"; }, complete() { self.loading = false; }
                  });
                },

                loadRecommend() {
                  const self = this;
                  $.ajax({
                    url: "/main/data/recommend.dox",  // ✅ 실제 호출 URL
                    type: "POST",                                 // dox → POST
                    dataType: "json",
                    success(res) {
                      self.recommend = res.list;                  // ✅ 백엔드에서 list로 리턴
                    },
                    error(xhr, status, err) {
                      console.error("추천 상품 로드 실패:", err);
                    }
                  });
                },

                loadNew() {
                  const self = this;
                  $.ajax({
                    url: "/main/data/newList.dox",  // ✅ 신상품 데이터 요청 경로
                    type: "POST",
                    dataType: "json",
                    success(res) {
                      self.newProducts = res.list || [];       // ✅ 응답의 list 배열로 세팅
                    },
                    error(xhr, status, err) {
                      console.error("신상품 로드 실패:", err);
                    }
                  });
                },

                loadProducers() {
                  const self = this;

                  // ✅ 1. 로그인 여부 및 위치 정보 확인
                  $.ajax({
                    url: "/main/data/userLocation.dox",
                    type: "POST",
                    dataType: "json",
                    success(res) {
                      if (res.login && res.lat && res.lng) {
                        console.log("✅ 로그인 사용자 위치 사용:", res.lat, res.lng);
                        self.fnLoadProducerList(res.lat, res.lng);
                      } else {
                        console.log("⚠️ 비로그인 또는 위치 정보 없음 → 브라우저 위치 사용");
                        self.loadLocationFromBrowser();
                      }
                    },
                    error() {
                      console.warn("❌ 사용자 위치 불러오기 실패, 브라우저 위치로 대체");
                      self.loadLocationFromBrowser();
                    }
                  });
                },

                // ✅ 2. 비로그인 시 브라우저 위치
                loadLocationFromBrowser() {
                  const self = this;
                  if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                      (pos) => {
                        self.fnLoadProducerList(pos.coords.latitude, pos.coords.longitude);
                      },
                      (err) => {
                        console.warn("⚠️ 위치 접근 실패:", err.message);
                        // 기본 서울 좌표
                        self.fnLoadProducerList(37.5665, 126.9780);
                      }
                    );
                  } else {
                    console.warn("❌ 위치정보 지원 안 함");
                    self.fnLoadProducerList(37.5665, 126.9780);
                  }
                },

                fnLoadProducerList(lat, lng) {
                  const self = this;
                  $.ajax({
                    url: "/main/data/sellerList.dox",
                    type: "POST",
                    data: { lat, lng },
                    dataType: "json",
                    success(res) {
                      console.log("✅ 생산자 목록:", res);
                      self.producers = res.list || [];
                      self.$nextTick(() => {
                        self.showMap(lat, lng, self.producers);
                      });
                    },
                    error(xhr, status, err) {
                      console.error("❌ 생산자 목록 로드 실패:", err);
                    }
                  });
                },

                showMap(lat, lng, list) {
                  const container = document.getElementById("map");
                  const map = new kakao.maps.Map(container, {
                    center: new kakao.maps.LatLng(lat, lng),
                    level: 6
                  });

                  // ✅ 내 위치 마커
                  const userMarker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(lat, lng),
                    map: map
                  });
                  const userInfo = new kakao.maps.InfoWindow({
                    content: "<div style='padding:5px;'>내 위치</div>"
                  });
                  userInfo.open(map, userMarker);

                  // ✅ 판매자 마커 표시
                  list.forEach((p) => {
                    if (!p.lat || !p.lng) return;

                    const pos = new kakao.maps.LatLng(p.lat, p.lng);
                    const marker = new kakao.maps.Marker({ position: pos, map: map });

                    // 거리값 처리
                    const distanceText =
                      typeof p.distance === "number" && !isNaN(p.distance)
                        ? p.distance.toFixed(1) + "km"
                        : "거리 정보 없음";

                    // ✅ InfoWindow HTML (문자열 연결 방식)
                    const html =
                      "<div style='padding:10px;width:180px;line-height:1.5;font-size:13px;'>" +
                      "<strong style='font-size:14px;color:#1a5d1a;'>" +
                      (p.businessName || "이름 없음") +
                      "</strong><br>" +
                      (p.addrDo || "") +
                      " " +
                      (p.addrCity || "") +
                      "<br>📍 " +
                      distanceText +
                      "<br>" +
                      // ✅ 상세 페이지 버튼 추가
                      "<button class='btn-map-detail' onclick=\"location.href='/seller/detail.do?sellerId=" + p.userId + "'\">상세보기</button>" +
                      "</div>";

                    const info = new kakao.maps.InfoWindow({ content: html });

                    kakao.maps.event.addListener(marker, "click", function () {
                      info.open(map, marker);
                    });
                  });
                },

                goSeller(userId) {
                  location.href = "/seller/detail.do?sellerId=" + userId;
                },

                /* ------------ 슬라이드 ------------ */
                measure() {
                  const track = this.$refs.track; if (!track) return;
                  const container = track.parentElement;
                  this.width = container ? container.clientWidth : window.innerWidth;
                  track.style.width = (this.width * this.banners.length) + "px";
                  for (let s of track.children) { s.style.width = this.width + "px"; }
                },

                move(i, smooth = true) {
                  if (!this.banners.length) return;
                  const max = this.banners.length - 1;
                  if (i < 0) i = max; if (i > max) i = 0;
                  this.index = i;
                  const track = this.$refs.track;
                  if (track) {
                    track.style.transition = smooth ? "transform 0.6s ease" : "none";
                    track.style.transform = 'translateX(-' + (i * this.width) + 'px)';
                  }
                },

                next() {
                  this.stopAuto();
                  this.move(this.index + 1, true);
                  this.startAuto();
                },

                prev() {
                  this.stopAuto();
                  this.move(this.index - 1, true);
                  this.startAuto();
                },

                go(i) {
                  this.stopAuto();
                  this.move(i, true);
                  this.startAuto();
                },

                startAuto() {
                  this.stopAuto();
                  if (this.banners.length > 1) {
                    this.auto = setInterval(() => this.move(this.index + 1, true), 4000);
                  }
                },

                stopAuto() {
                  if (this.auto) {
                    clearInterval(this.auto); this.auto = null;
                  }
                },

                startDrag(e) {
                  if (this.banners.length <= 1) return;
                  this.stopAuto();
                  this.dragging = true;
                  this.startX = e.touches ? e.touches[0].clientX : e.clientX;
                  this.deltaX = 0; const t = this.$refs.track;
                  if (t) t.style.transition = "none";
                },

                dragging(e) {
                  if (!this.dragging) return;
                  const x = e.touches ? e.touches[0].clientX : e.clientX;
                  this.deltaX = x - this.startX;
                  const t = this.$refs.track;
                  if (t) {
                    const offset = -(this.index * this.width) + this.deltaX;
                    t.style.transform = `translateX(${offset}px)`;
                  }
                },

                endDrag() {
                  if (!this.dragging) return;
                  this.dragging = false;
                  const t = this.width * 0.15;
                  if (this.deltaX < -t) this.index++;
                  else if (this.deltaX > t) this.index--;
                  this.deltaX = 0;
                  this.move(this.index, true);
                  this.startAuto();
                },

                openBanner(b) {
                  if (this.dragging) return;
                  if (b && b.linkUrl) location.href = b.linkUrl;
                },

                /* ------------ 스크롤 리모컨 ------------ */
                scrollTop() {
                  window.scrollTo({ top: 0, behavior: "smooth" });
                },

                scrollBottom() {
                  window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
                },

                fnGoRecommendList() {
                  location.href = this.path + "/product/recommendList.do";
                },

                fnGoNewList() {
                  location.href = this.path + "/product/newList.do";
                },

                fnGoTopSellerList() {
                  location.href = this.path + "/seller/topList.do"; // ✅ 더보기 페이지로 이동
                },
              },
              mounted() {
                this.loadAll();
                window.addEventListener("resize", this.measure);
              },
              unmounted() {
                this.stopAuto();
                window.removeEventListener("resize", this.measure);
              }
            });
            app.mount("#app");
          </script>
    </body>

    </html>