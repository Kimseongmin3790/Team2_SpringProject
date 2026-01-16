<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>쿠폰 관리 - 관리자</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

    <style>
        body { margin: 0; font-family: "Noto Sans KR", sans-serif; background-color: #f9f9f9; }
        .admin-container { max-width: 1200px; margin: 60px auto; padding: 0 30px 60px; box-sizing: border-box; }
        .admin-title { text-align: center; font-size: 2rem; color: #2e5d2e; margin-bottom: 20px; font-weight: 700; }
        
        /* 버튼 스타일 */
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 0.9rem; transition: 0.2s; color: white; }
        .btn-primary { background-color: #4A773C; }
        .btn-primary:hover { background-color: #3a6330; }
        .btn-danger { background-color: #d9534f; }
        .btn-danger:hover { background-color: #c9302c; }
        .btn-info { background-color: #5bc0de; }
        .btn-info:hover { background-color: #31b0d5; }

        /* 상단 영역 */
        .top-area { display: flex; justify-content: flex-end; margin-bottom: 15px; }

        /* 테이블 스타일 */
        .coupon-table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; }
        .coupon-table th, .coupon-table td { padding: 12px 15px; text-align: center; border-bottom: 1px solid #eee; }
        .coupon-table th { background-color: #f4f4f4; color: #333; font-weight: 600; }
        .coupon-table tr:hover { background-color: #f9f9f9; }
        
        /* 모달 스타일 */
        .modal-mask { position: fixed; z-index: 9998; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); display: flex; align-items: center; justify-content: center; transition: opacity 0.3s ease; }
        .modal-container { width: 500px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33); padding: 30px; transition: all 0.3s ease; max-height: 90vh; overflow-y: auto; }
        .modal-header h3 { margin-top: 0; color: #42b983; }
        .modal-body { margin: 20px 0; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .modal-footer { text-align: right; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <div id="app">
        <div class="admin-container">
            <h2 class="admin-title">쿠폰 관리</h2>
            
            <div class="top-area">
                <button class="btn btn-primary" @click="openModal"><i class="fa-solid fa-plus"></i> 쿠폰 생성</button>
            </div>

            <!-- 쿠폰 목록 테이블 -->
            <table class="coupon-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>쿠폰명</th>
                        <th>할인내용</th>
                        <th>기간</th>
                        <th>알림 메시지</th>
                        <th>발급/사용</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in list" :key="item.couponNo || item.COUPON_NO">
                        <td>{{ item.couponNo || item.COUPON_NO }}</td>
                        <td>{{ item.couponName || item.COUPON_NAME }}</td>
                        <td>
                            <span v-if="(item.discountType || item.DISCOUNT_TYPE) == 'F'">{{ Number(item.discountAmount || item.DISCOUNT_AMOUNT).toLocaleString() }}원</span>
                            <span v-else>{{ item.discountAmount || item.DISCOUNT_AMOUNT }}%</span>
                        </td>
                        <td>{{ item.expireDays || item.EXPIRE_DAYS }}일</td>
                        <td :title="item.notiMessage || item.NOTI_MESSAGE" style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                            {{ item.notiMessage || item.NOTI_MESSAGE || '(기본값)' }}
                        </td>
                        <td>
                            <span style="color: blue;">{{ item.issuedCnt || item.ISSUED_CNT }}</span> / 
                            <span style="color: red;">{{ item.usedCnt || item.USED_CNT }}</span>
                        </td>
                        <td>
                            <button class="btn btn-info btn-sm" @click="fnIssue(item.couponNo || item.COUPON_NO)" title="전체 회원 발급">
                                <i class="fa-regular fa-paper-plane"></i> 발급
                            </button>
                            <button class="btn btn-danger btn-sm" @click="fnDelete(item.couponNo || item.COUPON_NO)" style="margin-left: 5px;" title="삭제">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <tr v-if="list.length == 0">
                        <td colspan="7" style="padding: 30px; color: #888;">등록된 쿠폰이 없습니다.</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 쿠폰 생성 모달 -->
        <div v-if="showModal" class="modal-mask">
            <div class="modal-container">
                <div class="modal-header">
                    <h3>새 쿠폰 만들기</h3>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>쿠폰 이름</label>
                        <input type="text" v-model="coupon.couponName" class="form-control" placeholder="예: 신규 회원 환영 쿠폰">
                    </div>
                    <div class="form-group">
                        <label>할인 방식</label>
                        <select v-model="coupon.discountType" class="form-control">
                            <option value="F">고정 금액 할인 (원)</option>
                            <option value="R">정률 할인 (%)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>할인 금액 / 비율</label>
                        <input type="number" v-model="coupon.discountAmount" class="form-control">
                    </div>
                    <div class="form-group" v-if="coupon.discountType == 'R'">
                        <label>최대 할인 한도 (원)</label>
                        <input type="number" v-model="coupon.maxDiscountPrice" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>최소 주문 금액 (원)</label>
                        <input type="number" v-model="coupon.minOrderPrice" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>유효 기간 (일)</label>
                        <input type="number" v-model="coupon.expireDays" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>알림 메시지</label>
                        <textarea v-model="coupon.notiMessage" class="form-control" rows="3" placeholder="[선물] 고객님께 쿠폰이 도착했습니다!"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" @click="fnCreate">생성</button>
                    <button class="btn btn-danger" @click="closeModal" style="background-color: #999;">취소</button>
                </div>
            </div>
        </div>

    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    showModal: false,
                    coupon: {
                        couponName: '', discountType: 'F', discountAmount: 0,
                        maxDiscountPrice: 0, minOrderPrice: 0, expireDays: 30, notiMessage: ''
                    }
                };
            },
            methods: {
                fnGetList() {
                    $.ajax({
                        url: "/admin/coupon/list.dox",
                        type: "POST",
                        dataType: "json",
                        success: (res) => {
                            console.log("받아온 쿠폰 목록 데이터:", res.list); // 디버깅용 로그
                            this.list = res.list;
                        }
                    });
                },
                openModal() {
                    this.coupon = { couponName: '', discountType: 'F', discountAmount: 0, maxDiscountPrice: 0, minOrderPrice: 0, expireDays: 30, notiMessage: '' };
                    this.showModal = true;
                },
                closeModal() {
                    this.showModal = false;
                },
                fnCreate() {
                    if(!this.coupon.couponName) { alert("쿠폰명을 입력하세요."); return; }
                    if(!confirm("쿠폰을 생성하시겠습니까?")) return;
                    
                    $.ajax({
                        url: "/admin/coupon/create.dox",
                        type: "POST",
                        data: this.coupon,
                        dataType: "json",
                        success: (res) => {
                            if(res.result == "success") {
                                alert("생성되었습니다.");
                                this.closeModal();
                                this.fnGetList(); // 목록 갱신
                            } else {
                                alert("오류: " + res.message);
                            }
                        }
                    });
                },
                fnIssue(couponNo) {
                    if(!confirm("정말 이 쿠폰을 모든 회원에게 발급하시겠습니까?\n(알림이 전송됩니다)")) return;
                    
                    $.ajax({
                        url: "/admin/coupon/issueAll.dox",
                        type: "POST",
                        data: { couponNo: couponNo },
                        dataType: "json",
                        success: (res) => {
                            if(res.result == "success") {
                                alert(res.count + "명에게 발급 및 알림 전송이 완료되었습니다.");
                                this.fnGetList(); // 발급 카운트 갱신
                            } else {
                                alert("오류: " + res.message);
                            }
                        }
                    });
                },
                fnDelete(couponNo) {
                    if(!confirm("정말 이 쿠폰을 삭제하시겠습니까? (복구 불가)")) return;
                    
                    $.ajax({
                        url: "/admin/coupon/delete.dox",
                        type: "POST",
                        data: { couponNo: couponNo },
                        dataType: "json",
                        success: (res) => {
                            if(res.result == "success") {
                                alert("삭제되었습니다.");
                                this.fnGetList();
                            } else {
                                alert("삭제 실패: " + res.message);
                            }
                        }
                    });
                }
            },
            mounted() {
                this.fnGetList();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>