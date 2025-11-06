$(document).ready(function() {
	const path = $("body").data("context") || "";

	$.ajax({
		url: path + "/categoryProductList.dox",
		type: "POST",
		dataType: "json",
		success: function(res) {
			// 해시 링크 빌더
			const linkTop = (pNo) =>
				path + "/productCategory.do#p=" + encodeURIComponent(String(pNo)) + "&v=child";
			const linkMid = (pNo, cNo) =>
				path + "/productCategory.do#p=" + encodeURIComponent(String(pNo)) +
				"&c=" + encodeURIComponent(String(cNo)) + "&v=sub";
			const linkLow = (pNo, cNo, sNo) =>
				path + "/productCategory.do#p=" + encodeURIComponent(String(pNo)) +
				"&c=" + encodeURIComponent(String(cNo)) +
				"&s=" + encodeURIComponent(String(sNo)) + "&v=product";

			const menu = $("#dropdownMenu");
			menu.empty();

			// categories 기준으로만 사용 (없으면 방어적 대체)
			const raw = Array.isArray(res.categories)
				? res.categories
				: Array.isArray(res.list) ? res.list : [];

			const norm = (c) => ({
				categoryNo: String(c.categoryNo),
				parentCategoryNo:
					(c.parentCategoryNo == null ||
						String(c.parentCategoryNo).trim() === "" ||
						String(c.parentCategoryNo) === "0") ? "" : String(c.parentCategoryNo),
				categoryName: c.categoryName || "",
				imageUrl: c.imageUrl || ""
			});
			const list = raw.map(norm);

			const idSet = new Set(list.map(c => c.categoryNo));
			const isRoot = (c) => (c.parentCategoryNo === "" || !idSet.has(c.parentCategoryNo));

			const topLevel = list.filter(isRoot);
			const children = list.filter(c => !isRoot(c));

			// 그리기
			topLevel.forEach(top => {
				const liTop = $("<li>");
				const aTop = $("<a>").text(top.categoryName).attr("href", linkTop(top.categoryNo));
				liTop.append(aTop);

				const mids = children.filter(m => m.parentCategoryNo === top.categoryNo);
				if (mids.length > 0) {
					const ulMid = $("<ul>");

					mids.forEach(mid => {
						const liMid = $("<li>");
						const aMid = $("<a>")
							.text(mid.categoryName)
							.attr("href", linkMid(top.categoryNo, mid.categoryNo));
						liMid.append(aMid);

						const lows = children.filter(s => s.parentCategoryNo === mid.categoryNo);
						if (lows.length > 0) {
							const ulLow = $("<ul>");
							lows.forEach(low => {
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
		}
	});

	// 이하 기존 클릭 핸들러들 그대로…
	$("#logoClick").on("click", function() { location.href = path + "/main.do"; });
	$("#btnSearch").on("click", function() {
		const keyword = $("#searchInput").val().trim();
		if (!keyword) return alert("검색어를 입력하세요!");
		location.href = path + "/search?keyword=" + encodeURIComponent(keyword);
	});
	$("#searchInput").on("keypress", function(e) { if (e.which === 13) $("#btnSearch").click(); });

	$("#btnLogout").on("click", function() {
		if (!confirm("로그아웃 하시겠습니까?")) return;
		$.ajax({
			url: path + "/logout.dox",
			type: "POST",
			success: function(res) {
				if (res.result === "success") {
					alert("로그아웃 되었습니다.");
					sessionStorage.clear();
					location.href = path + "/login.do";
				}
			},
			error: function() { alert("로그아웃 중 오류가 발생했습니다."); }
		});
	});

	$("#btnMyPage").on("click", function() {
		const sessionStatus = $("#btnMyPage").data("status");
		if (!sessionStatus) return (location.href = path + "/login.do");
		if (sessionStatus === "BUYER") location.href = path + "/buyerMyPage.do";
		else if (sessionStatus === "SELLER") location.href = path + "/sellerMyPage.do";
		else alert("잘못된 사용자 정보입니다.");
	});

	$("#btnFavorite").on("click", () => location.href = path + "/favorite");
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
});
