$(document).ready(function() {
	const path = $("body").data("context") || "";

	// ✅ Swal helper (success만 초록 버튼)
	const swWarn = (msg) => Swal.fire({ icon: "warning", title: "안내", text: msg });
	const swError = (msg) => Swal.fire({ icon: "error", title: "오류", text: msg });
	const swSuccess = (msg) =>
		Swal.fire({
			icon: "success",
			title: "성공",
			text: msg,
			confirmButtonColor: "#5dbb63",
		});

	$.ajax({
		url: path + "/categoryProductList.dox",
		type: "POST",
		dataType: "json",
		success: function(res) {
			const enc = (v) => encodeURIComponent(String(v));

			const linkTop = (pNo) => path + "/productCategory.do#p=" + enc(pNo) + "&v=product";
			const linkMid = (pNo, cNo) =>
				path + "/productCategory.do#p=" + enc(pNo) + "&c=" + enc(cNo) + "&v=product";
			const linkLow = (pNo, cNo, sNo) =>
				path +
				"/productCategory.do#p=" +
				enc(pNo) +
				"&c=" +
				enc(cNo) +
				"&s=" +
				enc(sNo) +
				"&v=product";

			const menu = $("#dropdownMenu");
			menu.empty();

			const raw = Array.isArray(res.categories)
				? res.categories
				: Array.isArray(res.list)
					? res.list
					: [];

			const norm = (c) => ({
				categoryNo: String(c.categoryNo),
				parentCategoryNo:
					c.parentCategoryNo == null ||
						String(c.parentCategoryNo).trim() === "" ||
						String(c.parentCategoryNo) === "0"
						? ""
						: String(c.parentCategoryNo),
				categoryName: c.categoryName || "",
				imageUrl: c.imageUrl || "",
			});
			const list = raw.map(norm);

			const idSet = new Set(list.map((c) => c.categoryNo));
			const isRoot = (c) => c.parentCategoryNo === "" || !idSet.has(c.parentCategoryNo);

			const topLevel = list.filter(isRoot);
			const children = list.filter((c) => !isRoot(c));

			topLevel.forEach((top) => {
				const liTop = $("<li>");
				const aTop = $("<a>").text(top.categoryName).attr("href", linkTop(top.categoryNo));
				liTop.append(aTop);

				const mids = children.filter((m) => m.parentCategoryNo === top.categoryNo);
				if (mids.length > 0) {
					const ulMid = $("<ul>");

					mids.forEach((mid) => {
						const liMid = $("<li>");
						const aMid = $("<a>").text(mid.categoryName).attr("href", linkMid(top.categoryNo, mid.categoryNo));
						liMid.append(aMid);

						const lows = children.filter((s) => s.parentCategoryNo === mid.categoryNo);
						if (lows.length > 0) {
							const ulLow = $("<ul>");
							lows.forEach((low) => {
								const liLow = $("<li>");
								const aLow = $("<a>")
									.text(low.categoryName)
									.attr("href", linkLow(top.categoryNo, mid.categoryNo, low.categoryNo));
								liLow.append(aLow);
								ulLow.append(liLow);
							});
							liMid.append(ulLow);
						}
						ulMid.append(liMid);
					});

					liTop.append(ulMid);
				}

				menu.append(liTop);
			});
		},
		error: function(xhr, status, error) {
			console.error("카테고리 불러오기 실패:", error);
			$("#dropdownMenu").append("<li><span>불러오기 실패</span></li>");
			// (원하면 여기도 swError로 띄울 수 있음)
			// swError("카테고리를 불러오지 못했습니다.");
		},
	});

	$("#logoClick").on("click", function() {
		location.href = path + "/main.do";
	});

	$("#btnSearch").on("click", async function() {
		const keyword = $("#searchInput").val().trim();
		if (!keyword) {
			await swWarn("검색어를 입력하세요!");
			return;
		}
		location.href = path + "/search?keyword=" + encodeURIComponent(keyword);
	});

	$("#searchInput").on("keypress", function(e) {
		if (e.which === 13) $("#btnSearch").click();
	});

	$("#btnLogout").on("click", async function() {
		const result = await Swal.fire({
			title: "로그아웃",
			text: "로그아웃 하시겠습니까?",
			icon: "warning",
			showCancelButton: true,
			confirmButtonText: "로그아웃",
			cancelButtonText: "취소",
			reverseButtons: true,
		});

		if (!result.isConfirmed) return;

		$.ajax({
			url: path + "/logout.dox",
			type: "POST",
			success: async function(res) {
				if (res.result === "success") {
					await swSuccess("로그아웃 되었습니다.");
					sessionStorage.clear();
					location.href = path + "/login.do";
				} else {
					swError(res.message || "로그아웃에 실패했습니다.");
				}
			},
			error: function() {
				swError("로그아웃 중 오류가 발생했습니다.");
			},
		});
	});

	const mypageBtn = $("#btnMyPage");
	const dropdown = mypageBtn.siblings(".mypage-menu");

	mypageBtn.on("click", function(e) {
		e.preventDefault();
		if (dropdown.length > 0) {
			dropdown.toggleClass("show");
		} else {
			const sessionStatus = mypageBtn.data("status");
			if (!sessionStatus) return (location.href = path + "/login.do");
			if (sessionStatus === "BUYER" || sessionStatus === "ADMIN")
				location.href = path + "/buyerMyPage.do";
		}
	});

	$(document).on("click", function(e) {
		if (!$(e.target).closest(".mypage-dropdown").length) {
			dropdown.removeClass("show");
		}
	});

	$("#btnFavorite").on("click", () => (location.href = path + "/favorite"));

	$("#btnCart").on("click", function() {
		const sessionStatus = $("#btnCart").data("status");
		if (!sessionStatus) return (location.href = path + "/login.do");
		location.href = path + "/buyerMyPage.do";
	});

	$("#btnCategory").on("click", function(e) {
		e.preventDefault();
		e.stopPropagation();
		$("#dropdownMenu").toggleClass("active");
	});

	$(document).on("click", function(e) {
		if (!$(e.target).closest(".category-container").length) {
			$("#dropdownMenu").removeClass("active");
		}
	});

	$("#btnHamburger").on("click", function() {
		$(".nav-menu").stop(true, true).toggleClass("active");
		$(".search-section").removeClass("active");
	});

	$("#btnSearchToggle").on("click", function() {
		$(".search-section").stop(true, true).toggleClass("active");
		$(".nav-menu").removeClass("active");
	});

	function markActiveNav() {
		const ctx = $("body").data("context") || "${pageContext.request.contextPath}" || "";
		const p = location.pathname.replace(ctx, "") || location.pathname;
		const h = location.hash || "";

		$(".nav-menu a").removeClass("active").removeAttr("aria-current");

		let pick = null;
		if (/^\/(main|default)\.do$/.test(p)) pick = "/main.do";
		else if (/^\/productCategory\.do$/.test(p) || /#.*\b(v|p|c|s)=/.test(h)) pick = "/productCategory.do";
		else if (/^\/product\/recommendList\.do$/.test(p)) pick = "/product/recommendList.do";
		else if (/^\/board\.do$/.test(p) || /^\/customerService\.do$/.test(p)) pick = "/board.do";

		if (pick) {
			$(`.nav-menu a[href$="${pick}"]`).addClass("active").attr("aria-current", "page");
		}
	}

	function fnGetNotiCount() {
		$.ajax({
			url: path + "/notification/unreadCount.dox",
			type: "POST",
			dataType: "json",
			success: function(res) {
				if (res.result === "success" && res.count > 0) {
					$("#notiBadge").text(res.count).show();
				} else {
					$("#notiBadge").hide();
				}
			},
		});
	}

	if ($("#btnLogout").length > 0) {
		fnGetNotiCount();
	}

	$("#btnNoti").on("click", function() {
		location.href = path + "/notification/list.do";
	});

	// 실시간 알림 (WebSocket)
	const mySessionId = $("#btnLogout").length > 0 ? "user" : "";

	if ($("#btnLogout").length > 0) {
		const socket = new SockJS(path + "/ws");
		const stompClient = Stomp.over(socket);
		stompClient.debug = null;

		stompClient.connect({}, function(frame) {
			const userId = $("#hdSessionId").val();

			/* if (userId) {
			  stompClient.subscribe('/topic/notifications/' + userId, async function(res) {
				const noti = JSON.parse(res.body);
				fnGetNotiCount();
				await swWarn("🔔 " + noti.message); // ✅ alert 대신
			  });
			} */
		});
	}

	markActiveNav();
	$(window).on("hashchange", markActiveNav);

	$(".nav-menu a").on("click", function() {
		$(".nav-menu a").removeClass("active");
		$(this).addClass("active");
	});
});
