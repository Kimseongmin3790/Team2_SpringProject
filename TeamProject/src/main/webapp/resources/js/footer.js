$(document).ready(function() {
    // '이용약관' 링크 클릭 시
    $('#open-terms-link').on('click', function(e) {
        e.preventDefault();

		$('#terms-modal .terms-text').load(CONTEXT_PATH + '/terms.do', function() {
			$('#terms-modal').fadeIn();
		 });
	});

     // 개인정보처리방침 클릭 시
    $('#open-privacy-link').on('click', function(e) {
        e.preventDefault();

		$('#privacy-modal .terms-text').load(CONTEXT_PATH + '/privacy.do', function() {
			$('#privacy-modal').fadeIn();
		});
	});

    // 닫기 버튼 또는 모달 바깥 영역 클릭 시
    $('.modal-close-btn, .modal-overlay').on('click', function(e) {
        if ($(e.target).closest('.modal-content').length > 0 && !$(e.target).hasClass('modal-close-btn'))
        {
            return;
        }
        $('#terms-modal').fadeOut();
        $('#privacy-modal').fadeOut();
    });
	
	/* ============================== */
	  /* 💬 챗봇 열기 / 닫기 토글 */
	  /* ============================== */
	  $('#chatbot-toggle').on('click', function () {
	    $('#chatbot-box').toggleClass('hidden');
	    $(this).toggleClass('active');

	    if ($(this).hasClass('active')) {
	      $(this).html('✖'); // 닫기 아이콘
	    } else {
	      $(this).html('💬'); // 열기 아이콘
	    }
	  });
	
	
	/* ============================== */
  	 /* 💬 AGRICOLA 챗봇 기능 */
   /* ============================== */
   $("#chat-send").on("click", function () {
       const msg = $("#chat-input").val().trim();
       if (!msg) return;

       appendMessage("user", msg);
       $("#chat-input").val("");

       let answer = "";

       if (msg.includes("배송")) {
           answer = "🚚 배송은 결제 후 2~3일 이내 도착합니다.<br>상세 조회는 <a href='" + CONTEXT_PATH + "/order/status.do'>여기</a>에서 확인하세요.";
       } else if (msg.includes("환불") || msg.includes("취소")) {
           answer = "💳 환불은 상품 회수 완료 후 2~5일 내 처리됩니다.<br>자세한 안내는 <a href='" + CONTEXT_PATH + "/customerService.do?tab=refund'>여기</a>에서 확인하세요.";
       } else if (msg.includes("문의")) {
           answer = "📞 고객센터 1:1 문의는 <a href='" + CONTEXT_PATH + "/customerService.do?tab=inquiry'>이곳</a>에서 가능합니다.";
       } else if (msg.includes("입점") || msg.includes("제휴")) {
           answer = "🧑‍🌾 입점 및 제휴문의는 <a href='" + CONTEXT_PATH + "/partnership.do'>여기</a>에서 진행할 수 있습니다.";
       } else if (msg.includes("공지") || msg.includes("이벤트")) {
           answer = "🎉 공지사항과 문의사항은 <a href='" + CONTEXT_PATH + "/board.do'>이곳</a>에서 확인하세요.";
       } else if (msg.includes("로그인")) {
           answer = "🔑 로그인은 <a href='" + CONTEXT_PATH + "/login.do'>여기</a>에서 할 수 있습니다.";
       } else {
           answer = "🤖 죄송해요, 아직 그 질문은 준비 중이에요.<br>예: '배송', '환불', '입점', '제휴', '공지' 등으로 물어보세요!";
       }

       appendMessage("bot", answer);
   });

   // Enter 키로 전송
   $("#chat-input").on("keypress", function (e) {
       if (e.which === 13) $("#chat-send").click();
   });

   // 메시지 추가 함수
   function appendMessage(sender, text) {
       $("#chatbot-messages").append(`<div class='chat-msg ${sender}'>${text}</div>`);
       $("#chatbot-messages").scrollTop($("#chatbot-messages")[0].scrollHeight);
   }

	
});