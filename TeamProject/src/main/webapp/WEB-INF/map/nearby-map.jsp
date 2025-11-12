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
                    justify-content: space-between;
                    gap: 12px;
                    padding: 16px 20px;
                    max-width: 1200px;
                    width: 100%;
                    margin: 16px auto 0;
                }

                .page-header h1 {
                    margin: 0;
                    font-size: 1.4rem;
                    color: #1a5d1a;
                    font-weight: 700;
                }

                .page-header .btns {
                    display: flex;
                    gap: 8px;
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
                    .map-wrap {
                        grid-template-columns: 1fr;
                    }

                    #bigmap,
                    .side {
                        height: 60vh;
                    }
                }

                .searchbar {
                    display: flex;
                    gap: 8px;
                    align-items: center;
                    flex: 1;
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
                            <button class="btn btn--line" @click="recenterToMyPos" title="브라우저 현재 위치로 이동">현재 위치</button>
                            <button class="btn" :class="{'btn--line': followMe}" @click="toggleFollowMe"
                                title="내 위치 자동추적 On/Off">
                                {{ followMe ? '추적 해제' : '내 위치 추적' }}
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
                                    path: "${pageContext.request.contextPath}",
                                    center: { lat: 37.5665, lng: 126.9780 },  // 기본: 서울시청
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
                                    geoWatchId: null,   // watchPosition id
                                    followMe: false,    // 내 위치 추적 모드
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
                                hasActiveFilter() { return !!(this.searchText || this.onlyInRange); }
                            },
                            methods: {
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
                                initFromQueryOrBrowser() {
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

                                    if (!(qLat && qLng)) {
                                        // 쿼리 없으면 사용자/브라우저 위치 우선
                                        $.ajax({
                                            url: this.path + "/main/data/userLocation.dox",
                                            type: "POST",
                                            dataType: "json",
                                            success: (res) => {
                                                if (res.login && res.lat && res.lng) {
                                                    this.center = { lat: res.lat, lng: res.lng };
                                                } else {
                                                    this.tryBrowserGeolocation();
                                                }
                                                this.initMapThenLoad();
                                            },
                                            error: () => {
                                                this.tryBrowserGeolocation();
                                                this.initMapThenLoad();
                                            }
                                        });
                                    } else {
                                        this.initMapThenLoad();
                                    }
                                },
                                tryBrowserGeolocation() {
                                    if (navigator.geolocation) {
                                        navigator.geolocation.getCurrentPosition(
                                            pos => this.center = { lat: pos.coords.latitude, lng: pos.coords.longitude },
                                            () => { } // 무시: 기본값 유지
                                        );
                                    }
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

                                    // 내 위치 마커
                                    const me = new kakao.maps.Marker({ position: new kakao.maps.LatLng(this.center.lat, this.center.lng), map: this.map });
                                    new kakao.maps.InfoWindow({ content: "<div style='padding:5px;'>내 위치</div>" }).open(this.map, me);

                                    this.drawRangeCircles();
                                    this.loadProducers();
                                },
                                loadProducers() {
                                    $.ajax({
                                        url: this.path + "/main/data/sellerList.dox",
                                        type: "POST",
                                        data: { lat: this.center.lat, lng: this.center.lng },
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
                                    if (rememberPrev) this.prevCenter = { ...this.center };
                                    this.center = { lat, lng };
                                    if (this.map) {
                                        this.map.setCenter(new kakao.maps.LatLng(lat, lng));
                                        if (level != null) this.map.setLevel(level);
                                    }
                                    this._updateUserMarker(lat, lng);
                                    this.drawRangeCircles();
                                    this.updateMarkerVisibility();
                                    this._syncUrl();
                                },

                                recenterToMyPos() {
                                    if (!navigator.geolocation) { alert("이 브라우저는 위치 기능을 지원하지 않습니다."); return; }
                                    navigator.geolocation.getCurrentPosition(
                                        pos => {
                                            this.myPos = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                                            this._setCenter(this.myPos.lat, this.myPos.lng, { level: 6, rememberPrev: true });
                                        },
                                        err => {
                                            console.warn("GPS 실패:", err.code, err.message);
                                            // ❗ HTTPS가 아니거나 권한 거부면 자주 실패합니다(로컬은 localhost만 예외).
                                            // 대체 1) 서버 세션 위치 사용 시도
                                            $.ajax({
                                                url: this.path + "/main/data/userLocation.dox",
                                                type: "POST", dataType: "json", timeout: 5000
                                            }).done(res => {
                                                if (res && res.lat && res.lng) {
                                                    this._setCenter(res.lat, res.lng, { level: 6, rememberPrev: true });
                                                } else {
                                                    alert("현재 위치 권한이 없어서 기본 위치(서울시청)로 이동합니다.");
                                                    this._setCenter(37.5665, 126.9780, { level: 6, rememberPrev: true });
                                                }
                                            }).fail(() => {
                                                alert("현재 위치를 가져올 수 없어 기본 위치(서울시청)로 이동합니다.");
                                                this._setCenter(37.5665, 126.9780, { level: 6, rememberPrev: true });
                                            });
                                        },
                                        { enableHighAccuracy: true, maximumAge: 10000, timeout: 10000 }
                                    );
                                },

                                goPrevCenter() {
                                    if (!this.prevCenter) return;
                                    this._setCenter(this.prevCenter.lat, this.prevCenter.lng, { rememberPrev: false });
                                },

                                toggleFollowMe() {
                                    if (!navigator.geolocation) {
                                        alert("브라우저가 위치 기능을 지원하지 않습니다.");
                                        return;
                                    }
                                    if (!this.followMe) {
                                        // ON
                                        this.followMe = true;
                                        this.geoWatchId = navigator.geolocation.watchPosition(
                                            pos => {
                                                this.myPos = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                                                // 추적 모드에서는 지도 중심도 따라가게
                                                this._setCenter(this.myPos.lat, this.myPos.lng, { rememberPrev: false });
                                            },
                                            err => console.warn("watchPosition 실패:", err && err.message),
                                            { enableHighAccuracy: true, maximumAge: 5000, timeout: 20000 }
                                        );
                                    } else {
                                        // OFF
                                        if (this.geoWatchId != null) navigator.geolocation.clearWatch(this.geoWatchId);
                                        this.geoWatchId = null;
                                        this.followMe = false;
                                    }
                                },

                                _updateUserMarker(lat, lng) {
                                    if (!this.map) return;
                                    const pos = new kakao.maps.LatLng(lat, lng);
                                    if (this.userMarker) {
                                        this.userMarker.setPosition(pos);
                                    } else {
                                        this.userMarker = new kakao.maps.Marker({ position: pos, map: this.map });
                                        new kakao.maps.InfoWindow({ content: "<div style='padding:5px;'>내 위치</div>" })
                                            .open(this.map, this.userMarker);
                                    }
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
                                            // 주소가 아니면: 현재 데이터에 대해 텍스트 필터만 적용
                                            // (renderMarkers가 이미 돌았다면, updateMarkerVisibility만 다시 적용)
                                            this.updateMarkerVisibility();
                                        }
                                    });
                                },

                                resetSearch() {
                                    this.searchText = "";
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
                                        alert("카카오 SDK 초기화에 실패했어요. 도메인 등록을 확인해주세요.");
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
                                    if (!p) return alert("판매자 정보를 찾을 수 없습니다.");
                                    this.shareSellerKakao(p);
                                },

                                shareSellerKakao(p) {
                                    if (!window.Kakao || !window.Kakao.isInitialized()) {
                                        alert("카카오 SDK가 초기화되지 않았습니다. 도메인 등록을 확인해주세요.");
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
                                    this.updateMarkerVisibility();
                                },

                                clearAllFilters() {
                                    this.onlyInRange = false;
                                    this.searchText = "";
                                    // 원하는 중심으로 리셋(검색 전 중심이 있으면 복귀)
                                    const restore = this._lastSearchCenter || this.center;
                                    this._setCenter(restore.lat, restore.lng, { rememberPrev: false });
                                }

                            },
                            watch: {
                                rangeKm() { this.drawRangeCircles(); this.updateMarkerVisibility(); this._syncUrl(); },
                                onlyInRange() { this.updateMarkerVisibility(); this._syncUrl(); }
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