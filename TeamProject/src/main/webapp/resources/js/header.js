$(document).ready(function () {
    const path = $("body").data("context") || ""; // JSP contextPath 필요 시 body에 data-context로 전달

	$.ajax({
	        url: path + "/categoryList.dox",
	        type: "POST",
	        dataType: "json",
	        success: function (res) {
	            const menu = $("#dropdownMenu");
	            menu.empty();

	            const topLevel = res.list.filter(c => !c.parentCategoryNo);
	            const children = res.list.filter(c => c.parentCategoryNo);
	            
	            topLevel.forEach(top => {
	                const liTop = $("<li>");
	                const aTop = $("<a>")
	                    .text(top.categoryName)
	                    .attr("href", path + "/category/" + top.categoryNo)
	                    .attr("data-category-no", top.categoryNo)
	                    .attr("data-category-name", top.categoryName)
	                    .addClass("category-link");

	                liTop.append(aTop);
	                
	                const midList = children.filter(m => m.parentCategoryNo === top.categoryNo);
	                if (midList.length > 0) {
	                    const ulMid = $("<ul>");
	                    midList.forEach(mid => {
	                        const liMid = $("<li>");
	                        const aMid = $("<a>")
	                            .text(mid.categoryName)
	                            .attr("href", path + "/category/" + mid.categoryNo)
	                            .attr("data-category-no", mid.categoryNo)
	                            .attr("data-category-name", mid.categoryName)
	                            .addClass("category-link");
	                        
	                        const lowList = children.filter(s => s.parentCategoryNo === mid.categoryNo);
	                        if (lowList.length > 0) {
	                            const ulLow = $("<ul>");
	                            lowList.forEach(low => {
	                                const liLow = $("<li>");
	                                const aLow = $("<a>")
	                                    .text(low.categoryName)
	                                    .attr("href", path + "/category/" + low.categoryNo)
	                                    .attr("data-category-no", low.categoryNo)
	                                    .attr("data-category-name", low.categoryName)
	                                    .addClass("category-link");

	                                liLow.append(aLow);
	                                ulLow.append(liLow);
	                            });
	                            liMid.append(ulLow);
	                        }

	                        liMid.append(aMid);
	                        ulMid.append(liMid);
	                    });
	                    liTop.append(ulMid);
	                }

	                menu.append(liTop);
	            });
	        },
	        error: function (xhr, status, error) {
	            console.error("카테고리 불러오기 실패:", error);
	            $("#dropdownMenu").append("<li><span>불러오기 실패</span></li>");
	        }
	  });
	  
	  $(document).on("click", ".category-link", function (e) {
	          e.preventDefault(); // a태그 기본 이동 방지

	          const href = $(this).attr("href");
	          const categoryNo = $(this).data("category-no");
	          const categoryName = $(this).data("category-name");

	          if (!href || href === "#") {
	              console.error("잘못된 링크입니다.");
	              return;
	          }
			  
			  if (!categoryNo || !categoryName) {
			     console.error("카테고리 정보가 올바르지 않습니다.");
			     return;
			  }
	         
	          const newUrl = `${href}?categoryNo=${categoryNo}&categoryName=${encodeURIComponent(categoryName)}`;
	          window.location.href = newUrl; 
	          
	 });
			     		   	   
	

    $("#logoClick").on("click", function () {
        location.href = path + "/main.do";
    });

    $("#btnSearch").on("click", function () {
        const keyword = $("#searchInput").val().trim();
        if (keyword === "") {
            alert("검색어를 입력하세요!");
            return;
        }
        location.href = path + "/search?keyword=" + encodeURIComponent(keyword);
    });

    $("#btnLogout").on("click", function () {
        if (confirm("로그아웃 하시겠습니까?")) {
            $.ajax({
                url: path + "/logout.dox",
                type: "POST",
                success: function (res) {
                    if (res.result === "success") {
                        alert("로그아웃 되었습니다.");
                        location.href = path + "/login.do";
                    }
                },
                error: function () {
                    alert("로그아웃 중 오류가 발생했습니다.");
                }
            });
        }
    });

    $("#btnMyPage").on("click", function () {
        const sessionStatus = $("#btnMyPage").data("status");
		console.log(sessionStatus);
        if (!sessionStatus) {
            alert("로그인이 필요합니다.");
            location.href = path + "/login.do";
            return;
        }
        if (sessionStatus === "BUYER") {
            location.href = path + "/buyerMyPage.do";
        } else if (sessionStatus === "SELLER") {
            location.href = path + "/sellerMyPage.do";
        } else {
            alert("잘못된 사용자 정보입니다.");
        }
    });

    $("#btnFavorite").on("click", () => location.href = path + "/favorite");
    $("#btnCart").on("click", function () {
	        const sessionStatus = $("#btnCart").data("status");
			console.log(sessionStatus);
	        if (!sessionStatus) {
	            alert("로그인이 필요합니다.");
	            location.href = path + "/login.do";
	            return;
	        } else {
				location.href = path + "/cart.do";
			}
				        
	    });

    $("#btnCategory").on("click", function () {
        $("#dropdownMenu").toggleClass("show");
    });

    $(document).on("click", function (e) {
        if (!$(e.target).closest(".category-container").length) {
            $("#dropdownMenu").removeClass("show");
        }
    });
	
	// 메뉴 토글
	$("#btnHamburger").on("click", function () {
	    $(".nav-menu").stop(true, true).toggleClass("active");
	    $(".search-section").removeClass("active");
	  });

	  // 검색창 토글
	  $("#btnSearchToggle").on("click", function () {
	    $(".search-section").stop(true, true).toggleClass("active");
	    $(".nav-menu").removeClass("active");
	  });
});