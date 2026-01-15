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

      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

      <style>
        #app {
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          min-height: auto !important;
        }

        .content {
          flex: 0 0 auto !important;
          background: #faf8f0;
          padding-bottom: 80px;
        }

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

        .producer-list {
          display: flex;
          flex-wrap: nowrap;
          overflow-x: auto;
          gap: 40px;
          padding: 10px 0;
          scroll-behavior: smooth;
          scroll-snap-type: x mandatory;
        }

        .producer-list::-webkit-scrollbar {
          height: 8px;
        }

        .producer-list::-webkit-scrollbar-thumb {
          background: #c8e6c9;
          border-radius: 4px;
        }

        .producer-list::-webkit-scrollbar-thumb:hover {
          background: #81c784;
        }

        .producer-card {
          flex: 0 0 auto;
          width: 180px;
          text-align: center;
          scroll-snap-align: start;
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
          margin-bottom: 15px;
        }

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

        .map-controls {
          display: flex;
          align-items: center;
          justify-content: flex-end;
          gap: 8px;
          margin: 6px 0 28px;
          padding: 6px 10px;
          border: 1px solid #e1f0e1;
          background: #f7fff7;
          border-radius: 10px;
        }

        .map-controls__title {
          margin-right: auto;
          color: #567;
          font-size: 13px;
        }

        .map-controls label {
          display: inline-flex;
          align-items: center;
          gap: 4px;
          font-size: 13px;
          color: #2e7d32;
          background: #e8f5e9;
          padding: 6px 10px;
          border-radius: 14px;
          cursor: pointer;
          user-select: none;
        }

        .map-controls input[type="radio"],
        .map-controls input[type="checkbox"] {
          accent-color: #5dbb63;
        }

        .map-controls .sep {
          width: 1px;
          height: 20px;
          background: #c8e6c9;
          margin: 0 4px;
        }

        .service-grid {
          display: flex;
          flex-wrap: wrap;
          gap: 20px;
          justify-content: center;
          margin-top: 20px;
        }

        .service-card {
          flex: 1 1 260px;
          max-width: 360px;
          background: #fff;
          border-radius: 12px;
          padding: 20px;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
          text-align: left;
        }

        .service-card h3 {
          margin: 0 0 10px;
          font-size: 1.2rem;
          color: #1a5d1a;
        }

        .service-card p {
          margin: 0 0 12px;
          font-size: 0.95rem;
          color: #555;
          line-height: 1.5;
        }

        .service-card .btn-more {
          margin-top: 4px;
        }
      </style>
    </head>

    <body>
      <%@ include file="/WEB-INF/views/common/header.jsp" %>

        <div id="app">
          <main class="content">
            <section class="main-slider">
              <div v-if="loading" style="text-align:center; line-height:400px;">배너 로딩 중...</div>
              <div v-else-if="error" style="text-align:center; line-height:400px; color:red;">{{ error }}</div>

              <div v-show="!loading && !error" @mousedown="startDrag" @mousemove="dragging" @mouseup="endDrag"
                @mouseleave="endDrag" @touchstart="startDrag" @touchmove="dragging" @touchend="endDrag">
                <div class="slider-track" ref="track">
                  <a v-for="(banner, i) in banners" :key="i" class="slider-item" :href="bannerHref(banner)"
                    @click.prevent="openBanner(banner, $event)">
                    <img :src="fullUrl(banner.imageUrl)" :alt="banner.title || '배너'+i" draggable="false">
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

            <section class="main-section">
              <h2>AGRICOLA 서비스</h2>
              <p class="section-desc">지역의 신선한 농산물을 다양한 방식으로 만나보세요.</p>

              <div class="service-grid">
                <!-- 지역별 특산물 배송 -->
                <div class="service-card">
                  <h3>지역별 특산물 배송</h3>
                  <p>
                    강원 감자, 제주 감귤, 광천 김 등
                    전국 산지의 특산품을 한 번에 받아보는 지역 박스입니다.
                  </p>
                  <button class="btn-more" @click="fnGoRegionalList">바로가기</button>
                </div>

                <!-- 농산물 정기배송 -->
                <div class="service-card">
                  <h3>농산물 정기배송</h3>
                  <p>
                    제철 채소·과일을 주기적으로 받아보는 구독 서비스입니다.
                    원하는 주기와 구성을 선택해 보세요.
                  </p>
                  <button class="btn-more" @click="fnGoSubscriptionList">바로가기</button>
                </div>

                <!-- 내 주변 판매자 -->
                <div class="service-card">
                  <h3>내 주변 판매자 찾기</h3>
                  <p>
                    내 주변 생산자들을 지도에서 확인하고
                    가까운 농가와 직접 거래해 보세요.
                  </p>
                  <button class="btn-more" @click="fnGoNearby">내 주변 보기</button>
                </div>
              </div>
            </section>

            <section class="main-section">
              <div class="section-header">
                <h2>지역별 특산물 배송</h2>
                <button class="btn-more" @click="fnGoRegionalList">＋</button>
              </div>
              <p class="section-desc">
                전국 산지의 특산품을 한 박스로 받아보는 서비스입니다.
              </p>

              <div class="product-grid">
                <div class="product-card" v-for="box in regionalSpecials" :key="box.regionId"
                  @click="goRegionalDetail(box.regionId)">
                  <img :src="fullUrl(box.imageUrl)" alt="">
                  <div class="product-info">
                    <h4>{{ box.regionName }} {{ box.title }}</h4>
                    <p>{{ box.description }}</p>
                    <span class="product-price">
                      {{ box.price.toLocaleString() }}원
                    </span>
                  </div>
                </div>
              </div>
            </section>

            <section class="main-section">
              <div class="section-header">
                <h2>농산물 정기배송</h2>
                <button class="btn-more" @click="fnGoSubscriptionList">＋</button>
              </div>
              <p class="section-desc">
                제철 농산물을 주기적으로 받는 구독 서비스입니다.
              </p>

              <div class="product-grid">
                <div class="product-card" v-for="plan in subscriptionPlans" :key="plan.planId"
                  @click="goSubscriptionDetail(plan.planId)">
                  <img :src="fullUrl(plan.imageUrl)" alt="">
                  <div class="product-info">
                    <h4>{{ plan.planName }}</h4>
                    <p>{{ plan.shortDesc }}</p>
                    <span class="product-price">
                      {{ plan.price.toLocaleString() }}원 / {{ formatPeriod(plan.periodType) }}
                    </span>
                  </div>
                </div>
              </div>
            </section>

            <section class="main-section">
              <div class="section-header">
                <h2>AGRICOLA 신상품</h2>
                <button class="btn-more" @click="fnGoNewList">＋</button>
              </div>
              <p class="section-desc">지금 막 수확된 신선한 농산물을 만나보세요.</p>

              <div class="product-grid">
                <div class="product-card" v-for="p in newProducts" :key="p.productNo" @click="goInfo(p.productNo)">
                  <img :src="p.imageUrl" alt="">
                  <div class="product-info">
                    <h4>{{ p.pname }}</h4>
                    <p>{{ p.pinfo }}</p>
                    <span class="product-price">{{ p.price.toLocaleString() }}원</span>
                  </div>
                </div>
              </div>
            </section>

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
                  sessionId: "${sessionId}",
                  userRole: "${sessionScope.sessionStatus}",
                  path: "${pageContext.request.contextPath}",

                  banners: [],
                  newProducts: [],

                  regionalSpecials: [],
                  subscriptionPlans: [],

                  loading: true,
                  error: null,
                  index: 0,
                  auto: null,
                  dragging: false,
                  startX: 0,
                  deltaX: 0,
                  width: 0,
                };
              },
              methods: {
                fullUrl(u) {
                  if (!u) return "";
                  if (/^https?:\/\//i.test(u)) return u;
                  return this.path + (u.startsWith("/") ? u : "/" + u);
                },

                bannerHref(b) {
                  const url = (b && b.linkUrl) ? b.linkUrl : '#';
                  return this.normalizeLink(url);
                },

                normalizeLink(url) {
                  if (!url) return '#';

                  // http(s)면 그대로
                  if (/^https?:\/\//i.test(url)) return url;

                  const base = this.path || ''; // 예: '/agricola'
                  if (!base) return url;

                  // url이 '/xxx' 형태면 base + url (중복 슬래시 제거)
                  if (url.startsWith('/')) {
                    return (base.endsWith('/') ? base.slice(0, -1) : base) + url;
                  }
                  // url이 'xxx' 형태면 base/xxx
                  return base.endsWith('/') ? (base + url) : (base + '/' + url);
                },

                loadAll() {
                  this.loadBanners();
                  this.loadRegionalSpecials();
                  this.loadSubscriptions();
                  this.loadNew();
                },

                loadRegionalSpecials() {
                  const self = this;
                  $.ajax({
                    url: "/main/data/regionalSpecials.dox",
                    type: "POST",
                    dataType: "json",
                    success(res) {
                      console.log(res);
                      self.regionalSpecials = res.list || [];
                    },
                    error(xhr, status, err) {
                      console.error("지역 특산물 로드 실패:", err);
                    }
                  });
                },

                loadSubscriptions() {
                  const self = this;
                  $.ajax({
                    url: "/main/data/subscriptionPlans.dox",
                    type: "POST",
                    dataType: "json",
                    success(res) {
                      self.subscriptionPlans = res.list || [];
                    },
                    error(xhr, status, err) {
                      console.error("정기배송 플랜 로드 실패:", err);
                    }
                  });
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

                loadNew() {
                  const self = this;
                  $.ajax({
                    url: "/main/data/newList.dox",
                    type: "POST",
                    dataType: "json",
                    success(res) {
                      self.newProducts = res.list || [];
                    },
                    error(xhr, status, err) {
                      console.error("신상품 로드 실패:", err);
                    }
                  });
                },

                goSeller(userId) {
                  this._saveMapState();
                  location.href = "/seller/detail.do?sellerId=" + userId;
                },

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
                  this._isDragging = false;
                  this._dragStartX = this._getX(e);
                  if (this.banners.length <= 1) return;
                  this.stopAuto();
                  this.dragging = true;
                  this.startX = e.touches ? e.touches[0].clientX : e.clientX;
                  this.deltaX = 0; const t = this.$refs.track;
                  if (t) t.style.transition = "none";
                },

                dragging(e) {
                  const dx = Math.abs(this._getX(e) - (this._dragStartX || 0));
                  if (dx > 6) this._isDragging = true;
                  if (!this.dragging) return;
                  const x = e.touches ? e.touches[0].clientX : e.clientX;
                  this.deltaX = x - this.startX;
                  const t = this.$refs.track;
                  if (t) {
                    const offset = -(this.index * this.width) + this.deltaX;
                    t.style.transform = `translateX(${offset}px)`;
                  }
                },

                _getX(e) {
                  return (e.touches && e.touches[0] ? e.touches[0].clientX : e.clientX) || 0;
                },

                endDrag() {
                  setTimeout(() => { this._isDragging = false; }, 0);
                  if (!this.dragging) return;
                  this.dragging = false;
                  const t = this.width * 0.15;
                  if (this.deltaX < -t) this.index++;
                  else if (this.deltaX > t) this.index--;
                  this.deltaX = 0;
                  this.move(this.index, true);
                  this.startAuto();
                },

                openBanner(banner, evt) {
                  if (this._isDragging) return; // 드래그 중이면 무시

                  const href = this.bannerHref(banner);
                  if (!href || href === '#') return;

                  window.location.href = href;
                },
                /* ------------ 스크롤 리모컨 ------------ */
                scrollTop() {
                  window.scrollTo({ top: 0, behavior: "smooth" });
                },

                scrollBottom() {
                  window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
                },

                fnGoNewList() {
                  location.href = this.path + "/product/newList.do";
                },

                fnGoTopSellerList() {
                  location.href = this.path + "/seller/topList.do";
                },

                goInfo(productNo) {
                  location.href = this.path + "/productInfo.do?productNo=" + productNo;
                },

                fnGoRegionalList() {
                  location.href = this.path + "/region/specialList.do";
                },

                fnGoSubscriptionList() {
                  location.href = this.path + "/subscription/list.do";
                },

                fnGoNearby() {
                  location.href = this.path + "/map/nearby.do";
                },

                goRegionalDetail(regionId) {
                  location.href = this.path + "/region/specialDetail.do?regionId=" + regionId;
                },

                goSubscriptionDetail(planId) {
                  location.href = this.path + "/subscription/detail.do?planId=" + planId;
                },

                formatPeriod(type) {
                  switch (type) {
                    case "WEEKLY": return "주 1회";
                    case "BIWEEKLY": return "격주";
                    case "MONTHLY": return "월 1회";
                    default: return type;
                  }
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