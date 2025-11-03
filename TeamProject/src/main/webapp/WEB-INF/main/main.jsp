<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AGRICOLA 메인</title>

  <!-- jQuery / Vue -->
  <script src="https://code.jquery.com/jquery-3.7.1.js"
          integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
          crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

  <!-- 공통 헤더 / 푸터 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

  <!-- 메인 전용 스타일 (header/footer와 이름 충돌 피함) -->
  <style>
    #app {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .content {
      flex: 1;
      background: #faf8f0;
      padding: 20px 0;
    }

    /* 🌿 슬라이더 전체 영역 */
    .main-slider {
      width: 100%;
      max-width: 1200px;
      margin: 0 auto;
      position: relative;
      overflow: hidden;
      border-radius: 12px;
      background: #f7fff7;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
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

    /* 제목 캡션 */
    .slider-caption {
      position: absolute;
      bottom: 15px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(0,0,0,0.5);
      color: #fff;
      padding: 8px 15px;
      border-radius: 6px;
      font-size: 1rem;
    }

    /* 화살표 버튼 */
    .slider-arrow {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      border: none;
      border-radius: 50%;
      background: rgba(0,0,0,0.3);
      color: #fff;
      width: 40px;
      height: 40px;
      cursor: pointer;
      font-size: 20px;
      z-index: 5;
      transition: background 0.3s;
    }
    .slider-arrow:hover { background: rgba(0,0,0,0.6); }
    .arrow-prev { left: 15px; }
    .arrow-next { right: 15px; }

    /* 점(dot) 네비게이션 */
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
      background: rgba(255,255,255,0.6);
      cursor: pointer;
      transition: background 0.3s;
    }
    .slider-dot.active {
      background: #4caf50;
    }

    /* 반응형 */
    @media (max-width: 768px) {
      .slider-item img { height: 250px; }
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

        <div v-show="!loading && !error"
             @mousedown="startDrag" @mousemove="dragging"
             @mouseup="endDrag" @mouseleave="endDrag"
             @touchstart="startDrag" @touchmove="dragging" @touchend="endDrag">
          <div class="slider-track" ref="track">
            <a v-for="(banner, i) in banners" :key="i" class="slider-item" :href="banner.linkUrl || '#'" @click.prevent="openBanner(banner)">
              <img :src="fullUrl(banner.imageUrl)" :alt="banner.title || '배너'+i" draggable="false">
              <div class="slider-caption" v-if="banner.title">{{ banner.title }}</div>
            </a>
          </div>

          <button v-if="banners.length > 1" class="slider-arrow arrow-prev" @click="prev">‹</button>
          <button v-if="banners.length > 1" class="slider-arrow arrow-next" @click="next">›</button>

          <div v-if="banners.length > 1" class="slider-dots">
            <div v-for="(d,idx) in banners.length" :key="idx"
                 :class="['slider-dot', { active: idx === index }]"
                 @click="go(idx)"></div>
          </div>
        </div>
      </section>

      <div style="text-align:center; margin-top:40px;">
        <h3>신선한 농수산물을 직접 거래하세요!</h3>
        <p>생산자와 소비자가 1:1로 연결되는 새로운 직거래 플랫폼입니다.</p>
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
          loading: true,
          error: null,
          index: 0,
          auto: null,
          dragging: false,
          startX: 0,
          deltaX: 0,
          width: 0
        };
      },
      methods: {
        /* 경로 합성 */
        fullUrl(u) {
          if (!u) return "";
          if (/^https?:\/\//i.test(u)) return u;
          return this.path + (u.startsWith("/") ? u : "/" + u);
        },

        /* 배너 로드 */
        load() {
          this.loading = true;
          this.error = null;
          const self = this;
          $.ajax({
            url: self.path + "/main/data/banners",
            type: "GET",
            dataType: "json",
            success(res) {
              self.banners = Array.isArray(res) ? res : [];
              self.$nextTick(() => {
                self.measure();
                self.move(0, false);
                self.startAuto();
              });
            },
            error() {
              self.error = "배너 정보를 불러오는 데 실패했습니다.";
            },
            complete() {
              self.loading = false;
            }
          });
        },

        /* 크기 계산 */
        measure() {
          const track = this.$refs.track;
          if (!track) return;
          const container = track.parentElement;
          this.width = container ? container.clientWidth : window.innerWidth;
          track.style.width = (this.width * this.banners.length) + "px";
          for (let slide of track.children) slide.style.width = this.width + "px";
        },

        /* 슬라이드 이동 */
        move(i, smooth = true) {
          if (!this.banners.length) return;
          const max = this.banners.length - 1;
          if (i < 0) i = max;
          if (i > max) i = 0;
          this.index = i;
          const track = this.$refs.track;
          if (track) {
            track.style.transition = smooth ? "transform 0.6s ease-in-out" : "none";
            track.style.transform = "translateX(-" + (i * this.width) + "px)";
          }
        },

        /* 버튼 제어 */
        next() { this.stopAuto(); this.move(this.index + 1, true); this.startAuto(); },
        prev() { this.stopAuto(); this.move(this.index - 1, true); this.startAuto(); },
        go(i) { this.stopAuto(); this.move(i, true); this.startAuto(); },

        /* 자동 전환 */
        startAuto() {
          this.stopAuto();
          if (this.banners.length > 1) {
            this.auto = setInterval(() => {
              this.move(this.index + 1, true);
            }, 4000);
          }
        },
        stopAuto() { if (this.auto) { clearInterval(this.auto); this.auto = null; } },

        /* 드래그 */
        startDrag(e) {
          if (this.banners.length <= 1) return;
          this.stopAuto();
          this.dragging = true;
          this.startX = e.touches ? e.touches[0].clientX : e.clientX;
          this.deltaX = 0;
          const track = this.$refs.track;
          if (track) track.style.transition = "none";
        },
        dragging(e) {
          if (!this.dragging) return;
          const x = e.touches ? e.touches[0].clientX : e.clientX;
          this.deltaX = x - this.startX;
          const track = this.$refs.track;
          if (track) {
            const offset = -(this.index * this.width) + this.deltaX;
            track.style.transform = "translateX(" + offset + "px)";
          }
        },
        endDrag() {
          if (!this.dragging) return;
          this.dragging = false;
          const threshold = this.width * 0.15;
          if (this.deltaX < -threshold) this.index++;
          else if (this.deltaX > threshold) this.index--;
          this.deltaX = 0;
          this.move(this.index, true);
          this.startAuto();
        },

        /* 배너 클릭 */
        openBanner(b) {
          if (this.dragging) return;
          if (b && b.linkUrl) location.href = b.linkUrl;
        }
      },
      mounted() {
        this.load();
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
