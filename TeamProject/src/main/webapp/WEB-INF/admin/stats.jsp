<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>AGRICOLA 관리자 통계</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

            <style>
                body {
                    margin: 0;
                    font-family: "Noto Sans KR", sans-serif;
                    background: #f9f9f9;
                }

                .stats-container {
                    max-width: 1300px;
                    margin: 60px auto;
                    padding: 0 30px 80px;
                }

                h2 {
                    text-align: center;
                    color: #1a5d1a;
                    font-size: 2rem;
                    margin-bottom: 40px;
                    font-weight: 700;
                }

                .chart-section {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                    padding: 30px;
                    margin-bottom: 50px;
                }

                .chart-section h3 {
                    color: #2e5d2e;
                    margin-bottom: 20px;
                    font-size: 1.3rem;
                }

                .btn-back {
                    background: #5dbb63;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 10px 20px;
                    font-size: 15px;
                    cursor: pointer;
                    transition: 0.3s;
                    margin-bottom: 25px;
                }

                .btn-back:hover {
                    background: #4ba954;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/views/common/header.jsp" %>

                <div id="app">
                    <div class="stats-container">
                        <button class="btn-back" @click="goBack">이전</button>
                        <h2>AGRICOLA 통계</h2>

                        <div class="chart-section">
                            <h3>회원 비율</h3>
                            <div id="userChart"></div>
                        </div>

                        <div class="chart-section">
                            <h3>회원 나이대 분포</h3>
                            <div id="ageChart"></div>
                        </div>

                        <div class="chart-section">
                            <h3>성별 비율</h3>
                            <div id="genderChart"></div>
                        </div>

                        <div class="chart-section">
                            <h3>지역별 회원 비율</h3>
                            <div id="regionChart"></div>
                        </div>

                        <div class="chart-section">
                            <h3>월별 매출 금액 (₩)</h3>
                            <div id="salesChart"></div>
                        </div>

                        <div class="chart-section">
                            <h3>신규 회원 증가 추이</h3>
                            <div id="joinChart"></div>
                        </div>
                    </div>
                </div>

                <%@ include file="/WEB-INF/views/common/footer.jsp" %>

                    <script>
                        const app = Vue.createApp({
                            data() {
                                return {
                                    stats: {},
                                    path: "${pageContext.request.contextPath}"
                                };
                            },
                            methods: {
                                goBack() {
                                    location.href = this.path + "/dashboard.do";
                                },
                                loadStats() {
                                    const self = this;
                                    $.ajax({
                                        url: "/admin/statsData.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success(res) {
                                            self.stats = res;
                                            // console.log(self.stats);
                                            self.renderCharts();
                                        },
                                        error() {
                                            alert("통계 데이터를 불러오지 못했습니다.");
                                        }
                                    });
                                },
                                renderCharts() {
                                    let buyerCnt = 0;
                                    let sellerCnt = 0;

                                    if (Array.isArray(this.stats.userCount)) {
                                        this.stats.userCount.forEach(item => {
                                            if (item.userRole === "BUYER") buyerCnt = item.cnt;
                                            else if (item.userRole === "SELLER") sellerCnt = item.cnt;
                                        });
                                    }

                                    new ApexCharts(document.querySelector("#userChart"), {
                                        chart: { type: 'donut', height: 320 },
                                        labels: ['일반회원', '판매자'],
                                        series: [buyerCnt, sellerCnt],
                                        colors: ['#81C784', '#388E3C'],
                                        legend: { position: 'bottom' },
                                    }).render();

                                    if (Array.isArray(this.stats.ageGenderDistribution)) {
                                        const raw = this.stats.ageGenderDistribution;

                                        const ageGroups = ['10대 이하', '20대', '30대', '40대', '50대', '60대 이상'];

                                        const maleData = new Array(ageGroups.length).fill(0);
                                        const femaleData = new Array(ageGroups.length).fill(0);

                                        raw.forEach(item => {
                                            const idx = ageGroups.indexOf(item.ageGroup);
                                            if (idx >= 0) {
                                                if (item.userGender === '남자') maleData[idx] = item.cnt;
                                                else if (item.userGender === '여자') femaleData[idx] = item.cnt;
                                            }
                                        });

                                        new ApexCharts(document.querySelector("#ageChart"), {
                                            chart: { type: 'bar', height: 350, stacked: true },
                                            series: [
                                                { name: '남자', data: maleData },
                                                { name: '여자', data: femaleData }
                                            ],
                                            xaxis: { categories: ageGroups },
                                            colors: ['#4CAF50', '#81C784'],
                                            plotOptions: { bar: { borderRadius: 5, columnWidth: '55%' } },
                                            legend: { position: 'bottom' },
                                            dataLabels: { enabled: false },
                                            tooltip: {
                                                y: { formatter: (val) => val + '명' }
                                            }
                                        }).render();
                                    }

                                    if (Array.isArray(this.stats.genderCount)) {
                                        const labels = this.stats.genderCount.map(g => g.userGender);
                                        const series = this.stats.genderCount.map(g => g.cnt);

                                        new ApexCharts(document.querySelector("#genderChart"), {
                                            chart: { type: 'pie', height: 320 },
                                            labels: labels,
                                            series: series,
                                            colors: ['#43A047', '#A5D6A7'],
                                            legend: { position: 'bottom' },
                                            dataLabels: {
                                                enabled: true,
                                                formatter: (val, opts) => val.toFixed(1) + '%'
                                            },
                                            tooltip: {
                                                y: {
                                                    formatter: (val) => val + '명'
                                                }
                                            },
                                            title: {
                                                text: '성별 비율',
                                                align: 'left',
                                                style: { color: '#1a5d1a', fontSize: '16px' }
                                            }
                                        }).render();
                                    }

                                    if (Array.isArray(this.stats.regionRatio)) {
                                        const regions = this.stats.regionRatio.map(r => r.region);
                                        const counts = this.stats.regionRatio.map(r => r.cnt);

                                        new ApexCharts(document.querySelector("#regionChart"), {
                                            chart: { type: 'bar', height: 350 },
                                            series: [{ name: '회원 수', data: counts }],
                                            xaxis: { categories: regions },
                                            colors: ['#5DBB63'],
                                            plotOptions: { bar: { borderRadius: 5, columnWidth: '50%' } },
                                            dataLabels: { enabled: true },
                                            tooltip: {
                                                y: { formatter: (val) => val + '명' }
                                            },
                                            legend: { show: false }
                                        }).render();
                                    }

                                    if (Array.isArray(this.stats.salesByMonth)) {
                                        const months = this.stats.salesByMonth.map(item => item.orderMonth);
                                        const sales = this.stats.salesByMonth.map(item => item.totalSales);

                                        new ApexCharts(document.querySelector("#salesChart"), {
                                            chart: { type: 'line', height: 350 },
                                            series: [{ name: '매출 금액', data: sales }],
                                            xaxis: {
                                                categories: months,
                                                labels: { style: { colors: '#333', fontSize: '13px' } }
                                            },
                                            colors: ['#2E7D32'],
                                            stroke: { curve: 'smooth', width: 3 },
                                            markers: { size: 5 },
                                            dataLabels: { enabled: false },
                                            tooltip: {
                                                y: {
                                                    formatter: (val) => val.toLocaleString() + '원'
                                                }
                                            },
                                            title: {
                                                text: '월별 매출 추이',
                                                align: 'left',
                                                style: { fontSize: '16px', color: '#1a5d1a' }
                                            },
                                            grid: { borderColor: '#e0e0e0', strokeDashArray: 4 }
                                        }).render();
                                    }

                                    if (Array.isArray(this.stats.newUserTrend)) {
                                        const data = this.stats.newUserTrend;

                                        const months = [...new Set(data.map(d => d.joinMonth))].sort();

                                        const buyerData = [];
                                        const sellerData = [];

                                        months.forEach(month => {
                                            const buyer = data.find(d => d.userRole === "BUYER" && d.joinMonth === month);
                                            const seller = data.find(d => d.userRole === "SELLER" && d.joinMonth === month);
                                            buyerData.push(buyer ? buyer.cnt : 0);
                                            sellerData.push(seller ? seller.cnt : 0);
                                        });

                                        new ApexCharts(document.querySelector("#joinChart"), {
                                            chart: { type: 'area', height: 350 },
                                            series: [
                                                { name: '일반회원', data: buyerData },
                                                { name: '판매자', data: sellerData }
                                            ],
                                            xaxis: { categories: months },
                                            colors: ['#43A047', '#1B5E20'],
                                            stroke: { curve: 'smooth', width: 3 },
                                            fill: {
                                                type: 'gradient',
                                                gradient: { shadeIntensity: 0.5, opacityFrom: 0.6, opacityTo: 0.1 }
                                            },
                                            dataLabels: { enabled: false },
                                            tooltip: {
                                                shared: true,
                                                y: {
                                                    formatter: (val) => val + '명'
                                                }
                                            },
                                            legend: { position: 'bottom' },
                                            title: {
                                                text: '신규 회원 증가 추이',
                                                align: 'left',
                                                style: { color: '#1a5d1a', fontSize: '16px' }
                                            },
                                            grid: { borderColor: '#e0e0e0', strokeDashArray: 4 }
                                        }).render();
                                    }

                                }
                            },
                            mounted() {
                                this.loadStats();
                            }
                        });

                        app.mount("#app");
                    </script>
        </body>

        </html>