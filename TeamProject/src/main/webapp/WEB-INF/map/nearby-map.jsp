<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>주변 생산자 지도 | AGRICOLA</title>

            <!-- libs -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script
                src="//dapi.kakao.com/v2/maps/sdk.js?appkey=78c3fbd5be4327cf3319a04cf0a379c4&libraries=services"></script>
            <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js" crossorigin="anonymous"></script>
            <script>
                // ⚠️ 도메인(예: localhost:8080, 배포 도메인)을 카카오 개발자 콘솔에 등록해야 동작합니다.
                window.Kakao && !window.Kakao.isInitialized() && window.Kakao.init('78c3fbd5be4327cf3319a04cf0a379c4');
            </script>
            <!-- 공통 CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                html,
                body {
                    height: 100%;
                    background: #faf8f0;
                }

                #app {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .page-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 16px 20px;
                    max-width: 1200px;
                    width: 100%;
                    margin: 16px auto 0;

                    flex-wrap: wrap;
                }

                .page-header h1 {
                    flex: 0 0 auto;
                }


                .page-header .btns {
                    display: flex;
                    align-items: center;
                    gap: 8px;

                    flex: 0 0 auto;
                    margin-left: auto;
                }

                .btn {
                    border: none;
                    padding: 8px 12px;
                    border-radius: 10px;
                    cursor: pointer;
                    background: #5dbb63;
                    color: #fff;
                    font-size: 14px;
                }

                .btn--line {
                    background: #e8f5e9;
                    color: #2e7d32;
                }

                .btn:hover {
                    background: #4ba954;
                }

                .btn--line:hover {
                    background: #d7efda;
                }

                .map-wrap {
                    max-width: 1200px;
                    width: 100%;
                    margin: 0 auto;
                    padding: 0 20px 20px;
                    display: grid;
                    gap: 14px;
                    grid-template-columns: minmax(0, 1fr) 360px;
                    align-items: stretch;
                    flex: 1;
                    box-sizing: border-box;
                }

                #bigmap {
                    width: 100%;
                    height: calc(100vh - 230px);
                    /* 헤더/버튼/푸터를 감안한 큰 높이 */
                    background: #f7fff7;
                    border-radius: 12px;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, .08);
                }

                .side {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                    height: calc(100vh - 230px);
                }

                .controls {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    padding: 10px;
                    border: 1px solid #e1f0e1;
                    background: #f7fff7;
                    border-radius: 10px;
                }

                .controls label {
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    font-size: 13px;
                    color: #2e7d32;
                    background: #e8f5e9;
                    padding: 6px 10px;
                    border-radius: 14px;
                    cursor: pointer;
                }

                .controls input[type="radio"],
                .controls input[type="checkbox"] {
                    accent-color: #5dbb63;
                }

                .seller-list {
                    flex: 1;
                    overflow: auto;
                    padding: 8px;
                    background: #fff;
                    border-radius: 12px;
                    border: 1px solid #eee;
                }

                .seller-item {
                    display: flex;
                    gap: 10px;
                    padding: 10px;
                    border: 1px solid #f0f0f0;
                    border-radius: 10px;
                    margin-bottom: 8px;
                    cursor: pointer;
                    background: #fff;
                    transition: transform .2s;
                }

                .seller-item:hover {
                    transform: translateY(-2px);
                }

                .seller-logo {
                    width: 56px;
                    height: 56px;
                    border-radius: 50%;
                    background: #f5f5f5;
                    background-size: cover;
                    background-position: center;
                    border: 1px solid #eee;
                    flex-shrink: 0;
                }

                .seller-meta {
                    font-size: 13px;
                    color: #555;
                    line-height: 1.4;
                }

                .seller-name {
                    font-weight: 700;
                    color: #1a5d1a;
                    margin-bottom: 2px;
                }

                .badge-inrange {
                    display: inline-block;
                    margin-left: 4px;
                    padding: 2px 6px;
                    border-radius: 10px;
                    background: #e8f5e9;
                    color: #2e7d32;
                    font-size: 11px;
                }

                @media (max-width: 960px) {
                    .searchbar {
                        flex: 1 1 100%;
                        min-width: 0;
                        max-width: 100%;
                    }

                    .page-header .btns {
                        width: 100%;
                        margin-left: 0;
                        justify-content: flex-end;
                    }
                }

                .searchbar {
                    display: flex;
                    align-items: center;
                    gap: 8px;

                    flex: 1 1 520px;
                    min-width: 420px;
                    max-width: 620px;
                }

                .searchbar input {
                    flex: 1;
                    min-width: 200px;
                    padding: 8px 10px;
                    border: 1px solid #e1f0e1;
                    border-radius: 10px;
                    background: #fff;
                }

                .filter-chips {
                    max-width: 1200px;
                    margin: 6px auto 0;
                    padding: 0 20px;
                }

                .filter-chips__row {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                    flex-wrap: wrap;
                }

                /* ⬇️ 배지(Chip) */
                .chip {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    background: #e8f5e9;
                    color: #2e7d32;
                    padding: 6px 10px;
                    border-radius: 14px;
                    font-size: 12px;
                    line-height: 1;
                }

                .chip__x {
                    border: none;
                    background: transparent;
                    cursor: pointer;
                    font-size: 14px;
                    padding: 0 2px;
                    color: inherit;
                }

                /* ⬇️ ‘전체 해제’ 버튼을 라이트톤으로 */
                .btn--light {
                    background: #f3faf3;
                    color: #2e7d32;
                }

                .btn--light:hover {
                    background: #e6f6e6;
                }

                .agri-user-label {
                    position: relative;
                    display: inline-flex !important;
                    align-items: center;
                    gap: 6px;

                    padding: 7px 10px !important;
                    background: #ffffff !important;
                    border: 1px solid rgba(0, 0, 0, .15) !important;
                    border-radius: 999px !important;

                    color: #111 !important;
                    -webkit-text-fill-color: #111 !important;
                    font-size: 13px !important;
                    font-weight: 800 !important;
                    line-height: 1 !important;
                    white-space: nowrap !important;

                    box-shadow: 0 6px 14px rgba(0, 0, 0, .14) !important;

                    /* ✅ 마커 위로 올리기 (yAnchor보다 안정적) */
                    transform: translateY(calc(-100% - 18px));
                    pointer-events: none;
                    /* 지도 클릭 방해 X */
                }

                .agri-user-label::after {
                    content: "";
                    position: absolute;
                    left: 50%;
                    bottom: -7px;
                    transform: translateX(-50%);
                    width: 0;
                    height: 0;
                    border-left: 7px solid transparent;
                    border-right: 7px solid transparent;
                    border-top: 7px solid #ffffff;
                    filter: drop-shadow(0 2px 2px rgba(0, 0, 0, .12));
                }

                .agri-user-dot {
                    width: 8px;
                    height: 8px;
                    border-radius: 50%;
                    background: #5dbb63;
                    box-shadow: 0 0 0 3px rgba(93, 187, 99, .20);
                }

                /* 카카오 커스텀 오버레이/인포윈도우 레이어를 최상단으로 */
                #bigmap .wrap,
                #bigmap .wrap * {
                    box-sizing: border-box;
                }

                #bigmap .wrap,
                #bigmap .wrap * {
                    visibility: visible !important;
                    opacity: 1 !important;
                }

                #bigmap .agri-user-label {
                    z-index: 2147483647 !important;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <div class="page-header">
                        <h1>내 주변 생산자 지도</h1>
                        <div class="searchbar">
                            <input type="text" v-model.trim="searchText" @keyup.enter="search"
                                placeholder="키워드/지역(시·도/구/동)로 검색" />
                            <button class="btn" @click="search">검색</button>
                            <button class="btn btn--line" @click="resetSearch">초기화</button>
                            <button class="btn" @click="shareKakao">카카오톡 공유</button>
                        </div>
                        <div class="btns">
                            <button class="btn btn--line" @click="goHome">메인으로</button>
                            <button class="btn btn--line" @click="goPrevCenter" title="검색 전 중심으로 복귀">이전 위치</button>
                            <button type="button" class="btn" :class="{'btn--line': followMe}" :disabled="isToggling"
                                @click.stop.prevent="toggleFollowMe">
                                {{ followMe ? '내 주소로' : '내 위치 추적' }}
                            </button>
                        </div>
                    </div>

                    <div class="filter-chips" v-if="hasActiveFilter">
                        <div class="filter-chips__row">
                            <span class="chip" v-if="searchText">
                                키워드: {{ searchText }}
                                <button class="chip__x" @click="clearKeyword" aria-label="키워드 지우기">×</button>
                            </span>
                            <span class="chip" v-if="onlyInRange">
                                반경: {{ rangeKm }}km
                            </span>

                            <button class="btn btn--line btn--light" @click="clearAllFilters">전체 해제</button>
                        </div>
                    </div>

                    <div class="map-wrap">
                        <div id="bigmap"></div>

                        <aside class="side">
                            <div class="controls">
                                <label><input type="radio" name="range" :value="1" v-model.number="rangeKm">1km</label>
                                <label><input type="radio" name="range" :value="3" v-model.number="rangeKm">3km</label>
                                <label><input type="radio" name="range" :value="5" v-model.number="rangeKm">5km</label>
                                <label style="margin-left:auto;"><input type="checkbox" v-model="onlyInRange">범위
                                    내만</label>
                            </div>

                            <div class="seller-list">
                                <div v-for="p in visibleProducers" :key="p.userId" class="seller-item"
                                    @click="goSeller(p.userId)">
                                    <div class="seller-logo"
                                        :style="{ backgroundImage: 'url(' + (p.profileImg || '') + ')' }"></div>
                                    <div class="seller-meta">
                                        <div class="seller-name">
                                            {{ p.businessName || '이름 없음' }}
                                            <span v-if="inRange(p)" class="badge-inrange">범위내</span>
                                        </div>
                                        <div>{{ p.addrDo || '' }} {{ p.addrCity || '' }}</div>
                                        <div>📍 {{ (p.distance!=null ? Number(p.distance).toFixed(1) :
                                            calcDistanceKm(center.lat, center.lng, p.lat, p.lng).toFixed(1)) }}km</div>
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </div>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    __vmId: Math.random().toString(36).slice(2),
                                    path: "${pageContext.request.contextPath}",
                                    center: { lat: 37.5665, lng: 126.9780 },
                                    map: null,
                                    rangeKm: 3,
                                    onlyInRange: false,
                                    producers: [],
                                    _markers: [],
                                    _circles: [],
                                    _infoWindow: null,
                                    _openMarker: null,
                                    searchText: "",
                                    _lastSearchCenter: null,

                                    myPos: null,        // {lat, lng} - 브라우저 내 위치
                                    userMarker: null,   // 내 위치 마커
                                    prevCenter: null,   // 검색/이동 전 중심 저장
                                    followMe: false,    // 내 위치 추적 모드
                                    isAddressSearch: false,
                                    isToggling: false,
                                    _userOverlay: null,
                                    isLoggedIn: false,
                                    prevUserPin: null,
                                    userLabelText: "내 주소",
                                };
                            },
                            computed: {
                                visibleProducers() {
                                    // 현재 중심 기준으로 매번 거리 갱신
                                    const list = (this.producers || []).map(p => {
                                        p.distance = (p.lat && p.lng)
                                            ? this.calcDistanceKm(this.center.lat, this.center.lng, p.lat, p.lng)
                                            : Infinity;
                                        return p;
                                    });

                                    const matched = list.filter(p => this.matchSeller(p)); // 키워드/지역 매칭(이전 답변대로)
                                    const filtered = this.onlyInRange
                                        ? matched.filter(p => p.distance <= this.rangeKm + 1e-9)
                                        : matched;

                                    return filtered.sort((a, b) => (a.distance || 9999) - (b.distance || 9999));
                                },
                                hasActiveFilter() { return !!(this.onlyInRange || (this.searchText && !this.isAddressSearch)); }
                            },
                            methods: {
                                _setUserLabel(text) {
                                    if (!this._userOverlay) return;
                                    const safe = String(text)
                                        .replace(/&/g, "&amp;")
                                        .replace(/</g, "&lt;")
                                        .replace(/>/g, "&gt;")
                                        .replace(/"/g, "&quot;")
                                        .replace(/'/g, "&#39;");
                                    this._userOverlay.setContent(`<div class="agri-user-label">${safe}</div>`);
                                },


                                goHome() { location.href = this.path + "/main.do"; },
                                inRange(p) {
                                    if (!p.lat || !p.lng) return false;
                                    const d = this.calcDistanceKm(this.center.lat, this.center.lng, p.lat, p.lng);
                                    p.distance = d; // 최신 거리 반영
                                    return d <= this.rangeKm + 1e-9;
                                },
                                qs(key) {
                                    const params = new URLSearchParams(location.search);
                                    return params.get(key);
                                },
                                async initFromQueryOrBrowser() {
                                    const qLat = parseFloat(this.qs('lat'));
                                    const qLng = parseFloat(this.qs('lng'));
                                    const qRange = parseInt(this.qs('rangeKm'), 10);
                                    const qOnly = this.qs('onlyInRange');

                                    if (!isNaN(qLat) && !isNaN(qLng)) {
                                        this.center = { lat: qLat, lng: qLng };
                                    }
                                    if (!isNaN(qRange)) this.rangeKm = qRange;
                                    if (qOnly === 'Y') this.onlyInRange = true;
                                    if (qOnly === 'N') this.onlyInRange = false;

                                    // ✅ 쿼리가 없으면: 서버(가입 주소 좌표) -> 실패 시 브라우저 GPS -> 그래도 실패면 기본값 유지
                                    if (isNaN(qLat) || isNaN(qLng)) {
                                        let decided = false;

                                        try {
                                            const res = await $.ajax({
                                                url: this.path + "/main/data/userLocation.dox",
                                                type: "POST",
                                                dataType: "json",
                                                timeout: 5000
                                            });
                                            this.isLoggedIn = !!res?.login;

                                            const lat = parseFloat(res?.lat);
                                            const lng = parseFloat(res?.lng);
                                            if (res?.login && Number.isFinite(lat) && Number.isFinite(lng)) {
                                                this.center = { lat, lng };
                                                decided = true;
                                            }

                                        } catch (e) { }

                                    }

                                    // ✅ 여기서 "확정된 center"로 지도 생성
                                    this.initMapThenLoad();
                                },

                                initMapThenLoad() {
                                    const container = document.getElementById("bigmap");
                                    this.map = new kakao.maps.Map(container, {
                                        center: new kakao.maps.LatLng(this.center.lat, this.center.lng),
                                        level: 6
                                    });

                                    if (!this._infoWindow) {
                                        this._infoWindow = new kakao.maps.InfoWindow({ removable: false });
                                    }

                                    kakao.maps.event.addListener(this.map, "click", () => {
                                        if (this._infoWindow && this._infoWindow.getMap()) {
                                            this._infoWindow.close();
                                            this._openMarker = null;
                                        }
                                    });

                                    // initMapThenLoad() 끝부분에서:
                                    // ✅ 초기 표시 규칙
                                    if (!this.isLoggedIn) {
                                        // 비로그인: 서울시청
                                        this.followMe = false;
                                        this._setCenter(37.5665, 126.9780, { level: 6, rememberPrev: false });
                                        this._updateUserMarker(37.5665, 126.9780, "서울시청");
                                    } else {
                                        // 로그인: 기본은 내 주소(DB)
                                        this.followMe = false;
                                        this._updateUserMarker(this.center.lat, this.center.lng, "내 주소");
                                    }

                                    this.drawRangeCircles();
                                    this.loadProducers();

                                },

                                loadProducers() {
                                    $.ajax({
                                        url: this.path + "/main/data/sellerList.dox",
                                        type: "POST",
                                        data: {
                                            lat: this.center.lat,
                                            lng: this.center.lng,
                                            onlyInRange: this.onlyInRange ? 'Y' : 'N',
                                            rangeKm: this.onlyInRange ? this.rangeKm : null
                                        },
                                        dataType: "json",
                                        success: (res) => {
                                            this.producers = res.list || [];
                                            (this.producers || []).forEach(p => {
                                                if (typeof p.distance !== 'number' && p.lat && p.lng) {
                                                    p.distance = this.calcDistanceKm(this.center.lat, this.center.lng, p.lat, p.lng);
                                                }
                                            });
                                            this.renderMarkers();
                                        },
                                        error: (xhr, s, e) => {
                                            console.error("생산자 목록 로드 실패:", e);
                                        }
                                    });
                                },
                                renderMarkers() {
                                    if (!this.map) return;
                                    if (this._markers && this._markers.length) this._markers.forEach(m => m.marker.setMap(null));
                                    this._markers = [];

                                    // 열려있던 공유 InfoWindow 닫기
                                    this._openMarker = null;
                                    if (this._infoWindow && this._infoWindow.getMap()) this._infoWindow.close();

                                    (this.producers || []).forEach(p => {
                                        if (!p.lat || !p.lng) return;
                                        const pos = new kakao.maps.LatLng(p.lat, p.lng);
                                        const marker = new kakao.maps.Marker({ position: pos, map: this.map });

                                        kakao.maps.event.addListener(marker, "click", () => {
                                            const d = (typeof p.distance === 'number' && !isNaN(p.distance)) ? p.distance.toFixed(1) + "km" : "거리 정보 없음";
                                            const inRange = this.inRange(p);
                                            const html =
                                                "<div style='padding:10px;width:220px;line-height:1.5;font-size:13px;'>" +
                                                "<strong style='font-size:14px;color:#1a5d1a;'>" + (p.businessName || "이름 없음") + "</strong>" +
                                                (inRange ? " <span style=\"display:inline-block;margin-left:4px;padding:2px 6px;border-radius:10px;background:#e8f5e9;color:#2e7d32;font-size:11px;\">범위내</span>" : "") +
                                                "<br>" + (p.addrDo || "") + " " + (p.addrCity || "") +
                                                "<br>📍 " + d +
                                                "<div style='display:flex;gap:6px;margin-top:8px;'>" +
                                                "<button class='btn' style='padding:6px 10px;border:none;border-radius:6px;' " +
                                                "onclick=\"location.href='" + (this.path || '') + "/seller/detail.do?sellerId=" + p.userId + "'\">상세보기</button>" +
                                                "<button class='btn btn--line' style='padding:6px 10px;border:none;border-radius:6px;' " +
                                                "onclick=\"window.__agriShareSeller('" + p.userId + "')\">공유</button>" +
                                                "</div>" +
                                                "</div>";

                                            const isOpenOnThis = (this._openMarker === marker) && this._infoWindow.getMap();
                                            if (isOpenOnThis) {
                                                this._infoWindow.close();
                                                this._openMarker = null;
                                                return;
                                            }
                                            this._infoWindow.setContent(html);
                                            this._infoWindow.open(this.map, marker);
                                            this._openMarker = marker;
                                        });

                                        this._markers.push({ marker, p });
                                    });

                                    this.updateMarkerVisibility();
                                },
                                updateMarkerVisibility() {
                                    if (!this._markers) return;
                                    this._markers.forEach(({ marker, p }) => {
                                        const inRange = !this.onlyInRange || this.inRange(p);
                                        const byKeyword = this.matchSeller(p);
                                        const show = inRange && byKeyword;

                                        marker.setMap(show ? this.map : null);

                                        // 숨기는 마커가 열려있던 경우 닫기
                                        if (!show && this._openMarker === marker && this._infoWindow && this._infoWindow.getMap()) {
                                            this._infoWindow.close();
                                            this._openMarker = null;
                                        }
                                    });
                                },
                                drawRangeCircles() {
                                    if (!this.map || !this.center) return;
                                    if (this._circles && this._circles.length) this._circles.forEach(c => c.setMap(null));
                                    this._circles = [];

                                    const center = new kakao.maps.LatLng(this.center.lat, this.center.lng);
                                    [1, 3, 5].forEach(km => {
                                        const c = new kakao.maps.Circle({
                                            center, radius: km * 1000,
                                            strokeWeight: 2,
                                            strokeColor: (km === this.rangeKm) ? '#5dbb63' : '#1a5d1a',
                                            strokeOpacity: (km === this.rangeKm) ? 0.9 : 0.5,
                                            strokeStyle: 'shortdash',
                                            fillColor: '#5dbb63',
                                            fillOpacity: (km === this.rangeKm) ? 0.12 : 0.0
                                        });
                                        c.setMap(this.map);
                                        this._circles.push(c);
                                    });
                                },

                                // 중심을 바꾸기 전에 반드시 이전 중심 저장
                                _setCenter(lat, lng, { level = null, rememberPrev = true } = {}) {
                                    if (rememberPrev) {
                                        this.prevCenter = { ...this.center };

                                        const pos = this._userOverlay ? this._userOverlay.getPosition() : null;

                                        this.prevUserPin = {
                                            lat: pos ? pos.getLat() : this.center.lat,
                                            lng: pos ? pos.getLng() : this.center.lng,
                                            label: this.userLabelText || (!this.isLoggedIn ? "서울시청" : (this.followMe ? "현재 위치" : "내 주소")),
                                        };
                                    }

                                    this.center = { lat, lng };
                                    if (this.map) {
                                        this.map.setCenter(new kakao.maps.LatLng(lat, lng));
                                        if (level != null) this.map.setLevel(level);
                                    }
                                    this.drawRangeCircles();
                                    this.updateMarkerVisibility();
                                    this._syncUrl();
                                    this.loadProducers();
                                },

                                goPrevCenter() {
                                    if (!this.prevCenter) return Swal.fire('ℹ️', '이전 위치가 아직 없어요. 먼저 위치를 한 번 이동해보세요.', 'info');

                                    this._setCenter(this.prevCenter.lat, this.prevCenter.lng, { rememberPrev: false });

                                    const pin = this.prevUserPin;
                                    if (pin && Number.isFinite(pin.lat) && Number.isFinite(pin.lng)) {
                                        this._updateUserMarker(pin.lat, pin.lng, pin.label || "내 위치"); // ✅ 저장된 라벨 사용
                                    }
                                },

                                async applyFollowState() {
                                    // 비로그인: 항상 서울시청
                                    if (!this.isLoggedIn) {
                                        this.followMe = false;
                                        this._setCenter(37.5665, 126.9780, { level: 6, rememberPrev: true });
                                        this._updateUserMarker(37.5665, 126.9780, "서울시청");
                                        return;
                                    }

                                    if (this.followMe) {
                                        // ✅ 추적 ON => GPS
                                        const ok = await new Promise(resolve => {
                                            if (!navigator.geolocation) return resolve(false);
                                            navigator.geolocation.getCurrentPosition(
                                                (pos) => {
                                                    const lat = pos.coords.latitude;
                                                    const lng = pos.coords.longitude;
                                                    if (!Number.isFinite(lat) || !Number.isFinite(lng) || (lat === 0 && lng === 0)) return resolve(false);

                                                    this.myPos = { lat, lng };
                                                    this._setCenter(lat, lng, { level: 6, rememberPrev: true });
                                                    this._updateUserMarker(lat, lng, "현재 위치");
                                                    resolve(true);
                                                },
                                                () => resolve(false),
                                                { enableHighAccuracy: true, maximumAge: 0, timeout: 12000 }
                                            );
                                        });

                                        if (!ok) {
                                            Swal.fire('⚠️', '현재 위치를 가져오지 못했어요. 위치 권한/HTTPS를 확인해 주세요.', 'warning');
                                            this.followMe = false;
                                            await this.applyFollowState();
                                        }

                                        return;
                                    }

                                    // ✅ 추적 OFF => 내 주소(DB)
                                    try {
                                        const res = await $.ajax({
                                            url: this.path + "/main/data/userLocation.dox",
                                            type: "POST",
                                            dataType: "json",
                                            timeout: 5000
                                        });

                                        const lat = Number(res?.lat);
                                        const lng = Number(res?.lng);

                                        if (res?.login === true && Number.isFinite(lat) && Number.isFinite(lng)) {
                                            this._setCenter(lat, lng, { level: 6, rememberPrev: true });
                                            this._updateUserMarker(lat, lng, "내 주소");
                                        } else {
                                            // 로그인인데 좌표 없으면 서울시청으로 fallback
                                            this._setCenter(lat, lng, { level: 6, rememberPrev: true });
                                            this._updateUserMarker(37.5665, 126.9780, "서울시청");
                                        }
                                    } catch (e) {
                                        this._setCenter(37.5665, 126.9780, { level: 6, rememberPrev: false });
                                        this._updateUserMarker(37.5665, 126.9780, "서울시청");
                                    }
                                },

                                async toggleFollowMe() {
                                    if (this.isToggling) return;
                                    this.isToggling = true;
                                    try {
                                        this.followMe = !this.followMe;
                                        await this.applyFollowState();
                                    } finally {
                                        this.isToggling = false;
                                    }
                                },

                                _updateUserMarker(lat, lng, labelText = "내 위치") {
                                    this.userLabelText = labelText;
                                    if (!this.map) return;

                                    const pos = new kakao.maps.LatLng(lat, lng);

                                    // 마커
                                    if (!this.userMarker) {
                                        this.userMarker = new kakao.maps.Marker({ position: pos });
                                    } else {
                                        this.userMarker.setPosition(pos);
                                    }
                                    this.userMarker.setMap(this.map);

                                    // 라벨(CustomOverlay)
                                    const safe = String(labelText)
                                        .replace(/&/g, "&amp;")
                                        .replace(/</g, "&lt;")
                                        .replace(/>/g, "&gt;")
                                        .replace(/"/g, "&quot;")
                                        .replace(/'/g, "&#39;");

                                    const content =
                                        '<div class="agri-user-label"><span class="agri-user-dot"></span>' +
                                        safe +
                                        '</div>';

                                    if (!this._userOverlay) {
                                        this._userOverlay = new kakao.maps.CustomOverlay({
                                            position: pos,
                                            content,
                                            xAnchor: 0.5,  // ✅ CSS에서 -50% 처리
                                            yAnchor: 1.0,
                                            zIndex: 2147483647
                                        });
                                    } else {
                                        this._userOverlay.setPosition(pos);
                                        this._userOverlay.setContent(content);
                                    }

                                    this._userOverlay.setMap(this.map);
                                },

                                _escapeHtml(s) {
                                    return String(s)
                                        .replace(/&/g, "&amp;")
                                        .replace(/</g, "&lt;")
                                        .replace(/>/g, "&gt;")
                                        .replace(/"/g, "&quot;")
                                        .replace(/'/g, "&#39;");
                                },

                                goSeller(userId) {
                                    this._saveMapState();
                                    location.href = this.path + "/seller/detail.do?sellerId=" + userId;
                                },
                                calcDistanceKm(lat1, lon1, lat2, lon2) {
                                    if ([lat1, lon1, lat2, lon2].some(v => typeof v !== 'number')) return Infinity;
                                    const R = 6371;
                                    const toRad = d => d * Math.PI / 180;
                                    const dLat = toRad(lat2 - lat1);
                                    const dLon = toRad(lon2 - lon1);
                                    const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
                                    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                                },

                                _onPageShow() {
                                    this.drawRangeCircles && this.drawRangeCircles();
                                    this.updateMarkerVisibility && this.updateMarkerVisibility();
                                },

                                _restoreMapState({ preferQuery = false } = {}) {
                                    if (preferQuery) {
                                        const sp = new URLSearchParams(location.search);
                                        const o = sp.get('onlyInRange');
                                        const r = parseInt(sp.get('rangeKm'), 10);
                                        const lat = parseFloat(sp.get('lat')), lng = parseFloat(sp.get('lng'));
                                        if (o !== null) this.onlyInRange = (o === 'Y');
                                        if (!isNaN(r)) this.rangeKm = r;
                                        if (!isNaN(lat) && !isNaN(lng)) this.center = { lat, lng };
                                    }
                                    if (!preferQuery || location.search === '') {
                                        const only = sessionStorage.getItem('agri_only');
                                        if (only !== null) this.onlyInRange = (only === '1');
                                        const rk = parseInt(sessionStorage.getItem('agri_range'), 10);
                                        if (!isNaN(rk)) this.rangeKm = rk;
                                        const c = sessionStorage.getItem('agri_center');
                                        if (c) this.center = JSON.parse(c);
                                        const s = sessionStorage.getItem('agri_search');
                                        if (s !== null) this.searchText = s;            // ✅ 검색어 복원
                                    }
                                },

                                matchSeller(p) {
                                    if (this.isAddressSearch) return true;

                                    const q = (this.searchText || "").trim();
                                    if (!q) return true; // 검색어 없으면 모두 허용

                                    const hay = [
                                        p.businessName, p.addrDo, p.addrCity, p.addrGu, p.addrDong, p.addrDetail
                                    ].filter(Boolean).join(" ").toLowerCase();
                                    return q.split(/\s+/).every(tok => hay.includes(tok.toLowerCase()));
                                },

                                async search() {
                                    const q = (this.searchText || "").trim();
                                    if (!q) { this.resetSearch(); return; }

                                    this._lastSearchCenter = { ...this.center };

                                    const geocoder = new kakao.maps.services.Geocoder();
                                    geocoder.addressSearch(q, (results, status) => {
                                        if (status === kakao.maps.services.Status.OK && results.length) {
                                            const r = results[0];
                                            const lat = parseFloat(r.y), lng = parseFloat(r.x);
                                            // 지역 단위(도/시/군/구/동)에 따라 레벨 힌트
                                            const level = this.inferZoomFromQuery(q);

                                            this.isAddressSearch = true;
                                            this._setCenter(lat, lng, { level, rememberPrev: true });
                                            this.loadProducers();
                                            // loadProducers() 끝나면 renderMarkers()가 호출되고, watcher/updateMarkerVisibility가 반영됨
                                            // 추가 Places 키워드로 보조 바운즈 맞추기(선택적)
                                            const places = new kakao.maps.services.Places();
                                            places.keywordSearch(q, (res, st) => {
                                                if (st === kakao.maps.services.Status.OK && res.length) {
                                                    const b = new kakao.maps.LatLngBounds();
                                                    res.slice(0, 5).forEach(it => b.extend(new kakao.maps.LatLng(it.y, it.x)));
                                                    this.map.setBounds(b);
                                                }
                                            });
                                        } else {
                                            this.isAddressSearch = false;
                                            this.updateMarkerVisibility();
                                        }
                                    });
                                },

                                resetSearch() {
                                    this.searchText = "";
                                    this.isAddressSearch = false;
                                    const restore = this._lastSearchCenter || this.center;
                                    // 중심/원/마커 가시성/URL까지 한 번에 동기화
                                    this._setCenter(restore.lat, restore.lng, { rememberPrev: false });
                                    // _setCenter 안에서 drawRangeCircles(), updateMarkerVisibility(), _syncUrl()까지 실행됨
                                },

                                inferZoomFromQuery(q) {
                                    // 대략적인 감(프로젝트 맵 레벨 기준에 맞게 조절 가능)
                                    if (/[도]$/.test(q)) return 11;      // 도
                                    if (/[시]$/.test(q)) return 9;       // 광역/기초시
                                    if (/[군구]$/.test(q)) return 8;     // 군/구
                                    if (/[읍면동]$/.test(q)) return 6;   // 읍/면/동
                                    return null;
                                },

                                shareKakao() {
                                    if (!window.Kakao || !window.Kakao.isInitialized()) {
                                        Swal.fire('⚠️', '카카오 SDK 초기화에 실패했어요. 도메인 등록을 확인해주세요.', 'warning');
                                        return;
                                    }

                                    const sp = new URLSearchParams();
                                    sp.set("lat", this.center.lat);
                                    sp.set("lng", this.center.lng);
                                    sp.set("rangeKm", this.rangeKm);
                                    sp.set("onlyInRange", this.onlyInRange ? "Y" : "N");
                                    const url = `\${location.origin}\${this.path}/map/nearby.do?\${sp.toString()}`;

                                    const top3 = this.visibleProducers.slice(0, 3);
                                    const desc = top3.length
                                        ? top3.map(p => `\${p.businessName}(\${(p.distance || 0).toFixed(1)}km)`).join(" · ")
                                        : "주변 생산자를 지도에서 확인해 보세요";

                                    const firstImg = (top3[0] && top3[0].profileImg) || (this.path + "/resources/img/share-default.png");

                                    Kakao.Share.sendDefault({
                                        objectType: 'feed',
                                        content: {
                                            title: 'AGRICOLA 내 주변 생산자',
                                            description: desc,
                                            imageUrl: firstImg,        // 100x100 이상 권장
                                            link: { mobileWebUrl: url, webUrl: url }
                                        },
                                        buttons: [
                                            { title: '지도로 보기', link: { mobileWebUrl: url, webUrl: url } }
                                        ]
                                    });
                                },

                                shareSellerKakaoById(userId) {
                                    const p = (this.producers || []).find(x => x.userId === userId);
                                    if (!p) return Swal.fire('❌', '판매자 정보를 찾을 수 없습니다.', 'error');

                                    this.shareSellerKakao(p);
                                },

                                shareSellerKakao(p) {
                                    if (!window.Kakao || !window.Kakao.isInitialized()) {
                                        Swal.fire('⚠️', '카카오 SDK가 초기화되지 않았습니다. 도메인 등록을 확인해주세요.', 'warning');
                                        return;
                                    }
                                    // 공유 링크: 해당 판매자 상세 및 현재 지도로 열기
                                    const sp = new URLSearchParams();
                                    const lat = p.lat || this.center.lat, lng = p.lng || this.center.lng;
                                    sp.set("lat", lat); sp.set("lng", lng);
                                    sp.set("rangeKm", this.rangeKm);
                                    sp.set("onlyInRange", this.onlyInRange ? "Y" : "N");
                                    const mapUrl = `\${location.origin}\${this.path}/map/nearby.do?\${sp.toString()}`;
                                    const detailUrl = `\${location.origin}\${this.path}/seller/detail.do?sellerId=\${encodeURIComponent(p.userId)}`;

                                    const title = p.businessName || "AGRICOLA 생산자";
                                    const desc = `\${(p.addrDo || '') + ' ' + (p.addrCity || '')}`.trim() || "주변 생산자를 확인해 보세요";
                                    const imageUrl = p.profileImg || `\${location.origin}\${this.path}/resources/img/share-default.png`;

                                    Kakao.Share.sendDefault({
                                        objectType: 'feed',
                                        content: {
                                            title: title,
                                            description: desc,
                                            imageUrl: imageUrl,
                                            link: { mobileWebUrl: detailUrl, webUrl: detailUrl }
                                        },
                                        buttons: [
                                            { title: '상세보기', link: { mobileWebUrl: detailUrl, webUrl: detailUrl } },
                                            { title: '지도로 보기', link: { mobileWebUrl: mapUrl, webUrl: mapUrl } }
                                        ]
                                    });
                                },

                                _saveMapState() {
                                    sessionStorage.setItem('agri_only', this.onlyInRange ? '1' : '0');
                                    sessionStorage.setItem('agri_range', String(this.rangeKm || 3));
                                    sessionStorage.setItem('agri_center', JSON.stringify(this.center));
                                    sessionStorage.setItem('agri_search', this.searchText || '');
                                },

                                _syncUrl() {
                                    const sp = new URLSearchParams(location.search);
                                    sp.set('lat', this.center.lat);
                                    sp.set('lng', this.center.lng);
                                    sp.set('rangeKm', this.rangeKm);
                                    sp.set('onlyInRange', this.onlyInRange ? 'Y' : 'N');
                                    history.replaceState(null, '', `${location.pathname}?${sp.toString()}`);
                                },

                                clearKeyword() {
                                    this.searchText = "";
                                    this.isAddressSearch = false;
                                    this.updateMarkerVisibility();
                                },

                                clearAllFilters() {
                                    this.onlyInRange = false;
                                    this.searchText = "";
                                    this.isAddressSearch = false;
                                    const restore = this._lastSearchCenter || this.center;
                                    this._setCenter(restore.lat, restore.lng, { rememberPrev: false });
                                }

                            },
                            watch: {
                                rangeKm() {
                                    this.drawRangeCircles();
                                    this._syncUrl();
                                    if (this.onlyInRange) this.loadProducers();
                                    else this.updateMarkerVisibility();
                                },
                                onlyInRange() {
                                    this._syncUrl();
                                    this.loadProducers();
                                }
                            },
                            mounted() {
                                this._restoreMapState({ preferQuery: true });
                                this.initFromQueryOrBrowser();
                                window.addEventListener('pageshow', this._onPageShow);
                                window.addEventListener("resize", this.drawRangeCircles);
                            },
                            unmounted() {
                                window.removeEventListener('pageshow', this._onPageShow);
                                window.removeEventListener("resize", this.drawRangeCircles);
                            }
                        });
                        const vm = app.mount("#app");
                        // InfoWindow 안에서 호출될 전역 함수
                        window.__agriShareSeller = function (userId) {
                            vm.shareSellerKakaoById(userId);
                        };
                    </script>
        </body>

        </html>